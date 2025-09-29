package com.xja.club.mapper;

import com.xja.club.pojo.Eventhosts;
import org.apache.ibatis.annotations.Mapper;

/**
* @author yao
* @description 针对表【eventhosts】的数据库操作Mapper
* @createDate 2025-09-07 20:55:12
* @Entity generator.domain.Eventhosts
*/
@Mapper
public interface EventhostsMapper {

    int deleteByPrimaryKey(Long id);

    int insert(Eventhosts record);

    int insertSelective(Eventhosts record);

    Eventhosts selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Eventhosts record);

    int updateByPrimaryKey(Eventhosts record);

}
