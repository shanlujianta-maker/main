package com.xja.club.controller;

import com.xja.club.pojo.ClubMember;
import com.xja.club.pojo.Users;
import com.xja.club.service.ClubMemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/members")
@CrossOrigin(origins = "*")
public class ClubMemberController {

    @Autowired
    private ClubMemberService clubMemberService;

    /**
     * 获取所有成员列表
     */
    @GetMapping("/getAllMembers")
    @ResponseBody
    public Map<String, Object> getAllMembers() {
        Map<String, Object> result = new HashMap<>();
        try {
            // 使用包含关联信息的方法
            List<Object> memberDetails = new ArrayList<>();
            if (clubMemberService instanceof com.xja.club.service.impl.ClubMemberServiceImpl) {
                com.xja.club.service.impl.ClubMemberServiceImpl serviceImpl = 
                    (com.xja.club.service.impl.ClubMemberServiceImpl) clubMemberService;
                memberDetails.addAll(serviceImpl.getAllMemberDetails());
            } else {
                // 如果类型不匹配，使用原来的方法
                memberDetails.addAll(clubMemberService.getAllMembers());
            }
            
            result.put("success", true);
            result.put("data", memberDetails);
            result.put("msg", "获取成员列表成功");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "获取成员列表失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 根据用户角色获取成员列表
     */
    @GetMapping("/getMembersByRole")
    @ResponseBody
    public Map<String, Object> getMembersByRole(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            Users loginUser = (Users) session.getAttribute("loginUser");
            if (loginUser == null) {
                result.put("success", false);
                result.put("msg", "用户未登录");
                return result;
            }

            String userType = loginUser.getUserType();
            List<Object> memberDetails = new ArrayList<>();

            if ("admin".equals(userType)) {
                // 管理员可以看到所有成员
                if (clubMemberService instanceof com.xja.club.service.impl.ClubMemberServiceImpl) {
                    com.xja.club.service.impl.ClubMemberServiceImpl serviceImpl = 
                        (com.xja.club.service.impl.ClubMemberServiceImpl) clubMemberService;
                    memberDetails.addAll(serviceImpl.getAllMemberDetails());
                } else {
                    memberDetails.addAll(clubMemberService.getAllMembers());
                }
            } else {
                result.put("success", false);
                result.put("msg", "权限不足");
                return result;
            }
            
            result.put("success", true);
            result.put("data", memberDetails);
            result.put("msg", "获取成员列表成功");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "获取成员列表失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 根据ID获取成员详情
     */
    @GetMapping("/{membershipId}")
    @ResponseBody
    public Map<String, Object> getMemberById(@PathVariable Integer membershipId) {
        Map<String, Object> result = new HashMap<>();
        try {
            ClubMember member = clubMemberService.getMemberById(membershipId);
            if (member != null) {
                result.put("success", true);
                result.put("data", member);
                result.put("msg", "获取成员详情成功");
            } else {
                result.put("success", false);
                result.put("msg", "成员不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "获取成员详情失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 根据社团ID获取成员列表
     */
    @GetMapping("/club/{clubId}")
    @ResponseBody
    public Map<String, Object> getMembersByClubId(@PathVariable Integer clubId) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<ClubMember> members = clubMemberService.getMembersByClubId(clubId);
            result.put("success", true);
            result.put("data", members);
            result.put("msg", "获取社团成员列表成功");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "获取社团成员列表失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 保存成员信息（新增或更新）
     */
    @PostMapping("/save")
    @ResponseBody
    public Map<String, Object> saveMember(@RequestBody ClubMember member) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 数据验证
            if (member.getUserId() == null) {
                result.put("success", false);
                result.put("msg", "用户ID不能为空");
                return result;
            }
            if (member.getClubId() == null) {
                result.put("success", false);
                result.put("msg", "社团ID不能为空");
                return result;
            }

            // 检查用户是否已加入该社团
            if (member.getMembershipId() == null && clubMemberService.isUserInClub(member.getUserId(), member.getClubId())) {
                result.put("success", false);
                result.put("msg", "该用户已加入此社团");
                return result;
            }

            boolean success = clubMemberService.saveMember(member);
            result.put("success", success);
            result.put("msg", success ? "保存成功" : "保存失败");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "保存失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 更新成员信息
     */
    @PutMapping("/update/{membershipId}")
    @ResponseBody
    public Map<String, Object> updateMember(@PathVariable Integer membershipId, @RequestBody ClubMember member) {
        Map<String, Object> result = new HashMap<>();
        try {
            member.setMembershipId(membershipId);
            boolean success = clubMemberService.saveMember(member);
            result.put("success", success);
            result.put("msg", success ? "更新成功" : "更新失败");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "更新失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 删除成员
     */
    @DeleteMapping("/{membershipId}")
    @ResponseBody
    public Map<String, Object> deleteMember(@PathVariable Integer membershipId) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean success = clubMemberService.deleteMember(membershipId);
            result.put("success", success);
            result.put("msg", success ? "删除成功" : "删除失败");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "删除失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 更新成员状态
     */
    @PutMapping("/status/{membershipId}")
    @ResponseBody
    public Map<String, Object> updateMemberStatus(@PathVariable Integer membershipId, @RequestParam String status) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean success = clubMemberService.updateMemberStatus(membershipId, status);
            result.put("success", success);
            result.put("msg", success ? "状态更新成功" : "状态更新失败");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "状态更新失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 更新成员角色
     */
    @PutMapping("/role/{membershipId}")
    @ResponseBody
    public Map<String, Object> updateMemberRole(@PathVariable Integer membershipId, @RequestParam String role) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean success = clubMemberService.updateMemberRole(membershipId, role);
            result.put("success", success);
            result.put("msg", success ? "角色更新成功" : "角色更新失败");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "角色更新失败: " + e.getMessage());
        }
        return result;
    }
}
