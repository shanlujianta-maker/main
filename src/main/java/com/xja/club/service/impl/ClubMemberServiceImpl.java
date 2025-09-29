package com.xja.club.service.impl;

import com.xja.club.mapper.ClubMemberMapper;
import com.xja.club.pojo.ClubMember;
import com.xja.club.pojo.MemberDetailDTO;
import com.xja.club.service.ClubMemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class ClubMemberServiceImpl implements ClubMemberService {

    @Autowired
    private ClubMemberMapper clubMemberMapper;

    @Override
    public List<ClubMember> getAllMembers() {
        try {
            // 从数据库获取真实数据
            return clubMemberMapper.selectAllWithDetails();
        } catch (Exception e) {
            e.printStackTrace();
            // 如果数据库查询失败，返回空列表
            return new ArrayList<>();
        }
    }
    
    /**
     * 获取所有成员详情（包含关联信息）
     */
    public List<MemberDetailDTO> getAllMemberDetails() {
        List<ClubMember> members = getAllMembers();
        List<MemberDetailDTO> memberDetails = new ArrayList<>();
        
        for (ClubMember member : members) {
            MemberDetailDTO dto = new MemberDetailDTO(
                member.getMembershipId(),
                member.getUserId(),
                member.getClubId(),
                member.getRoleInClub(),
                member.getJoinDate(),
                member.getApplicationReason(),
                member.getMemberStatus(),
                member.getRealName(),
                member.getUserPhone(),
                member.getUserType(),
                member.getClubName(),
                member.getClubDescription(),
                member.getClubStatus()
            );
            memberDetails.add(dto);
        }
        
        return memberDetails;
    }

    @Override
    public ClubMember getMemberById(Integer membershipId) {
        try {
            // 从数据库获取真实数据
            return clubMemberMapper.selectByPrimaryKey(membershipId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<ClubMember> getMembersByClubId(Integer clubId) {
        try {
            // 从数据库获取真实数据
            return clubMemberMapper.selectByClubId(clubId);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    @Override
    public List<ClubMember> getMembersByUserId(Integer userId) {
        try {
            // 从数据库获取真实数据
            return clubMemberMapper.selectByUserId(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    @Override
    @Transactional
    public boolean saveMember(ClubMember member) {
        try {
            if (member.getMembershipId() == null) {
                // 新增成员
                int result = clubMemberMapper.insertSelective(member);
                return result > 0;
            } else {
                // 更新成员
                int result = clubMemberMapper.updateByPrimaryKeySelective(member);
                return result > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    @Transactional
    public boolean deleteMember(Integer membershipId) {
        try {
            int result = clubMemberMapper.deleteByPrimaryKey(membershipId);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean isUserInClub(Integer userId, Integer clubId) {
        try {
            // 从数据库查询用户是否已加入社团
            ClubMember member = clubMemberMapper.selectByUserAndClub(userId, clubId);
            return member != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    @Transactional
    public boolean updateMemberStatus(Integer membershipId, String status) {
        try {
            ClubMember member = new ClubMember();
            member.setMembershipId(membershipId);
            member.setMemberStatus(status);
            int result = clubMemberMapper.updateByPrimaryKeySelective(member);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    @Transactional
    public boolean updateMemberRole(Integer membershipId, String role) {
        try {
            ClubMember member = new ClubMember();
            member.setMembershipId(membershipId);
            member.setRoleInClub(role);
            int result = clubMemberMapper.updateByPrimaryKeySelective(member);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
