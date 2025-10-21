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
('A03', '���Ӱ�', '2024-12-30 18:48:51'),
('B01', '��ͨ��', '2024-12-30 18:48:51'),
('E01', '������', '2024-12-30 18:48:51'),
('C01', '��ͨ��', '2024-12-30 18:48:51'),
('E02', '������', '2024-12-30 18:48:51'),
('D03', '��ͨ��', '2024-12-30 18:48:51'),
('C03', '��ͨ��', '2024-12-30 18:48:51'),
('C02', '��ͨ��', '2024-12-30 18:48:51'),
('A02', '���Ӱ�', '2024-12-30 18:48:51'),
('D02', '��ͨ��', '2024-12-30 18:48:51');


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
    [level] VARCHAR(10) COLLATE Chinese_PRC_CI_AS NULL DEFAULT '����Ա',
    [addtime] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    PRIMARY KEY CLUSTERED ([id] ASC)
);


-- ----------------------------
-- Records of guanliyuan
-- ----------------------------
INSERT INTO dbo.guanliyuan ([yonghuming], [mima], [status], [level], [addtime])
VALUES ('admin', '21232f297a57a5a743894a0e4a801fc3', '0', '����Ա', '2025-08-18 18:48:51');


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
    [level] VARCHAR(10) COLLATE Chinese_PRC_CI_AS NULL DEFAULT '��ʦ',
    [addtime] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    PRIMARY KEY CLUSTERED ([id] ASC)
);

-- ----------------------------
-- Records of jiaoshixinxi
-- ----------------------------
INSERT INTO dbo.jiaoshixinxi ([gonghao], [mima], [xingming], [xingbie], [shenfenzheng], [dianhua], [zhicheng], [zhujiaokecheng], [banji], [jiguan], [zhaopian], [beizhu], [level], [addtime])
VALUES 
('027', 'e10adc3949ba59abbe56e057f20f883e', '������', '1', '330327198615482633', '13587835380', '����Ա', '����', 'E01', '����', '', '����', '��ʦ', '2024-12-30 18:48:51'),
('008', 'e10adc3949ba59abbe56e057f20f883e', '����ϣ', '1', '330327185403060589', '13159863241', '����', '�����', 'C02', '����', '', 'û����', '��ʦ', '2024-12-30 18:48:51'),
('009', 'e10adc3949ba59abbe56e057f20f883e', '������', '1', '330327199010142546', '13186835580', '����', '�������', 'D02', '����', '', '��', '��ʦ', '2024-12-30 18:48:51'),
('017', 'e10adc3949ba59abbe56e057f20f883e', '������', '1', '330327199504059511', '13748589658', '��ʦ', '����', 'E02', '����', '', 'û����', '��ʦ', '2024-12-30 18:48:51'),
('010', 'e10adc3949ba59abbe56e057f20f883e', '³����', '0', '330327198708070789', '17505772420', '����ʦ', '��ʷ', 'D03', '����', '', 'abc', '��ʦ', '2024-12-30 18:48:51'),
('029', 'e10adc3949ba59abbe56e057f20f883e', '��֮��', '0', '330327198406150488', '17706641413', '������', '����', 'B01', '���', '', 'abc', '��ʦ', '2024-12-30 18:48:51'),
('004', 'e10adc3949ba59abbe56e057f20f883e', '�泩', '0', '330327198805060222', '13489665487', '����', 'Ӣ��', 'C02', '������', '', '��', '��ʦ', '2024-12-30 18:48:51'),
('012', 'e10adc3949ba59abbe56e057f20f883e', '������', '1', '33032719900723568X', '18759640002', '����', '���Դ���', 'E02', '����', '', 'û����', '��ʦ', '2024-12-30 18:48:51'),
('034', 'e10adc3949ba59abbe56e057f20f883e', '����', '0', '330327198501020300', '13544655202', '����', '����', 'E02', '�㶫', '', '����', '��ʦ', '2024-12-30 18:48:51'),
('001', 'e10adc3949ba59abbe56e057f20f883e', '������', '0', '330327198811020456', '13052154877', '����', '���Դ���', 'A03', '����', '/files/download/24', 'abc', '��ʦ', '2024-12-30 18:48:51');

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
    [issh] VARCHAR(10) COLLATE Chinese_PRC_CI_AS NULL DEFAULT '�����',
    [shhf] VARCHAR(200) COLLATE Chinese_PRC_CI_AS NULL,
    [addtime] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    PRIMARY KEY CLUSTERED ([id] ASC)
);


-- ----------------------------
-- Records of qingjiashenqing
-- ----------------------------
INSERT INTO dbo.qingjiashenqing ([qingjiabianhao], [xuehao], [xueshengxingming], [lianxidianhua], [banji], [qingjiayuanyin], [qishishijian], [zhongzhishijian], [beizhu], [issh], [shhf], [addtime])
VALUES 
('43568839218187', '025', '÷����', '13587835380', 'D02', '', '2024-03-16 06:44:00', '2024-04-11 08:35:00', 'û����', '��ͨ��', '1', '2024-12-30 18:48:51'),
('43564462955769', '003', '��С��', '17505772420', 'A03', '', '2024-03-06 13:53:00', '2024-03-26 08:08:00', '��ע', '��ͨ��', '��׼', '2024-12-30 18:48:51'),
('43562853687001', '015', '˾�ܲ�', '13623256544', 'C02', '', '2024-04-06 09:20:00', '2024-03-19 02:34:00', 'ok', '�����', NULL, '2024-12-30 18:48:51'),
('43563934079920', '029', '���غ�', '18956482221', 'E01', '', '2024-03-09 11:01:00', '2024-04-28 19:30:00', '��', '�����', NULL, '2024-12-30 18:48:51'),
('43564220951174', '032', '������', '13748589658', 'C03', '', '2024-03-16 21:43:00', '2024-04-10 11:18:00', '����', '�����', NULL, '2024-12-30 18:48:51'),
('43568817825896', '005', '�Ʊ�', '13025896548', 'B02', '', '2024-04-11 15:49:00', '2024-04-28 19:30:00', '��', '�����', NULL, '2024-12-30 18:48:51'),
('43564781063782', '024', '������', '13489665487', 'A02', '', '2024-03-17 08:16:00', '2024-03-06 05:13:00', '����', '�����', NULL, '2024-12-30 18:48:51'),
('43562956484055', '004', '���ෲ', '13910215489', 'D03', '', '2024-03-16 06:44:00', '2024-04-19 23:17:00', 'abc', '�����', NULL, '2024-12-30 18:48:51'),
('43561645380733', '012', '���ױ�', '18759640002', 'A01', '', '2024-04-06 09:20:00', '2024-03-06 05:13:00', '����', '�����', NULL, '2024-12-30 18:48:51'),
('43561068898080', '001', '���', '13184865998', 'A03', '', '2025-08-18 12:39:38', '2025-08-19 12:00:00', 'ok', '�����', NULL, '2024-12-30 18:48:51'),
('20240403322', '001', '���', '13544655202', 'A03', '1', '2025-08-18 12:40:19', '2025-08-20 12:40:27', NULL, '�����', NULL, '2024-12-30 19:16:47');


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
    [level] VARCHAR(10) COLLATE Chinese_PRC_CI_AS NULL DEFAULT 'ѧ��',
    [addtime] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    PRIMARY KEY CLUSTERED ([id] ASC)
);


-- ----------------------------
-- Records of xueshengxinxi
-- ----------------------------
INSERT INTO dbo.xueshengxinxi ([xuehao], [mima], [xueshengxingming], [xingbie], [shenfenzheng], [dianhua], [banji], [jiguan], [zhaopian], [beizhu], [level], [addtime])
VALUES 
('008', 'e10adc3949ba59abbe56e057f20f883e', '��ٳ', '0', '330327199504059511', '13587835380', 'D03', '����', '', 'abc', 'ѧ��', '2024-12-30 18:48:51'),
('031', 'e10adc3949ba59abbe56e057f20f883e', '�����', '1', '330327199010142546', '13623256544', 'E02', '�ӱ�', '', 'ok', 'ѧ��', '2024-12-30 18:48:51'),
('023', 'e10adc3949ba59abbe56e057f20f883e', '������', '0', '33032719900723568X', '18759640002', 'C02', '�Ϻ�', '', '����', 'ѧ��', '2024-12-30 18:48:51'),
('030', 'e10adc3949ba59abbe56e057f20f883e', '����', '1', '330327199005060003', '13769548711', 'B01', 'ɽ��', '', 'û����', 'ѧ��', '2024-12-30 18:48:51'),
('005', 'e10adc3949ba59abbe56e057f20f883e', '����', '0', '330327198406150488', '13184865998', 'E01', '����', '', 'ok', 'ѧ��', '2024-12-30 18:48:51'),
('002', 'e10adc3949ba59abbe56e057f20f883e', '�׽���', '1', '330327198811020456', '13489665487', 'C03', '����', '', 'ok', 'ѧ��', '2024-12-30 18:48:51'),
('015', 'e10adc3949ba59abbe56e057f20f883e', 'Ԭ����', '1', '330327198615482633', '13025896548', 'D02', '�㽭', '', '��', 'ѧ��', '2024-12-30 18:48:51'),
('028', 'e10adc3949ba59abbe56e057f20f883e', '¹��', '1', '330327198501020300', '18956482221', 'E02', '�㶫', '', '����', 'ѧ��', '2024-12-30 18:48:51'),
('011', 'e10adc3949ba59abbe56e057f20f883e', '�ּ���', '0', '330327185403060589', '13159863241', 'E01', 'ɽ��', '', 'ok', 'ѧ��', '2024-12-30 18:48:51'),
('001', 'e10adc3949ba59abbe56e057f20f883e', '���', '1', '330327198708070789', '13544655202', 'A03', '����', '/files/download/22', '����ѧ��', 'ѧ��', '2024-12-30 18:48:51');

SET NOCOUNT OFF;




