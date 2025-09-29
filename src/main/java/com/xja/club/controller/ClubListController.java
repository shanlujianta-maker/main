package com.xja.club.controller;

import com.xja.club.mapper.ClubsMapper;
import com.xja.club.mapper.ClubMemberMapper;
import com.xja.club.pojo.Clubs;
import com.xja.club.pojo.ClubMember;
import com.xja.club.pojo.Users;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 社团列表控制器 - 用于前端社团列表页面
 */
@RestController
@RequestMapping("/api/clubs/list")
@CrossOrigin(origins = "*")
public class ClubListController {

    @Autowired
    private ClubsMapper clubsMapper;

    @Autowired
    private ClubMemberMapper clubMemberMapper;

    /**
     * 获取所有社团列表（用于前端展示）
     */
    @GetMapping("/all")
    public Map<String, Object> getAllClubs() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<Clubs> clubs = clubsMapper.selectAll();
            response.put("success", true);
            response.put("data", clubs);
            response.put("message", "获取社团列表成功");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "获取社团列表失败: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }

    /**
     * 获取当前登录用户信息
     */
    @GetMapping("/current-user")
    public Map<String, Object> getCurrentUser(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Users loginUser = (Users) session.getAttribute("loginUser");
            if (loginUser != null) {
                Map<String, Object> userInfo = new HashMap<>();
                userInfo.put("userId", loginUser.getUserId());
                userInfo.put("realName", loginUser.getRealName());
                userInfo.put("userPhone", loginUser.getUserPhone());
                userInfo.put("userType", loginUser.getUserType());
                
                response.put("success", true);
                response.put("data", userInfo);
                response.put("message", "获取用户信息成功");
            } else {
                response.put("success", false);
                response.put("message", "用户未登录");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "获取用户信息失败: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }

    /**
     * 根据ID获取社团详情
     */
    @GetMapping("/{id}")
    public Map<String, Object> getClubById(@PathVariable Integer id) {
        Map<String, Object> response = new HashMap<>();
        try {
            Clubs club = clubsMapper.selectByPrimaryKey(id);
            if (club != null) {
                response.put("success", true);
                response.put("data", club);
                response.put("message", "获取社团详情成功");
            } else {
                response.put("success", false);
                response.put("message", "社团不存在");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "获取社团详情失败: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }

    /**
     * 申请加入社团
     */
    @PostMapping("/join")
    public Map<String, Object> joinClub(@RequestBody Map<String, Object> joinData, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 获取当前登录用户
            Users loginUser = (Users) session.getAttribute("loginUser");
            if (loginUser == null) {
                response.put("success", false);
                response.put("message", "请先登录后再申请加入社团");
                return response;
            }

            // 安全地转换clubId
            Integer clubId = null;
            Object clubIdObj = joinData.get("clubId");
            if (clubIdObj instanceof Integer) {
                clubId = (Integer) clubIdObj;
            } else if (clubIdObj instanceof String) {
                try {
                    clubId = Integer.parseInt((String) clubIdObj);
                } catch (NumberFormatException e) {
                    response.put("success", false);
                    response.put("message", "社团ID格式错误");
                    return response;
                }
            }

            String applicationReason = (String) joinData.get("applicationReason");

            // 验证必要字段
            if (clubId == null) {
                response.put("success", false);
                response.put("message", "社团ID不能为空");
                return response;
            }

            // 检查社团是否存在且为活跃状态
            Clubs club = clubsMapper.selectByPrimaryKey(clubId);
            if (club == null) {
                response.put("success", false);
                response.put("message", "社团不存在");
                return response;
            }
            
            if (!"active".equals(club.getClubStatus())) {
                response.put("success", false);
                response.put("message", "该社团已注销，无法申请加入");
                return response;
            }

            // 检查是否已经申请过该社团
            ClubMember existingMember = clubMemberMapper.selectByUserAndClub(loginUser.getUserId(), clubId);
            if (existingMember != null) {
                response.put("success", false);
                response.put("message", "您已经申请过该社团了");
                return response;
            }

            // 创建新的社团成员申请记录
            ClubMember clubMember = new ClubMember();
            clubMember.setUserId(loginUser.getUserId()); // 使用当前登录用户的ID
            clubMember.setClubId(clubId);
            clubMember.setJoinDate(new Date()); // 当前时间
            clubMember.setMemberStatus("applying"); // 申请状态 - 使用数据库枚举值
            clubMember.setRoleInClub("member"); // 默认角色
            clubMember.setApplicationReason(applicationReason); // 申请理由

            // 插入数据库
            int result = clubMemberMapper.insertSelective(clubMember);
            
            if (result > 0) {
                response.put("success", true);
                response.put("message", "申请已提交，等待审核");
            } else {
                response.put("success", false);
                response.put("message", "申请失败，请稍后重试");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "申请失败: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }
}
