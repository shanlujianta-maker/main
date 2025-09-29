package com.xja.club.mapper;

import com.xja.club.pojo.Clubs;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
* @author yao
* @description 针对表【clubs】的数据库操作Mapper
* @createDate 2025-09-07 20:55:12
* @Entity generator.domain.Clubs
*/
@Mapper
public interface ClubsMapper {

    int deleteByPrimaryKey(Integer id);

    int insert(Clubs record);

    int insertSelective(Clubs record);

    Clubs selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Clubs record);

    int updateByPrimaryKey(Clubs record);
    List<Clubs> selectAll();

}
