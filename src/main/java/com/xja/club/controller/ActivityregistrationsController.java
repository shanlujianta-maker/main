package com.xja.club.controller;

import com.xja.club.pojo.Activityregistrations;
import com.xja.club.service.ActivityregistrationsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/api/registrations")
public class ActivityregistrationsController {

    @Autowired
    private ActivityregistrationsService registrationService;

    /**
     * 用户报名活动
     * 基于数据库unique_user_activity索引防止重复报名
     */
    @PostMapping
    @ResponseBody
    public Map<String, Object> registerActivity(
            @RequestParam Integer activityId,
            HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        // 1. 校验登录状态
        Object loginUser = session.getAttribute("loginUser");
        if (loginUser == null) {
            result.put("success", false);
            result.put("msg", "请先登录");
            return result;
        }
        Integer userId = ((com.xja.club.pojo.Users) loginUser).getUserId();

        try {
            // 2. 检查活动是否可报名（状态为open）
            if (!registrationService.isActivityOpen(activityId)) {
                result.put("success", false);
                result.put("msg", "活动未开启报名或已结束");
                return result;
            }

            // 3. 检查是否已报名
            if (registrationService.checkRegistrationExists(userId, activityId)) {
                result.put("success", false);
                result.put("msg", "您已报名该活动，无需重复报名");
                return result;
            }

            // 4. 检查是否超过最大参与人数
            if (registrationService.isActivityFull(activityId)) {
                result.put("success", false);
                result.put("msg", "活动人数已满，无法报名");
                return result;
            }

            // 5. 保存报名记录
            Activityregistrations registration = new Activityregistrations();
            registration.setUserId(userId);
            registration.setActivityId(activityId);
            registration.setRegistrationTime(new Date()); // 报名时间为当前时间
            registration.setCheckInStatus("registered"); // 初始状态为"已报名"

            int rows = registrationService.saveRegistration(registration);
            if (rows > 0) {
                // 数据库触发器会自动更新参与人数，无需手动调用
                // activitiesService.incrementParticipantCount(activityId);
                result.put("success", true);
                result.put("msg", "报名成功");
            } else {
                result.put("success", false);
                result.put("msg", "报名失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "报名异常：" + e.getMessage());
        }
        return result;
    }

    /**
     * 活动签到
     * 仅活动进行中可签到（需与活动时间关联校验）
     */
    @PutMapping("/checkin")
    @ResponseBody
    public Map<String, Object> checkIn(
            @RequestParam Integer activityId,
            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        Integer userId = ((com.xja.club.pojo.Users) session.getAttribute("loginUser")).getUserId();

        try {
            // 校验活动是否在进行中（可根据活动startTime和endTime判断）
            if (!registrationService.isActivityOngoing(activityId)) {
                result.put("success", false);
                result.put("msg", "活动未开始或已结束，无法签到");
                return result;
            }

            // 执行签到（更新状态和时间）
            int rows = registrationService.updateCheckInStatus(userId, activityId, "checked_in", new Date());
            result.put("success", rows > 0);
            result.put("msg", rows > 0 ? "签到成功" : "签到失败（未找到报名记录）");
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "签到异常：" + e.getMessage());
        }
        return result;
    }

    /**
     * 取消报名
     */
    @DeleteMapping
    @ResponseBody
    public Map<String, Object> cancelRegistration(
            @RequestParam Integer activityId,
            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        Integer userId = ((com.xja.club.pojo.Users) session.getAttribute("loginUser")).getUserId();

        try {
            // 仅活动未开始时可取消报名
            if (registrationService.isActivityStarted(activityId)) {
                result.put("success", false);
                result.put("msg", "活动已开始，无法取消报名");
                return result;
            }

            int rows = registrationService.deleteRegistration(userId, activityId);
            result.put("success", rows > 0);
            result.put("msg", rows > 0 ? "取消报名成功" : "取消失败（未找到报名记录）");
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "取消异常：" + e.getMessage());
        }
        return result;
    }
}
