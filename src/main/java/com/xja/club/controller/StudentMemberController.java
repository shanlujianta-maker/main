package com.xja.club.controller;

import com.xja.club.mapper.ClubMemberMapper;
import com.xja.club.pojo.ClubMember;
import com.xja.club.pojo.Users;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 学生用户成员管理控制器
 */
@RestController
@RequestMapping("/api/club-member")
@CrossOrigin(origins = "*")
public class StudentMemberController {

    @Autowired
    private ClubMemberMapper clubMemberMapper;

    /**
     * 获取当前用户的社团信息
     */
    @GetMapping("/user-club-info")
    public Map<String, Object> getUserClubInfo(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            System.out.println("开始获取用户社团信息...");
            
            Users loginUser = (Users) session.getAttribute("loginUser");
            if (loginUser == null) {
                System.out.println("用户未登录");
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            System.out.println("用户ID: " + loginUser.getUserId() + ", 用户类型: " + loginUser.getUserType());

            if (!"student".equals(loginUser.getUserType())) {
                System.out.println("用户类型不是学生");
                result.put("success", false);
                result.put("message", "权限不足");
                return result;
            }

            // 查询用户的社团信息
            System.out.println("查询用户社团信息...");
            List<ClubMember> userClubMembers = clubMemberMapper.selectByUserId(loginUser.getUserId());
            System.out.println("查询结果数量: " + (userClubMembers != null ? userClubMembers.size() : 0));
            
            if (userClubMembers == null || userClubMembers.isEmpty()) {
                System.out.println("用户没有加入任何社团");
                result.put("success", false);
                result.put("message", "您还没有加入任何社团");
                return result;
            }
            ClubMember userClubMember = userClubMembers.get(0); // 取第一个社团

            Map<String, Object> clubInfo = new HashMap<>();
            clubInfo.put("clubId", userClubMember.getClubId());
            clubInfo.put("roleInClub", userClubMember.getRoleInClub());
            clubInfo.put("clubName", userClubMember.getClubName());

            result.put("success", true);
            result.put("data", clubInfo);
            result.put("message", "获取社团信息成功");
            
            System.out.println("成功获取社团信息: " + clubInfo);

        } catch (Exception e) {
            System.err.println("获取社团信息时发生异常: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "获取社团信息失败：" + e.getMessage());
        }

        return result;
    }

    /**
     * 获取本社团的成员列表（学生用户）
     */
    @GetMapping("/student-members")
    public Map<String, Object> getStudentMembers(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            System.out.println("开始获取成员列表...");
            
            Users loginUser = (Users) session.getAttribute("loginUser");
            if (loginUser == null) {
                System.out.println("用户未登录");
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            System.out.println("用户ID: " + loginUser.getUserId() + ", 用户类型: " + loginUser.getUserType());

            if (!"student".equals(loginUser.getUserType())) {
                System.out.println("用户类型不是学生");
                result.put("success", false);
                result.put("message", "权限不足");
                return result;
            }

            // 查询用户的社团信息
            System.out.println("查询用户社团信息...");
            List<ClubMember> userClubMembers = clubMemberMapper.selectByUserId(loginUser.getUserId());
            System.out.println("用户社团数量: " + (userClubMembers != null ? userClubMembers.size() : 0));
            
            if (userClubMembers == null || userClubMembers.isEmpty()) {
                System.out.println("用户没有加入任何社团");
                result.put("success", false);
                result.put("message", "您还没有加入任何社团");
                return result;
            }
            ClubMember userClubMember = userClubMembers.get(0);
            System.out.println("用户社团ID: " + userClubMember.getClubId());

            // 查询本社团的所有成员
            System.out.println("查询社团成员列表...");
            List<ClubMember> members = clubMemberMapper.selectByClubId(userClubMember.getClubId());
            System.out.println("社团成员数量: " + (members != null ? members.size() : 0));
            
            result.put("success", true);
            result.put("data", members);
            result.put("message", "获取成员列表成功");
            
            System.out.println("成功获取成员列表，数量: " + (members != null ? members.size() : 0));

        } catch (Exception e) {
            System.err.println("获取成员列表时发生异常: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "获取成员列表失败：" + e.getMessage());
        }

        return result;
    }

    /**
     * 更新成员信息（仅限president角色）
     */
    @PutMapping("/update")
    public Map<String, Object> updateMember(@RequestBody Map<String, Object> memberData, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            Users loginUser = (Users) session.getAttribute("loginUser");
            if (loginUser == null) {
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            if (!"student".equals(loginUser.getUserType())) {
                result.put("success", false);
                result.put("message", "权限不足");
                return result;
            }

            // 检查用户是否为president
            List<ClubMember> userClubMembers = clubMemberMapper.selectByUserId(loginUser.getUserId());
            if (userClubMembers == null || userClubMembers.isEmpty()) {
                result.put("success", false);
                result.put("message", "您还没有加入任何社团");
                return result;
            }
            ClubMember userClubMember = userClubMembers.get(0);
            if (!"president".equals(userClubMember.getRoleInClub())) {
                result.put("success", false);
                result.put("message", "只有社团管理者才能修改成员信息");
                return result;
            }

            // 获取要更新的成员信息
            Integer membershipId = (Integer) memberData.get("membershipId");
            String realName = (String) memberData.get("realName");
            Integer userId = (Integer) memberData.get("userId");
            String userPhone = (String) memberData.get("userPhone");
            String roleInClub = (String) memberData.get("roleInClub");

            if (membershipId == null) {
                result.put("success", false);
                result.put("message", "成员ID不能为空");
                return result;
            }

            // 查询要更新的成员
            ClubMember member = clubMemberMapper.selectByPrimaryKey(membershipId);
            if (member == null) {
                result.put("success", false);
                result.put("message", "成员不存在");
                return result;
            }

            // 检查是否为同一社团
            if (!member.getClubId().equals(userClubMember.getClubId())) {
                result.put("success", false);
                result.put("message", "只能修改本社团成员信息");
                return result;
            }

            // 更新成员信息
            if (realName != null) member.setRealName(realName);
            if (userId != null) member.setUserId(userId);
            if (userPhone != null) member.setUserPhone(userPhone);
            if (roleInClub != null) member.setRoleInClub(roleInClub);

            int updateResult = clubMemberMapper.updateByPrimaryKeySelective(member);
            if (updateResult > 0) {
                result.put("success", true);
                result.put("message", "更新成功");
            } else {
                result.put("success", false);
                result.put("message", "更新失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "更新失败：" + e.getMessage());
        }

        return result;
    }

    /**
     * 删除成员（仅限president角色）
     */
    @DeleteMapping("/delete/{membershipId}")
    public Map<String, Object> deleteMember(@PathVariable Integer membershipId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            Users loginUser = (Users) session.getAttribute("loginUser");
            if (loginUser == null) {
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            if (!"student".equals(loginUser.getUserType())) {
                result.put("success", false);
                result.put("message", "权限不足");
                return result;
            }

            // 检查用户是否为president
            List<ClubMember> userClubMembers = clubMemberMapper.selectByUserId(loginUser.getUserId());
            if (userClubMembers == null || userClubMembers.isEmpty()) {
                result.put("success", false);
                result.put("message", "您还没有加入任何社团");
                return result;
            }
            ClubMember userClubMember = userClubMembers.get(0);
            if (!"president".equals(userClubMember.getRoleInClub())) {
                result.put("success", false);
                result.put("message", "只有社团管理者才能删除成员");
                return result;
            }

            // 查询要删除的成员
            ClubMember member = clubMemberMapper.selectByPrimaryKey(membershipId);
            if (member == null) {
                result.put("success", false);
                result.put("message", "成员不存在");
                return result;
            }

            // 检查是否为同一社团
            if (!member.getClubId().equals(userClubMember.getClubId())) {
                result.put("success", false);
                result.put("message", "只能删除本社团成员");
                return result;
            }

            // 不能删除自己
            if (member.getUserId().equals(loginUser.getUserId())) {
                result.put("success", false);
                result.put("message", "不能删除自己");
                return result;
            }

            // 删除成员
            int deleteResult = clubMemberMapper.deleteByPrimaryKey(membershipId);
            if (deleteResult > 0) {
                result.put("success", true);
                result.put("message", "删除成功");
            } else {
                result.put("success", false);
                result.put("message", "删除失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "删除失败：" + e.getMessage());
        }

        return result;
    }

    /**
     * 测试API连接
     */
    @GetMapping("/test")
    public Map<String, Object> testApi() {
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "API连接正常");
        return result;
    }

    /**
     * 更新成员状态（审核操作）
     */
    @PostMapping("/update-status")
    public Map<String, Object> updateMemberStatus(@RequestBody Map<String, Object> requestData,
                                                  HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            System.out.println("开始更新成员状态...");
            
            Users loginUser = (Users) session.getAttribute("loginUser");
            if (loginUser == null) {
                System.out.println("用户未登录");
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            if (!"student".equals(loginUser.getUserType())) {
                System.out.println("用户类型不是学生");
                result.put("success", false);
                result.put("message", "权限不足");
                return result;
            }

            // 检查用户是否为社团管理者
            ClubMember userClubInfo = clubMemberMapper.getUserClubInfo(loginUser.getUserId());
            if (userClubInfo == null || !"president".equals(userClubInfo.getRoleInClub())) {
                System.out.println("用户不是社团管理者");
                result.put("success", false);
                result.put("message", "只有社团管理者才能进行审核操作");
                return result;
            }

            Object membershipIdObj = requestData.get("membershipId");
            if (membershipIdObj == null) {
                result.put("success", false);
                result.put("message", "成员ID不能为空");
                return result;
            }
            
            Integer membershipId;
            try {
                if (membershipIdObj instanceof String) {
                    membershipId = Integer.parseInt((String) membershipIdObj);
                } else if (membershipIdObj instanceof Integer) {
                    membershipId = (Integer) membershipIdObj;
                } else {
                    membershipId = Integer.parseInt(membershipIdObj.toString());
                }
            } catch (NumberFormatException e) {
                result.put("success", false);
                result.put("message", "成员ID格式错误");
                return result;
            }

            String newStatus = (String) requestData.get("memberStatus");
            if (newStatus == null || newStatus.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "状态参数不能为空");
                return result;
            }

            // 验证状态值（使用数据库枚举值）
            if (!"active".equals(newStatus) && !"applying".equals(newStatus) && 
                !"resigned".equals(newStatus)) {
                result.put("success", false);
                result.put("message", "无效的状态值");
                return result;
            }

            // 检查成员是否存在且属于当前用户的社团
            ClubMember targetMember = clubMemberMapper.getMemberById(membershipId);
            if (targetMember == null) {
                System.out.println("成员不存在");
                result.put("success", false);
                result.put("message", "成员不存在");
                return result;
            }

            if (!targetMember.getClubId().equals(userClubInfo.getClubId())) {
                System.out.println("成员不属于当前用户的社团");
                result.put("success", false);
                result.put("message", "只能管理本社团的成员");
                return result;
            }

            // 更新成员状态
            int updateResult = clubMemberMapper.updateMemberStatus(membershipId, newStatus);
            if (updateResult > 0) {
                System.out.println("成员状态更新成功");
                result.put("success", true);
                result.put("message", "状态更新成功");
            } else {
                System.out.println("成员状态更新失败");
                result.put("success", false);
                result.put("message", "状态更新失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "更新失败：" + e.getMessage());
        }

        return result;
    }
}