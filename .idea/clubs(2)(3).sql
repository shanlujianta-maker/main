/*
 Navicat MySQL Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80040 (8.0.40)
 Source Host           : localhost:3306
 Source Schema         : clubs

 Target Server Type    : MySQL
 Target Server Version : 80040 (8.0.40)
 File Encoding         : 65001

 Date: 11/09/2025 17:55:08
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activities
-- ----------------------------
DROP TABLE IF EXISTS `activities`;
CREATE TABLE `activities`  (
  `activity_id` int NOT NULL AUTO_INCREMENT COMMENT '活动唯一标识，自增',
  `activity_name` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '活动名称',
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '活动详情',
  `start_time` datetime NOT NULL COMMENT '活动开始时间',
  `end_time` datetime NOT NULL COMMENT '活动结束时间',
  `location` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动地点',
  `organizing_club_id` int NOT NULL COMMENT '组织该活动的社团ID',
  `max_participants` int NOT NULL DEFAULT 0 COMMENT '最大参与人数 (0表示不限)',
  `current_participants` int NOT NULL DEFAULT 0 COMMENT '当前参与人数',
  `act_status` enum('planning','open','ongoing','completed','cancelled') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'planning' COMMENT '活动状态',
  `created_by_user_id` int NOT NULL COMMENT '活动创建者ID',
  PRIMARY KEY (`activity_id`) USING BTREE,
  INDEX `idx_activities_status`(`act_status` ASC) USING BTREE,
  INDEX `idx_activities_time`(`start_time` ASC, `end_time` ASC) USING BTREE,
  INDEX `idx_activities_club`(`organizing_club_id` ASC) USING BTREE,
  INDEX `idx_activities_creator`(`created_by_user_id` ASC) USING BTREE,
  CONSTRAINT `activities_ibfk_1` FOREIGN KEY (`organizing_club_id`) REFERENCES `clubs` (`club_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `activities_ibfk_2` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `activities_chk_1` CHECK (`end_time` > `start_time`)
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of activities
-- ----------------------------
INSERT INTO `activities` VALUES (1, '校园编程大赛', '面向全校的算法竞赛', '2025-08-16 01:00:00', '2025-08-20 10:00:00', '图书馆报告厅', 1, 100, 1, 'completed', 3);
INSERT INTO `activities` VALUES (2, '经典名著读书会', '分享《红楼梦》阅读心得', '2025-09-11 06:00:00', '2025-09-17 08:00:00', '文学社活动室', 2, 30, 0, 'ongoing', 1);
INSERT INTO `activities` VALUES (3, '人工智能前沿讲座', '邀请高校教授讲解AI大模型发展趋势，适合所有专业学生参与', '2025-09-09 22:00:00', '2025-09-17 00:00:00', '学校大礼堂', 1, 0, 0, 'ongoing', 3);
INSERT INTO `activities` VALUES (4, '科幻文学分享会', '讨论《三体》系列中的科学与哲学，限20人深入交流', '2025-09-14 19:00:00', '2025-09-17 21:00:00', '文学社活动室', 2, 20, 0, 'planning', 1);
INSERT INTO `activities` VALUES (5, '公园环保清洁行动', '清理公园垃圾，宣传环保理念，需自带手套和垃圾袋', '2025-09-10 17:00:00', '2025-09-16 19:30:00', '城市中央公园', 5, 50, 0, 'ongoing', 5);
INSERT INTO `activities` VALUES (6, '校园围棋锦标赛', '因裁判临时有事，活动取消，后续将重新安排', '2025-07-15 17:00:00', '2025-07-21 01:00:00', '体育馆二楼', 3, 32, 0, 'cancelled', 3);
INSERT INTO `activities` VALUES (7, 'Python数据分析实战', '从零教学Python pandas库，完成电商数据可视化案例', '2025-08-07 18:00:00', '2025-08-15 00:00:00', '计算机实验室302', 1, 40, 0, 'completed', 1);
INSERT INTO `activities` VALUES (8, '野外露营与天文观测', '夜间观星+露营体验，需自带帐篷，社团提供天文望远镜', '2025-09-10 08:00:00', '2025-09-22 02:00:00', '近郊天文观测基地', 4, 25, 0, 'ongoing', 2);
INSERT INTO `activities` VALUES (9, '社团管理层年度规划会', '讨论下一年度活动预算与目标，仅限社团组织者参与', '2025-09-20 06:00:00', '2025-09-26 09:00:00', '行政楼305会议室', 1, 10, 0, 'open', 3);

-- ----------------------------
-- Table structure for activityregistrations
-- ----------------------------
DROP TABLE IF EXISTS `activityregistrations`;
CREATE TABLE `activityregistrations`  (
  `registration_id` int NOT NULL AUTO_INCREMENT COMMENT '报名记录唯一标识，自增',
  `user_id` int NOT NULL COMMENT '报名的用户ID',
  `activity_id` int NOT NULL COMMENT '报名的活动ID',
  `registration_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '报名时间',
  `check_in_status` enum('registered','checked_in','absent') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'registered' COMMENT '签到状态',
  `check_in_time` datetime NULL DEFAULT NULL COMMENT '签到时间',
  PRIMARY KEY (`registration_id`) USING BTREE,
  UNIQUE INDEX `unique_user_activity`(`user_id` ASC, `activity_id` ASC) USING BTREE COMMENT '防止用户重复报名同一活动',
  INDEX `activity_id`(`activity_id` ASC) USING BTREE,
  INDEX `idx_registrations_time`(`registration_time` ASC) USING BTREE,
  INDEX `idx_registrations_status`(`check_in_status` ASC) USING BTREE,
  INDEX `idx_registrations_checkin`(`check_in_time` ASC) USING BTREE,
  CONSTRAINT `activityregistrations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `activityregistrations_ibfk_2` FOREIGN KEY (`activity_id`) REFERENCES `activities` (`activity_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `activityregistrations_chk_1` CHECK (((`check_in_status` = _utf8mb3'checked_in') and (`check_in_time` is not null)) or ((`check_in_status` <> _utf8mb3'checked_in') and (`check_in_time` is null)))
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of activityregistrations
-- ----------------------------
INSERT INTO `activityregistrations` VALUES (1, 1, 1, '2025-08-16 17:14:03', 'checked_in', '2025-08-17 08:50:00');
INSERT INTO `activityregistrations` VALUES (7, 1, 3, '2025-09-05 17:16:20', 'registered', NULL);
INSERT INTO `activityregistrations` VALUES (9, 4, 3, '2025-09-05 17:16:25', 'checked_in', '2025-08-17 09:10:00');
INSERT INTO `activityregistrations` VALUES (11, 6, 2, '2025-09-05 17:16:28', 'checked_in', '2025-09-13 16:30:00');
INSERT INTO `activityregistrations` VALUES (12, 7, 9, '2025-09-05 17:16:28', 'registered', NULL);
INSERT INTO `activityregistrations` VALUES (14, 7, 1, '2025-08-16 17:47:22', 'absent', NULL);
-- ----------------------------
-- Table structure for clubmember
-- ----------------------------
DROP TABLE IF EXISTS `clubmember`;
CREATE TABLE `clubmember`  (
  `membership_id` int NOT NULL AUTO_INCREMENT COMMENT '成员关系唯一标识，自增',
  `user_id` int NOT NULL COMMENT '用户ID，关联到Users.user_id',
  `club_id` int NOT NULL COMMENT '社团ID，关联到Clubs.club_id',
  `role_in_club` enum('member','president') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'member' COMMENT '在社团中的角色：member-普通成员，president-社团管理者',
  `join_date` date NOT NULL COMMENT '加入日期',
  `application_reason` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '申请加入理由',
  `member_status` enum('applying','active','resigned') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'applying' COMMENT '成员状态：申请中、在职、已离职',
  PRIMARY KEY (`membership_id`) USING BTREE,
  UNIQUE INDEX `unique_user_club`(`user_id` ASC, `club_id` ASC) USING BTREE COMMENT '防止同一用户重复加入同一社团',
  INDEX `club_id`(`club_id` ASC) USING BTREE,
  INDEX `idx_member_role`(`role_in_club` ASC) USING BTREE,
  INDEX `idx_member_status`(`member_status` ASC) USING BTREE,
  INDEX `idx_member_join`(`join_date` ASC) USING BTREE,
  CONSTRAINT `clubmember_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `clubmember_ibfk_2` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`club_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of clubmember
-- ----------------------------
INSERT INTO `clubmember` VALUES (1, 1, 1, 'member', '2024-12-01', '', 'resigned');
INSERT INTO `clubmember` VALUES (2, 4, 1, 'president', '2025-09-09', '担任计算机协会社长，负责技术指导', 'active');
INSERT INTO `clubmember` VALUES (3, 5, 1, 'member', '2025-09-09', '对编程技术感兴趣，希望提升技能', 'active');
INSERT INTO `clubmember` VALUES (4, 6, 2, 'president', '2025-09-02', '担任文学社社长，热爱文学创作', 'active');
INSERT INTO `clubmember` VALUES (5, 7, 2, 'member', '2025-08-09', '喜欢阅读和写作，希望与同好交流', 'active');
INSERT INTO `clubmember` VALUES (6, 8, 2, 'member', '2025-09-03', '对古典文学有浓厚兴趣', 'active');
INSERT INTO `clubmember` VALUES (7, 9, 3, 'president', '2025-09-05', '担任机器人协会社长，有丰富的竞赛经验', 'active');
INSERT INTO `clubmember` VALUES (8, 10, 3, 'member', '2025-09-01', '对机器人技术充满热情', 'active');
INSERT INTO `clubmember` VALUES (9, 11, 4, 'president', '2025-09-05', '担任摄影社社长，专业摄影师', 'active');
INSERT INTO `clubmember` VALUES (10, 12, 4, 'member', '2025-07-11', '热爱摄影，希望学习更多技巧', 'active');
INSERT INTO `clubmember` VALUES (11, 13, 5, 'president', '2025-09-08', '担任志愿者联盟负责人，热心公益', 'active');

-- ----------------------------
-- Table structure for clubs
-- ----------------------------
DROP TABLE IF EXISTS `clubs`;
CREATE TABLE `clubs`  (
  `club_id` int NOT NULL AUTO_INCREMENT COMMENT '社团唯一标识，自增',
  `club_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '社团名称，唯一',
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '社团简介',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '社团成立时间',
  `club_status` enum('active','inactive') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'active' COMMENT '社团状态 (活跃/已注销)',
  PRIMARY KEY (`club_id`) USING BTREE,
  UNIQUE INDEX `club_name`(`club_name` ASC) USING BTREE,
  INDEX `idx_clubs_status`(`club_status` ASC) USING BTREE,
  INDEX `idx_clubs_created`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of clubs
-- ----------------------------
INSERT INTO `clubs` VALUES (1, '计算机协会', '专注编程与算法交流', '2025-09-05 17:09:28', 'active');
INSERT INTO `clubs` VALUES (2, '文学社', '分享文学作品与阅读心得', '2025-09-05 17:09:28', 'active');
INSERT INTO `clubs` VALUES (3, '机器人爱好者协会', '研究机器人编程与竞赛，定期举办校内选拔赛', '2025-09-05 17:09:37', 'active');
INSERT INTO `clubs` VALUES (4, '摄影社', '分享摄影技巧与作品，包含人像、风光等主题拍摄', '2025-09-05 17:09:37', 'active');
INSERT INTO `clubs` VALUES (5, '校园志愿者联盟', '成立于2018年，现有成员300+人，常年开展社区支教、环保宣传、敬老服务等志愿活动，与市志愿者协会建立长期合作关系，年均服务时长超10000小时', '2025-09-05 17:10:08', 'active');
INSERT INTO `clubs` VALUES (6, '话剧社', '曾组织《雷雨》《茶馆》等经典剧目演出，2023年因成员不足解散', '2025-09-05 17:10:15', 'inactive');
INSERT INTO `clubs` VALUES (7, '融媒体', '公众号推文制作发布', '2025-09-11 17:45:02', 'active');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `user_password` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '用户密码',
  `real_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '真实姓名',
  `user_phone` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `user_type` enum('admin','student') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '用户类型',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '账号创建时间',
  PRIMARY KEY (`user_id`) USING BTREE,
  INDEX `idx_users_type`(`user_type` ASC) USING BTREE,
  INDEX `idx_users_phone`(`user_phone` ASC) USING BTREE,
  INDEX `idx_users_name`(`real_name` ASC) USING BTREE,
  CONSTRAINT `chk_user_phone_length` CHECK (length(`user_phone`) = 11)
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, '123456', '张三', '13800138000', 'student', '2025-09-05 16:59:42');
INSERT INTO `users` VALUES (2, '654321', '李四', '13900139000', 'admin', '2025-09-05 16:59:42');
INSERT INTO `users` VALUES (3, 'admin123', '王五', '13700137000', 'admin', '2025-09-05 16:59:42');
INSERT INTO `users` VALUES (4, '123456', '崔欣欣', '15254609793', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (5, '123456', '赖佳惠', '18540072854', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (6, '123456', '田春齐', '19773781799', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (7, '123456', '熊娟', '19971790975', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (8, '123456', '谭苒溪', '17734645688', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (9, '123456', '余欣源', '13695368453', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (10, '123456', '梁佳钰', '15372166477', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (11, '123456', '蔡翔', '18985715118', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (12, '123456', '武伟洋', '15114688766', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (13, '123456', '毛易轩', '14941320657', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (14, '123456', '蔡娜', '18783739490', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (15, '123456', '龙翔', '16645775190', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (16, '123456', '顾欣欣', '18035161469', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (17, '123456', '萧甜', '15756338612', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (18, '123456', '马娟', '14991693274', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (19, '123456', '蔡紫轩', '15733152461', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (20, '123456', '姜明远', '18977125497', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (21, '123456', '邹欣宜', '18872799615', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (22, '123456', '郑静', '19882535114', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (23, '123456', '余文轩', '18777475191', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (24, '123456', '张佳欣', '18845577384', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (25, '123456', '卢娜', '19357645531', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (26, '123456', '方桂英', '13649861854', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (27, '123456', '陆林', '15622523203', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (28, '123456', '方瑞堂', '18814802574', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (29, '123456', '尹艳', '18639977696', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (30, '123456', '张美欣', '19795299084', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (31, '123456', '王若萌', '19369764312', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (32, '123456', '潘熙涵', '17513269192', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (33, '123456', '何佳琪', '13050544943', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (34, '123456', '叶欣怡', '19819281737', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (35, '123456', '邓淑慧', '14733294621', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (36, '123456', '邱佳怡', '15124201746', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (37, '123456', '曹泽远', '18912800455', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (38, '123456', '张晓庆', '13697671415', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (39, '123456', '黄凌晶', '18370733702', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (40, '123456', '张子璇', '13714733278', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (41, '123456', '傅益辰', '17883123936', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (42, '123456', '徐佳琪', '15196819129', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (43, '123456', '陈雅涵', '18121807128', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (44, '123456', '任佳玉', '17572513342', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (45, '123456', '姚易轩', '18654469904', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (46, '123456', '梁益冉', '19674833833', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (47, '123456', '邱尚', '19399923181', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (48, '123456', '杨文昊', '13131716815', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (49, '123456', '张欣汝', '13962675462', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (50, '123456', '石天昊', '17894122714', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (51, '123456', '史浩晨', '19165246855', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (52, '123456', '崔伟', '19919758787', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (53, '123456', '姜文轩', '14955185461', 'student', '2025-09-05 17:03:03');
INSERT INTO `users` VALUES (66, '123456', '11111', '15318221261', 'student', '2025-09-11 14:46:38');

-- ----------------------------
-- View structure for v_activity_detail
-- ----------------------------
DROP VIEW IF EXISTS `v_activity_detail`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_activity_detail` AS select `a`.`activity_id` AS `activity_id`,`a`.`activity_name` AS `activity_name`,`a`.`description` AS `description`,`a`.`start_time` AS `start_time`,`a`.`end_time` AS `end_time`,`a`.`location` AS `location`,`a`.`organizing_club_id` AS `organizing_club_id`,`a`.`max_participants` AS `max_participants`,`a`.`act_status` AS `act_status`,`a`.`created_by_user_id` AS `created_by_user_id`,`c`.`club_name` AS `club_name`,`c`.`description` AS `club_description`,`u`.`real_name` AS `creator_name`,`u`.`user_phone` AS `creator_contact`,concat(round((((select count(0) from `activityregistrations` `ar` where ((`ar`.`activity_id` = `a`.`activity_id`) and (`ar`.`check_in_status` = 'checked_in'))) / (select count(0) from `activityregistrations` `ar` where (`ar`.`activity_id` = `a`.`activity_id`))) * 100),1),'%') AS `check_in_rate` from ((`activities` `a` left join `clubs` `c` on((`a`.`organizing_club_id` = `c`.`club_id`))) left join `users` `u` on((`a`.`created_by_user_id` = `u`.`user_id`)));

-- ----------------------------
-- View structure for v_activity_notice
-- ----------------------------
DROP VIEW IF EXISTS `v_activity_notice`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_activity_notice` AS select `a`.`activity_id` AS `activity_id`,`a`.`activity_name` AS `activity_name`,`a`.`description` AS `description`,`a`.`start_time` AS `start_time`,`a`.`end_time` AS `end_time`,`a`.`location` AS `location`,`a`.`max_participants` AS `max_participants`,`a`.`act_status` AS `act_status`,(select count(0) from `activityregistrations` `ar` where (`ar`.`activity_id` = `a`.`activity_id`)) AS `registered_count`,`c`.`club_id` AS `club_id`,`c`.`club_name` AS `club_name`,`u`.`user_id` AS `creator_id`,`u`.`real_name` AS `creator_name`,(case `a`.`act_status` when 'planning' then '规划中' when 'open' then '报名中' when 'ongoing' then '进行中' when 'completed' then '已结束' when 'cancelled' then '已取消' end) AS `status_text`,(case when (`a`.`max_participants` = 0) then 0 else (`a`.`max_participants` - (select count(0) from `activityregistrations` `ar` where (`ar`.`activity_id` = `a`.`activity_id`))) end) AS `remaining_quota` from ((`activities` `a` left join `clubs` `c` on((`a`.`organizing_club_id` = `c`.`club_id`))) left join `users` `u` on((`a`.`created_by_user_id` = `u`.`user_id`)));

-- ----------------------------
-- View structure for v_activity_registration_stats
-- ----------------------------
DROP VIEW IF EXISTS `v_activity_registration_stats`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_activity_registration_stats` AS select `a`.`activity_id` AS `activity_id`,`a`.`activity_name` AS `activity_name`,`a`.`start_time` AS `start_time`,`a`.`end_time` AS `end_time`,`a`.`max_participants` AS `max_participants`,count(`ar`.`registration_id`) AS `total_registrations`,sum((case when (`ar`.`check_in_status` = 'checked_in') then 1 else 0 end)) AS `checked_in_count`,sum((case when (`ar`.`check_in_status` = 'absent') then 1 else 0 end)) AS `absent_count`,`c`.`club_name` AS `club_name`,`u`.`real_name` AS `creator_name` from (((`activities` `a` left join `activityregistrations` `ar` on((`a`.`activity_id` = `ar`.`activity_id`))) join `clubs` `c` on((`a`.`organizing_club_id` = `c`.`club_id`))) join `users` `u` on((`a`.`created_by_user_id` = `u`.`user_id`))) group by `a`.`activity_id`;

-- ----------------------------
-- View structure for v_club_member_detail
-- ----------------------------
DROP VIEW IF EXISTS `v_club_member_detail`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_club_member_detail` AS select `cm`.`membership_id` AS `membership_id`,`cm`.`user_id` AS `user_id`,`cm`.`club_id` AS `club_id`,`cm`.`role_in_club` AS `role_in_club`,`cm`.`join_date` AS `join_date`,`cm`.`member_status` AS `member_status`,`u`.`real_name` AS `real_name`,`u`.`user_phone` AS `user_phone`,`u`.`user_type` AS `user_type`,`c`.`club_name` AS `club_name` from ((`clubmember` `cm` join `users` `u` on((`cm`.`user_id` = `u`.`user_id`))) join `clubs` `c` on((`cm`.`club_id` = `c`.`club_id`)));

-- ----------------------------
-- View structure for v_user_activity_participation
-- ----------------------------
DROP VIEW IF EXISTS `v_user_activity_participation`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_user_activity_participation` AS select `u`.`user_id` AS `user_id`,`u`.`real_name` AS `real_name`,count(distinct `ar`.`activity_id`) AS `total_activities`,count(distinct (case when (`ar`.`check_in_status` = 'checked_in') then `ar`.`activity_id` end)) AS `attended_activities`,count(distinct `cm`.`club_id`) AS `joined_clubs` from ((`users` `u` left join `activityregistrations` `ar` on((`u`.`user_id` = `ar`.`user_id`))) left join `clubmember` `cm` on(((`u`.`user_id` = `cm`.`user_id`) and (`cm`.`member_status` = 'active')))) group by `u`.`user_id`,`u`.`real_name`;

-- ----------------------------
-- View structure for v_user_activity_status
-- ----------------------------
DROP VIEW IF EXISTS `v_user_activity_status`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_user_activity_status` AS select `ar`.`registration_id` AS `registration_id`,`ar`.`user_id` AS `user_id`,`ar`.`activity_id` AS `activity_id`,`a`.`activity_name` AS `activity_name`,`a`.`start_time` AS `start_time`,`ar`.`check_in_status` AS `check_in_status`,`ar`.`check_in_time` AS `check_in_time`,`ar`.`registration_time` AS `registration_time`,(case `ar`.`check_in_status` when 'registered' then '已报名' when 'checked_in' then '已签到' when 'absent' then '未到场' end) AS `status_text` from (`activityregistrations` `ar` left join `activities` `a` on((`ar`.`activity_id` = `a`.`activity_id`)));

-- ----------------------------
-- Procedure structure for sp_check_in_activity
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_check_in_activity`;
delimiter ;;
CREATE PROCEDURE `sp_check_in_activity`(IN p_registration_id INT,
    IN p_user_id INT)
BEGIN
    UPDATE activityregistrations 
    SET check_in_status = 'checked_in', 
        check_in_time = NOW()
    WHERE registration_id = p_registration_id 
    AND user_id = p_user_id
    AND check_in_status = 'registered';
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '签到失败，请检查报名状态';
    ELSE
        SELECT '签到成功' AS result;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_create_activity
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_create_activity`;
delimiter ;;
CREATE PROCEDURE `sp_create_activity`(IN p_activity_name VARCHAR(150),
    IN p_description TEXT,
    IN p_start_time DATETIME,
    IN p_end_time DATETIME,
    IN p_location VARCHAR(255),
    IN p_organizing_club_id INT,
    IN p_max_participants INT,
    IN p_created_by_user_id INT)
BEGIN
    INSERT INTO activities (
        activity_name, description, start_time, end_time, 
        location, organizing_club_id, max_participants, created_by_user_id
    ) VALUES (
        p_activity_name, p_description, p_start_time, p_end_time,
        p_location, p_organizing_club_id, p_max_participants, p_created_by_user_id
    );
    
    SELECT LAST_INSERT_ID() AS new_activity_id;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_register_activity
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_register_activity`;
delimiter ;;
CREATE PROCEDURE `sp_register_activity`(IN p_user_id INT,
    IN p_activity_id INT)
BEGIN
    DECLARE v_max_participants INT;
    DECLARE v_current_count INT;
    DECLARE v_activity_status ENUM('planning','open','ongoing','completed','cancelled');
    
    -- 获取活动信息
    SELECT max_participants, act_status INTO v_max_participants, v_activity_status
    FROM activities WHERE activity_id = p_activity_id;
    
    -- 获取当前报名人数
    SELECT COUNT(*) INTO v_current_count
    FROM activityregistrations 
    WHERE activity_id = p_activity_id AND check_in_status != 'absent';
    
    -- 检查是否可以报名
    IF v_activity_status != 'open' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '活动不在报名阶段';
    ELSEIF v_max_participants > 0 AND v_current_count >= v_max_participants THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '活动人数已满';
    ELSE
        -- 插入报名记录
        INSERT INTO activityregistrations (user_id, activity_id)
        VALUES (p_user_id, p_activity_id)
        ON DUPLICATE KEY UPDATE check_in_status = 'registered', check_in_time = NULL;
        
        SELECT '报名成功' AS result;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers
-- ----------------------------

-- 触发器1：当活动结束时间到达后，自动将活动状态改为completed
DELIMITER $$
CREATE TRIGGER tr_activity_auto_complete
AFTER UPDATE ON activities
FOR EACH ROW
BEGIN
    -- 当活动结束时间已过且状态不是completed或cancelled时，自动设置为completed
    IF NEW.end_time < NOW() 
       AND NEW.act_status NOT IN ('completed', 'cancelled') 
       AND (OLD.act_status != NEW.act_status OR OLD.end_time != NEW.end_time) THEN
        UPDATE activities 
        SET act_status = 'completed' 
        WHERE activity_id = NEW.activity_id;
    END IF;
END$$
DELIMITER ;

-- 触发器2：当用户报名活动时，自动更新activities表的current_participants字段
DELIMITER $$
CREATE TRIGGER tr_update_participants_count_insert
AFTER INSERT ON activityregistrations
FOR EACH ROW
BEGIN
    -- 只有当签到状态不是absent时才计入参与人数
    IF NEW.check_in_status != 'absent' THEN
        UPDATE activities 
        SET current_participants = (
            SELECT COUNT(*) 
            FROM activityregistrations 
            WHERE activity_id = NEW.activity_id 
            AND check_in_status != 'absent'
        )
        WHERE activity_id = NEW.activity_id;
    END IF;
END$$
DELIMITER ;

-- 触发器3：当用户签到状态改变时，更新参与人数
DELIMITER $$
CREATE TRIGGER tr_update_participants_count_update
AFTER UPDATE ON activityregistrations
FOR EACH ROW
BEGIN
    -- 当签到状态发生变化时，重新计算参与人数
    IF OLD.check_in_status != NEW.check_in_status THEN
        UPDATE activities 
        SET current_participants = (
            SELECT COUNT(*) 
            FROM activityregistrations 
            WHERE activity_id = NEW.activity_id 
            AND check_in_status != 'absent'
        )
        WHERE activity_id = NEW.activity_id;
    END IF;
END$$
DELIMITER ;

-- 触发器4：当活动结束时，自动将未签到的用户状态设为absent
DELIMITER $$
CREATE TRIGGER tr_auto_mark_absent
AFTER UPDATE ON activities
FOR EACH ROW
BEGIN
    -- 当活动状态变为completed时
    IF OLD.act_status != 'completed' AND NEW.act_status = 'completed' THEN
        -- 将未签到的用户标记为absent
        UPDATE activityregistrations 
        SET check_in_status = 'absent'
        WHERE activity_id = NEW.activity_id 
        AND check_in_status = 'registered';
    END IF;
END$$
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;

