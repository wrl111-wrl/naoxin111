/*
 Navicat Premium Dump SQL

 Source Server         : Project
 Source Server Type    : MySQL
 Source Server Version : 50714 (5.7.14-log)
 Source Host           : localhost:3306
 Source Schema         : db061

 Target Server Type    : MySQL
 Target Server Version : 50714 (5.7.14-log)
 File Encoding         : 65001

 Date: 19/08/2025 00:21:29
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for banjixinxi
-- ----------------------------
DROP TABLE IF EXISTS `banjixinxi`;
CREATE TABLE `banjixinxi`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `banji` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `beizhu` varchar(500) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = gb2312 COLLATE = gb2312_chinese_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of banjixinxi
-- ----------------------------
INSERT INTO `banjixinxi` VALUES (2, 'A03', 'abc', '2024-12-30 18:48:51');
INSERT INTO `banjixinxi` VALUES (3, 'B01', 'ok', '2024-12-30 18:48:51');
INSERT INTO `banjixinxi` VALUES (4, 'E01', 'abc', '2024-12-30 18:48:51');
INSERT INTO `banjixinxi` VALUES (5, 'C01', '没问题', '2024-12-30 18:48:51');
INSERT INTO `banjixinxi` VALUES (6, 'E02', '暂无', '2024-12-30 18:48:51');
INSERT INTO `banjixinxi` VALUES (7, 'D03', 'abc', '2024-12-30 18:48:51');
INSERT INTO `banjixinxi` VALUES (8, 'C03', 'abc', '2024-12-30 18:48:51');
INSERT INTO `banjixinxi` VALUES (9, 'C02', 'abc', '2024-12-30 18:48:51');
INSERT INTO `banjixinxi` VALUES (10, 'A02', '暂无', '2024-12-30 18:48:51');
INSERT INTO `banjixinxi` VALUES (11, 'D02', '暂无', '2024-12-30 18:48:51');

-- ----------------------------
-- Table structure for file
-- ----------------------------
DROP TABLE IF EXISTS `file`;
CREATE TABLE `file`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `originName` varchar(255) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `fileName` varchar(255) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = gb2312 COLLATE = gb2312_chinese_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of file
-- ----------------------------
INSERT INTO `file` VALUES (2, 'xueshengxinxi1.jpg', 'xueshengxinxi1.jpg');
INSERT INTO `file` VALUES (3, 'xueshengxinxi2.jpg', 'xueshengxinxi2.jpg');
INSERT INTO `file` VALUES (4, 'xueshengxinxi3.jpg', 'xueshengxinxi3.jpg');
INSERT INTO `file` VALUES (5, 'xueshengxinxi4.jpg', 'xueshengxinxi4.jpg');
INSERT INTO `file` VALUES (6, 'xueshengxinxi5.jpg', 'xueshengxinxi5.jpg');
INSERT INTO `file` VALUES (7, 'xueshengxinxi6.jpg', 'xueshengxinxi6.jpg');
INSERT INTO `file` VALUES (8, 'xueshengxinxi7.jpg', 'xueshengxinxi7.jpg');
INSERT INTO `file` VALUES (9, 'xueshengxinxi8.jpg', 'xueshengxinxi8.jpg');
INSERT INTO `file` VALUES (10, 'xueshengxinxi9.jpg', 'xueshengxinxi9.jpg');
INSERT INTO `file` VALUES (11, 'xueshengxinxi10.jpg', 'xueshengxinxi10.jpg');
INSERT INTO `file` VALUES (12, 'jiaoshixinxi1.jpg', 'jiaoshixinxi1.jpg');
INSERT INTO `file` VALUES (13, 'jiaoshixinxi2.jpg', 'jiaoshixinxi2.jpg');
INSERT INTO `file` VALUES (14, 'jiaoshixinxi3.jpg', 'jiaoshixinxi3.jpg');
INSERT INTO `file` VALUES (15, 'jiaoshixinxi4.jpg', 'jiaoshixinxi4.jpg');
INSERT INTO `file` VALUES (16, 'jiaoshixinxi5.jpg', 'jiaoshixinxi5.jpg');
INSERT INTO `file` VALUES (17, 'jiaoshixinxi6.jpg', 'jiaoshixinxi6.jpg');
INSERT INTO `file` VALUES (18, 'jiaoshixinxi7.jpg', 'jiaoshixinxi7.jpg');
INSERT INTO `file` VALUES (19, 'jiaoshixinxi8.jpg', 'jiaoshixinxi8.jpg');
INSERT INTO `file` VALUES (20, 'jiaoshixinxi9.jpg', 'jiaoshixinxi9.jpg');
INSERT INTO `file` VALUES (21, 'jiaoshixinxi10.jpg', 'jiaoshixinxi10.jpg');
INSERT INTO `file` VALUES (22, '2.jpeg', '21755442408733.jpeg');
INSERT INTO `file` VALUES (23, '1.jpeg', '11755447448054.jpeg');
INSERT INTO `file` VALUES (24, '1.jpeg', '11755448057513.jpeg');

-- ----------------------------
-- Table structure for guanliyuan
-- ----------------------------
DROP TABLE IF EXISTS `guanliyuan`;
CREATE TABLE `guanliyuan`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `yonghuming` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `mima` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `status` varchar(10) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT '0',
  `level` varchar(10) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT '管理员',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = gb2312 COLLATE = gb2312_chinese_ci COMMENT = '管理员' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of guanliyuan
-- ----------------------------
INSERT INTO `guanliyuan` VALUES (1, 'admin', '21232f297a57a5a743894a0e4a801fc3', '0', '管理员', '2025-08-18 18:48:51');

-- ----------------------------
-- Table structure for jiaoshixinxi
-- ----------------------------
DROP TABLE IF EXISTS `jiaoshixinxi`;
CREATE TABLE `jiaoshixinxi`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gonghao` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `mima` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `xingming` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `xingbie` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `shenfenzheng` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `dianhua` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `zhicheng` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `zhujiaokecheng` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `banji` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `jiguan` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `zhaopian` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `beizhu` varchar(500) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `level` varchar(10) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT '教师',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = gb2312 COLLATE = gb2312_chinese_ci COMMENT = '教师' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of jiaoshixinxi
-- ----------------------------
INSERT INTO `jiaoshixinxi` VALUES (2, '027', 'e10adc3949ba59abbe56e057f20f883e', '陈燕琪', '1', '330327198615482633', '13587835380', '技术员', '政治', 'E01', '吉林', '', '暂无', '教师', '2024-12-30 18:48:51');
INSERT INTO `jiaoshixinxi` VALUES (3, '008', 'e10adc3949ba59abbe56e057f20f883e', '陈明希', '1', '330327185403060589', '13159863241', '教授', '计算机', 'C02', '安徽', '', '没问题', '教师', '2024-12-30 18:48:51');
INSERT INTO `jiaoshixinxi` VALUES (4, '009', 'e10adc3949ba59abbe56e057f20f883e', '何永康', '1', '330327199010142546', '13186835580', '助教', '软件工程', 'D02', '甘肃', '', '无', '教师', '2024-12-30 18:48:51');
INSERT INTO `jiaoshixinxi` VALUES (5, '017', 'e10adc3949ba59abbe56e057f20f883e', '吴永国', '1', '330327199504059511', '13748589658', '讲师', '政治', 'E02', '辽宁', '', '没问题', '教师', '2024-12-30 18:48:51');
INSERT INTO `jiaoshixinxi` VALUES (6, '010', 'e10adc3949ba59abbe56e057f20f883e', '鲁艾弈', '0', '330327198708070789', '17505772420', '工程师', '历史', 'D03', '江苏', '', 'abc', '教师', '2024-12-30 18:48:51');
INSERT INTO `jiaoshixinxi` VALUES (7, '029', 'e10adc3949ba59abbe56e057f20f883e', '方之明', '0', '330327198406150488', '17706641413', '副教授', '语文', 'B01', '天津', '', 'abc', '教师', '2024-12-30 18:48:51');
INSERT INTO `jiaoshixinxi` VALUES (8, '004', 'e10adc3949ba59abbe56e057f20f883e', '舒畅', '0', '330327198805060222', '13489665487', '助教', '英语', 'C02', '黑龙江', '', '无', '教师', '2024-12-30 18:48:51');
INSERT INTO `jiaoshixinxi` VALUES (9, '012', 'e10adc3949ba59abbe56e057f20f883e', '黄行阳', '1', '33032719900723568X', '18759640002', '助教', '线性代数', 'E02', '云南', '', '没问题', '教师', '2024-12-30 18:48:51');
INSERT INTO `jiaoshixinxi` VALUES (10, '034', 'e10adc3949ba59abbe56e057f20f883e', '沈古璐', '0', '330327198501020300', '13544655202', '助理', '法律', 'E02', '广东', '', '暂无', '教师', '2024-12-30 18:48:51');
INSERT INTO `jiaoshixinxi` VALUES (11, '001', 'e10adc3949ba59abbe56e057f20f883e', '余少庆', '0', '330327198811020456', '13052154877', '助理', '线性代数', 'A03', '海南', '/files/download/24', 'abc', '教师', '2024-12-30 18:48:51');

-- ----------------------------
-- Table structure for qingjiashenqing
-- ----------------------------
DROP TABLE IF EXISTS `qingjiashenqing`;
CREATE TABLE `qingjiashenqing`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `qingjiabianhao` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `xuehao` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `xueshengxingming` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `lianxidianhua` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `banji` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `qingjiayuanyin` varchar(500) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `qishishijian` datetime NULL DEFAULT NULL,
  `zhongzhishijian` datetime NULL DEFAULT NULL,
  `beizhu` varchar(500) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `issh` varchar(10) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT '待审核',
  `shhf` varchar(200) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = gb2312 COLLATE = gb2312_chinese_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qingjiashenqing
-- ----------------------------
INSERT INTO `qingjiashenqing` VALUES (2, '43568839218187', '025', '梅邹雁', '13587835380', 'D02', '', '2024-03-16 06:44:00', '2024-04-11 08:35:00', '没问题', '已通过', '1', '2024-12-30 18:48:51');
INSERT INTO `qingjiashenqing` VALUES (3, '43564462955769', '003', '陈小巧', '17505772420', 'A03', '', '2024-03-06 13:53:00', '2024-03-26 08:08:00', '备注', '已通过', '批准', '2024-12-30 18:48:51');
INSERT INTO `qingjiashenqing` VALUES (4, '43562853687001', '015', '司宪策', '13623256544', 'C02', '', '2024-04-06 09:20:00', '2024-03-19 02:34:00', 'ok', '待审核', NULL, '2024-12-30 18:48:51');
INSERT INTO `qingjiashenqing` VALUES (5, '43563934079920', '029', '王柏弘', '18956482221', 'E01', '', '2024-03-09 11:01:00', '2024-04-28 19:30:00', '无', '待审核', NULL, '2024-12-30 18:48:51');
INSERT INTO `qingjiashenqing` VALUES (6, '43564220951174', '032', '吴永国', '13748589658', 'C03', '', '2024-03-16 21:43:00', '2024-04-10 11:18:00', '暂无', '待审核', NULL, '2024-12-30 18:48:51');
INSERT INTO `qingjiashenqing` VALUES (7, '43568817825896', '005', '科比', '13025896548', 'B02', '', '2024-04-11 15:49:00', '2024-04-28 19:30:00', '无', '待审核', NULL, '2024-12-30 18:48:51');
INSERT INTO `qingjiashenqing` VALUES (8, '43564781063782', '024', '刘建福', '13489665487', 'A02', '', '2024-03-17 08:16:00', '2024-03-06 05:13:00', '暂无', '待审核', NULL, '2024-12-30 18:48:51');
INSERT INTO `qingjiashenqing` VALUES (9, '43562956484055', '004', '吴亦凡', '13910215489', 'D03', '', '2024-03-16 06:44:00', '2024-04-19 23:17:00', 'abc', '待审核', NULL, '2024-12-30 18:48:51');
INSERT INTO `qingjiashenqing` VALUES (10, '43561645380733', '012', '伍兆斌', '18759640002', 'A01', '', '2024-04-06 09:20:00', '2024-03-06 05:13:00', '暂无', '待审核', NULL, '2024-12-30 18:48:51');
INSERT INTO `qingjiashenqing` VALUES (11, '43561068898080', '001', '李景阳', '13184865998', 'A03', '', '2025-08-18 12:39:38', '2025-08-19 12:00:00', 'ok', '待审核', NULL, '2024-12-30 18:48:51');
INSERT INTO `qingjiashenqing` VALUES (12, '20240403322', '001', '李景阳', '13544655202', 'A03', '1', '2025-08-18 12:40:19', '2025-08-20 12:40:27', NULL, '待审核', NULL, '2024-12-30 19:16:47');

-- ----------------------------
-- Table structure for xueshengxinxi
-- ----------------------------
DROP TABLE IF EXISTS `xueshengxinxi`;
CREATE TABLE `xueshengxinxi`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `xuehao` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `mima` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `xueshengxingming` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `xingbie` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `shenfenzheng` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `dianhua` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `banji` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `jiguan` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `zhaopian` varchar(50) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `beizhu` varchar(500) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `level` varchar(10) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT '学生',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = gb2312 COLLATE = gb2312_chinese_ci COMMENT = '学生' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of xueshengxinxi
-- ----------------------------
INSERT INTO `xueshengxinxi` VALUES (2, '008', 'e10adc3949ba59abbe56e057f20f883e', '孙俪', '0', '330327199504059511', '13587835380', 'D03', '陕西', '', 'abc', '学生', '2024-12-30 18:48:51');
INSERT INTO `xueshengxinxi` VALUES (3, '031', 'e10adc3949ba59abbe56e057f20f883e', '马庆炳', '1', '330327199010142546', '13623256544', 'E02', '河北', '', 'ok', '学生', '2024-12-30 18:48:51');
INSERT INTO `xueshengxinxi` VALUES (4, '023', 'e10adc3949ba59abbe56e057f20f883e', '刘建福', '0', '33032719900723568X', '18759640002', 'C02', '上海', '', '暂无', '学生', '2024-12-30 18:48:51');
INSERT INTO `xueshengxinxi` VALUES (5, '030', 'e10adc3949ba59abbe56e057f20f883e', '沈古璐', '1', '330327199005060003', '13769548711', 'B01', '山西', '', '没问题', '学生', '2024-12-30 18:48:51');
INSERT INTO `xueshengxinxi` VALUES (6, '005', 'e10adc3949ba59abbe56e057f20f883e', '李鹏', '0', '330327198406150488', '13184865998', 'E01', '湖南', '', 'ok', '学生', '2024-12-30 18:48:51');
INSERT INTO `xueshengxinxi` VALUES (7, '002', 'e10adc3949ba59abbe56e057f20f883e', '易建联', '1', '330327198811020456', '13489665487', 'C03', '辽宁', '', 'ok', '学生', '2024-12-30 18:48:51');
INSERT INTO `xueshengxinxi` VALUES (8, '015', 'e10adc3949ba59abbe56e057f20f883e', '袁庆轩', '1', '330327198615482633', '13025896548', 'D02', '浙江', '', '无', '学生', '2024-12-30 18:48:51');
INSERT INTO `xueshengxinxi` VALUES (9, '028', 'e10adc3949ba59abbe56e057f20f883e', '鹿晗', '1', '330327198501020300', '18956482221', 'E02', '广东', '', '暂无', '学生', '2024-12-30 18:48:51');
INSERT INTO `xueshengxinxi` VALUES (10, '011', 'e10adc3949ba59abbe56e057f20f883e', '林嘉俐', '0', '330327185403060589', '13159863241', 'E01', '山东', '', 'ok', '学生', '2024-12-30 18:48:51');
INSERT INTO `xueshengxinxi` VALUES (11, '001', 'e10adc3949ba59abbe56e057f20f883e', '李景阳', '1', '330327198708070789', '13544655202', 'A03', '海南', '/files/download/22', '我是学生', '学生', '2024-12-30 18:48:51');

SET FOREIGN_KEY_CHECKS = 1;
