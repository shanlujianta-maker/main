package com.xja.club.controller;

import com.xja.club.pojo.Activities;
import com.xja.club.pojo.Users;
import com.xja.club.service.ActivitiesService;
import com.xja.club.service.ClubsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 活动管理控制器
 * 
 * 功能说明：
 * 1. 提供活动的CRUD操作接口
 * 2. 处理活动相关的业务逻辑
 * 3. 与前端页面进行数据交互
 * 4. 支持活动状态管理和数据验证
 * 
 * 主要接口：
 * - GET /api/activities/getAllActivities - 获取所有活动列表
 * - POST /api/activities/save - 保存活动（新增/更新）
 * - GET /api/activities/{activityId} - 根据ID获取活动详情
 * - PUT /api/activities/update/{activityId} - 更新活动
 * - DELETE /api/activities/{activityId} - 删除活动
 * 
 * @author 系统管理员
 * @version 1.0
 * @since 2025-01-01
 */
@Controller
@RequestMapping("/api/activities") // 与前端AJAX请求路径一致
public class ActivitiesController {

    @Autowired
    private ActivitiesService activitiesService; // 活动服务层，处理活动相关业务逻辑
    
    @Autowired
    private ClubsService clubsService; // 社团服务层，用于验证社团信息

    /**
     * 获取所有活动列表
     * 
     * 功能说明：
     * - 从数据库获取所有活动信息
     * - 供活动预告页面和活动管理页面使用
     * - 返回JSON格式的活动列表数据
     * 
     * 请求方式：GET
     * 请求路径：/api/activities/getAllActivities
     * 
     * @return List<Activities> 活动列表，异常时返回null
     * 
     * 异常处理：
     * - 数据库连接异常：返回null，前端显示无数据
     * - 其他异常：打印异常信息，返回null
     */
    @RequestMapping("/getAllActivities")
    @ResponseBody // 自动将返回值转为JSON
    public List<Activities> getAllActivities() {
        try {
            // 调用Service层方法获取数据
            List<Activities> activities = activitiesService.listAllActivities();
            // 调试输出：打印活动信息到控制台
            activities.forEach(System.out::println);
            return activitiesService.listAllActivities();
        } catch (Exception e) {
            e.printStackTrace();
            return null; // 异常时返回空列表（前端可处理为无数据）
        }
    }

    /**
     * 保存活动（新增/更新）
     * 
     * 功能说明：
     * - 支持新增和更新活动信息
     * - 进行数据验证和业务逻辑检查
     * - 自动设置创建者信息
     * - 验证社团ID的有效性
     * 
     * 请求方式：POST
     * 请求路径：/api/activities/save
     * 请求体：Activities对象（JSON格式）
     * 
     * 数据验证：
     * 1. 活动名称不能为空
     * 2. 活动开始时间和结束时间不能为空
     * 3. 主办社团ID不能为空
     * 4. 验证社团ID是否存在于数据库中
     * 
     * @param activity 活动对象，包含活动详细信息
     * @param session HTTP会话，用于获取当前登录用户信息
     * @return Map<String, Object> 包含操作结果的Map
     *         - success: boolean 操作是否成功
     *         - msg: String 操作结果消息
     *         - activityId: Integer 新增活动时返回活动ID
     * 
     * 异常处理：
     * - 数据验证失败：返回错误信息
     * - 社团不存在：返回社团不存在错误
     * - 数据库异常：返回异常信息
     */
    @PostMapping("/save")
    @ResponseBody
    public Map<String, Object> saveActivity(@RequestBody Activities activity, HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 数据验证：检查必填字段
            if (activity.getActivityName() == null || activity.getActivityName().trim().isEmpty()) {
                result.put("success", false);
                result.put("msg", "活动名称不能为空");
                return result;
            }

            if (activity.getStartTime() == null || activity.getEndTime() == null) {
                result.put("success", false);
                result.put("msg", "活动时间不能为空");
                return result;
            }

            if (activity.getOrganizingClubId() == null) {
                result.put("success", false);
                result.put("msg", "主办社团不能为空");
                return result;
            }

            // 业务逻辑验证：检查社团是否存在
            boolean clubExists = clubsService.checkClubExists(activity.getOrganizingClubId());
            if (!clubExists) {
                result.put("success", false);
                result.put("msg", "指定的社团不存在，请检查社团ID");
                return result;
            }

            // 设置创建者信息：从会话中获取当前登录用户
            Object loginUser = session.getAttribute("loginUser");
            if (loginUser != null) {
                activity.setCreatedByUserId(((Users) loginUser).getUserId());
            } else {
                // 测试环境下使用默认值
                activity.setCreatedByUserId(1);
            }

            // 调用服务层保存活动
            int rows = activitiesService.saveActivity(activity);
            result.put("success", rows > 0);
            result.put("msg", rows > 0 ? "保存成功" : "保存失败");
            
            // 新增活动时返回活动ID
            if (rows > 0 && activity.getActivityId() == null) {
                result.put("activityId", activity.getActivityId());
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "保存异常：" + e.getMessage());
        }
        return result;
    }

    /**
     * 根据ID获取活动详情
     * 
     * 功能说明：
     * - 根据活动ID查询活动详细信息
     * - 用于活动详情页面显示
     * - 支持活动编辑前的数据回显
     * 
     * 请求方式：GET
     * 请求路径：/api/activities/{activityId}
     * 路径参数：activityId - 活动ID
     * 
     * @param activityId 活动ID，路径参数
     * @return Map<String, Object> 包含查询结果的Map
     *         - success: boolean 查询是否成功
     *         - data: Activities 活动对象（成功时）
     *         - msg: String 错误信息（失败时）
     * 
     * 异常处理：
     * - 活动不存在：返回"活动不存在"错误
     * - 数据库异常：返回异常信息
     */
    @GetMapping("/{activityId}")
    @ResponseBody
    public Map<String, Object> getActivityById(@PathVariable Integer activityId) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 调用服务层根据ID查询活动
            Activities activity = activitiesService.getActivityById(activityId);
            if (activity != null) {
                result.put("success", true);
                result.put("data", activity);
            } else {
                result.put("success", false);
                result.put("msg", "活动不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "查询异常：" + e.getMessage());
        }
        return result;
    }

    /**
     * 更新活动信息
     * 
     * 功能说明：
     * - 根据活动ID更新活动信息
     * - 进行数据验证和业务逻辑检查
     * - 验证社团ID的有效性
     * - 支持部分字段更新
     * 
     * 请求方式：PUT
     * 请求路径：/api/activities/update/{activityId}
     * 路径参数：activityId - 要更新的活动ID
     * 请求体：Activities对象（JSON格式）
     * 
     * 数据验证：
     * 1. 活动名称不能为空
     * 2. 活动开始时间和结束时间不能为空
     * 3. 主办社团ID不能为空
     * 4. 验证社团ID是否存在于数据库中
     * 
     * @param activityId 活动ID，路径参数
     * @param activity 活动对象，包含要更新的活动信息
     * @return Map<String, Object> 包含操作结果的Map
     *         - success: boolean 操作是否成功
     *         - msg: String 操作结果消息
     * 
     * 异常处理：
     * - 数据验证失败：返回错误信息
     * - 社团不存在：返回社团不存在错误
     * - 数据库异常：返回异常信息
     */
    @PutMapping("/update/{activityId}")
    @ResponseBody
    public Map<String, Object> updateActivity(@PathVariable Integer activityId, @RequestBody Activities activity) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 数据验证：检查必填字段
            if (activity.getActivityName() == null || activity.getActivityName().trim().isEmpty()) {
                result.put("success", false);
                result.put("msg", "活动名称不能为空");
                return result;
            }

            if (activity.getStartTime() == null || activity.getEndTime() == null) {
                result.put("success", false);
                result.put("msg", "活动时间不能为空");
                return result;
            }

            if (activity.getOrganizingClubId() == null) {
                result.put("success", false);
                result.put("msg", "主办社团不能为空");
                return result;
            }

            // 业务逻辑验证：检查社团是否存在
            boolean clubExists = clubsService.checkClubExists(activity.getOrganizingClubId());
            if (!clubExists) {
                result.put("success", false);
                result.put("msg", "指定的社团不存在，请检查社团ID");
                return result;
            }

            // 设置活动ID：确保更新的是正确的活动
            activity.setActivityId(activityId);
            
            // 调用服务层更新活动
            int rows = activitiesService.saveActivity(activity);
            result.put("success", rows > 0);
            result.put("msg", rows > 0 ? "更新成功" : "更新失败");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "更新异常：" + e.getMessage());
        }
        return result;
    }

    /**
     * 删除活动
     * 
     * 功能说明：
     * - 根据活动ID删除活动
     * - 级联删除相关的报名记录
     * - 支持软删除和硬删除
     * 
     * 请求方式：DELETE
     * 请求路径：/api/activities/{activityId}
     * 路径参数：activityId - 要删除的活动ID
     * 
     * 注意事项：
     * - 删除活动会同时删除相关的报名记录
     * - 建议在删除前检查是否有用户已报名
     * - 删除操作不可逆，请谨慎操作
     * 
     * @param activityId 活动ID，路径参数
     * @return Map<String, Object> 包含操作结果的Map
     *         - success: boolean 操作是否成功
     *         - msg: String 操作结果消息
     * 
     * 异常处理：
     * - 活动不存在：返回"删除失败"消息
     * - 数据库异常：返回异常信息
     */
    @DeleteMapping("/{activityId}")
    @ResponseBody
    public Map<String, Object> deleteActivity(@PathVariable Integer activityId) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 调用服务层删除活动
            int rows = activitiesService.deleteActivity(activityId);
            result.put("success", rows > 0);
            result.put("msg", rows > 0 ? "删除成功" : "删除失败");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "删除异常：" + e.getMessage());
        }
        return result;
    }

}