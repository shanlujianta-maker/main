package com.xja.club.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * 数据库连接清理监听器
 * 用于在Web应用关闭时正确清理数据库连接
 */
public class DatabaseCleanupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Web应用启动时的初始化
        System.out.println("数据库连接清理监听器已启动");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            // 手动关闭MySQL连接清理线程
            com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown();
            System.out.println("MySQL连接清理线程已关闭");
        } catch (Exception e) {
            // 忽略关闭时的异常
            System.out.println("数据库连接清理时出现异常: " + e.getMessage());
        }
    }
}
