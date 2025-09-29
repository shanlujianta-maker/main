<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 获取当前页面路径，用于高亮显示当前页面
    String currentPage = request.getRequestURI();
    String currentPageName = currentPage.substring(currentPage.lastIndexOf("/") + 1);
    
    // 判断当前页面类型
    boolean isClubList = currentPageName.equals("club_list.jsp");
    boolean isClubManage = currentPageName.equals("club_manage.jsp");
    boolean isMemberManage = currentPageName.equals("member_manage.jsp");
    boolean isActivityList = currentPageName.equals("activity_list.jsp");
    boolean isActivityManage = currentPageName.equals("activity_manage.jsp");
    boolean isIndex = currentPageName.equals("index.jsp");
    
    // 获取用户角色和权限
    String userType = "";
    if (session.getAttribute("loginUser") != null) {
        com.xja.club.pojo.Users loginUser = (com.xja.club.pojo.Users) session.getAttribute("loginUser");
        userType = loginUser.getUserType() != null ? loginUser.getUserType() : "";
    }
    
    // 判断用户权限
    boolean isAdmin = "admin".equals(userType);
    boolean isStudent = "student".equals(userType);
    
    // 统一路径计算 - 使用绝对路径避免相对路径问题
    String basePath = "";
    String homePath = "";
    String memberManagePath = "";
    String clubListPath = "";
    String clubManagePath = "";
    String activityListPath = "";
    String activityManagePath = "";
    String myActivitiesPath = "";
    String loginPath = "";
    
    if (currentPage.contains("/admin/")) {
        // 在admin目录下
        basePath = "";
        homePath = "../index.jsp";
        // 根据用户类型决定成员管理页面路径
        if (isAdmin) {
            memberManagePath = "member_manage.jsp";  // 管理员使用admin目录下的成员管理页面
        } else {
            memberManagePath = "../student/member_manage.jsp";  // 学生使用student目录下的成员管理页面
        }
        clubListPath = "club_list.jsp";
        clubManagePath = "club_manage.jsp";
        activityListPath = "activity_list.jsp";
        activityManagePath = "activity_manage.jsp";
        myActivitiesPath = "my_activities.jsp";
        loginPath = "login.jsp";
    } else if (currentPage.contains("/student/")) {
        // 在student目录下
        basePath = "../admin/";
        homePath = "../index.jsp";
        memberManagePath = "member_manage.jsp";  // 在student目录下，直接访问当前目录的成员管理页面
        clubListPath = "../admin/club_list.jsp";
        clubManagePath = "../admin/club_manage.jsp";
        activityListPath = "../admin/activity_list.jsp";
        activityManagePath = "../admin/activity_manage.jsp";
        myActivitiesPath = "../admin/my_activities.jsp";
        loginPath = "../admin/login.jsp";
    } else {
        // 在根目录下
        basePath = "admin/";
        homePath = "index.jsp";
        // 根据用户类型决定成员管理页面路径
        if (isAdmin) {
            memberManagePath = "admin/member_manage.jsp";  // 管理员使用admin目录下的成员管理页面
        } else {
            memberManagePath = "student/member_manage.jsp";  // 学生使用student目录下的成员管理页面
        }
        clubListPath = "admin/club_list.jsp";
        clubManagePath = "admin/club_manage.jsp";
        activityListPath = "admin/activity_list.jsp";
        activityManagePath = "admin/activity_manage.jsp";
        myActivitiesPath = "admin/my_activities.jsp";
        loginPath = "admin/login.jsp";
    }
%>

<!-- 导航栏 -->
<header class="bg-white shadow-sm sticky top-0 z-50 transition-all duration-300" id="navbar">
    <div class="container mx-auto px-4">
        <div class="flex justify-between items-center py-4">
            <div class="flex items-center space-x-2">
                <i class="fa fa-users text-primary text-2xl"></i>
                <h1 class="text-2xl font-bold text-primary">校园社团活动管理系统</h1>
            </div>

            <nav class="flex items-center space-x-6">
                <a href="<%= homePath %>" 
                   class="nav-link text-gray-600 <%= isIndex ? "text-primary font-medium" : "" %>">首页</a>
                
                <!-- 社团下拉菜单 - 根据角色显示不同内容 -->
                <% if (isAdmin || isStudent) { %>
                <div class="relative group">
                    <button class="nav-link text-gray-600 flex items-center <%= (isClubList || isClubManage || isMemberManage) ? "text-primary font-medium" : "" %>">
                        社团 <i class="fas fa-chevron-down ml-1 text-xs"></i>
                    </button>
                    <div class="absolute top-full left-0 mt-1 w-48 bg-white rounded-md shadow-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 z-50">
                        <div class="py-1">
                            <% if (isStudent) { %>
                            <!-- 学生可以看到社团列表和成员管理 -->
                            <a href="<%= clubListPath %>" 
                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 <%= isClubList ? "bg-primary/10 text-primary" : "" %>">社团列表</a>
                            <a href="<%= memberManagePath %>" 
                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 <%= isMemberManage ? "bg-primary/10 text-primary" : "" %>">成员管理</a>
                            <% } else if (isAdmin) { %>
                            <!-- 管理员可以看到所有社团功能 -->
                            <a href="<%= clubListPath %>" 
                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 <%= isClubList ? "bg-primary/10 text-primary" : "" %>">社团列表</a>
                            <a href="<%= clubManagePath %>" 
                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 <%= isClubManage ? "bg-primary/10 text-primary" : "" %>">社团管理</a>
                            <a href="<%= memberManagePath %>" 
                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 <%= isMemberManage ? "bg-primary/10 text-primary" : "" %>">成员管理</a>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } else if (isAdmin) { %>
                <!-- 社长只能看到成员管理 -->
                <div class="relative group">
                    <button class="nav-link text-gray-600 flex items-center <%= isMemberManage ? "text-primary font-medium" : "" %>">
                        社团 <i class="fas fa-chevron-down ml-1 text-xs"></i>
                    </button>
                    <div class="absolute top-full left-0 mt-1 w-48 bg-white rounded-md shadow-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 z-50">
                        <div class="py-1">
                            <a href="<%= memberManagePath %>" 
                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 <%= isMemberManage ? "bg-primary/10 text-primary" : "" %>">成员管理</a>
                        </div>
                    </div>
                </div>
                <% } %>
                
                <!-- 活动下拉菜单 - 根据角色显示不同内容 -->
                <div class="relative group">
                    <button class="nav-link text-gray-600 flex items-center <%= (isActivityList || isActivityManage) ? "text-primary font-medium" : "" %>">
                        活动 <i class="fas fa-chevron-down ml-1 text-xs"></i>
                    </button>
                    <div class="absolute top-full left-0 mt-1 w-48 bg-white rounded-md shadow-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 z-50">
                        <div class="py-1">
                            <!-- 所有角色都可以看到活动列表 -->
                            <a href="<%= activityListPath %>" 
                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 <%= isActivityList ? "bg-primary/10 text-primary" : "" %>">活动预告</a>
                            <% if (isStudent) { %>
                            <!-- 普通学生可以看到我的活动 -->
                            <a href="<%= myActivitiesPath %>" 
                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">我的活动</a>
                            <% } %>
                            <% if (isAdmin) { %>
                            <!-- 老师和社长可以管理活动 -->
                            <a href="<%= activityManagePath %>" 
                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 <%= isActivityManage ? "bg-primary/10 text-primary" : "" %>">活动管理</a>
                            <% } %>
                        </div>
                    </div>
                </div>
                
            </nav>

            <div class="flex items-center space-x-4">
                <button id="logoutBtn" class="btn-primary" onclick="logout()">
                    <i class="fa fa-sign-out-alt mr-1"></i>注销
                </button>
            </div>
        </div>
    </div>

</header>

<!-- 导航栏JavaScript -->
<script>
    // 注销功能
    function logout() {
        if (confirm('确定要退出登录吗？')) {
            // 直接跳转到登录页面
            window.location.href = '<%= loginPath %>';
        }
    }
</script>
