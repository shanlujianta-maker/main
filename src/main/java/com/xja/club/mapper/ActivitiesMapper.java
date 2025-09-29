package com.xja.club.mapper;

import com.xja.club.pojo.Activities;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface ActivitiesMapper {

    int deleteByPrimaryKey(Integer id);

    int insert(Activities record);

    int insertSelective(Activities record);

    Activities selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Activities record);

    int updateByPrimaryKey(Activities record);

    List<Activities> listAll();

    // 新增的视图查询方法
    List<Map<String, Object>> selectAllWithDetails();
    
    List<Map<String, Object>> selectActivityNotices();
    
    List<Map<String, Object>> selectRegistrationStats();
    
    // 参与人数管理方法
    int incrementParticipantCount(Integer activityId);
    
    int decrementParticipantCount(Integer activityId);
    
    boolean checkCapacity(Integer activityId);
    
    int syncParticipantCount(Integer activityId);
    
    int syncAllParticipantCounts();
    
    int autoCloseFullActivities();
    
    int setAbsentForExpiredActivities();
    
    // 新增的触发器相关方法
    /**
     * 更新过期的活动状态为completed
     */
    int updateExpiredActivitiesToCompleted();
    
    /**
     * 更新已开始的活动状态为ongoing
     */
    int updateStartedActivitiesToOngoing();
}
