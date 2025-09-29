package com.xja.club.controller;

import com.xja.club.service.ActivitiesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/activity-registration")
@CrossOrigin(origins = "*")
public class ActivityRegistrationController {

    @Autowired
    private ActivitiesService activitiesService;
    
    @Autowired
    private com.xja.club.mapper.ActivityregistrationsMapper activityregistrationsMapper;

    /**
     * 报名活动
     */
    @PostMapping("/register/{activityId}")
    public Map<String, Object> registerForActivity(@PathVariable Integer activityId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        System.out.println("=== 报名API开始 ===");
        System.out.println("活动ID: " + activityId);
        
        try {
            // 获取当前用户信息
            com.xja.club.pojo.Users loginUser = (com.xja.club.pojo.Users) session.getAttribute("loginUser");
            System.out.println("报名API - 获取到的loginUser: " + loginUser);
            if (loginUser == null) {
                System.out.println("报名API - 用户未登录");
                result.put("success", false);
                result.put("msg", "请先登录");
                return result;
            }
            Integer userId = loginUser.getUserId();
            System.out.println("报名API - 用户ID: " + userId);
            
            // 执行报名（内部会检查容量和重复报名）
            System.out.println("报名API - 开始执行报名，用户ID: " + userId + ", 活动ID: " + activityId);
            Map<String, Object> serviceResult = activitiesService.registerForActivity(userId, activityId);
            System.out.println("报名API - 报名结果: " + serviceResult);
            
            // 直接使用Service返回的结果
            result.put("success", serviceResult.get("success"));
            result.put("msg", serviceResult.get("msg"));
            
        } catch (Exception e) {
            System.out.println("报名API - 发生异常: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "报名失败：" + e.getMessage());
        }
        
        System.out.println("报名API - 最终返回结果: " + result);
        System.out.println("=== 报名API结束 ===");
        return result;
    }


    /**
     * 检查活动容量
     */
    @GetMapping("/check-capacity/{activityId}")
    public Map<String, Object> checkCapacity(@PathVariable Integer activityId) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            boolean hasCapacity = activitiesService.checkActivityCapacity(activityId);
            result.put("success", true);
            result.put("hasCapacity", hasCapacity);
            result.put("msg", hasCapacity ? "活动还有名额" : "活动已满");
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "检查失败：" + e.getMessage());
        }
        
        return result;
    }

    /**
     * 检查用户是否已报名（调试用）
     */
    @GetMapping("/check-registration/{activityId}")
    public Map<String, Object> checkRegistration(@PathVariable Integer activityId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 获取当前用户信息
            com.xja.club.pojo.Users loginUser = (com.xja.club.pojo.Users) session.getAttribute("loginUser");
            if (loginUser == null) {
                result.put("success", false);
                result.put("msg", "请先登录");
                return result;
            }
            Integer userId = loginUser.getUserId();
            
            // 查询报名记录
            com.xja.club.pojo.Activityregistrations registration = activityregistrationsMapper.selectByUserAndActivity(userId, activityId);
            
            result.put("success", true);
            result.put("hasRegistration", registration != null);
            result.put("registration", registration);
            result.put("msg", registration != null ? "已报名" : "未报名");
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "检查失败：" + e.getMessage());
        }
        
        return result;
    }

    /**
     * 同步参与人数（管理员功能）
     */
    @PostMapping("/sync-participant-count/{activityId}")
    public Map<String, Object> syncParticipantCount(@PathVariable Integer activityId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 检查管理员权限
            com.xja.club.pojo.Users loginUser = (com.xja.club.pojo.Users) session.getAttribute("loginUser");
            if (loginUser == null || !"admin".equals(loginUser.getUserType())) {
                result.put("success", false);
                result.put("msg", "权限不足");
                return result;
            }
            
            int count = activitiesService.syncParticipantCount(activityId);
            result.put("success", true);
            result.put("msg", "同步成功，更新了 " + count + " 条记录");
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "同步失败：" + e.getMessage());
        }
        
        return result;
    }

    /**
     * 同步所有活动的参与人数（管理员功能）
     */
    @PostMapping("/sync-all-participant-counts")
    public Map<String, Object> syncAllParticipantCounts(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 检查管理员权限
            com.xja.club.pojo.Users loginUser = (com.xja.club.pojo.Users) session.getAttribute("loginUser");
            if (loginUser == null || !"admin".equals(loginUser.getUserType())) {
                result.put("success", false);
                result.put("msg", "权限不足");
                return result;
            }
            
            int count = activitiesService.syncAllParticipantCounts();
            result.put("success", true);
            result.put("msg", "同步成功，更新了 " + count + " 个活动");
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "同步失败：" + e.getMessage());
        }
        
        return result;
    }

    /**
     * 自动关闭已满的活动（管理员功能）
     */
    @PostMapping("/auto-close-full-activities")
    public Map<String, Object> autoCloseFullActivities(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 检查管理员权限
            com.xja.club.pojo.Users loginUser = (com.xja.club.pojo.Users) session.getAttribute("loginUser");
            if (loginUser == null || !"admin".equals(loginUser.getUserType())) {
                result.put("success", false);
                result.put("msg", "权限不足");
                return result;
            }
            
            int count = activitiesService.autoCloseFullActivities();
            result.put("success", true);
            result.put("msg", "自动关闭成功，关闭了 " + count + " 个已满的活动");
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "自动关闭失败：" + e.getMessage());
        }
        
        return result;
    }

    /**
     * 设置已过期活动的缺席状态（管理员功能）
     */
    @PostMapping("/set-absent-for-expired")
    public Map<String, Object> setAbsentForExpiredActivities(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 检查管理员权限
            com.xja.club.pojo.Users loginUser = (com.xja.club.pojo.Users) session.getAttribute("loginUser");
            if (loginUser == null || !"admin".equals(loginUser.getUserType())) {
                result.put("success", false);
                result.put("msg", "权限不足");
                return result;
            }
            
            int count = activitiesService.setAbsentForExpiredActivities();
            result.put("success", true);
            result.put("msg", "设置缺席状态成功，更新了 " + count + " 条记录");
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "设置缺席状态失败：" + e.getMessage());
        }
        
        return result;
    }
}
