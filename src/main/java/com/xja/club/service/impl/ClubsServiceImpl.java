package com.xja.club.service.impl;

import com.xja.club.mapper.ClubsMapper;
import com.xja.club.pojo.Clubs;
import com.xja.club.service.ClubsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ClubsServiceImpl implements ClubsService {

    @Autowired
    private ClubsMapper clubsMapper;

    @Override
    public List<Clubs> getAllClubs() {
        // 调用Mapper查询所有社团
        return clubsMapper.selectAll();
    }

    @Override
    public Clubs getClubById(Integer clubId) {
        return clubsMapper.selectByPrimaryKey(clubId);
    }

    @Override
    public int saveClub(Clubs club) {
        if (club.getClubId() == null) {
            // 新增社团
            return clubsMapper.insertSelective(club);
        } else {
            // 更新社团
            return clubsMapper.updateByPrimaryKeySelective(club);
        }
    }

    @Override
    public int deleteClub(Integer clubId) {
        return clubsMapper.deleteByPrimaryKey(clubId);
    }

    @Override
    public boolean checkClubExists(Integer clubId) {
        // 检查社团是否存在
        return clubsMapper.selectByPrimaryKey(clubId) != null;
    }
}
