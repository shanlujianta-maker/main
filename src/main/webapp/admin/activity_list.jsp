<%--
  Created by IntelliJ IDEA.
  User: yao
  Date: 2025/9/8
  Time: 上午10:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园社团活动管理系统 - 活动列表</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" 
          onerror="this.onerror=null;this.href='../css/font-awesome-fallback.css';">
    <!-- 引入导航栏样式 -->
    <link rel="stylesheet" href="../css/navbar.css">
    <!-- 配置Tailwind自定义颜色和字体 -->
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#4F46E5', // 主色调：靛蓝色，代表信任和专业
                        secondary: '#EC4899', // 辅助色：粉色，用于文学类社团
                        accent: '#10B981', // 强调色：绿色，用于体育类社团
                        dark: '#1E293B', // 深色：用于页脚背景
                    },
                    fontFamily: {
                        sans: ['Inter', 'system-ui', 'sans-serif'],
                    },
                }
            }
        }
    </script>
    <style type="text/tailwindcss">
        @layer utilities {
            .content-auto {
                content-visibility: auto;
            }
            .card-hover {
                @apply transition-all duration-300 hover:shadow-lg hover:-translate-y-1;
            }
            .btn-primary {
                @apply bg-primary text-white py-2 px-4 rounded-md font-medium transition-all duration-200 hover:bg-primary/90 hover:shadow-md focus:outline-none focus:ring-2 focus:ring-primary/50;
            }
            .btn-secondary {
                @apply bg-white text-primary border border-primary py-2 px-4 rounded-md font-medium transition-all duration-200 hover:bg-primary/5 hover:shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/30;
            }
            .text-balance {
                text-wrap: balance;
            }
        }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 font-sans">
<!-- 引入导航栏组件 -->
<jsp:include page="../components/navbar.jsp" />

<!-- 页面标题 -->
<section class="bg-gradient-to-r from-primary/90 to-primary py-12 border-b border-gray-200 text-white">
    <div class="container mx-auto px-4">
        <h2 class="text-2xl md:text-3xl font-bold mb-2">活动列表</h2>
        <p class="text-white/90 max-w-2xl">发现精彩活动，丰富校园生活，结交志同道合的朋友</p>
    </div>
</section>

<!-- 活动列表筛选 -->
<section class="py-8">
    <div class="container mx-auto px-4">
        <div class="bg-white rounded-xl shadow-sm p-6 mb-8 transform transition-all duration-300 hover:shadow-md">
            <div class="flex flex-col md:flex-row gap-4">
                <div class="flex-grow">
                    <div class="relative">
                        <input type="text" id="searchInput" placeholder="搜索活动名称或关键词..."
                               class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all duration-200">
                        <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    </div>
                </div>

                <div class="w-full md:w-auto">
                    <select id="clubFilter" class="w-full md:w-48 px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent bg-white transition-all duration-200">
                        <option value="all">所有社团</option>
                        <!-- 动态加载社团选项 -->
                    </select>
                </div>

                <div class="w-full md:w-auto">
                    <button id="searchBtn" class="btn-primary w-full">
                        <i class="fas fa-filter mr-1"></i>筛选
                    </button>
                </div>
            </div>
        </div>

        <!-- 活动列表 -->
        <div id="activitiesContainer" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <!-- 动态加载的活动卡片将在这里显示 -->
        </div>

    </div>
</section>

<!-- 底部 -->
<footer class="bg-dark text-white py-12 mt-12">
    <div class="container mx-auto px-4">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div>
                <div class="flex items-center space-x-2 mb-4">
                    <i class="fas fa-users text-primary text-2xl"></i>
                    <h3 class="text-xl font-bold">校园社团活动管理系统</h3>
                </div>
                <p class="text-gray-400 text-sm">为校园社团提供便捷的管理工具，促进社团健康发展，丰富学生校园生活。</p>
            </div>

        </div>

        <div class="border-t border-gray-700 mt-8 pt-8 text-center text-gray-500 text-sm">
            <p>© 2025 校园社团活动管理系统 版权所有</p>
        </div>
    </div>
</footer>


<!-- 活动报名模态框 -->
<div id="enrollActivityModal" class="fixed inset-0 bg-black/50 z-50 hidden flex items-center justify-center p-4 opacity-0 transition-opacity duration-300">
    <div class="bg-white rounded-xl w-full max-w-md p-6 shadow-2xl transform transition-all duration-300 scale-95 translate-y-8">
        <div class="flex justify-between items-center mb-6">
            <h3 class="text-xl font-bold">活动报名</h3>
            <button id="closeEnrollModalBtn" class="text-gray-500 hover:text-gray-700 transition-colors duration-200">
                <i class="fas fa-times text-xl"></i>
            </button>
        </div>

        <form id="enrollActivityForm">
            <input type="hidden" id="activityId">

            <div class="mb-6">
                <div class="bg-gray-50 p-4 rounded-lg">
                    <h4 class="text-sm font-medium text-gray-700 mb-3">您的报名信息</h4>
                    <div class="space-y-2 text-sm">
                        <div class="flex justify-between">
                            <span class="text-gray-600">姓名：</span>
                            <span id="userRealName" class="font-medium">加载中...</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-600">学号：</span>
                            <span id="userStudentId" class="font-medium">加载中...</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-600">联系电话：</span>
                            <span id="userPhone" class="font-medium">加载中...</span>
                        </div>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn-primary w-full">确认报名</button>
        </form>
    </div>
</div>

<script>


    // 移动端菜单切换
    const mobileMenuBtn = document.getElementById('mobileMenuBtn');
    if (mobileMenuBtn) {
        mobileMenuBtn.addEventListener('click', function() {
            const mobileMenu = document.getElementById('mobileMenu');
            if (mobileMenu) {
                mobileMenu.classList.toggle('hidden');
            }
        });
    }

    // 页面加载时检查登录状态
    window.addEventListener('load', function() {
        const realName = '<%= session.getAttribute("realName") != null ? session.getAttribute("realName") : "" %>';
        if (!realName) {
            alert('请先登录系统');
            window.location.href = 'login.jsp';
        }
    });


    // 导航栏滚动效果
    window.addEventListener('scroll', function() {
        const navbar = document.getElementById('navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('shadow-md');
            navbar.classList.remove('shadow-sm');
        } else {
            navbar.classList.remove('shadow-md');
            navbar.classList.add('shadow-sm');
        }
    });



    // 活动报名模态框控制
    const enrollModal = document.getElementById('enrollActivityModal');
    const closeEnrollModalBtn = document.getElementById('closeEnrollModalBtn');
    const activityIdInput = document.getElementById('activityId');

    function openEnrollModal(activityId) {
        if (!enrollModal || !activityIdInput) {
            console.warn('模态框元素未找到');
            return;
        }
        
        // 检查用户是否已登录
        if (!currentUser) {
            alert('请先登录后再报名活动');
            return;
        }
        
        // 检查活动状态是否允许报名
        const activity = allActivities.find(a => a.activityId == activityId);
        if (activity && activity.actStatus !== 'open') {
            let message = '';
            switch (activity.actStatus) {
                case 'planning': message = '该活动还在策划中，暂不能报名'; break;
                case 'ongoing': message = '该活动正在进行中，无法报名'; break;
                case 'completed': message = '该活动已结束，无法报名'; break;
                case 'cancelled': message = '该活动已取消，无法报名'; break;
                default: message = '该活动当前状态不允许报名';
            }
            alert(message);
            return;
        }
        
        // 检查活动容量
        if (activity && activity.maxParticipants > 0) {
            const current = activity.currentParticipants || 0;
            if (current >= activity.maxParticipants) {
                alert('该活动报名人数已满，无法报名');
                return;
            }
        }
        
        // 设置当前活动ID
        activityIdInput.value = activityId;
        
        // 显示用户信息
        document.getElementById('userRealName').textContent = currentUser.realName || '未知';
        document.getElementById('userStudentId').textContent = currentUser.userId || '未知';
        document.getElementById('userPhone').textContent = currentUser.userPhone || '未知';
        
        // 显示模态框
        enrollModal.classList.remove('hidden');
        setTimeout(() => {
            enrollModal.classList.add('opacity-100');
            const modalContent = enrollModal.querySelector('div');
            if (modalContent) {
                modalContent.classList.remove('scale-95', 'translate-y-8');
                modalContent.classList.add('scale-100', 'translate-y-0');
            }
        }, 10);
        document.body.style.overflow = 'hidden';
    }

    function closeEnrollModal() {
        if (!enrollModal) {
            console.warn('模态框元素未找到');
            return;
        }
        
        enrollModal.classList.remove('opacity-100');
        const modalContent = enrollModal.querySelector('div');
        if (modalContent) {
            modalContent.classList.remove('scale-100', 'translate-y-0');
            modalContent.classList.add('scale-95', 'translate-y-8');
        }
        setTimeout(() => {
            enrollModal.classList.add('hidden');
            document.body.style.overflow = '';
        }, 300);
    }

    // 绑定模态框关闭按钮事件
    if (closeEnrollModalBtn) {
        closeEnrollModalBtn.addEventListener('click', closeEnrollModal);
    }

    // 点击报名模态框外部关闭
    if (enrollModal) {
        enrollModal.addEventListener('click', function(e) {
            if (e.target === enrollModal) {
                closeEnrollModal();
            }
        });
    }

    // 报名表单提交处理
    const enrollForm = document.getElementById('enrollActivityForm');
    let isSubmitting = false; // 防重复提交标志
    
    if (enrollForm) {
        enrollForm.addEventListener('submit', function(e) {
            e.preventDefault();

            // 防重复提交检查
            if (isSubmitting) {
                console.log('正在提交中，请勿重复点击');
                return;
            }

            // 检查用户是否已登录
            if (!currentUser) {
                alert('请先登录后再报名活动');
                return;
            }

            // 获取表单数据
            const formData = {
                activityId: document.getElementById('activityId').value
            };

            // 简单表单验证
            if (!formData.activityId) {
                alert('活动ID不能为空');
                return;
            }

            // 设置提交状态
            isSubmitting = true;
            
            // 禁用提交按钮
            const submitBtn = enrollForm.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.textContent = '报名中...';
            }

            // 调用API提交报名
            fetch('/club_war_exploded/api/activity-registration/register/' + formData.activityId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                credentials: 'same-origin'  // 确保发送cookies和session
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.msg);
                    closeEnrollModal();
                    // 重新加载活动列表
                    loadActivities();
                } else {
                    alert('报名失败: ' + data.msg);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('提交失败，请稍后再试');
            })
            .finally(() => {
                // 恢复提交状态
                isSubmitting = false;
                if (submitBtn) {
                    submitBtn.disabled = false;
                    submitBtn.textContent = '确认报名';
                }
            });
        });
    }

    // 搜索筛选功能
    const searchBtn = document.getElementById('searchBtn');
    const searchInput = document.getElementById('searchInput');
    const clubFilter = document.getElementById('clubFilter');

    if (searchBtn && searchInput && clubFilter) {
        searchBtn.addEventListener('click', function() {
            filterActivities();
        });
    }

    // 社团筛选变化事件
    if (clubFilter) {
        clubFilter.addEventListener('change', function() {
            filterActivities();
        });
    }

    // 筛选活动
    function filterActivities() {
        const searchTerm = searchInput ? searchInput.value.trim().toLowerCase() : '';
        const selectedClub = clubFilter ? clubFilter.value : 'all';

        let filteredActivities = allActivities;

        // 根据搜索词筛选
        if (searchTerm) {
            filteredActivities = filteredActivities.filter(activity => 
                activity.activityName.toLowerCase().includes(searchTerm) ||
                (activity.description && activity.description.toLowerCase().includes(searchTerm)) ||
                (activity.clubName && activity.clubName.toLowerCase().includes(searchTerm))
            );
        }

        // 根据社团筛选
        if (selectedClub !== 'all') {
            filteredActivities = filteredActivities.filter(activity => 
                activity.organizingClubId == selectedClub
            );
        }

        renderActivities(filteredActivities);
    }

    // 按回车键触发搜索
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                if (searchBtn) {
                    searchBtn.click();
                }
            }
        });
    }

    // 存储所有活动数据和社团数据用于筛选
    let allActivities = [];
    let allClubs = [];
    let currentUser = null;

    // 加载活动数据
    function loadActivities() {
        console.log('开始加载活动数据...');
        const startTime = Date.now();
        
        // 设置超时
        const timeoutPromise = new Promise((_, reject) => {
            setTimeout(() => reject(new Error('请求超时')), 10000);
        });
        
        const fetchPromise = fetch('/club_war_exploded/api/activities/list/all')
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }
                return response.json();
            });
        
        Promise.race([fetchPromise, timeoutPromise])
            .then(data => {
                const endTime = Date.now();
                console.log(`活动数据加载完成，耗时: ${endTime - startTime}ms`);
                
                if (data.success) {
                    allActivities = data.data; // 保存所有活动数据
                    renderActivities(data.data);
                } else {
                    console.error('加载活动数据失败:', data.message);
                    showErrorMessage('加载活动数据失败: ' + data.message);
                }
            })
            .catch(error => {
                const endTime = Date.now();
                console.error('加载活动数据失败:', error);
                console.error(`请求耗时: ${endTime - startTime}ms`);
                
                if (error.message === '请求超时') {
                    showErrorMessage('请求超时，请检查网络连接或稍后重试');
                } else {
                    showErrorMessage('网络错误: ' + error.message);
                }
            });
    }

    // 加载社团数据（优化版）
    function loadClubs() {
        console.log('开始加载社团数据...');
        const startTime = Date.now();
        
        // 设置超时
        const timeoutPromise = new Promise((_, reject) => {
            setTimeout(() => reject(new Error('请求超时')), 10000);
        });
        
        const fetchPromise = fetch('/club_war_exploded/api/activities/list/clubs')
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }
                return response.json();
            });
        
        Promise.race([fetchPromise, timeoutPromise])
            .then(data => {
                const endTime = Date.now();
                console.log(`社团数据加载完成，耗时: ${endTime - startTime}ms`);
                
                if (data.success) {
                    allClubs = data.data;
                    renderClubFilter(data.data);
                } else {
                    console.error('加载社团数据失败:', data.message);
                }
            })
            .catch(error => {
                const endTime = Date.now();
                console.error('加载社团数据失败:', error);
                console.error(`请求耗时: ${endTime - startTime}ms`);
            });
    }

    // 渲染社团筛选下拉框
    function renderClubFilter(clubs) {
        const clubFilter = document.getElementById('clubFilter');
        if (!clubFilter) return;

        // 清空现有选项（保留"所有社团"选项）
        clubFilter.innerHTML = '<option value="all">所有社团</option>';

        // 添加社团选项
        clubs.forEach(club => {
            const option = document.createElement('option');
            option.value = club.clubId;
            option.textContent = club.clubName;
            clubFilter.appendChild(option);
        });
    }

    // 加载当前用户信息
    function loadCurrentUser() {
        fetch('/club_war_exploded/api/activities/list/current-user')
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    currentUser = data.data;
                    console.log('当前用户信息:', currentUser);
                } else {
                    console.error('获取用户信息失败:', data.message);
                    showErrorMessage('获取用户信息失败，请重新登录');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showErrorMessage('网络错误，请稍后重试');
            });
    }

    // 渲染活动卡片
    function renderActivities(activities) {
        const container = document.getElementById('activitiesContainer');
        if (!container) {
            console.warn('活动容器未找到');
            return;
        }
        
        container.innerHTML = '';

        if (!activities || activities.length === 0) {
            container.innerHTML = '<div class="col-span-full text-center py-12 text-gray-500">暂无活动数据</div>';
            return;
        }

        activities.forEach(activity => {
            const card = createActivityCard(activity);
            container.appendChild(card);
        });

        // 重新绑定报名按钮事件
        bindEnrollButtons();
    }

    // 创建活动卡片
    function createActivityCard(activity) {
        const card = document.createElement('div');
        
        // 根据活动状态确定样式和交互性
        const canEnroll = activity.actStatus === 'open';
        const statusClass = getStatusClass(activity.actStatus);
        const statusText = getStatusText(activity.actStatus);
        
        // 如果是不可报名的状态，添加灰色滤镜和禁用样式
        if (!canEnroll) {
            card.className = 'border border-gray-200 rounded-xl overflow-hidden shadow-sm bg-white opacity-60';
        } else {
            card.className = 'border border-gray-200 rounded-xl overflow-hidden shadow-sm card-hover bg-white';
        }
        
        // 根据状态确定按钮内容
        let buttonHtml;
        if (canEnroll) {
            buttonHtml = '<button class="btn-secondary w-full enroll-activity" data-id="' + activity.activityId + '">我要报名</button>' +
                        '<button class="btn-accent w-full mt-2 check-registration" data-id="' + activity.activityId + '">检查报名状态</button>';
        } else {
            let buttonText = '';
            switch (activity.actStatus) {
                case 'planning': buttonText = '策划中'; break;
                case 'ongoing': buttonText = '进行中'; break;
                case 'completed': buttonText = '已结束'; break;
                case 'cancelled': buttonText = '已取消'; break;
                default: buttonText = '无法报名';
            }
            buttonHtml = '<button class="bg-gray-300 text-gray-500 w-full px-4 py-2 rounded-md cursor-not-allowed" disabled>' + buttonText + '</button>';
        }
        
        card.innerHTML = 
            '<div class="relative h-48 overflow-hidden bg-gradient-to-br from-primary/10 to-secondary/10 flex items-center justify-center">' +
                '<div class="text-center">' +
                    '<i class="fas fa-calendar text-6xl text-primary/30 mb-2"></i>' +
                    '<p class="text-gray-500 text-sm">活动详情</p>' +
                '</div>' +
                '<div class="absolute top-3 left-3 ' + statusClass + ' text-white text-xs font-bold px-2 py-1 rounded">' +
                    statusText +
                '</div>' +
                '<div class="absolute top-3 right-3 bg-primary/90 text-white text-xs font-bold px-2 py-1 rounded">' +
                    (activity.clubName || '未知社团') +
                '</div>' +
            '</div>' +
            '<div class="p-6">' +
                '<h3 class="text-xl font-bold mb-2 line-clamp-2">' + activity.activityName + '</h3>' +
                '<p class="text-gray-600 text-sm mb-4 line-clamp-3 text-balance">' + (activity.description || '暂无描述') + '</p>' +
                '<div class="space-y-2 text-sm">' +
                    '<div class="flex items-center text-gray-600">' +
                        '<i class="fas fa-clock w-5 text-gray-400"></i>' +
                        '<span>' + formatDateTime(activity.startTime) + ' - ' + formatDateTime(activity.endTime) + '</span>' +
                    '</div>' +
                    '<div class="flex items-center text-gray-600">' +
                        '<i class="fas fa-map-marker-alt w-5 text-gray-400"></i>' +
                        '<span>' + (activity.location || '待定') + '</span>' +
                    '</div>' +
                    '<div class="flex items-center text-gray-600">' +
                        '<i class="fas fa-user w-5 text-gray-400"></i>' +
                        '<span>' + getParticipantInfo(activity) + '</span>' +
                    '</div>' +
                '</div>' +
                '<div class="mt-5">' +
                    buttonHtml +
                '</div>' +
            '</div>';
        
        return card;
    }

    // 获取状态样式类
    function getStatusClass(status) {
        switch (status) {
            case 'planning': return 'bg-gray-500/90';
            case 'open': return 'bg-accent/90';
            case 'ongoing': return 'bg-primary/90';
            case 'completed': return 'bg-gray-400/90';
            case 'cancelled': return 'bg-red-500/90';
            default: return 'bg-gray-500/90';
        }
    }

    // 获取状态文本
    function getStatusText(status) {
        switch (status) {
            case 'planning': return '策划中';
            case 'open': return '报名中';
            case 'ongoing': return '进行中';
            case 'completed': return '已结束';
            case 'cancelled': return '已取消';
            default: return '未知';
        }
    }

    // 格式化日期时间
    function formatDateTime(dateString) {
        if (!dateString) return '待定';
        const date = new Date(dateString);
        return date.toLocaleString('zh-CN', {
            month: 'numeric',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    }

    // 获取参与人数信息
    function getParticipantInfo(activity) {
        const current = activity.currentParticipants || 0;
        if (activity.maxParticipants === 0) {
            return '已报名 ' + current + ' 人（不限人数）';
        } else {
            return '已报名 ' + current + ' / ' + activity.maxParticipants + ' 人';
        }
    }

    // 绑定报名按钮事件
    function bindEnrollButtons() {
        const enrollButtons = document.querySelectorAll('.enroll-activity');
        enrollButtons.forEach(button => {
            button.addEventListener('click', function() {
                const activityId = this.getAttribute('data-id');
                openEnrollModal(activityId);
            });
        });
        
        // 绑定检查报名状态按钮事件
        const checkButtons = document.querySelectorAll('.check-registration');
        checkButtons.forEach(button => {
            button.addEventListener('click', function() {
                const activityId = this.getAttribute('data-id');
                checkRegistrationStatus(activityId);
            });
        });
    }
    
    // 检查报名状态
    function checkRegistrationStatus(activityId) {
        fetch('/club_war_exploded/api/activity-registration/check-registration/' + activityId, {
            method: 'GET',
            credentials: 'same-origin'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('报名状态: ' + data.msg + '\n详细信息: ' + JSON.stringify(data.registration));
            } else {
                alert('检查失败: ' + data.msg);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('检查失败: ' + error.message);
        });
    }

    // 显示错误信息
    function showErrorMessage(message) {
        const container = document.getElementById('activitiesContainer');
        if (!container) return;
        
        container.innerHTML = 
            '<div class="col-span-full text-center py-12">' +
                '<i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>' +
                '<p class="text-red-500">' + message + '</p>' +
                '<button onclick="loadActivities()" class="btn-primary mt-4">重新加载</button>' +
            '</div>';
    }

    // 页面加载完成后加载数据
    document.addEventListener('DOMContentLoaded', function() {
        loadActivities();
        loadClubs();
        loadCurrentUser();
    });
</script>
</body>
</html>
