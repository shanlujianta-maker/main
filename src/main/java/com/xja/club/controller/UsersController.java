package com.xja.club.controller;

import com.xja.club.pojo.Users;
import com.xja.club.service.UsersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UsersController {

    @Autowired
    private UsersService usersService;

    /**
     * 处理手机号登录请求
     */
    @PostMapping("/login")
    public String login(String userPhone, String password, HttpServletRequest request) {
        // 调用Service进行登录验证
        Users user = usersService.loginByPhone(userPhone, password);
        HttpSession session = request.getSession();
        if (user != null) {
            // 登录成功：保存用户信息到
            session.setAttribute("loginUser", user);
            session.setAttribute("realName", user.getRealName());
            return "redirect:/index.jsp";
        } else {
            // 登录失败：回显错误信息
            request.setAttribute("msg", "账号密码错误");
            return "forward:/admin/login.jsp";
        }
    }

    /**
     * 处理用户注册请求 (AJAX) - 简化版
     */
    @PostMapping("/register")
    @ResponseBody
    public Map<String, Object> register(@RequestParam String realName,
                                        @RequestParam String userPhone,
                                        @RequestParam String userPassword,
                                        @RequestParam String userType) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 创建新用户
            Users newUser = new Users();
            newUser.setRealName(realName);
            newUser.setUserPhone(userPhone);
            newUser.setUserPassword(userPassword);
            newUser.setUserType(userType);
            newUser.setCreatedAt(new Date());

            // 保存用户（Service层会处理所有验证）
            int insertResult = usersService.insert(newUser);

            if (insertResult > 0) {
                result.put("success", true);
                result.put("message", "注册成功");
            } else {
                result.put("success", false);
                result.put("message", "注册失败，请重试");
            }
        } catch (IllegalArgumentException e) {
            // 业务异常
            result.put("success", false);
            result.put("message", e.getMessage());
        } catch (Exception e) {
            // 系统异常
            result.put("success", false);
            result.put("message", "系统错误，请稍后重试");
        }

        return result;
    }


    /**
     * 退出登录 - POST请求（更安全）
     */
    @PostMapping("/logout")
    public String logout(HttpSession session, HttpServletRequest request) {
        try {
            // 获取当前登录用户信息
            Users loginUser = (Users) session.getAttribute("loginUser");
            String userInfo = loginUser != null ?
                    loginUser.getRealName() + "(" + loginUser.getUserPhone() + ")" : "未知用户";


            // 清除Session
            session.removeAttribute("loginUser");
            session.removeAttribute("realName");
            session.invalidate();

            System.out.println("用户注销成功: " + userInfo);

        } catch (Exception e) {
            System.err.println("用户注销异常: " + e.getMessage());
        }

        return "redirect:/admin/login.jsp";
    }

}