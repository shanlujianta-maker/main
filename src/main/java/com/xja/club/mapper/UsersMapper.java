package com.xja.club.mapper;

import com.xja.club.pojo.Users;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
* @author yao
* @description 针对表【users】的数据库操作Mapper
* @createDate 2025-09-07 20:55:12
* @Entity generator.domain.Users
*/
@Mapper

public interface UsersMapper {

    int deleteByPrimaryKey(Long id);

    int insert(Users record);

    int insertSelective(Users record);

    Users selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Users record);

    int updateByPrimaryKey(Users record);

    // 新增：根据手机号查询用户（用于登录注册验证）
    Users selectByPhone(@Param("userPhone") String userPhone);


}
