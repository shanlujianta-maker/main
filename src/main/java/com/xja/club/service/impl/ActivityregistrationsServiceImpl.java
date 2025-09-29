package com.xja.club.service.impl;

import com.xja.club.mapper.ActivityregistrationsMapper;
import com.xja.club.pojo.Activityregistrations;
import com.xja.club.service.ActivityregistrationsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ActivityregistrationsServiceImpl implements ActivityregistrationsService {

    @Autowired
    private ActivityregistrationsMapper activityregistrationsMapper;

    @Override
    public boolean isActivityOpen(Integer activityId) {
        // 这里需要查询活动状态，暂时返回true
        return true;
    }

    @Override
    public boolean checkRegistrationExists(Integer userId, Integer activityId) {
        return activityregistrationsMapper.checkRegistrationExists(userId, activityId) > 0;
    }

    @Override
    public boolean isActivityFull(Integer activityId) {
        // 这里需要查询活动最大参与人数和当前报名人数
        return false;
    }

    @Override
    public int saveRegistration(Activityregistrations registration) {
        return activityregistrationsMapper.insertSelective(registration);
    }

    @Override
    public boolean isActivityOngoing(Integer activityId) {
        // 这里需要查询活动时间，暂时返回true
        return true;
    }

    @Override
    public int updateCheckInStatus(Integer userId, Integer activityId, String status, Date checkInTime) {
        return activityregistrationsMapper.updateCheckInStatus(userId, activityId, status, checkInTime);
    }

    @Override
    public boolean isActivityStarted(Integer activityId) {
        // 这里需要查询活动开始时间，暂时返回false
        return false;
    }

    @Override
    public int deleteRegistration(Integer userId, Integer activityId) {
        return activityregistrationsMapper.deleteByUserAndActivity(userId, activityId);
    }

    @Override
    public List<Map<String, Object>> getMyActivitiesWithDetails(Integer userId) {
        return activityregistrationsMapper.getMyActivitiesWithDetails(userId);
    }

    @Override
    public boolean checkInActivity(Integer registrationId, Integer userId) {
        try {
            // 验证报名记录是否属于当前用户
            Activityregistrations registration = activityregistrationsMapper.selectByPrimaryKey(registrationId);
            if (registration == null || !registration.getUserId().equals(userId)) {
                return false;
            }

            // 检查是否已经签到
            if ("checked_in".equals(registration.getCheckInStatus())) {
                return false;
            }

            // 更新签到状态
            int result = activityregistrationsMapper.updateCheckInStatusByRegistrationId(registrationId, "checked_in", new Date());
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
