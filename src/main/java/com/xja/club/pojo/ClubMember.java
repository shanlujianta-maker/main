package com.xja.club.pojo;

import java.util.Date;

/**
 * 社团成员实体类
 * 
 * @TableName clubmember
 */
public class ClubMember {
    /**
     * 成员关系唯一标识，自增
     */
    private Integer membershipId;

    /**
     * 用户ID，关联到Users.user_id
     */
    private Integer userId;

    /**
     * 社团ID，关联到Clubs.club_id
     */
    private Integer clubId;

    /**
     * 在社团中的角色
     */
    private String roleInClub;

    /**
     * 加入日期
     */
    private Date joinDate;

    /**
     * 申请加入理由
     */
    private String applicationReason;

    /**
     * 成员状态：申请中、在职、已离职
     */
    private String memberStatus;

    // 关联查询字段
    /**
     * 用户真实姓名
     */
    private String realName;

    /**
     * 用户联系方式
     */
    private String userPhone;

    /**
     * 用户类型
     */
    private String userType;

    /**
     * 社团名称
     */
    private String clubName;

    /**
     * 社团描述
     */
    private String clubDescription;

    /**
     * 社团状态
     */
    private String clubStatus;

    // 构造函数
    public ClubMember() {
    }

    public ClubMember(Integer membershipId, Integer userId, Integer clubId, String roleInClub, Date joinDate, String applicationReason, String memberStatus, String realName, String userPhone, String userType, String clubName, String clubDescription, String clubStatus) {
        this.membershipId = membershipId;
        this.userId = userId;
        this.clubId = clubId;
        this.roleInClub = roleInClub;
        this.joinDate = joinDate;
        this.applicationReason = applicationReason;
        this.memberStatus = memberStatus;
        this.realName = realName;
        this.userPhone = userPhone;
        this.userType = userType;
        this.clubName = clubName;
        this.clubDescription = clubDescription;
        this.clubStatus = clubStatus;
    }

    // Getter和Setter方法
    public Integer getMembershipId() {
        return membershipId;
    }

    public void setMembershipId(Integer membershipId) {
        this.membershipId = membershipId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getClubId() {
        return clubId;
    }

    public void setClubId(Integer clubId) {
        this.clubId = clubId;
    }

    public String getRoleInClub() {
        return roleInClub;
    }

    public void setRoleInClub(String roleInClub) {
        this.roleInClub = roleInClub;
    }

    public Date getJoinDate() {
        return joinDate;
    }

    public void setJoinDate(Date joinDate) {
        this.joinDate = joinDate;
    }

    public String getApplicationReason() {
        return applicationReason;
    }

    public void setApplicationReason(String applicationReason) {
        this.applicationReason = applicationReason;
    }

    public String getMemberStatus() {
        return memberStatus;
    }

    public void setMemberStatus(String memberStatus) {
        this.memberStatus = memberStatus;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getUserPhone() {
        return userPhone;
    }

    public void setUserPhone(String userPhone) {
        this.userPhone = userPhone;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public String getClubName() {
        return clubName;
    }

    public void setClubName(String clubName) {
        this.clubName = clubName;
    }

    public String getClubDescription() {
        return clubDescription;
    }

    public void setClubDescription(String clubDescription) {
        this.clubDescription = clubDescription;
    }

    public String getClubStatus() {
        return clubStatus;
    }

    public void setClubStatus(String clubStatus) {
        this.clubStatus = clubStatus;
    }
}
