package com.xja.club.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.Date;

/**
 * 活动实体类
 * 
 * 功能说明：
 * 1. 对应数据库中的activities表
 * 2. 存储社团活动的完整信息
 * 3. 支持活动的生命周期管理
 * 4. 与报名记录、社团信息关联
 * 
 * 数据库表：activities
 * 主要字段：
 * - activity_id: 活动唯一标识（主键，自增）
 * - activity_name: 活动名称（必填）
 * - description: 活动详情描述
 * - start_time: 活动开始时间（必填）
 * - end_time: 活动结束时间（必填）
 * - location: 活动地点
 * - organizing_club_id: 主办社团ID（外键）
 * - max_participants: 最大参与人数（0表示不限）
 * - current_participants: 当前参与人数（自动统计）
 * - act_status: 活动状态（枚举值）
 * - created_by_user_id: 创建者用户ID（外键）
 * 
 * 活动状态说明：
 * - planning: 策划中（活动创建后的初始状态）
 * - open: 报名中（开放用户报名）
 * - ongoing: 进行中（活动正在进行）
 * - completed: 已结束（活动正常结束）
 * - cancelled: 已取消（活动被取消）
 * 
 * 关联关系：
 * - 与clubs表：多对一关系（多个活动属于一个社团）
 * - 与users表：多对一关系（多个活动由同一用户创建）
 * - 与activityregistrations表：一对多关系（一个活动有多个报名记录）
 * 
 * @author 系统管理员
 * @version 1.0
 * @since 2025-01-01
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Activities {
    
    /**
     * 活动唯一标识
     * 
     * 数据库字段：activity_id
     * 数据类型：INT
     * 约束：PRIMARY KEY, AUTO_INCREMENT
     * 说明：活动的主键，系统自动生成
     */
    private Integer activityId;

    /**
     * 活动名称
     * 
     * 数据库字段：activity_name
     * 数据类型：VARCHAR(150)
     * 约束：NOT NULL
     * 说明：活动的标题名称，必填字段
     */
    private String activityName;

    /**
     * 活动详情
     * 
     * 数据库字段：description
     * 数据类型：TEXT
     * 约束：NULL
     * 说明：活动的详细描述信息，可选字段
     */
    private String description;

    /**
     * 活动开始时间
     * 
     * 数据库字段：start_time
     * 数据类型：DATETIME
     * 约束：NOT NULL
     * 说明：活动开始的具体时间，必填字段
     */
    private Date startTime;

    /**
     * 活动结束时间
     * 
     * 数据库字段：end_time
     * 数据类型：DATETIME
     * 约束：NOT NULL
     * 说明：活动结束的具体时间，必填字段
     * 约束：end_time > start_time
     */
    private Date endTime;

    /**
     * 活动地点
     * 
     * 数据库字段：location
     * 数据类型：VARCHAR(255)
     * 约束：NULL
     * 说明：活动举办的具体地点，可选字段
     */
    private String location;

    /**
     * 主办社团ID
     * 
     * 数据库字段：organizing_club_id
     * 数据类型：INT
     * 约束：NOT NULL, FOREIGN KEY
     * 说明：组织该活动的社团ID，关联clubs表
     */
    private Integer organizingClubId;

    /**
     * 最大参与人数
     * 
     * 数据库字段：max_participants
     * 数据类型：INT
     * 约束：NOT NULL, DEFAULT 0
     * 说明：活动允许的最大参与人数，0表示不限制人数
     */
    private Integer maxParticipants;

    /**
     * 当前参与人数
     * 
     * 数据库字段：current_participants
     * 数据类型：INT
     * 约束：NOT NULL, DEFAULT 0
     * 说明：当前已报名的人数，由系统自动统计更新
     */
    private Integer currentParticipants;

    /**
     * 活动状态
     * 
     * 数据库字段：act_status
     * 数据类型：ENUM
     * 约束：NOT NULL, DEFAULT 'planning'
     * 可选值：'planning', 'open', 'ongoing', 'completed', 'cancelled'
     * 说明：活动的当前状态，影响用户是否可以报名
     */
    private String actStatus;

    /**
     * 活动创建者ID
     * 
     * 数据库字段：created_by_user_id
     * 数据类型：INT
     * 约束：NOT NULL, FOREIGN KEY
     * 说明：创建该活动的用户ID，关联users表
     */
    private Integer createdByUserId;
}