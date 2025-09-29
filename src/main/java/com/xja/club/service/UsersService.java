package com.xja.club.service;

import com.xja.club.pojo.Users;

public interface UsersService {


    //根据手机号登录
   public Users loginByPhone(String userPhone, String password);

    // 根据手机号查询用户
    Users selectByPhone(String userPhone);

    int insert(Users newUser);
}
