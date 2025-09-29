<%--
  Created by IntelliJ IDEA.
  User: yao
  Date: 2025/9/8
  Time: 上午10:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 获取用户角色和权限
    String userType = "";
    if (session.getAttribute("loginUser") != null) {
        com.xja.club.pojo.Users loginUser = (com.xja.club.pojo.Users) session.getAttribute("loginUser");
        userType = loginUser.getUserType() != null ? loginUser.getUserType() : "";
    }
    
    // 判断用户权限
    boolean isAdmin = "admin".equals(userType);
    
    boolean isStudent = "student".equals(userType);
    
    // 如果未登录，重定向到登录页面
    if (userType == null || userType.isEmpty()) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园社团活动管理系统 - 社团列表</title>
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
                        primary: '#3B82F6', // 蓝色主色调
                        secondary: '#EC4899', // 粉色辅助色
                        accent: '#10B981', // 绿色强调色
                        dark: '#1F2937', // 深色背景
                        light: '#F9FAFB'  // 浅色背景
                    },
                    fontFamily: {
                        inter: ['Inter', 'system-ui', 'sans-serif'],
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
                @apply bg-primary hover:bg-primary/90 text-white font-medium py-2 px-4 rounded-md transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-primary/50;
            }
            .btn-outline {
                @apply border border-primary text-primary hover:bg-primary/10 font-medium py-2 px-4 rounded-md transition-all duration-200;
            }
            .section-padding {
                @apply py-12 md:py-16;
            }
            .text-balance {
                text-wrap: balance;
            }
        }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 font-inter antialiased">
<!-- 引入导航栏组件 -->
<jsp:include page="../components/navbar.jsp" />

<!-- 页面标题 -->
<section class="bg-gradient-to-r from-primary/90 to-primary py-12 md:py-16 text-white relative overflow-hidden">
    <!-- 背景装饰 -->
    <div class="absolute inset-0 overflow-hidden opacity-10">
        <div class="absolute -right-10 -top-10 w-64 h-64 rounded-full bg-white"></div>
        <div class="absolute left-20 bottom-10 w-32 h-32 rounded-full bg-white"></div>
        <div class="absolute right-1/3 top-1/3 w-16 h-16 rounded-full bg-white"></div>
    </div>

    <div class="container mx-auto px-4 relative z-10">
        <h2 class="text-3xl md:text-4xl font-bold mb-3">校园社团列表</h2>
        <p class="text-white/90 text-lg max-w-2xl text-balance">探索所有社团，找到你的兴趣所在，丰富你的校园生活</p>
    </div>
</section>

<!-- 社团列表筛选 -->
<section class="section-padding">
    <div class="container mx-auto px-4">
        <div class="bg-white rounded-xl shadow-sm p-6 mb-8 transform transition-all duration-300 hover:shadow-md">
            <div class="flex flex-col md:flex-row gap-4">
                <div class="flex-grow">
                    <div class="relative">
                        <input type="text" id="searchInput" placeholder="搜索社团名称或关键词..."
                               class="w-full pl-10 pr-4 py-2.5 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all duration-200">
                        <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    </div>
                </div>
                <div class="w-full md:w-auto">
                    <button id="searchBtn" class="btn-primary w-full">
                        <i class="fas fa-search mr-1"></i>搜索
                    </button>
                </div>
            </div>
        </div>

        <!-- 社团列表 -->
        <div id="clubsContainer" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            <!-- 动态加载的社团卡片将在这里显示 -->
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

<!-- 加入社团模态框 -->
<div id="joinClubModal" class="fixed inset-0 bg-black/50 z-50 hidden flex items-center justify-center p-4 opacity-0 transition-opacity duration-300">
    <div class="bg-white rounded-xl w-full max-w-md p-6 shadow-2xl transform transition-all duration-300 scale-95 translate-y-4">
        <div class="flex justify-between items-center mb-6">
            <h3 class="text-xl font-bold">申请加入社团</h3>
            <button id="closeJoinModalBtn" class="text-gray-500 hover:text-gray-700 transition-colors duration-200">
                <i class="fas fa-times text-xl"></i>
            </button>
        </div>

        <form id="joinClubForm">
            <input type="hidden" id="clubId">

            <div class="mb-6">
                <div class="bg-gray-50 p-4 rounded-lg">
                    <h4 class="text-sm font-medium text-gray-700 mb-3">您的申请信息</h4>
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

            <div class="mb-6">
                <label for="applicationReason" class="block text-sm font-medium text-gray-700 mb-1">申请理由</label>
                <textarea id="applicationReason" rows="3" class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all duration-200" placeholder="请简要说明您想加入该社团的原因"></textarea>
            </div>

            <button type="submit" class="btn-primary w-full">提交申请</button>
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
            window.location.href = 'admin/login.jsp';
        }
    });


    // 加入社团模态框控制
    const joinClubModal = document.getElementById('joinClubModal');
    const closeJoinModalBtn = document.getElementById('closeJoinModalBtn');
    const clubIdInput = document.getElementById('clubId');

    function openJoinModal(clubId) {
        if (!joinClubModal || !clubIdInput) {
            console.warn('模态框元素未找到');
            return;
        }
        
        // 检查用户是否已登录
        if (!currentUser) {
            alert('请先登录后再申请加入社团');
            return;
        }
        
        // 检查社团是否活跃
        const club = allClubs.find(c => c.clubId == clubId);
        if (club && club.clubStatus !== 'active') {
            alert('该社团已注销，无法申请加入');
            return;
        }
        
        // 设置社团ID
        clubIdInput.value = clubId;
        
        // 显示用户信息
        document.getElementById('userRealName').textContent = currentUser.realName || '未知';
        document.getElementById('userStudentId').textContent = currentUser.userId || '未知';
        document.getElementById('userPhone').textContent = currentUser.userPhone || '未知';
        
        // 清空申请理由
        document.getElementById('applicationReason').value = '';
        
        joinClubModal.classList.remove('hidden');

        setTimeout(() => {
            joinClubModal.classList.add('opacity-100');
            const modalContent = joinClubModal.querySelector('div');
            if (modalContent) {
                modalContent.classList.remove('scale-95', 'translate-y-4');
                modalContent.classList.add('scale-100', 'translate-y-0');
            }
        }, 10);
    }

    function closeJoinModal() {
        if (!joinClubModal) {
            console.warn('模态框元素未找到');
            return;
        }
        
        joinClubModal.classList.remove('opacity-100');
        const modalContent = joinClubModal.querySelector('div');
        if (modalContent) {
            modalContent.classList.remove('scale-100', 'translate-y-0');
            modalContent.classList.add('scale-95', 'translate-y-4');
        }

        setTimeout(() => {
            joinClubModal.classList.add('hidden');
        }, 300);
    }

    // 绑定模态框关闭按钮事件
    if (closeJoinModalBtn) {
        closeJoinModalBtn.addEventListener('click', closeJoinModal);
    }

    // 点击模态框外部关闭
    if (joinClubModal) {
        joinClubModal.addEventListener('click', function(e) {
            if (e.target === joinClubModal) {
                closeJoinModal();
            }
        });
    }

    // 表单提交处理
    const joinClubForm = document.getElementById('joinClubForm');
    if (joinClubForm) {
        joinClubForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // 检查用户是否已登录
        if (!currentUser) {
            alert('请先登录后再申请加入社团');
            return;
        }

        const clubId = document.getElementById('clubId').value;
        const applicationReason = document.getElementById('applicationReason').value;
        
        // 验证申请理由
        if (!applicationReason || applicationReason.trim() === '') {
            alert('请填写申请理由');
            return;
        }
        
        // 调用API提交申请
        fetch('/club_war_exploded/api/clubs/list/join', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                clubId: parseInt(clubId),
                applicationReason: applicationReason
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('申请已提交，等待审核');
                closeJoinModal();
                // 清空表单
                document.getElementById('joinClubForm').reset();
            } else {
                alert('申请失败: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('申请失败，请稍后重试');
        });
        });
    }

    // 存储所有社团数据和当前用户信息用于筛选
    let allClubs = [];
    let currentUser = null;

    // 加载当前用户信息
    function loadCurrentUser() {
        fetch('/club_war_exploded/api/clubs/list/current-user')
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

    // 筛选功能
    const searchBtn = document.getElementById('searchBtn');
    if (searchBtn) {
        searchBtn.addEventListener('click', function() {
            filterClubs();
        });
    }

    // 搜索框回车事件
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                filterClubs();
            }
        });
    }


    // 筛选社团
    function filterClubs() {
        const searchInput = document.getElementById('searchInput');
        
        if (!searchInput) {
            console.warn('搜索元素未找到，跳过筛选');
            return;
        }
        
        const searchTerm = searchInput.value.toLowerCase();
        let filteredClubs = allClubs;
        
        // 根据搜索词筛选
        if (searchTerm) {
            filteredClubs = filteredClubs.filter(club => 
                club.clubName.toLowerCase().includes(searchTerm) ||
                (club.description && club.description.toLowerCase().includes(searchTerm))
            );
        }
        
        renderClubs(filteredClubs);
    }

    // 滚动时导航栏效果
    window.addEventListener('scroll', function() {
        const header = document.querySelector('header');
        if (window.scrollY > 50) {
            header.classList.add('shadow');
        } else {
            header.classList.remove('shadow');
        }
    });

    // 加载社团数据（优化版）
    function loadClubs() {
        console.log('开始加载社团数据...');
        const startTime = Date.now();
        
        // 设置超时
        const timeoutPromise = new Promise((_, reject) => {
            setTimeout(() => reject(new Error('请求超时')), 10000);
        });
        
        const fetchPromise = fetch('/club_war_exploded/api/clubs/list/all')
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
                    allClubs = data.data; // 保存所有社团数据
                    renderClubs(data.data);
                } else {
                    console.error('加载社团数据失败:', data.message);
                    showErrorMessage('加载社团数据失败: ' + data.message);
                }
            })
            .catch(error => {
                const endTime = Date.now();
                console.error('加载社团数据失败:', error);
                console.error(`请求耗时: ${endTime - startTime}ms`);
                
                if (error.message === '请求超时') {
                    showErrorMessage('请求超时，请检查网络连接或稍后重试');
                } else {
                    showErrorMessage('网络错误: ' + error.message);
                }
            });
    }

    // 渲染社团卡片
    function renderClubs(clubs) {
        const container = document.getElementById('clubsContainer');
        container.innerHTML = '';

        if (!clubs || clubs.length === 0) {
            container.innerHTML = '<div class="col-span-full text-center py-12 text-gray-500">暂无社团数据</div>';
            return;
        }

        clubs.forEach(club => {
            const card = createClubCard(club);
            container.appendChild(card);
        });

        // 重新绑定加入按钮事件
        bindJoinButtons();
    }

    // 创建社团卡片
    function createClubCard(club) {
        const card = document.createElement('div');
        
        // 根据社团状态确定样式和交互性
        const isActive = club.clubStatus === 'active';
        const statusClass = isActive ? 'bg-accent' : 'bg-gray-500';
        const statusText = isActive ? '活跃' : '已注销';
        
        // 如果是非活跃状态，添加灰色滤镜和禁用样式
        if (!isActive) {
            card.className = 'bg-white rounded-xl overflow-hidden shadow-sm opacity-60';
        } else {
            card.className = 'bg-white rounded-xl overflow-hidden shadow-sm card-hover';
        }
        
        // 根据状态确定按钮内容
        let buttonHtml;
        if (isActive) {
            buttonHtml = '<button class="btn-primary text-sm join-club" data-id="' + club.clubId + '">申请加入</button>';
        } else {
            buttonHtml = '<button class="bg-gray-300 text-gray-500 text-sm px-4 py-2 rounded-md cursor-not-allowed" disabled>已注销</button>';
        }
        
        card.innerHTML = 
            '<div class="relative overflow-hidden h-48 bg-gradient-to-br from-primary/10 to-secondary/10 flex items-center justify-center">' +
                '<div class="text-center">' +
                    '<i class="fas fa-users text-6xl text-primary/30 mb-2"></i>' +
                    '<p class="text-gray-500 text-sm">社团活动</p>' +
                '</div>' +
                '<span class="absolute top-3 right-3 ' + statusClass + ' text-white text-xs px-2 py-1 rounded-full shadow-sm">' + statusText + '</span>' +
            '</div>' +
            '<div class="p-6">' +
                '<div class="flex justify-between items-start mb-3">' +
                    '<h3 class="text-xl font-bold">' + club.clubName + '</h3>' +
                    '<span class="text-sm text-gray-500 bg-gray-100 px-2 py-0.5 rounded-full">' +
                        '<i class="fas fa-calendar mr-1"></i> ' + formatDate(club.createdAt) +
                    '</span>' +
                '</div>' +
                '<p class="text-gray-600 text-sm mb-4 line-clamp-3">' + (club.description || '暂无简介') + '</p>' +
                '<div class="flex justify-between items-center pt-2 border-t border-gray-100">' +
                    '<span class="text-sm text-gray-500">' +
                        '<i class="fas fa-id-card mr-1"></i> ID: ' + club.clubId +
                    '</span>' +
                    buttonHtml +
                '</div>' +
            '</div>';
        
        return card;
    }

    // 格式化日期
    function formatDate(dateString) {
        if (!dateString) return '未知';
        const date = new Date(dateString);
        return date.toLocaleDateString('zh-CN');
    }

    // 绑定加入按钮事件
    function bindJoinButtons() {
        const joinButtons = document.querySelectorAll('.join-club');
        joinButtons.forEach(button => {
            button.addEventListener('click', function() {
                const clubId = this.getAttribute('data-id');
                openJoinModal(clubId);
            });
        });
    }

    // 显示错误信息
    function showErrorMessage(message) {
        const container = document.getElementById('clubsContainer');
        container.innerHTML = 
            '<div class="col-span-full text-center py-12">' +
                '<i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>' +
                '<p class="text-red-500">' + message + '</p>' +
                '<button onclick="loadClubs()" class="btn-primary mt-4">重新加载</button>' +
            '</div>';
    }

    // 页面加载完成后加载数据
    document.addEventListener('DOMContentLoaded', function() {
        loadClubs();
        loadCurrentUser();
    });
</script>
</body>
</html>
