package com.xja.club.controller;

import com.xja.club.service.ActivityStatusSchedulerService;
import com.xja.club.service.ActivitiesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * 触发器测试控制器
 * 用于测试数据库触发器的功能
 */
@Controller
@RequestMapping("/api/trigger-test")
public class TriggerTestController {

    @Autowired
    private ActivityStatusSchedulerService activityStatusSchedulerService;
    

    /**
     * 手动触发活动状态检查
     */
    @RequestMapping("/check-expired")
    @ResponseBody
    public Map<String, Object> checkExpiredActivities() {
        Map<String, Object> result = new HashMap<>();
        try {
            activityStatusSchedulerService.checkAndUpdateExpiredActivities();
            result.put("success", true);
            result.put("message", "过期活动检查完成");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "检查失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 手动触发进行中活动检查
     */
    @RequestMapping("/check-ongoing")
    @ResponseBody
    public Map<String, Object> checkOngoingActivities() {
        Map<String, Object> result = new HashMap<>();
        try {
            activityStatusSchedulerService.checkAndUpdateOngoingActivities();
            result.put("success", true);
            result.put("message", "进行中活动检查完成");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "检查失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 手动同步参与人数
     */
    @RequestMapping("/sync-participants")
    @ResponseBody
    public Map<String, Object> syncParticipantCounts() {
        Map<String, Object> result = new HashMap<>();
        try {
            activityStatusSchedulerService.syncAllParticipantCounts();
            result.put("success", true);
            result.put("message", "参与人数同步完成");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "同步失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 执行完整的触发器测试
     */
    @RequestMapping("/full-test")
    @ResponseBody
    public Map<String, Object> fullTriggerTest() {
        Map<String, Object> result = new HashMap<>();
        try {
            // 1. 检查过期活动
            activityStatusSchedulerService.checkAndUpdateExpiredActivities();
            
            // 2. 检查进行中活动
            activityStatusSchedulerService.checkAndUpdateOngoingActivities();
            
            // 3. 同步参与人数
            activityStatusSchedulerService.syncAllParticipantCounts();
            
            result.put("success", true);
            result.put("message", "完整触发器测试完成");
            result.put("details", "已执行：过期活动检查、进行中活动检查、参与人数同步");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "测试失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
}
