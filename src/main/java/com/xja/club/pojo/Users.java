package com.xja.club.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 用户实体类
 * 
 * 功能说明：
 * 1. 对应数据库中的users表
 * 2. 存储系统用户的基本信息
 * 3. 支持用户身份验证和权限管理
 * 4. 与活动、社团、报名记录关联
 * 
 * 数据库表：users
 * 主要字段：
 * - user_id: 用户唯一标识（主键，自增）
 * - user_password: 用户密码（加密存储）
 * - real_name: 真实姓名（必填）
 * - user_phone: 联系方式（可选）
 * - user_type: 用户类型（枚举值）
 * - created_at: 账号创建时间（自动生成）
 * 
 * 用户类型说明：
 * - student: 学生用户（普通用户）
 * - admin: 管理员用户（系统管理员）
 * 
 * 关联关系：
 * - 与activities表：一对多关系（一个用户可创建多个活动）
 * - 与activityregistrations表：一对多关系（一个用户可报名多个活动）
 * - 与clubmember表：一对多关系（一个用户可加入多个社团）
 * 
 * 安全说明：
 * - 密码应加密存储
 * - 敏感信息应脱敏处理
 * - 支持用户权限控制
 * 
 * @author 系统管理员
 * @version 1.0
 * @since 2025-01-01
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Users {
    
    /**
     * 用户唯一标识
     * 
     * 数据库字段：user_id
     * 数据类型：INT
     * 约束：PRIMARY KEY, AUTO_INCREMENT
     * 说明：用户的主键，系统自动生成
     */
    private Integer userId;

    /**
     * 用户密码
     * 
     * 数据库字段：user_password
     * 数据类型：VARCHAR(255)
     * 约束：NOT NULL
     * 说明：用户登录密码，应加密存储
     */
    private String userPassword;

    /**
     * 真实姓名
     * 
     * 数据库字段：real_name
     * 数据类型：VARCHAR(100)
     * 约束：NOT NULL
     * 说明：用户的真实姓名，必填字段
     */
    private String realName;

    /**
     * 联系方式
     * 
     * 数据库字段：user_phone
     * 数据类型：VARCHAR(20)
     * 约束：NULL
     * 说明：用户的手机号码或联系方式，可选字段
     */
    private String userPhone;

    /**
     * 用户类型
     * 
     * 数据库字段：user_type
     * 数据类型：ENUM
     * 约束：NOT NULL, DEFAULT 'student'
     * 可选值：'student', 'admin'
     * 说明：用户类型，决定用户权限和功能访问
     */
    private String userType;

    /**
     * 账号创建时间
     * 
     * 数据库字段：created_at
     * 数据类型：DATETIME
     * 约束：NOT NULL, DEFAULT CURRENT_TIMESTAMP
     * 说明：用户账号的创建时间，系统自动生成
     */
    private Date createdAt;

    // ========================================
    // 用户类型常量定义
    // ========================================
    
    /**
     * 学生用户类型
     * 用于标识普通学生用户
     */
    public static final String TYPE_STUDENT = "student";
    
    /**
     * 管理员用户类型
     * 用于标识系统管理员用户
     */
    public static final String TYPE_ADMIN = "admin";
}