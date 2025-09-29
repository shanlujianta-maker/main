package com.xja.club.listener;

import com.xja.club.service.ActivityStatusSchedulerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

/**
 * 活动状态定时调度器
 * 
 * 功能说明：
 * 1. 定期检查活动状态并自动更新
 * 2. 与数据库触发器配合实现自动化管理
 * 3. 确保活动状态的实时性和准确性
 * 4. 维护数据一致性和完整性
 * 
 * 主要任务：
 * - 检查过期活动并更新状态为completed
 * - 检查已开始活动并更新状态为ongoing
 * - 同步所有活动的参与人数统计
 * - 应用启动时进行初始化检查
 * 
 * 定时任务配置：
 * - 过期活动检查：每60秒执行一次
 * - 进行中活动检查：每60秒执行一次
 * - 参与人数同步：每5分钟执行一次
 * - 应用启动初始化：启动时执行一次
 * 
 * 异常处理：
 * - 所有定时任务都有异常捕获
 * - 异常信息会输出到控制台
 * - 单个任务异常不影响其他任务执行
 * 
 * @author 系统管理员
 * @version 1.0
 * @since 2025-01-01
 */
@Component
public class ActivityStatusScheduler {

    @Autowired
    private ActivityStatusSchedulerService activityStatusSchedulerService; // 活动状态调度服务

    /**
     * 检查过期活动定时任务
     * 
     * 功能说明：
     * - 定期检查所有活动是否已过期
     * - 将结束时间已过且状态不是completed或cancelled的活动状态更新为completed
     * - 配合数据库触发器实现自动化管理
     * 
     * 执行频率：每60秒执行一次
     * 触发条件：@Scheduled(fixedRate = 60000)
     * 
     * 业务逻辑：
     * 1. 查询所有活动记录
     * 2. 筛选出结束时间已过且状态需要更新的活动
     * 3. 批量更新活动状态为completed
     * 4. 记录更新结果到日志
     * 
     * 异常处理：
     * - 捕获所有异常并输出到控制台
     * - 确保定时任务不会因异常而停止
     */
    @Scheduled(fixedRate = 60000) // 每60秒执行一次
    public void checkExpiredActivities() {
        try {
            activityStatusSchedulerService.checkAndUpdateExpiredActivities();
        } catch (Exception e) {
            System.err.println("定时检查过期活动时发生错误: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 检查进行中活动定时任务
     * 
     * 功能说明：
     * - 定期检查所有活动是否已开始
     * - 将开始时间已到且状态为open的活动状态更新为ongoing
     * - 确保活动状态的及时更新
     * 
     * 执行频率：每60秒执行一次
     * 触发条件：@Scheduled(fixedRate = 60000)
     * 
     * 业务逻辑：
     * 1. 查询所有状态为open的活动
     * 2. 筛选出开始时间已到的活动
     * 3. 批量更新活动状态为ongoing
     * 4. 记录更新结果到日志
     * 
     * 异常处理：
     * - 捕获所有异常并输出到控制台
     * - 确保定时任务不会因异常而停止
     */
    @Scheduled(fixedRate = 60000) // 每60秒执行一次
    public void checkOngoingActivities() {
        try {
            activityStatusSchedulerService.checkAndUpdateOngoingActivities();
        } catch (Exception e) {
            System.err.println("定时检查进行中活动时发生错误: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 同步参与人数定时任务
     * 
     * 功能说明：
     * - 定期同步所有活动的参与人数统计
     * - 根据实际报名记录重新计算参与人数
     * - 排除缺席状态的用户
     * - 维护数据一致性
     * 
     * 执行频率：每5分钟执行一次
     * 触发条件：@Scheduled(fixedRate = 300000)
     * 
     * 业务逻辑：
     * 1. 查询所有活动记录
     * 2. 对每个活动统计实际报名人数
     * 3. 排除缺席状态的用户
     * 4. 更新活动的current_participants字段
     * 5. 记录同步结果到日志
     * 
     * 异常处理：
     * - 捕获所有异常并输出到控制台
     * - 确保定时任务不会因异常而停止
     */
    @Scheduled(fixedRate = 300000) // 每5分钟执行一次
    public void syncParticipantCounts() {
        try {
            activityStatusSchedulerService.syncAllParticipantCounts();
        } catch (Exception e) {
            System.err.println("定时同步参与人数时发生错误: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 应用启动初始化方法
     * 
     * 功能说明：
     * - 应用启动时执行一次完整的状态检查和同步
     * - 确保系统启动后数据状态的一致性
     * - 修复可能存在的状态不一致问题
     * 
     * 执行时机：应用启动完成后
     * 触发条件：@PostConstruct
     * 
     * 初始化步骤：
     * 1. 检查并更新过期活动状态
     * 2. 检查并更新进行中活动状态
     * 3. 同步所有活动的参与人数
     * 4. 输出初始化完成信息
     * 
     * 异常处理：
     * - 捕获所有异常并输出到控制台
     * - 确保应用能够正常启动
     */
    @PostConstruct
    public void initializeActivityStatus() {
        System.out.println("应用启动，开始初始化活动状态...");
        try {
            // 步骤1：检查过期活动
            activityStatusSchedulerService.checkAndUpdateExpiredActivities();
            // 步骤2：检查进行中活动
            activityStatusSchedulerService.checkAndUpdateOngoingActivities();
            // 步骤3：同步参与人数
            activityStatusSchedulerService.syncAllParticipantCounts();
            System.out.println("活动状态初始化完成");
        } catch (Exception e) {
            System.err.println("初始化活动状态时发生错误: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
