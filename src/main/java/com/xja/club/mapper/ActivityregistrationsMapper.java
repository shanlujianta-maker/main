package com.xja.club.mapper;

import com.xja.club.pojo.Activityregistrations;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
* @author yao
* @description 针对表【activityregistrations】的数据库操作Mapper
* @createDate 2025-09-07 20:55:12
* @Entity generator.domain.Activityregistrations
*/
@Mapper
public interface ActivityregistrationsMapper {

    int deleteByPrimaryKey(Integer id);

    int insert(Activityregistrations record);

    int insertSelective(Activityregistrations record);

    Activityregistrations selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Activityregistrations record);

    int updateByPrimaryKey(Activityregistrations record);
    // 根据用户ID和活动ID查询报名记录
    List<Activityregistrations> selectByUserIdAndActivityId(Activityregistrations example);

    // 根据活动ID统计报名人数
    int countByActivityId(Integer activityId);

    // 根据用户ID和活动ID删除报名记录
    int deleteByUserIdAndActivityId(Integer userId, Integer activityId);

    // 检查用户是否已报名某活动
    int checkRegistrationExists(@Param("userId") Integer userId, @Param("activityId") Integer activityId);

    // 更新签到状态（通过用户ID和活动ID）
    int updateCheckInStatus(@Param("userId") Integer userId, @Param("activityId") Integer activityId, 
                           @Param("status") String status, @Param("checkInTime") Date checkInTime);

    // 根据用户ID和活动ID删除报名记录
    int deleteByUserAndActivity(@Param("userId") Integer userId, @Param("activityId") Integer activityId);

    // 获取用户报名的活动列表（包含活动详情）
    List<Map<String, Object>> getMyActivitiesWithDetails(@Param("userId") Integer userId);

    // 根据报名记录ID更新签到状态
    int updateCheckInStatusByRegistrationId(@Param("registrationId") Integer registrationId, 
                                           @Param("status") String status, @Param("checkInTime") Date checkInTime);
    
    // 根据用户ID和活动ID查询单个报名记录
    Activityregistrations selectByUserAndActivity(@Param("userId") Integer userId, @Param("activityId") Integer activityId);
    
    Activityregistrations selectRegisteredByUserAndActivity(@Param("userId") Integer userId, @Param("activityId") Integer activityId);
}
