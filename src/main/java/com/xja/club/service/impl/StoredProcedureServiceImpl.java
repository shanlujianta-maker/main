package com.xja.club.service.impl;

import com.xja.club.service.StoredProcedureService;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

@Service
public class StoredProcedureServiceImpl implements StoredProcedureService {

    @Autowired
    private SqlSessionFactory sqlSessionFactory;

    @Override
    public Integer createActivity(String activityName, String description, 
                                String startTime, String endTime, String location,
                                Integer organizingClubId, Integer maxParticipants, 
                                Integer createdByUserId) {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Connection connection = sqlSession.getConnection();
            try (CallableStatement cs = connection.prepareCall("{CALL sp_create_activity(?, ?, ?, ?, ?, ?, ?, ?)}")) {
                cs.setString(1, activityName);
                cs.setString(2, description);
                cs.setString(3, startTime);
                cs.setString(4, endTime);
                cs.setString(5, location);
                cs.setInt(6, organizingClubId);
                cs.setInt(7, maxParticipants);
                cs.setInt(8, createdByUserId);
                
                cs.execute();
                
                // 获取返回的活动ID
                return cs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("创建活动失败", e);
        }
    }

    @Override
    public String registerActivity(Integer userId, Integer activityId) {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Connection connection = sqlSession.getConnection();
            try (CallableStatement cs = connection.prepareCall("{CALL sp_register_activity(?, ?)}")) {
                cs.setInt(1, userId);
                cs.setInt(2, activityId);
                
                cs.execute();
                
                // 获取返回结果
                return cs.getString(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("活动报名失败", e);
        }
    }

    @Override
    public String checkInActivity(Integer registrationId, Integer userId) {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Connection connection = sqlSession.getConnection();
            try (CallableStatement cs = connection.prepareCall("{CALL sp_check_in_activity(?, ?)}")) {
                cs.setInt(1, registrationId);
                cs.setInt(2, userId);
                
                cs.execute();
                
                // 获取返回结果
                return cs.getString(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("活动签到失败", e);
        }
    }
}
