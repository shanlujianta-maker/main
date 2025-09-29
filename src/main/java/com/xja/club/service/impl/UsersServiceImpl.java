package com.xja.club.service.impl;

import com.xja.club.mapper.UsersMapper;
import com.xja.club.pojo.Users;
import com.xja.club.service.UsersService;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
@Transactional
@Setter
public class UsersServiceImpl implements UsersService {

    @Autowired
    private UsersMapper usersMapper;

    /**
     * 使用手机号和密码进行登录验证
     * @param userPhone 手机号（登录账号）
     * @param password 密码
     * @return 验证通过返回用户信息，否则返回null
     */
    @Override
    public Users loginByPhone(String userPhone, String password) {
            // 1. 参数校验
            if (userPhone == null || userPhone.trim().isEmpty() ||
                    password == null || password.trim().isEmpty()) {
                return null;
            }
            // 2. 根据手机号查询用户
            Users user = usersMapper.selectByPhone(userPhone);
            if (user == null) {
                return null; // 手机号不存在
            }
            // 3. 密码校验
            if (!password.equals(user.getUserPassword())) {
                return null; // 密码错误
            }

            return user; // 验证通过
        }


    @Override
    public Users selectByPhone(String userPhone) {
        return usersMapper.selectByPhone(userPhone);
    }

    @Override
    public int insert(Users newUser) {
            try {
                // 参数校验
                if (newUser == null) {
                    throw new IllegalArgumentException("用户信息不能为空");
                }

                // 验证必填字段
                if (newUser.getRealName() == null || newUser.getRealName().trim().isEmpty()) {
                    throw new IllegalArgumentException("真实姓名不能为空");
                }

                if (newUser.getUserPhone() == null || newUser.getUserPhone().trim().isEmpty()) {
                    throw new IllegalArgumentException("手机号不能为空");
                }

                if (newUser.getUserPassword() == null || newUser.getUserPassword().trim().isEmpty()) {
                    throw new IllegalArgumentException("密码不能为空");
                }

                if (newUser.getUserType() == null) {
                    throw new IllegalArgumentException("用户类型不能为空");
                }

                // 验证手机号格式
                String phoneRegex = "^1[3-9]\\d{9}$";
                if (!newUser.getUserPhone().matches(phoneRegex)) {
                    throw new IllegalArgumentException("手机号格式不正确");
                }

                // 验证密码长度
                if (newUser.getUserPassword().length() < 6) {
                    throw new IllegalArgumentException("密码长度不能少于6位");
                }

                // 检查手机号是否已存在
                Users existingUser = usersMapper.selectByPhone(newUser.getUserPhone());
                if (existingUser != null) {
                    throw new IllegalArgumentException("该手机号已被注册");
                }


                // 插入用户数据
                return usersMapper.insert(newUser);

            } catch (IllegalArgumentException e) {
                // 记录业务异常日志
                System.err.println("用户注册业务异常: " + e.getMessage());
                throw e; // 重新抛出，让Controller处理
            } catch (Exception e) {
                // 记录系统异常日志
                System.err.println("用户注册系统异常: " + e.getMessage());
                throw new RuntimeException("系统错误，注册失败", e);
            }
        }
    }

