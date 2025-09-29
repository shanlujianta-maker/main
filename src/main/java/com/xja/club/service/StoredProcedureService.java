package com.xja.club.service;

import java.util.Map;

/**
 * 存储过程服务接口
 */
public interface StoredProcedureService {
    
    /**
     * 创建活动
     * @param activityName 活动名称
     * @param description 活动描述
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @param location 活动地点
     * @param organizingClubId 组织社团ID
     * @param maxParticipants 最大参与人数
     * @param createdByUserId 创建者用户ID
     * @return 新创建的活动ID
     */
    Integer createActivity(String activityName, String description, 
                          String startTime, String endTime, String location,
                          Integer organizingClubId, Integer maxParticipants, 
                          Integer createdByUserId);
    
    /**
     * 活动报名
     * @param userId 用户ID
     * @param activityId 活动ID
     * @return 报名结果
     */
    String registerActivity(Integer userId, Integer activityId);
    
    /**
     * 活动签到
     * @param registrationId 报名记录ID
     * @param userId 用户ID
     * @return 签到结果
     */
    String checkInActivity(Integer registrationId, Integer userId);
}
