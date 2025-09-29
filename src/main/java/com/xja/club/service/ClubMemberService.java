package com.xja.club.service;

import com.xja.club.pojo.ClubMember;

import java.util.List;

public interface ClubMemberService {
    
    /**
     * 获取所有成员信息（带关联信息）
     */
    List<ClubMember> getAllMembers();
    
    /**
     * 根据ID获取成员信息
     */
    ClubMember getMemberById(Integer membershipId);
    
    /**
     * 根据社团ID获取成员列表
     */
    List<ClubMember> getMembersByClubId(Integer clubId);
    
    /**
     * 根据用户ID获取成员列表
     */
    List<ClubMember> getMembersByUserId(Integer userId);
    
    /**
     * 保存成员信息（新增或更新）
     */
    boolean saveMember(ClubMember member);
    
    /**
     * 删除成员
     */
    boolean deleteMember(Integer membershipId);
    
    /**
     * 检查用户是否已加入社团
     */
    boolean isUserInClub(Integer userId, Integer clubId);
    
    /**
     * 更新成员状态
     */
    boolean updateMemberStatus(Integer membershipId, String status);
    
    /**
     * 更新成员角色
     */
    boolean updateMemberRole(Integer membershipId, String role);
}
