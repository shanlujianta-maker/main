package com.xja.club.mapper;

import com.xja.club.pojo.ClubMember;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ClubMemberMapper {
    
    /**
     * 根据主键删除成员
     */
    int deleteByPrimaryKey(Integer membershipId);

    /**
     * 插入成员记录
     */
    int insert(ClubMember record);

    /**
     * 选择性插入成员记录
     */
    int insertSelective(ClubMember record);

    /**
     * 根据主键查询成员
     */
    ClubMember selectByPrimaryKey(Integer membershipId);

    /**
     * 选择性更新成员记录
     */
    int updateByPrimaryKeySelective(ClubMember record);

    /**
     * 根据主键更新成员记录
     */
    int updateByPrimaryKey(ClubMember record);

    /**
     * 查询所有成员（带关联信息）
     */
    List<ClubMember> selectAllWithDetails();

    /**
     * 根据社团ID查询成员
     */
    List<ClubMember> selectByClubId(Integer clubId);

    /**
     * 根据用户ID查询成员
     */
    List<ClubMember> selectByUserId(Integer userId);

    /**
     * 检查用户是否已加入社团
     */
    ClubMember selectByUserAndClub(@Param("userId") Integer userId, @Param("clubId") Integer clubId);

    /**
     * 更新成员状态
     */
    int updateMemberStatus(@Param("membershipId") Integer membershipId, @Param("memberStatus") String memberStatus);

    /**
     * 根据主键查询成员（用于权限检查）
     */
    ClubMember getMemberById(Integer membershipId);

    /**
     * 获取用户社团信息
     */
    ClubMember getUserClubInfo(Integer userId);
}