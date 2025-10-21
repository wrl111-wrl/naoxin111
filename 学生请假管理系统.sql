SET NOCOUNT ON; 

-- -------------------------------
-- Table structure for banjixinxi
-- -------------------------------
IF OBJECT_ID('dbo.banjixinxi', 'U') IS NOT NULL
    DROP TABLE dbo.banjixinxi;
CREATE TABLE dbo.banjixinxi (
    [id] INT IDENTITY(1,1) NOT NULL, 
    [banji] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL, 
    [beizhu] VARCHAR(500) COLLATE Chinese_PRC_CI_AS NULL,
    [addtime] DATETIME2 NOT NULL DEFAULT GETUTCDATE(), 
    PRIMARY KEY CLUSTERED ([id] ASC)
);

-- ----------------------------
-- Records of banjixinxi
-- ----------------------------
INSERT INTO dbo.banjixinxi ([banji], [beizhu], [addtime])
VALUES 
('A03', '尖子班', '2024-12-30 18:48:51'),
('B01', '普通班', '2024-12-30 18:48:51'),
('E01', '差生班', '2024-12-30 18:48:51'),
('C01', '普通班', '2024-12-30 18:48:51'),
('E02', '差生班', '2024-12-30 18:48:51'),
('D03', '普通班', '2024-12-30 18:48:51'),
('C03', '普通班', '2024-12-30 18:48:51'),
('C02', '普通班', '2024-12-30 18:48:51'),
('A02', '尖子班', '2024-12-30 18:48:51'),
('D02', '普通班', '2024-12-30 18:48:51');


-- ----------------------------
-- Table structure for [file]
-- ----------------------------
IF OBJECT_ID('dbo.[file]', 'U') IS NOT NULL
    DROP TABLE dbo.[file];
CREATE TABLE dbo.[file] (
    [id] INT IDENTITY(1,1) NOT NULL,
    [originName] VARCHAR(255) COLLATE Chinese_PRC_CI_AS NULL,
    [fileName] VARCHAR(255) COLLATE Chinese_PRC_CI_AS NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

-- ----------------------------
-- Records of [file]
-- ----------------------------
INSERT INTO dbo.[file] ([originName], [fileName])
VALUES 
('xueshengxinxi1.jpg', 'xueshengxinxi1.jpg'),
('xueshengxinxi2.jpg', 'xueshengxinxi2.jpg'),
('xueshengxinxi3.jpg', 'xueshengxinxi3.jpg'),
('xueshengxinxi4.jpg', 'xueshengxinxi4.jpg'),
('xueshengxinxi5.jpg', 'xueshengxinxi5.jpg'),
('xueshengxinxi6.jpg', 'xueshengxinxi6.jpg'),
('xueshengxinxi7.jpg', 'xueshengxinxi7.jpg'),
('xueshengxinxi8.jpg', 'xueshengxinxi8.jpg'),
('xueshengxinxi9.jpg', 'xueshengxinxi9.jpg'),
('xueshengxinxi10.jpg', 'xueshengxinxi10.jpg'),
('jiaoshixinxi1.jpg', 'jiaoshixinxi1.jpg'),
('jiaoshixinxi2.jpg', 'jiaoshixinxi2.jpg'),
('jiaoshixinxi3.jpg', 'jiaoshixinxi3.jpg'),
('jiaoshixinxi4.jpg', 'jiaoshixinxi4.jpg'),
('jiaoshixinxi5.jpg', 'jiaoshixinxi5.jpg'),
('jiaoshixinxi6.jpg', 'jiaoshixinxi6.jpg'),
('jiaoshixinxi7.jpg', 'jiaoshixinxi7.jpg'),
('jiaoshixinxi8.jpg', 'jiaoshixinxi8.jpg'),
('jiaoshixinxi9.jpg', 'jiaoshixinxi9.jpg'),
('jiaoshixinxi10.jpg', 'jiaoshixinxi10.jpg'),
('2.jpeg', '21755442408733.jpeg'),
('1.jpeg', '11755447448054.jpeg'),
('1.jpeg', '11755448057513.jpeg');


-- ----------------------------
-- Table structure for guanliyuan
-- ----------------------------
IF OBJECT_ID('dbo.guanliyuan', 'U') IS NOT NULL
    DROP TABLE dbo.guanliyuan;
CREATE TABLE dbo.guanliyuan (
    [id] INT IDENTITY(1,1) NOT NULL,
    [yonghuming] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [mima] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [status] VARCHAR(10) COLLATE Chinese_PRC_CI_AS NULL DEFAULT '0',
    [level] VARCHAR(10) COLLATE Chinese_PRC_CI_AS NULL DEFAULT '管理员',
    [addtime] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    PRIMARY KEY CLUSTERED ([id] ASC)
);


-- ----------------------------
-- Records of guanliyuan
-- ----------------------------
INSERT INTO dbo.guanliyuan ([yonghuming], [mima], [status], [level], [addtime])
VALUES ('admin', '21232f297a57a5a743894a0e4a801fc3', '0', '管理员', '2025-08-18 18:48:51');


-- ----------------------------
-- Table structure for jiaoshixinxi
-- ----------------------------
IF OBJECT_ID('dbo.jiaoshixinxi', 'U') IS NOT NULL
    DROP TABLE dbo.jiaoshixinxi;
CREATE TABLE dbo.jiaoshixinxi (
    [id] INT IDENTITY(1,1) NOT NULL,
    [gonghao] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [mima] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [xingming] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [xingbie] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [shenfenzheng] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [dianhua] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [zhicheng] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [zhujiaokecheng] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [banji] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [jiguan] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [zhaopian] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [beizhu] VARCHAR(500) COLLATE Chinese_PRC_CI_AS NULL,
    [level] VARCHAR(10) COLLATE Chinese_PRC_CI_AS NULL DEFAULT '教师',
    [addtime] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    PRIMARY KEY CLUSTERED ([id] ASC)
);

-- ----------------------------
-- Records of jiaoshixinxi
-- ----------------------------
INSERT INTO dbo.jiaoshixinxi ([gonghao], [mima], [xingming], [xingbie], [shenfenzheng], [dianhua], [zhicheng], [zhujiaokecheng], [banji], [jiguan], [zhaopian], [beizhu], [level], [addtime])
VALUES 
('027', 'e10adc3949ba59abbe56e057f20f883e', '陈燕琪', '1', '330327198615482633', '13587835380', '技术员', '政治', 'E01', '吉林', '', '暂无', '教师', '2024-12-30 18:48:51'),
('008', 'e10adc3949ba59abbe56e057f20f883e', '陈明希', '1', '330327185403060589', '13159863241', '教授', '计算机', 'C02', '安徽', '', '没问题', '教师', '2024-12-30 18:48:51'),
('009', 'e10adc3949ba59abbe56e057f20f883e', '何永康', '1', '330327199010142546', '13186835580', '助教', '软件工程', 'D02', '甘肃', '', '无', '教师', '2024-12-30 18:48:51'),
('017', 'e10adc3949ba59abbe56e057f20f883e', '吴永国', '1', '330327199504059511', '13748589658', '讲师', '政治', 'E02', '辽宁', '', '没问题', '教师', '2024-12-30 18:48:51'),
('010', 'e10adc3949ba59abbe56e057f20f883e', '鲁艾弈', '0', '330327198708070789', '17505772420', '工程师', '历史', 'D03', '江苏', '', 'abc', '教师', '2024-12-30 18:48:51'),
('029', 'e10adc3949ba59abbe56e057f20f883e', '方之明', '0', '330327198406150488', '17706641413', '副教授', '语文', 'B01', '天津', '', 'abc', '教师', '2024-12-30 18:48:51'),
('004', 'e10adc3949ba59abbe56e057f20f883e', '舒畅', '0', '330327198805060222', '13489665487', '助教', '英语', 'C02', '黑龙江', '', '无', '教师', '2024-12-30 18:48:51'),
('012', 'e10adc3949ba59abbe56e057f20f883e', '黄行阳', '1', '33032719900723568X', '18759640002', '助教', '线性代数', 'E02', '云南', '', '没问题', '教师', '2024-12-30 18:48:51'),
('034', 'e10adc3949ba59abbe56e057f20f883e', '沈古璐', '0', '330327198501020300', '13544655202', '助理', '法律', 'E02', '广东', '', '暂无', '教师', '2024-12-30 18:48:51'),
('001', 'e10adc3949ba59abbe56e057f20f883e', '余少庆', '0', '330327198811020456', '13052154877', '助理', '线性代数', 'A03', '海南', '/files/download/24', 'abc', '教师', '2024-12-30 18:48:51');

-- ----------------------------
-- Table structure for qingjiashenqing
-- ----------------------------
IF OBJECT_ID('dbo.qingjiashenqing', 'U') IS NOT NULL
    DROP TABLE dbo.qingjiashenqing;
CREATE TABLE dbo.qingjiashenqing (
    [id] INT IDENTITY(1,1) NOT NULL,
    [qingjiabianhao] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [xuehao] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [xueshengxingming] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [lianxidianhua] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [banji] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [qingjiayuanyin] VARCHAR(500) COLLATE Chinese_PRC_CI_AS NULL,
    [qishishijian] DATETIME NULL,
    [zhongzhishijian] DATETIME NULL,
    [beizhu] VARCHAR(500) COLLATE Chinese_PRC_CI_AS NULL,
    [issh] VARCHAR(10) COLLATE Chinese_PRC_CI_AS NULL DEFAULT '待审核',
    [shhf] VARCHAR(200) COLLATE Chinese_PRC_CI_AS NULL,
    [addtime] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    PRIMARY KEY CLUSTERED ([id] ASC)
);


-- ----------------------------
-- Records of qingjiashenqing
-- ----------------------------
INSERT INTO dbo.qingjiashenqing ([qingjiabianhao], [xuehao], [xueshengxingming], [lianxidianhua], [banji], [qingjiayuanyin], [qishishijian], [zhongzhishijian], [beizhu], [issh], [shhf], [addtime])
VALUES 
('43568839218187', '025', '梅邹雁', '13587835380', 'D02', '', '2024-03-16 06:44:00', '2024-04-11 08:35:00', '没问题', '已通过', '1', '2024-12-30 18:48:51'),
('43564462955769', '003', '陈小巧', '17505772420', 'A03', '', '2024-03-06 13:53:00', '2024-03-26 08:08:00', '备注', '已通过', '批准', '2024-12-30 18:48:51'),
('43562853687001', '015', '司宪策', '13623256544', 'C02', '', '2024-04-06 09:20:00', '2024-03-19 02:34:00', 'ok', '待审核', NULL, '2024-12-30 18:48:51'),
('43563934079920', '029', '王柏弘', '18956482221', 'E01', '', '2024-03-09 11:01:00', '2024-04-28 19:30:00', '无', '待审核', NULL, '2024-12-30 18:48:51'),
('43564220951174', '032', '吴永国', '13748589658', 'C03', '', '2024-03-16 21:43:00', '2024-04-10 11:18:00', '暂无', '待审核', NULL, '2024-12-30 18:48:51'),
('43568817825896', '005', '科比', '13025896548', 'B02', '', '2024-04-11 15:49:00', '2024-04-28 19:30:00', '无', '待审核', NULL, '2024-12-30 18:48:51'),
('43564781063782', '024', '刘建福', '13489665487', 'A02', '', '2024-03-17 08:16:00', '2024-03-06 05:13:00', '暂无', '待审核', NULL, '2024-12-30 18:48:51'),
('43562956484055', '004', '吴亦凡', '13910215489', 'D03', '', '2024-03-16 06:44:00', '2024-04-19 23:17:00', 'abc', '待审核', NULL, '2024-12-30 18:48:51'),
('43561645380733', '012', '伍兆斌', '18759640002', 'A01', '', '2024-04-06 09:20:00', '2024-03-06 05:13:00', '暂无', '待审核', NULL, '2024-12-30 18:48:51'),
('43561068898080', '001', '李景阳', '13184865998', 'A03', '', '2025-08-18 12:39:38', '2025-08-19 12:00:00', 'ok', '待审核', NULL, '2024-12-30 18:48:51'),
('20240403322', '001', '李景阳', '13544655202', 'A03', '1', '2025-08-18 12:40:19', '2025-08-20 12:40:27', NULL, '待审核', NULL, '2024-12-30 19:16:47');


-- ----------------------------
-- Table structure for xueshengxinxi
-- ----------------------------
IF OBJECT_ID('dbo.xueshengxinxi', 'U') IS NOT NULL
    DROP TABLE dbo.xueshengxinxi;
CREATE TABLE dbo.xueshengxinxi (
    [id] INT IDENTITY(1,1) NOT NULL,
    [xuehao] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [mima] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [xueshengxingming] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [xingbie] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [shenfenzheng] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [dianhua] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [banji] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [jiguan] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [zhaopian] VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
    [beizhu] VARCHAR(500) COLLATE Chinese_PRC_CI_AS NULL,
    [level] VARCHAR(10) COLLATE Chinese_PRC_CI_AS NULL DEFAULT '学生',
    [addtime] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    PRIMARY KEY CLUSTERED ([id] ASC)
);


-- ----------------------------
-- Records of xueshengxinxi
-- ----------------------------
INSERT INTO dbo.xueshengxinxi ([xuehao], [mima], [xueshengxingming], [xingbie], [shenfenzheng], [dianhua], [banji], [jiguan], [zhaopian], [beizhu], [level], [addtime])
VALUES 
('008', 'e10adc3949ba59abbe56e057f20f883e', '孙俪', '0', '330327199504059511', '13587835380', 'D03', '陕西', '', 'abc', '学生', '2024-12-30 18:48:51'),
('031', 'e10adc3949ba59abbe56e057f20f883e', '马庆炳', '1', '330327199010142546', '13623256544', 'E02', '河北', '', 'ok', '学生', '2024-12-30 18:48:51'),
('023', 'e10adc3949ba59abbe56e057f20f883e', '刘建福', '0', '33032719900723568X', '18759640002', 'C02', '上海', '', '暂无', '学生', '2024-12-30 18:48:51'),
('030', 'e10adc3949ba59abbe56e057f20f883e', '沈古璐', '1', '330327199005060003', '13769548711', 'B01', '山西', '', '没问题', '学生', '2024-12-30 18:48:51'),
('005', 'e10adc3949ba59abbe56e057f20f883e', '李鹏', '0', '330327198406150488', '13184865998', 'E01', '湖南', '', 'ok', '学生', '2024-12-30 18:48:51'),
('002', 'e10adc3949ba59abbe56e057f20f883e', '易建联', '1', '330327198811020456', '13489665487', 'C03', '辽宁', '', 'ok', '学生', '2024-12-30 18:48:51'),
('015', 'e10adc3949ba59abbe56e057f20f883e', '袁庆轩', '1', '330327198615482633', '13025896548', 'D02', '浙江', '', '无', '学生', '2024-12-30 18:48:51'),
('028', 'e10adc3949ba59abbe56e057f20f883e', '鹿晗', '1', '330327198501020300', '18956482221', 'E02', '广东', '', '暂无', '学生', '2024-12-30 18:48:51'),
('011', 'e10adc3949ba59abbe56e057f20f883e', '林嘉俐', '0', '330327185403060589', '13159863241', 'E01', '山东', '', 'ok', '学生', '2024-12-30 18:48:51'),
('001', 'e10adc3949ba59abbe56e057f20f883e', '李景阳', '1', '330327198708070789', '13544655202', 'A03', '海南', '/files/download/22', '我是学生', '学生', '2024-12-30 18:48:51');

SET NOCOUNT OFF;




