package com.xja.club.service;

/**
 * 活动状态调度服务接口
 * 用于定期检查和更新活动状态
 */
public interface ActivityStatusSchedulerService {
    
    /**
     * 检查并更新过期的活动状态
     * 将已结束的活动状态设置为completed
     */
    void checkAndUpdateExpiredActivities();
    
    /**
     * 检查并更新进行中的活动
     * 将已开始的活动状态设置为ongoing
     */
    void checkAndUpdateOngoingActivities();
    
    /**
     * 同步所有活动的参与人数
     */
    void syncAllParticipantCounts();
}
