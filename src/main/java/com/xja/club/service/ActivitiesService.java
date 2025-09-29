package com.xja.club.service;

import com.xja.club.pojo.Activities;
import java.util.List;
import java.util.Map;

/**
 * 活动服务接口
 * 
 * 功能说明：
 * 1. 提供活动相关的业务逻辑处理
 * 2. 管理活动的生命周期（创建、更新、删除）
 * 3. 处理活动报名和参与人数管理
 * 4. 支持活动状态自动更新和同步
 * 5. 与数据库触发器配合实现自动化管理
 * 
 * 主要功能模块：
 * - 活动CRUD操作
 * - 活动状态管理
 * - 参与人数统计
 * - 报名管理
 * - 数据同步
 * 
 * @author 系统管理员
 * @version 1.0
 * @since 2025-01-01
 */
public interface ActivitiesService {
    
    /**
     * 获取所有活动列表
     * 
     * 功能说明：
     * - 从数据库查询所有活动信息
     * - 按时间倒序排列
     * - 包含活动的完整信息
     * 
     * @return List<Activities> 活动列表，如果没有活动则返回空列表
     * @throws Exception 数据库查询异常
     */
    List<Activities> listAllActivities();

    /**
     * 保存活动（新增/更新）
     * 
     * 功能说明：
     * - 根据活动ID判断是新增还是更新
     * - 新增时设置默认值
     * - 更新时保持原有数据完整性
     * 
     * @param activity 活动对象
     * @return int 影响的行数，>0表示成功
     * @throws Exception 数据库操作异常
     */
    int saveActivity(Activities activity);

    /**
     * 根据ID获取活动详情
     * 
     * 功能说明：
     * - 根据活动ID查询单个活动
     * - 用于活动详情展示和编辑
     * 
     * @param activityId 活动ID
     * @return Activities 活动对象，不存在时返回null
     * @throws Exception 数据库查询异常
     */
    Activities getActivityById(Integer activityId);

    /**
     * 更新活动状态
     * 
     * 功能说明：
     * - 更新活动的状态字段
     * - 支持的状态：planning, open, ongoing, completed, cancelled
     * - 状态变更会触发相关触发器
     * 
     * @param activityId 活动ID
     * @param status 新的状态值
     * @return int 影响的行数，>0表示成功
     * @throws Exception 数据库操作异常
     */
    int updateActivityStatus(Integer activityId, String status);

    /**
     * 删除活动
     * 
     * 功能说明：
     * - 根据活动ID删除活动
     * - 级联删除相关的报名记录
     * - 删除操作不可逆
     * 
     * @param activityId 活动ID
     * @return int 影响的行数，>0表示成功
     * @throws Exception 数据库操作异常
     */
    int deleteActivity(Integer activityId);
    
    /**
     * 用户报名活动
     * 
     * 功能说明：
     * - 处理用户报名活动的业务逻辑
     * - 检查活动状态和容量限制
     * - 防止重复报名
     * - 自动更新参与人数
     * 
     * @param userId 用户ID
     * @param activityId 活动ID
     * @return Map<String, Object> 包含操作结果的Map
     *         - success: boolean 操作是否成功
     *         - msg: String 操作结果消息
     * @throws Exception 业务逻辑异常或数据库异常
     */
    Map<String, Object> registerForActivity(Integer userId, Integer activityId);
    
    /**
     * 检查活动容量
     * 
     * 功能说明：
     * - 检查活动是否还有报名名额
     * - 考虑最大参与人数限制
     * - 0表示不限制人数
     * 
     * @param activityId 活动ID
     * @return boolean true表示还有名额，false表示已满
     * @throws Exception 数据库查询异常
     */
    boolean checkActivityCapacity(Integer activityId);
    
    /**
     * 增加活动参与人数
     * 
     * 功能说明：
     * - 报名成功后调用此方法增加参与人数
     * - 原子性操作，确保数据一致性
     * - 配合报名业务使用
     * 
     * @param activityId 活动ID
     * @return int 影响的行数，>0表示成功
     * @throws Exception 数据库操作异常
     */
    int incrementParticipantCount(Integer activityId);
    
    /**
     * 同步单个活动的参与人数
     * 
     * 功能说明：
     * - 根据实际报名记录重新计算参与人数
     * - 排除缺席状态的用户
     * - 用于数据一致性维护
     * 
     * @param activityId 活动ID
     * @return int 同步的活动数量
     * @throws Exception 数据库操作异常
     */
    int syncParticipantCount(Integer activityId);
    
    /**
     * 同步所有活动的参与人数
     * 
     * 功能说明：
     * - 批量同步所有活动的参与人数
     * - 用于定时任务或数据修复
     * - 提高数据一致性
     * 
     * @return int 同步的活动数量
     * @throws Exception 数据库操作异常
     */
    int syncAllParticipantCounts();
    
    /**
     * 自动关闭已满的活动
     * 
     * 功能说明：
     * - 检查所有活动是否已满员
     * - 自动将已满的活动状态改为closed
     * - 防止超员报名
     * 
     * @return int 关闭的活动数量
     * @throws Exception 数据库操作异常
     */
    int autoCloseFullActivities();
    
    /**
     * 设置过期活动的缺席用户
     * 
     * 功能说明：
     * - 将已结束但未签到的用户标记为缺席
     * - 配合触发器使用
     * - 维护数据完整性
     * 
     * @return int 标记为缺席的用户数量
     * @throws Exception 数据库操作异常
     */
    int setAbsentForExpiredActivities();
}
