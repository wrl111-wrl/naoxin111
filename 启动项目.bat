@echo off
chcp 65001 >nul
echo ================================
echo    教学管理系统启动脚本
echo ================================
echo.

echo 正在检查环境...
echo.

echo 检查Java环境...
java -version >nul 2>&1
if errorlevel 1 (
    echo ❌ Java环境未安装或未配置，请先安装JDK 8+
    pause
    exit /b 1
)
echo ✅ Java环境正常

echo 检查Node.js环境...
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js环境未安装，请先安装Node.js 12+
    pause
    exit /b 1
)
echo ✅ Node.js环境正常

echo 检查MySQL连接...
mysql --version >nul 2>&1
if errorlevel 1 (
    echo ❌ MySQL未安装或未配置
    echo 请确保MySQL 5.7+已安装并创建数据库DB061
    pause
    exit /b 1
)
echo ✅ MySQL环境正常

echo.
echo ================================
echo 启动服务...
echo ================================
echo.

echo 🚀 启动后端服务 (端口: 8888)...
echo 后端启动可能需要几分钟时间，请耐心等待...
start "后端服务" cmd /k "cd /d d:\Project\houduan && mvn spring-boot:run"

echo.
echo ⏳ 等待后端服务启动 (15秒)...
timeout /t 15 /nobreak >nul

echo 🚀 启动前端服务 (端口: 9999)...
start "前端服务" cmd /k "cd /d d:\Project\houtai && npm install && npm run dev"

echo.
echo ================================
echo ✅ 启动完成！
echo ================================
echo.
echo 📋 访问地址：
echo    前端页面: http://localhost:9999
echo    后端API:  http://localhost:8888
echo.
echo 💡 提示：
echo    - 首次启动需要下载依赖，请耐心等待
echo    - 如果端口被占用，请关闭其他应用后重试
echo    - 后端启动可能需要更长时间
echo.
pause