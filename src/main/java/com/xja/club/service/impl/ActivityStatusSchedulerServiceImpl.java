package com.xja.club.service.impl;

import com.xja.club.mapper.ActivitiesMapper;
import com.xja.club.service.ActivityStatusSchedulerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


/**
 * 活动状态调度服务实现类
 * 用于定期检查和更新活动状态
 */
@Service
public class ActivityStatusSchedulerServiceImpl implements ActivityStatusSchedulerService {

    @Autowired
    private ActivitiesMapper activitiesMapper;

    @Override
    @Transactional
    public void checkAndUpdateExpiredActivities() {
        try {
            System.out.println("开始检查过期活动...");
            // 调用Mapper方法更新过期的活动状态
            int updatedCount = activitiesMapper.updateExpiredActivitiesToCompleted();
            System.out.println("已更新 " + updatedCount + " 个过期活动状态为completed");
        } catch (Exception e) {
            System.err.println("检查过期活动时发生错误: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    @Transactional
    public void checkAndUpdateOngoingActivities() {
        try {
            System.out.println("开始检查进行中的活动...");
            // 调用Mapper方法更新已开始的活动状态
            int updatedCount = activitiesMapper.updateStartedActivitiesToOngoing();
            System.out.println("已更新 " + updatedCount + " 个活动状态为ongoing");
        } catch (Exception e) {
            System.err.println("检查进行中活动时发生错误: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    @Transactional
    public void syncAllParticipantCounts() {
        try {
            System.out.println("开始同步所有活动参与人数...");
            // 调用Mapper方法同步所有活动的参与人数
            int syncedCount = activitiesMapper.syncAllParticipantCounts();
            System.out.println("已同步 " + syncedCount + " 个活动的参与人数");
        } catch (Exception e) {
            System.err.println("同步参与人数时发生错误: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
