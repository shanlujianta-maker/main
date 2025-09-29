package com.xja.club.controller;

import com.xja.club.pojo.Clubs;
import com.xja.club.service.ClubsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 社团管理控制器
 * 
 * 功能说明：
 * 1. 提供社团的CRUD操作接口
 * 2. 处理社团相关的业务逻辑
 * 3. 与前端页面进行数据交互
 * 4. 支持社团信息管理和数据验证
 * 
 * 主要接口：
 * - GET /api/clubs/getAllClubs - 获取所有社团列表
 * - GET /api/clubs/{clubId} - 根据ID获取社团详情
 * - POST /api/clubs/save - 保存社团（新增/更新）
 * - PUT /api/clubs/update/{clubId} - 更新社团
 * - DELETE /api/clubs/{clubId} - 删除社团
 * - GET /api/clubs/check/{clubId} - 检查社团是否存在
 * 
 * @author 系统管理员
 * @version 1.0
 * @since 2025-01-01
 */
@Controller
@RequestMapping("/api/clubs")
public class ClubsController {

    @Autowired
    private ClubsService clubsService; // 社团服务层，处理社团相关业务逻辑

    /**
     * 获取所有社团列表
     * 
     * 功能说明：
     * - 从数据库获取所有社团信息
     * - 供社团列表页面和下拉选择使用
     * - 返回JSON格式的社团列表数据
     * 
     * 请求方式：GET
     * 请求路径：/api/clubs/getAllClubs
     * 
     * @return List<Clubs> 社团列表，异常时返回null
     * 
     * 异常处理：
     * - 数据库连接异常：返回null，前端显示无数据
     * - 其他异常：打印异常信息，返回null
     */
    @GetMapping("/getAllClubs")
    @ResponseBody
    public List<Clubs> getAllClubs() {
        try {
            return clubsService.getAllClubs();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 根据ID获取社团详情
     */
    @GetMapping("/{clubId}")
    @ResponseBody
    public Map<String, Object> getClubById(@PathVariable Integer clubId) {
        Map<String, Object> result = new HashMap<>();
        try {
            Clubs club = clubsService.getClubById(clubId);
            if (club != null) {
                result.put("success", true);
                result.put("data", club);
            } else {
                result.put("success", false);
                result.put("msg", "社团不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "查询异常：" + e.getMessage());
        }
        return result;
    }

    /**
     * 保存社团（新增/更新）
     */
    @PostMapping("/save")
    @ResponseBody
    public Map<String, Object> saveClub(@RequestBody Clubs club) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 验证必填字段
            if (club.getClubName() == null || club.getClubName().trim().isEmpty()) {
                result.put("success", false);
                result.put("msg", "社团名称不能为空");
                return result;
            }

            int rows = clubsService.saveClub(club);
            result.put("success", rows > 0);
            result.put("msg", rows > 0 ? "保存成功" : "保存失败");
            if (rows > 0 && club.getClubId() == null) {
                result.put("clubId", club.getClubId());
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "保存异常：" + e.getMessage());
        }
        return result;
    }

    /**
     * 更新社团
     */
    @PutMapping("/update/{clubId}")
    @ResponseBody
    public Map<String, Object> updateClub(@PathVariable Integer clubId, @RequestBody Clubs club) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 验证必填字段
            if (club.getClubName() == null || club.getClubName().trim().isEmpty()) {
                result.put("success", false);
                result.put("msg", "社团名称不能为空");
                return result;
            }

            // 设置社团ID
            club.setClubId(clubId);
            
            int rows = clubsService.saveClub(club);
            result.put("success", rows > 0);
            result.put("msg", rows > 0 ? "更新成功" : "更新失败");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "更新异常：" + e.getMessage());
        }
        return result;
    }

    /**
     * 删除社团
     */
    @DeleteMapping("/{clubId}")
    @ResponseBody
    public Map<String, Object> deleteClub(@PathVariable Integer clubId) {
        Map<String, Object> result = new HashMap<>();
        try {
            int rows = clubsService.deleteClub(clubId);
            result.put("success", rows > 0);
            result.put("msg", rows > 0 ? "删除成功" : "删除失败");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "删除异常：" + e.getMessage());
        }
        return result;
    }

    /**
     * 检查社团是否存在
     */
    @GetMapping("/check/{clubId}")
    @ResponseBody
    public Map<String, Object> checkClubExists(@PathVariable Integer clubId) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean exists = clubsService.checkClubExists(clubId);
            result.put("success", true);
            result.put("exists", exists);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "检查异常：" + e.getMessage());
        }
        return result;
    }
}
