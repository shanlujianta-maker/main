package com.xja.club.service;

import com.xja.club.pojo.Clubs;
import java.util.List;

public interface ClubsService {

    // 获取所有社团列表
    List<Clubs> getAllClubs();

    // 根据ID获取社团
    Clubs getClubById(Integer clubId);

    // 保存社团（新增/更新）
    int saveClub(Clubs club);

    // 删除社团
    int deleteClub(Integer clubId);

    // 检查社团是否存在
    boolean checkClubExists(Integer clubId);
}
