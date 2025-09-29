package com.xja.club.controller;

import com.xja.club.pojo.Users;
import com.xja.club.service.ActivityregistrationsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/activities")
@CrossOrigin(origins = "*")
public class MyActivitiesController {

    @Autowired
    private ActivityregistrationsService activityregistrationsService;

    /**
     * 获取当前用户报名的活动列表
     */
    @GetMapping("/my-activities")
    @ResponseBody
    public Map<String, Object> getMyActivities(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            Users loginUser = (Users) session.getAttribute("loginUser");
            if (loginUser == null) {
                result.put("success", false);
                result.put("msg", "用户未登录");
                return result;
            }

            // 检查用户类型，只有学生可以访问
            if (!"student".equals(loginUser.getUserType())) {
                result.put("success", false);
                result.put("msg", "权限不足，只有学生可以访问此功能");
                return result;
            }

            List<Map<String, Object>> myActivities = activityregistrationsService.getMyActivitiesWithDetails(loginUser.getUserId());
            
            result.put("success", true);
            result.put("data", myActivities);
            result.put("msg", "获取我的活动列表成功");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "获取我的活动列表失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 活动签到
     */
    @PostMapping("/checkin")
    @ResponseBody
    public Map<String, Object> checkInActivity(@RequestBody Map<String, Object> requestData, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            Users loginUser = (Users) session.getAttribute("loginUser");
            if (loginUser == null) {
                result.put("success", false);
                result.put("msg", "用户未登录");
                return result;
            }

            // 检查用户类型，只有学生可以签到
            if (!"student".equals(loginUser.getUserType())) {
                result.put("success", false);
                result.put("msg", "权限不足，只有学生可以签到");
                return result;
            }

            Integer registrationId = (Integer) requestData.get("registrationId");
            if (registrationId == null) {
                result.put("success", false);
                result.put("msg", "报名记录ID不能为空");
                return result;
            }

            boolean success = activityregistrationsService.checkInActivity(registrationId, loginUser.getUserId());
            
            if (success) {
                result.put("success", true);
                result.put("msg", "签到成功");
            } else {
                result.put("success", false);
                result.put("msg", "签到失败，请检查报名记录是否存在或已签到");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "签到失败: " + e.getMessage());
        }
        return result;
    }
}
