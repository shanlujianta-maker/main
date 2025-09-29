package com.xja.club.service.impl;

import com.xja.club.mapper.ActivitiesMapper;
import com.xja.club.mapper.ActivityregistrationsMapper;
import com.xja.club.pojo.Activities;
import com.xja.club.pojo.Activityregistrations;
import com.xja.club.service.ActivitiesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivitiesServiceImpl implements ActivitiesService {

    @Autowired
    private ActivitiesMapper activitiesMapper;
    
    @Autowired
    private ActivityregistrationsMapper activityregistrationsMapper;

    @Override
    public List<Activities> listAllActivities() {
        return activitiesMapper.listAll();
    }

    @Override
    public int saveActivity(Activities activity) {
        if (activity.getActivityId() == null) {
            // 新增活动时，设置默认值
            if (activity.getCurrentParticipants() == null) {
                activity.setCurrentParticipants(0);
            }
            return activitiesMapper.insertSelective(activity);
        } else {
            return activitiesMapper.updateByPrimaryKeySelective(activity);
        }
    }

    @Override
    public Activities getActivityById(Integer activityId) {
        return activitiesMapper.selectByPrimaryKey(activityId);
    }

    @Override
    public int updateActivityStatus(Integer activityId, String status) {
        Activities activity = new Activities();
        activity.setActivityId(activityId);
        activity.setActStatus(status);
        return activitiesMapper.updateByPrimaryKeySelective(activity);
    }

    @Override
    public int deleteActivity(Integer activityId) {
        return activitiesMapper.deleteByPrimaryKey(activityId);
    }

    @Override
    @Transactional
    public Map<String, Object> registerForActivity(Integer userId, Integer activityId) {
        Map<String, Object> result = new HashMap<>();
        System.out.println("=== 报名Service开始 ===");
        System.out.println("用户ID: " + userId + ", 活动ID: " + activityId);
        
        try {
            // 1. 检查活动是否存在且状态为开放
            Activities activity = activitiesMapper.selectByPrimaryKey(activityId);
            System.out.println("报名Service - 活动信息: " + activity);
            if (activity == null) {
                System.out.println("报名Service - 活动不存在");
                result.put("success", false);
                result.put("msg", "活动不存在");
                return result;
            }
            if (!"open".equals(activity.getActStatus())) {
                System.out.println("报名Service - 活动状态不是open: " + activity.getActStatus());
                result.put("success", false);
                result.put("msg", "活动未开放报名");
                return result;
            }
            
            // 2. 检查用户是否已经报名（通过user_id和activity_id组合判断）
            Activityregistrations existingRegistration = activityregistrationsMapper.selectByUserAndActivity(userId, activityId);
            System.out.println("报名Service - 找到的现有记录: " + existingRegistration);
            if (existingRegistration != null) {
                System.out.println("报名Service - 用户已有记录，记录ID: " + existingRegistration.getRegistrationId() + ", 状态: " + existingRegistration.getCheckInStatus());
                // 如果已经有记录，说明已经报名过，不能重复报名
                System.out.println("报名Service - 用户已报名，不能重复报名");
                result.put("success", false);
                result.put("msg", "不能重复报名");
                return result;
            }
            
            // 3. 检查是否还有名额（只有新用户才需要检查）
            System.out.println("报名Service - 检查活动容量，活动ID: " + activityId);
            boolean hasCapacity = activitiesMapper.checkCapacity(activityId);
            System.out.println("报名Service - 容量检查结果: " + hasCapacity);
            if (!hasCapacity) {
                System.out.println("报名Service - 活动已满，无法报名");
                result.put("success", false);
                result.put("msg", "活动已满，无法报名");
                return result;
            }
            
            // 4. 创建报名记录
            System.out.println("报名Service - 创建新报名记录");
            Activityregistrations registration = new Activityregistrations();
            registration.setUserId(userId);
            registration.setActivityId(activityId);
            registration.setRegistrationTime(new Date());
            registration.setCheckInStatus("registered"); // 报名成功，状态为registered
            
            int insertResult = activityregistrationsMapper.insertSelective(registration);
            System.out.println("报名Service - 插入结果: " + insertResult);
            if (insertResult > 0) {
                // 5. 数据库触发器会自动更新参与人数，无需手动调用
                // activitiesMapper.incrementParticipantCount(activityId);
                
                // 6. 不再自动关闭活动，保持open状态
                // activitiesMapper.autoCloseFullActivities();
                
                System.out.println("报名Service - 新用户报名成功");
                result.put("success", true);
                result.put("msg", "报名成功");
                return result;
            }
            System.out.println("报名Service - 新用户报名失败");
            result.put("success", false);
            result.put("msg", "报名失败，请稍后重试");
            return result;
        } catch (Exception e) {
            System.out.println("报名Service - 发生异常: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "报名失败：" + e.getMessage());
            return result;
        } finally {
            System.out.println("=== 报名Service结束 ===");
        }
    }


    @Override
    public boolean checkActivityCapacity(Integer activityId) {
        try {
            return activitiesMapper.checkCapacity(activityId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int incrementParticipantCount(Integer activityId) {
        try {
            return activitiesMapper.incrementParticipantCount(activityId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int syncParticipantCount(Integer activityId) {
        try {
            return activitiesMapper.syncParticipantCount(activityId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int syncAllParticipantCounts() {
        try {
            return activitiesMapper.syncAllParticipantCounts();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int autoCloseFullActivities() {
        try {
            return activitiesMapper.autoCloseFullActivities();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int setAbsentForExpiredActivities() {
        try {
            return activitiesMapper.setAbsentForExpiredActivities();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}
