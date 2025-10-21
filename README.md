[Uploading README.md…]()
# 学生请假管理系统

# 项目简介
学生请假管理系统是一款专为学校、培训机构设计的请假流程数字化管理工具，旨在简化请假申请、审批流程，提高管理效率，实现请假记录的规范化、信息化管理。系统支持学生在线提交请假申请、教师/管理员审批、请假数据统计分析等功能，适用于各类教育机构的日常请假管理场景。

# 功能特点
1.多角色管理
学生：提交请假申请、查看申请状态、修改/撤销未审批申请
教师/辅导员：审批学生请假申请、查看管辖学生请假记录
管理员：系统配置、用户管理、权限分配、全量数据统计
2.请假流程管理
支持多种请假类型（病假、事假、公假等）
自定义审批流程（单级审批/多级审批）
请假时长自动计算（含节假日/周末排除）
申请状态实时更新（待审批、已批准、已驳回）
3.数据统计与查询
按班级、年级、时间段统计请假数据
导出请假记录（Excel/CSV格式）
学生请假历史查询与汇总
4.系统安全与便捷性
基于角色的权限控制（RBAC）
操作日志记录，确保流程可追溯
响应式设计，支持电脑端问

# 技术架构
前端：Vue.js
后端：Spring Boot
数据库：SQL Server
部署环境：Docker 容器化部署
开发语言：Java
  
# 安装与部署
1.前置条件
操作系统：Windows / Linux /macOS
数据库：Microsoft SQL Server Management Studio 18
JDK 11+
Maven 3.6+
2.部署步骤
1）克隆代码仓库
git clone https://github.com/your-org/student-leave-management.git
cd student-leave-management
2）配置数据库
创建数据库：CREATE DATABASE leave_management DEFAULT CHARACTER SET utf8mb4;
修改配置文件（application.yml 或 .env），填写数据库连接信息
3）初始化数据
执行数据库脚本：sql/init.sql（创建表结构及初始数据）
4）构建与启动
后端（Spring Boot）：
mvn clean package -Dmaven.test.skip=true
java -jar target/leave-management-1.0.0.jar
前端：
cd frontend
npm install
npm run build  # 构建生产环境包
# 部署到Nginx或直接启动开发环境
npm run dev
5）访问系统
默认地址：http://localhost:8080（后端）/ http://localhost:80（前端，需配置 Nginx代理）
初始账号：管理员 admin/admin123，学生 student1/123456

# 使用指南

1.学生端操作
登录系统后，点击「请假申请」进入表单页面
选择请假类型、填写请假时间、事由等信息
提交申请后，可在「我的请假」中查看审批进度
未审批的申请可点击「修改」或「撤销」
2.教师端操作
登录系统后，在「待审批列表」中查看学生提交的申请
点击申请查看详情，选择「批准」或「驳回」并填写意见
在「已审批列表」中查看历史审批记录
3.管理员操作
进入「系统管理」配置请假类型、审批流程等
在「用户管理」中添加 / 编辑学生、教师账号及权限
通过「数据统计」查看全校请假数据报表

# 常见问题

忘记密码怎么办？
联系管理员重置密码，管理员可在「用户管理」中修改账号密码。
如何修改审批流程？
管理员进入「系统配置 - 审批流程」，可添加 / 删除审批节点，设置审批角色。
请假记录能否批量导出？
支持在「数据查询」页面筛选条件后，点击「导出」按钮生成Excel文件。
系统支持多校区管理吗？
支持，管理员可在「校区管理」中添加校区信息，用户账号可关联对应校区。

# 版本更新日志

v1.0.0（2025-10-21）
初始版本，包含请假申请、审批、数据统计基础功能

# 联系方式

项目维护：zhezhishizhanwei@aaa.com
问题反馈：zheyeshizhanwei@aaa.com
技术支持：zhehaishizhanwei@aaa.com

# 开源协议

本项目采用 MIT License 开源协议，允许自由使用、修改和分发。
