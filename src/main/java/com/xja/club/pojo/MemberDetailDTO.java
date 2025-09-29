package com.xja.club.pojo;

import java.util.Date;

/**
 * 成员详情DTO，包含关联的用户和社团信息
 */
public class MemberDetailDTO {
    private Integer membershipId;
    private Integer userId;
    private Integer clubId;
    private String roleInClub;
    private Date joinDate;
    private String applicationReason;
    private String memberStatus;
    
    // 用户信息
    private String realName;
    private String userPhone;
    private String userType;
    
    // 社团信息
    private String clubName;
    private String clubDescription;
    private String clubStatus;
    
    // 构造函数
    public MemberDetailDTO() {}
    
    public MemberDetailDTO(Integer membershipId, Integer userId, Integer clubId, 
                          String roleInClub, Date joinDate, String applicationReason, 
                          String memberStatus, String realName, String userPhone, 
                          String userType, String clubName, String clubDescription, 
                          String clubStatus) {
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
    
    @Override
    public String toString() {
        return "MemberDetailDTO{" +
                "membershipId=" + membershipId +
                ", userId=" + userId +
                ", clubId=" + clubId +
                ", roleInClub='" + roleInClub + '\'' +
                ", joinDate=" + joinDate +
                ", applicationReason='" + applicationReason + '\'' +
                ", memberStatus='" + memberStatus + '\'' +
                ", realName='" + realName + '\'' +
                ", userPhone='" + userPhone + '\'' +
                ", userType='" + userType + '\'' +
                ", clubName='" + clubName + '\'' +
                ", clubDescription='" + clubDescription + '\'' +
                ", clubStatus='" + clubStatus + '\'' +
                '}';
    }
}
