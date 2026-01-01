@echo off
echo 正在连接数据库并执行插入操作...
cd /d "c:\Users\吴若澜\Desktop\Project(kegai)"

REM 尝试使用MySQL客户端执行SQL
mysql -h localhost -u root -p1234 DB061 < insert_students.sql

if %errorlevel% equ 0 (
    echo SQL插入操作成功完成！
    echo 现在可以在Navicat Premium中查看数据
    echo 启动前端和后端服务以验证数据显示
) else (
    echo MySQL命令不可用，请手动在Navicat Premium中执行insert_students.sql文件
    echo 打开Navicat Premium，连接到DB061数据库
    echo 执行insert_students.sql中的INSERT语句
)

pause