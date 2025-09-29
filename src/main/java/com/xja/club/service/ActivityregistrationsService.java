package com.xja.club.service;

import com.xja.club.pojo.Activityregistrations;
import java.util.Date;
import java.util.List;
import java.util.Map;

public interface ActivityregistrationsService {

    // 检查活动是否处于开放报名状态
    boolean isActivityOpen(Integer activityId);

    // 检查用户是否已报名该活动
    boolean checkRegistrationExists(Integer userId, Integer activityId);

    // 检查活动是否已报满
    boolean isActivityFull(Integer activityId);

    // 保存报名记录
    int saveRegistration(Activityregistrations registration);

    // 检查活动是否正在进行中（用于签到）
    boolean isActivityOngoing(Integer activityId);

    // 更新签到状态
    int updateCheckInStatus(Integer userId, Integer activityId, String status, Date checkInTime);

    // 检查活动是否已开始（用于判断是否允许取消报名）
    boolean isActivityStarted(Integer activityId);

    // 取消报名（删除报名记录）
    int deleteRegistration(Integer userId, Integer activityId);

    // 获取用户报名的活动列表（包含活动详情）
    List<Map<String, Object>> getMyActivitiesWithDetails(Integer userId);

    // 活动签到
    boolean checkInActivity(Integer registrationId, Integer userId);
}
