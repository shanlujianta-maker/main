@echo off
echo 正在清理缓存并重启Tomcat...

echo.
echo 1. 停止Tomcat服务器...
taskkill /f /im java.exe 2>nul
timeout /t 2 /nobreak >nul

echo.
echo 2. 清理Tomcat工作目录...
if exist "C:\Program Files\Apache Software Foundation\Tomcat 9.0\work\Catalina\localhost\club_war_exploded" (
    rmdir /s /q "C:\Program Files\Apache Software Foundation\Tomcat 9.0\work\Catalina\localhost\club_war_exploded"
    echo Tomcat工作目录已清理
) else (
    echo Tomcat工作目录不存在，跳过清理
)

echo.
echo 3. 清理浏览器缓存提示...
echo 请手动清理浏览器缓存：
echo - Chrome: Ctrl+Shift+Delete
echo - Firefox: Ctrl+Shift+Delete
echo - Edge: Ctrl+Shift+Delete

echo.
echo 4. 重新编译项目...
call mvnw.cmd clean compile

echo.
echo 5. 启动Tomcat服务器...
echo 请手动启动Tomcat服务器

echo.
echo 清理完成！请：
echo 1. 清理浏览器缓存
echo 2. 重新启动Tomcat服务器
echo 3. 访问测试页面: http://localhost:8080/club_war_exploded/test_navbar_links.jsp
echo 4. 测试成员管理页面: http://localhost:8080/club_war_exploded/student/member_manage.jsp

pause
