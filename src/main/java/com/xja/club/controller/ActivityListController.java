package com.xja.club.controller;

import com.xja.club.mapper.ActivitiesMapper;
import com.xja.club.mapper.ActivityregistrationsMapper;
import com.xja.club.mapper.UsersMapper;
import com.xja.club.mapper.ClubsMapper;
import com.xja.club.pojo.Activities;
import com.xja.club.pojo.Activityregistrations;
import com.xja.club.pojo.Users;
import com.xja.club.pojo.Clubs;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 活动列表控制器 - 用于前端活动列表页面
 */
@RestController
@RequestMapping("/api/activities/list")
@CrossOrigin(origins = "*")
public class ActivityListController {

    @Autowired
    private ActivitiesMapper activitiesMapper;

    @Autowired
    private ActivityregistrationsMapper activityregistrationsMapper;

    @Autowired
    private UsersMapper usersMapper;

    @Autowired
    private ClubsMapper clubsMapper;

    /**
     * 获取所有活动列表（用于前端展示）
     */
    @GetMapping("/all")
    public Map<String, Object> getAllActivities() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<Activities> activities = activitiesMapper.listAll();
            List<Map<String, Object>> activitiesWithClub = new ArrayList<>();
            
            // 为每个活动添加社团信息
            for (Activities activity : activities) {
                Map<String, Object> activityData = new HashMap<>();
                activityData.put("activityId", activity.getActivityId());
                activityData.put("activityName", activity.getActivityName());
                activityData.put("description", activity.getDescription());
                activityData.put("startTime", activity.getStartTime());
                activityData.put("endTime", activity.getEndTime());
                activityData.put("location", activity.getLocation());
                activityData.put("maxParticipants", activity.getMaxParticipants());
                activityData.put("currentParticipants", activity.getCurrentParticipants());
                activityData.put("actStatus", activity.getActStatus());
                activityData.put("organizingClubId", activity.getOrganizingClubId());
                
                // 获取社团名称
                if (activity.getOrganizingClubId() != null) {
                    Clubs club = clubsMapper.selectByPrimaryKey(activity.getOrganizingClubId());
                    if (club != null) {
                        activityData.put("clubName", club.getClubName());
                    } else {
                        activityData.put("clubName", "未知社团");
                    }
                } else {
                    activityData.put("clubName", "未知社团");
                }
                
                activitiesWithClub.add(activityData);
            }
            
            response.put("success", true);
            response.put("data", activitiesWithClub);
            response.put("message", "获取活动列表成功");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "获取活动列表失败: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }

    /**
     * 获取所有社团列表（用于筛选）
     */
    @GetMapping("/clubs")
    public Map<String, Object> getAllClubs() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<Clubs> clubs = clubsMapper.selectAll();
            response.put("success", true);
            response.put("data", clubs);
            response.put("message", "获取社团列表成功");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "获取社团列表失败: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }

    /**
     * 获取当前登录用户信息
     */
    @GetMapping("/current-user")
    public Map<String, Object> getCurrentUser(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Users loginUser = (Users) session.getAttribute("loginUser");
            if (loginUser != null) {
                Map<String, Object> userInfo = new HashMap<>();
                userInfo.put("userId", loginUser.getUserId());
                userInfo.put("realName", loginUser.getRealName());
                userInfo.put("userPhone", loginUser.getUserPhone());
                userInfo.put("userType", loginUser.getUserType());
                
                response.put("success", true);
                response.put("data", userInfo);
                response.put("message", "获取用户信息成功");
            } else {
                response.put("success", false);
                response.put("message", "用户未登录");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "获取用户信息失败: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }

    /**
     * 根据ID获取活动详情
     */
    @GetMapping("/{id}")
    public Map<String, Object> getActivityById(@PathVariable Integer id) {
        Map<String, Object> response = new HashMap<>();
        try {
            Activities activity = activitiesMapper.selectByPrimaryKey(id);
            if (activity != null) {
                response.put("success", true);
                response.put("data", activity);
                response.put("message", "获取活动详情成功");
            } else {
                response.put("success", false);
                response.put("message", "活动不存在");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "获取活动详情失败: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }

}
