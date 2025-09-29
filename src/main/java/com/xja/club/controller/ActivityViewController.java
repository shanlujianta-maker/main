package com.xja.club.controller;

import com.xja.club.mapper.ActivitiesMapper;
import com.xja.club.service.StoredProcedureService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 活动视图控制器 - 基于数据库视图和存储过程
 */
@RestController
@RequestMapping("/api/activities/view")
@CrossOrigin(origins = "*")
public class ActivityViewController {

    @Autowired
    private ActivitiesMapper activitiesMapper;
    
    @Autowired
    private StoredProcedureService storedProcedureService;

    /**
     * 获取活动详情（使用视图）
     */
    @GetMapping("/details")
    public Map<String, Object> getActivityDetails() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<Map<String, Object>> activities = activitiesMapper.selectAllWithDetails();
            response.put("success", true);
            response.put("data", activities);
            response.put("message", "获取活动详情成功");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "获取活动详情失败: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }

    /**
     * 获取活动预告（使用视图）
     */
    @GetMapping("/notices")
    public Map<String, Object> getActivityNotices() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<Map<String, Object>> notices = activitiesMapper.selectActivityNotices();
            response.put("success", true);
            response.put("data", notices);
            response.put("message", "获取活动预告成功");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "获取活动预告失败: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }

    /**
     * 获取活动报名统计（使用视图）
     */
    @GetMapping("/stats")
    public Map<String, Object> getRegistrationStats() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<Map<String, Object>> stats = activitiesMapper.selectRegistrationStats();
            response.put("success", true);
            response.put("data", stats);
            response.put("message", "获取报名统计成功");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "获取报名统计失败: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }

    /**
     * 创建活动（使用存储过程）
     */
    @PostMapping("/create")
    public Map<String, Object> createActivity(@RequestBody Map<String, Object> activityData) {
        Map<String, Object> response = new HashMap<>();
        try {
            String activityName = (String) activityData.get("activityName");
            String description = (String) activityData.get("description");
            String startTime = (String) activityData.get("startTime");
            String endTime = (String) activityData.get("endTime");
            String location = (String) activityData.get("location");
            Integer organizingClubId = (Integer) activityData.get("organizingClubId");
            Integer maxParticipants = (Integer) activityData.get("maxParticipants");
            Integer createdByUserId = (Integer) activityData.get("createdByUserId");

            Integer newActivityId = storedProcedureService.createActivity(
                activityName, description, startTime, endTime, location,
                organizingClubId, maxParticipants, createdByUserId
            );

            response.put("success", true);
            response.put("data", newActivityId);
            response.put("message", "创建活动成功");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "创建活动失败: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }

    /**
     * 活动报名（使用存储过程）
     */
    @PostMapping("/register")
    public Map<String, Object> registerActivity(@RequestBody Map<String, Object> registrationData) {
        Map<String, Object> response = new HashMap<>();
        try {
            Integer userId = (Integer) registrationData.get("userId");
            Integer activityId = (Integer) registrationData.get("activityId");

            String result = storedProcedureService.registerActivity(userId, activityId);

            response.put("success", true);
            response.put("data", result);
            response.put("message", "报名成功");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "报名失败: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }

    /**
     * 活动签到（使用存储过程）
     */
    @PostMapping("/checkin")
    public Map<String, Object> checkInActivity(@RequestBody Map<String, Object> checkinData) {
        Map<String, Object> response = new HashMap<>();
        try {
            Integer registrationId = (Integer) checkinData.get("registrationId");
            Integer userId = (Integer) checkinData.get("userId");

            String result = storedProcedureService.checkInActivity(registrationId, userId);

            response.put("success", true);
            response.put("data", result);
            response.put("message", "签到成功");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "签到失败: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }
}
