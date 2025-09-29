<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 获取用户角色和权限
    String userType = "";
    Integer currentUserId = null;
    if (session.getAttribute("loginUser") != null) {
        com.xja.club.pojo.Users loginUser = (com.xja.club.pojo.Users) session.getAttribute("loginUser");
        userType = loginUser.getUserType() != null ? loginUser.getUserType() : "";
        currentUserId = loginUser.getUserId();
    }
    
    // 判断用户权限
    boolean isAdmin = "admin".equals(userType);
    
    boolean isStudent = "student".equals(userType);
    
    // 只有普通学生可以访问此页面
    if (!isStudent) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的活动列表 - 校园社团活动管理系统</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .card-hover:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .loading-spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #3498db;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body class="bg-gray-50">
    <!-- 导航栏 -->
    <jsp:include page="../components/navbar.jsp" />

    <!-- 主要内容区域 -->
    <div class="container mx-auto px-4 py-8">
        <!-- 页面标题 -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-800 mb-2">我的活动列表</h1>
            <p class="text-gray-600">查看您已报名的活动并进行签到</p>
        </div>

        <!-- 搜索和筛选区域 -->
        <div class="bg-white rounded-lg shadow-sm p-6 mb-6">
            <div class="flex flex-col md:flex-row gap-4">
                <div class="flex-1">
                    <div class="relative">
                        <input type="text" id="searchInput" placeholder="搜索活动名称或地点..." 
                               class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                        <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                    </div>
                </div>
                <div class="md:w-48">
                    <select id="statusFilter" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                        <option value="">所有状态</option>
                        <option value="registered">已报名</option>
                        <option value="checked_in">已签到</option>
                        <option value="absent">已标记缺席</option>
                    </select>
                </div>
                <button onclick="performSearch()" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                    <i class="fas fa-search mr-2"></i>搜索
                </button>
            </div>
        </div>

        <!-- 活动列表区域 -->
        <div id="activitiesContainer" class="space-y-4">
            <!-- 加载状态 -->
            <div id="loadingState" class="text-center py-12">
                <div class="loading-spinner mx-auto mb-4"></div>
                <p class="text-gray-600">正在加载您的活动...</p>
            </div>
            
            <!-- 空状态 -->
            <div id="emptyState" class="text-center py-12 hidden">
                <i class="fas fa-calendar-times text-6xl text-gray-300 mb-4"></i>
                <h3 class="text-xl font-semibold text-gray-600 mb-2">暂无活动</h3>
                <p class="text-gray-500">您还没有报名任何活动</p>
                <a href="activity_list.jsp" class="inline-block mt-4 px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                    浏览活动
                </a>
            </div>
            
            <!-- 活动列表 -->
            <div id="activitiesList" class="space-y-4"></div>
        </div>
    </div>

    <!-- 签到确认模态框 -->
    <div id="checkinModal" class="fixed inset-0 bg-black bg-opacity-50 hidden z-50">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="bg-white rounded-lg shadow-xl max-w-md w-full">
                <div class="p-6">
                    <h3 class="text-lg font-semibold text-gray-800 mb-4">确认签到</h3>
                    <p class="text-gray-600 mb-6">您确定要签到这个活动吗？</p>
                    <div class="flex justify-end space-x-3">
                        <button onclick="closeCheckinModal()" class="px-4 py-2 text-gray-600 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
                            取消
                        </button>
                        <button onclick="confirmCheckin()" class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">
                            确认签到
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let allActivities = [];
        let currentCheckinId = null;

        // 页面加载时获取数据
        document.addEventListener('DOMContentLoaded', function() {
            loadMyActivities();
            bindEvents();
        });

        // 绑定事件
        function bindEvents() {
            // 搜索按钮
            document.getElementById('searchInput').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    performSearch();
                }
            });
        }

        // 加载我的活动列表
        async function loadMyActivities() {
            try {
                const response = await fetch('/club_war_exploded/api/activities/my-activities');
                const result = await response.json();
                
                if (result.success) {
                    allActivities = result.data || [];
                    displayActivities(allActivities);
                } else {
                    showError(result.msg || '获取活动列表失败');
                }
            } catch (error) {
                console.error('加载活动列表失败:', error);
                showError('网络错误，请稍后重试');
            }
        }

        // 显示活动列表
        function displayActivities(activities) {
            const loadingState = document.getElementById('loadingState');
            const emptyState = document.getElementById('emptyState');
            const activitiesList = document.getElementById('activitiesList');
            
            loadingState.classList.add('hidden');
            
            if (activities.length === 0) {
                emptyState.classList.remove('hidden');
                activitiesList.innerHTML = '';
            } else {
                emptyState.classList.add('hidden');
                activitiesList.innerHTML = activities.map(activity => createActivityCard(activity)).join('');
            }
        }

        // 创建活动卡片
        function createActivityCard(activity) {
            const canCheckin = canCheckIn(activity);
            let actionHtml = '';
            
            if (canCheckin) {
                actionHtml = '<button onclick="openCheckinModal(' + activity.registration_id + ', \'' + activity.activity_name + '\')" ' +
                           'class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">' +
                           '<i class="fas fa-check mr-2"></i>签到</button>';
            } else {
                actionHtml = '<span class="text-gray-500 text-sm">' + getCheckinStatusText(activity) + '</span>';
            }
            
            return '<div class="bg-gray-50 rounded-lg p-6 card-hover fade-in">' +
                '<div class="flex flex-col md:flex-row md:items-center justify-between">' +
                    '<div class="flex-1">' +
                        '<div class="flex items-center mb-2">' +
                            '<h3 class="text-lg font-semibold text-gray-800 mr-3">' + activity.activity_name + '</h3>' +
                            '<span class="px-2 py-1 text-xs rounded-full ' + getStatusClass(activity.check_in_status) + '">' + 
                            getStatusText(activity.check_in_status) + '</span>' +
                        '</div>' +
                        '<div class="grid grid-cols-1 md:grid-cols-2 gap-2 text-sm text-gray-600 mb-3">' +
                            '<div class="flex items-center">' +
                                '<i class="fas fa-calendar-alt text-blue-500 mr-2"></i>' +
                                '<span>' + formatDateTime(activity.start_time) + '</span>' +
                            '</div>' +
                            '<div class="flex items-center">' +
                                '<i class="fas fa-map-marker-alt text-red-500 mr-2"></i>' +
                                '<span>' + activity.location + '</span>' +
                            '</div>' +
                            '<div class="flex items-center">' +
                                '<i class="fas fa-users text-green-500 mr-2"></i>' +
                                '<span>' + activity.club_name + '</span>' +
                            '</div>' +
                            '<div class="flex items-center">' +
                                '<i class="fas fa-clock text-purple-500 mr-2"></i>' +
                                '<span>报名时间: ' + formatDateTime(activity.registration_time) + '</span>' +
                            '</div>' +
                        '</div>' +
                        (activity.description ? '<p class="text-gray-600 mt-3 text-sm">' + activity.description + '</p>' : '') +
                    '</div>' +
                    '<div class="mt-4 md:mt-0 md:ml-6">' +
                        actionHtml +
                    '</div>' +
                '</div>' +
            '</div>';
        }

        // 判断是否可以签到
        function canCheckIn(activity) {
            if (activity.check_in_status === 'checked_in') {
                return false; // 已经签到
            }
            
            const now = new Date();
            const startTime = new Date(activity.start_time);
            const endTime = new Date(activity.end_time);
            
            // 整个活动期间内都可以签到
            return now >= startTime && now <= endTime;
        }

        // 获取签到状态文本
        function getCheckinStatusText(activity) {
            if (activity.check_in_status === 'checked_in') {
                if (activity.check_in_time) {
                    const checkinTime = new Date(activity.check_in_time);
                    return '已签到 (' + formatDateTime(activity.check_in_time) + ')';
                }
                return '已签到';
            }
            
            if (activity.check_in_status === 'absent') {
                return '已标记缺席';
            }
            
            const now = new Date();
            const startTime = new Date(activity.start_time);
            const endTime = new Date(activity.end_time);
            
            if (now < startTime) {
                const timeDiff = Math.round((startTime.getTime() - now.getTime()) / (1000 * 60));
                if (timeDiff < 60) {
                    return '活动即将开始 (' + timeDiff + '分钟后)';
                } else {
                    const hours = Math.floor(timeDiff / 60);
                    const minutes = timeDiff % 60;
                    return '活动即将开始 (' + hours + '小时' + minutes + '分钟后)';
                }
            } else if (now > endTime) {
                return '活动已结束';
            } else {
                return '可以签到';
            }
        }

        // 格式化日期时间
        function formatDateTime(dateString) {
            if (!dateString) return 'Invalid Date';
            
            // 直接解析数据库中的时间字符串，不进行时区转换
            const date = new Date(dateString);
            if (isNaN(date.getTime())) return 'Invalid Date';
            
            // 使用本地时间显示，因为数据库已经存储了正确的本地时间
            return date.toLocaleString('zh-CN', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
            });
        }

        // 搜索功能
        function performSearch() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;
            
            let filteredActivities = allActivities.filter(activity => {
                const matchesSearch = !searchTerm || 
                    activity.activity_name.toLowerCase().includes(searchTerm) ||
                    activity.location.toLowerCase().includes(searchTerm) ||
                    activity.club_name.toLowerCase().includes(searchTerm);
                
                const matchesStatus = !statusFilter || activity.check_in_status === statusFilter;
                
                return matchesSearch && matchesStatus;
            });
            
            displayActivities(filteredActivities);
        }

        // 获取状态样式
        function getStatusClass(status) {
            switch (status) {
                case 'checked_in':
                    return 'bg-green-100 text-green-800';
                case 'absent':
                    return 'bg-red-100 text-red-800';
                default:
                    return 'bg-blue-100 text-blue-800';
            }
        }

        // 获取状态文本
        function getStatusText(status) {
            switch (status) {
                case 'checked_in':
                    return '已签到';
                case 'absent':
                    return '已标记缺席';
                default:
                    return '已报名';
            }
        }

        // 打开签到模态框
        function openCheckinModal(registrationId, activityName) {
            currentCheckinId = registrationId;
            document.getElementById('checkinModal').classList.remove('hidden');
        }

        // 关闭签到模态框
        function closeCheckinModal() {
            document.getElementById('checkinModal').classList.add('hidden');
            currentCheckinId = null;
        }

        // 确认签到
        async function confirmCheckin() {
            if (!currentCheckinId) return;
            
            try {
                const response = await fetch('/club_war_exploded/api/activities/checkin', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        registrationId: currentCheckinId
                    })
                });
                
                const result = await response.json();
                
                if (result.success) {
                    showSuccess('签到成功！');
                    closeCheckinModal();
                    loadMyActivities(); // 重新加载数据
                } else {
                    showError(result.msg || '签到失败');
                }
            } catch (error) {
                console.error('签到失败:', error);
                showError('网络错误，请稍后重试');
            }
        }

        // 显示成功消息
        function showSuccess(message) {
            alert(message);
        }

        // 显示错误消息
        function showError(message) {
            alert('错误: ' + message);
        }
    </script>
</body>
</html>
