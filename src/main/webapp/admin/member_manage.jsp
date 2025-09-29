
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
    
    // 如果不是管理员，重定向到首页
    if (!isAdmin) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>社团成员管理 - 校园社团活动管理系统</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="../js/member_api.js"></script>
    <!-- 引入导航栏样式 -->
    <link rel="stylesheet" href="../css/navbar.css">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#3b82f6',
                        secondary: '#64748b',
                        success: '#10b981',
                        danger: '#ef4444',
                        warning: '#f59e0b',
                        light: '#f8fafc',
                        dark: '#1e293b'
                    },
                    fontFamily: {
                        sans: ['Inter', 'system-ui', 'sans-serif'],
                    },
                }
            }
        }
    </script>
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
<body class="bg-gray-50 min-h-screen">
<!-- 引入导航栏组件 -->
<jsp:include page="../components/navbar.jsp" />

    <!-- 主要内容区域 -->
    <div class="container mx-auto px-4 py-8">
        <!-- 页面标题 -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-800 mb-2">社团成员管理</h1>
            <p class="text-gray-600">管理社团成员信息，包括添加、编辑和删除成员</p>
        </div>

        <!-- 操作按钮区域 -->
        <div class="mb-6 flex justify-end">
            <button id="addMemberBtn" class="bg-primary hover:bg-primary/90 text-white px-6 py-3 rounded-lg font-medium flex items-center transition-all">
                <i class="fas fa-plus mr-2"></i>添加成员
            </button>
        </div>

        <!-- 搜索和筛选区域 -->
        <div class="bg-white rounded-lg shadow-sm p-6 mb-6">
            <div class="flex flex-col md:flex-row gap-4">
                <div class="flex-1">
                    <div class="relative">
                        <input type="text" id="searchInput" placeholder="搜索成员姓名或社团名称..." 
                               class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                        <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                    </div>
                </div>
                <div class="md:w-48">
                    <select id="statusFilter" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                        <option value="">全部状态</option>
                        <option value="applying">申请中</option>
                        <option value="active">在职</option>
                        <option value="resigned">已离职</option>
                    </select>
                </div>
                <div class="md:w-48">
                    <select id="roleFilter" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                        <option value="">全部角色</option>
                        <option value="member">普通成员</option>
                        <option value="president">社团管理者</option>
                    </select>
                </div>
                <button id="searchBtn" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                    <i class="fas fa-search mr-2"></i>搜索
                </button>
                <button id="resetBtn" class="px-6 py-2 bg-gray-500 hover:bg-gray-600 text-white rounded-lg transition-colors">
                    <i class="fas fa-undo mr-2"></i>重置
                </button>
            </div>
        </div>

        <!-- 成员列表区域 -->
        <div class="bg-white rounded-lg shadow-sm">
            <div class="overflow-x-auto">
                <table class="w-full text-left">
                    <thead class="bg-gray-100 text-gray-700">
                    <tr>
                        <th class="px-6 py-4 font-semibold">成员ID</th>
                        <th class="px-6 py-4 font-semibold">姓名</th>
                        <th class="px-6 py-4 font-semibold">联系方式</th>
                        <th class="px-6 py-4 font-semibold">社团名称</th>
                        <th class="px-6 py-4 font-semibold">角色</th>
                        <th class="px-6 py-4 font-semibold">状态</th>
                        <th class="px-6 py-4 font-semibold">加入日期</th>
                        <th class="px-6 py-4 font-semibold">操作</th>
                    </tr>
                    </thead>
                    <tbody id="memberTableBody" class="divide-y divide-gray-200">
                    <!-- 成员数据通过 JS 动态加载 -->
                    <tr class="animate-pulse">
                        <td class="px-6 py-4"><div class="h-6 bg-gray-200 rounded w-16"></div></td>
                        <td class="px-6 py-4"><div class="h-6 bg-gray-200 rounded w-20"></div></td>
                        <td class="px-6 py-4"><div class="h-6 bg-gray-200 rounded w-24"></div></td>
                        <td class="px-6 py-4"><div class="h-6 bg-gray-200 rounded w-28"></div></td>
                        <td class="px-6 py-4"><div class="h-6 bg-gray-200 rounded w-16"></div></td>
                        <td class="px-6 py-4"><div class="h-6 bg-gray-200 rounded w-16"></div></td>
                        <td class="px-6 py-4"><div class="h-6 bg-gray-200 rounded w-20"></div></td>
                        <td class="px-6 py-4"><div class="h-6 bg-gray-200 rounded w-24"></div></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- 添加/编辑成员模态框 -->
    <div id="memberModal" class="fixed inset-0 bg-black bg-opacity-50 hidden z-50">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div id="modalContent" class="bg-white rounded-lg shadow-xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
                <div class="p-6">
                    <div class="flex justify-between items-center mb-6">
                        <h3 id="modalTitle" class="text-xl font-semibold text-gray-800">添加成员</h3>
                        <button id="closeModal" class="text-gray-400 hover:text-gray-600">
                            <i class="fas fa-times text-xl"></i>
                        </button>
                    </div>
                    <form id="memberForm">
                        <input type="hidden" id="membershipId">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                            <div>
                                <label for="userId" class="block text-gray-700 font-medium mb-2">用户ID</label>
                                <input type="number" id="userId" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" required>
                            </div>
                            <div>
                                <label for="clubId" class="block text-gray-700 font-medium mb-2">社团ID</label>
                                <input type="number" id="clubId" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" required>
                            </div>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                            <div>
                                <label for="roleInClub" class="block text-gray-700 font-medium mb-2">角色</label>
                                <select id="roleInClub" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" required>
                                    <option value="">请选择角色</option>
                                    <option value="member">普通成员</option>
                                    <option value="president">社团管理者</option>
                                </select>
                            </div>
                            <div>
                                <label for="memberStatus" class="block text-gray-700 font-medium mb-2">状态</label>
                                <select id="memberStatus" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" required>
                                    <option value="">请选择状态</option>
                                    <option value="applying">申请中</option>
                                    <option value="active">在职</option>
                                    <option value="resigned">已离职</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label for="joinDate" class="block text-gray-700 font-medium mb-2">加入日期</label>
                            <input type="date" id="joinDate" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" required>
                        </div>
                        <div class="mb-6">
                            <label for="applicationReason" class="block text-gray-700 font-medium mb-2">申请理由</label>
                            <textarea id="applicationReason" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" rows="3" placeholder="请输入申请理由"></textarea>
                        </div>
                        <div class="flex justify-end gap-3">
                            <button type="button" id="cancelBtn" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors">取消</button>
                            <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">保存</button>
                        </div>
                    </form>
        </div>
    </div>
</div>
    </div>
    <!-- 删除确认模态框 -->
    <div id="deleteModal" class="fixed inset-0 bg-black bg-opacity-50 hidden z-50">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="bg-white rounded-lg shadow-xl p-6 w-full max-w-md">
                <div class="text-center">
                    <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100 mb-4">
                        <i class="fas fa-exclamation-triangle text-red-600 text-xl"></i>
                    </div>
                    <h3 class="text-lg font-medium text-gray-900 mb-2">确认删除</h3>
                    <p class="text-sm text-gray-500 mb-6">确定要删除这个成员吗？此操作不可撤销。</p>
                    <div class="flex justify-center space-x-3">
                        <button id="cancelDeleteBtn" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors">取消</button>
                        <button id="confirmDeleteBtn" class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors">删除</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Toast 提示 -->
    <div id="toast" class="fixed top-4 right-4 z-50 hidden">
        <div class="bg-white border-l-4 p-4 rounded shadow-lg max-w-sm">
            <div class="flex items-center">
                <div id="toastIcon" class="flex-shrink-0">
                    <i class="fas fa-check-circle text-green-500"></i>
                </div>
                <div class="ml-3">
                    <p id="toastMessage" class="text-sm font-medium text-gray-900"></p>
                </div>
            </div>
        </div>
    </div>

<script>
    let currentDeleteId = null;

    // 加载成员列表
    function loadMemberList() {
        console.log('loadMemberList 被调用');
        
        // 显示加载状态
        $('#memberTableBody').html(`
            <tr>
                <td colspan="8" class="px-6 py-12 text-center">
                    <div class="flex flex-col items-center">
                        <div class="loading-spinner mb-4"></div>
                        <p class="text-gray-600">正在加载成员列表...</p>
                    </div>
                </td>
            </tr>
        `);
        
        // 使用jQuery AJAX获取成员列表
        $.ajax({
            url: '/club_war_exploded/api/members/getMembersByRole',
            type: 'GET',
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    console.log('loadMemberList接收到的数据:', result.data);
                    displayMemberList(result.data);
                } else {
                    console.error('获取成员列表失败:', result.msg);
                    $('#memberTableBody').html(`
                        <tr>
                            <td colspan="8" class="px-6 py-12 text-center text-red-500">
                                <div class="flex flex-col items-center">
                                    <i class="fas fa-exclamation-triangle text-4xl mb-3"></i>
                                    <p>${result.msg}</p>
                                </div>
                            </td>
                        </tr>
                    `);
                }
            },
            error: function(xhr, status, error) {
                console.error('加载成员列表失败:', error);
                $('#memberTableBody').html(`
                    <tr>
                        <td colspan="8" class="px-6 py-12 text-center text-red-500">
                            <div class="flex flex-col items-center">
                                <i class="fas fa-exclamation-triangle text-4xl mb-3"></i>
                                <p>加载失败，请稍后重试</p>
                            </div>
                        </td>
                    </tr>
                `);
            }
        });
    }

    $(document).ready(function() {
        console.log('页面加载完成');
        console.log('jQuery 版本:', $.fn.jquery);
        console.log('memberApi 在页面加载时:', typeof memberApi);
        
        // 配置AJAX请求
        $.ajaxSetup({
            xhrFields: {
                withCredentials: true // 跨域时携带Cookie（Tomcat部署路径可能导致跨域）
            }
        });
        
        // 加载成员列表
        loadMemberList();
        
        // 测试事件绑定
        setTimeout(function() {
            console.log('测试事件绑定...');
            console.log('编辑按钮数量:', $('.editBtn').length);
            console.log('删除按钮数量:', $('.deleteBtn').length);
            if ($('.editBtn').length > 0) {
                console.log('第一个编辑按钮的data-id:', $('.editBtn').first().data('id'));
            }
        }, 2000);

        // 事件绑定 - 使用更直接的方法
        $(document).on('click', '.editBtn', function(e) {
            e.preventDefault();
            e.stopPropagation();
            const id = $(this).data('id');
            console.log('编辑按钮点击，ID:', id);
            console.log('编辑按钮元素:', this);
            console.log('按钮HTML:', $(this).html());
            editMember(id);
        });

        $(document).on('click', '.deleteBtn', function(e) {
            e.preventDefault();
            e.stopPropagation();
            const id = $(this).data('id');
            console.log('删除按钮点击，ID:', id);
            console.log('删除按钮元素:', this);
            console.log('按钮HTML:', $(this).html());
            showDeleteConfirm(id);
        });

        // 添加成员按钮点击事件
        $('#addMemberBtn').click(function() {
            $('#modalTitle').text('添加成员');
            $('#memberForm')[0].reset();
            $('#membershipId').val('');
            // 设置默认日期为今天
            const today = new Date().toISOString().split('T')[0];
            $('#joinDate').val(today);
            openModal();
        });

        // 关闭模态框
        $('#closeModal, #cancelBtn').click(closeModal);

        // 搜索功能事件绑定
        $('#searchBtn').click(function() {
            performSearch();
        });

        // 回车键搜索
        $('#searchInput').keypress(function(e) {
            if (e.which === 13) { // Enter键
                performSearch();
            }
        });

        // 状态筛选变化时自动搜索
        $('#statusFilter, #roleFilter').change(function() {
            performSearch();
        });

        // 重置按钮
        $('#resetBtn').click(function() {
            resetSearch();
        });

        // 关闭删除确认框
        $('#cancelDeleteBtn').click(closeDeleteModal);

        // 提交表单
        $('#memberForm').submit(function(e) {
            e.preventDefault();
            saveMember();
        });

        // 确认删除
        $('#confirmDeleteBtn').click(confirmDelete);
    });

    // 搜索功能
    function performSearch() {
        const searchTerm = $('#searchInput').val().trim();
        const statusFilter = $('#statusFilter').val();
        const roleFilter = $('#roleFilter').val();
        
        console.log('搜索条件:', { searchTerm, statusFilter, roleFilter });
        
        // 获取所有成员数据
        $.ajax({
            url: '/club_war_exploded/api/members/getMembersByRole',
            type: 'GET',
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    let filteredData = result.data;
                    
                    // 按搜索词筛选（姓名或社团名称）
                    if (searchTerm) {
                        filteredData = filteredData.filter(member => 
                            (member.realName && member.realName.toLowerCase().includes(searchTerm.toLowerCase())) ||
                            (member.clubName && member.clubName.toLowerCase().includes(searchTerm.toLowerCase()))
                        );
                    }
                    
                    // 按状态筛选
                    if (statusFilter) {
                        filteredData = filteredData.filter(member => member.memberStatus === statusFilter);
                    }
                    
                    // 按角色筛选
                    if (roleFilter) {
                        filteredData = filteredData.filter(member => member.roleInClub === roleFilter);
                    }
                    
                    console.log('筛选后的数据:', filteredData);
                    displayMemberList(filteredData);
                } else {
                    console.error('获取成员列表失败:', result.msg);
                    showToast('搜索失败: ' + result.msg, 'error');
                }
            },
            error: function(xhr, status, error) {
                console.error('搜索失败:', error);
                showToast('搜索失败', 'error');
            }
        });
    }

    // 重置搜索
    function resetSearch() {
        $('#searchInput').val('');
        $('#statusFilter').val('');
        $('#roleFilter').val('');
        loadMemberList(); // 重新加载所有数据
    }

    // 显示成员列表（通用函数）
    function displayMemberList(data) {
        console.log('displayMemberList接收到的数据:', data);
        let html = '';
        if (data.length === 0) {
            html = `
                <tr>
                    <td colspan="8" class="px-6 py-12 text-center text-gray-500">
                        <div class="flex flex-col items-center">
                            <i class="fas fa-search-minus text-4xl mb-3 text-gray-300"></i>
                            <p>暂无匹配的成员数据</p>
                        </div>
                    </td>
                </tr>
            `;
        } else {
            data.forEach((memberData, index) => {
                console.log('处理第' + index + '个成员:', memberData);
                
                const membershipId = memberData.membershipId;
                const realName = memberData.realName || 'N/A';
                const userPhone = memberData.userPhone || 'N/A';
                const clubName = memberData.clubName || 'N/A';
                const roleInClub = memberData.roleInClub;
                const memberStatus = memberData.memberStatus;
                const joinDate = memberData.joinDate ? new Date(memberData.joinDate).toLocaleDateString() : 'N/A';
                
                // 角色显示
                const roleText = roleInClub === 'member' ? '普通成员' : 
                                roleInClub === 'president' ? '社团管理者' : 'N/A';
                
                // 状态显示
                const statusText = memberStatus === 'applying' ? '申请中' : 
                                  memberStatus === 'active' ? '在职' : 
                                  memberStatus === 'resigned' ? '已离职' : 'N/A';
                
                const statusClass = memberStatus === 'active' ? 'bg-green-100 text-green-800' : 
                                   memberStatus === 'applying' ? 'bg-yellow-100 text-yellow-800' : 
                                   'bg-red-100 text-red-800';
                
                const rowHtml = '<tr class="hover:bg-gray-50 transition-colors">' +
                    '<td class="px-6 py-4 font-medium">' + (membershipId || 'N/A') + '</td>' +
                    '<td class="px-6 py-4">' + realName + '</td>' +
                    '<td class="px-6 py-4">' + userPhone + '</td>' +
                    '<td class="px-6 py-4">' + clubName + '</td>' +
                    '<td class="px-6 py-4">' + roleText + '</td>' +
                    '<td class="px-6 py-4">' +
                        '<span class="px-2 py-1 rounded-full text-xs font-medium ' + statusClass + '">' +
                            statusText +
                        '</span>' +
                    '</td>' +
                    '<td class="px-6 py-4">' + joinDate + '</td>' +
                    '<td class="px-6 py-4">' +
                        '<button class="editBtn text-blue-600 hover:text-blue-800 mr-3 px-2 py-1 rounded" data-id="' + (membershipId || '') + '" onclick="console.log(\'编辑按钮点击\'); editMember(' + (membershipId || '') + ');">' +
                            '<i class="fas fa-edit mr-1"></i>编辑' +
                        '</button>' +
                        '<button class="deleteBtn text-red-600 hover:text-red-800 px-2 py-1 rounded" data-id="' + (membershipId || '') + '" onclick="console.log(\'删除按钮点击\'); showDeleteConfirm(' + (membershipId || '') + ');">' +
                            '<i class="fas fa-trash mr-1"></i>删除' +
                        '</button>' +
                    '</td>' +
                '</tr>';
                
                html += rowHtml;
            });
        }
        $('#memberTableBody').html(html);
    }


    // 打开模态框
    function openModal() {
        $('#memberModal').removeClass('hidden');
    }

    // 关闭模态框
    function closeModal() {
        $('#memberModal').addClass('hidden');
    }

    // 编辑成员 - 全局函数
    window.editMember = function(id) {
        console.log('editMember函数被调用，ID:', id);
        console.log('ID类型:', typeof id);
        if (!id || id === '') {
            console.error('ID为空，无法编辑');
            showToast('成员ID无效', 'error');
            return;
        }
        
        // 使用jQuery AJAX获取成员详情
        $.ajax({
            url: '/club_war_exploded/api/members/' + id,
            type: 'GET',
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    const member = result.data;
                    console.log('获取到的成员数据:', member);
                    $('#modalTitle').text('编辑成员');
                    $('#membershipId').val(member.membershipId);
                    $('#userId').val(member.userId);
                    $('#clubId').val(member.clubId);
                    $('#roleInClub').val(member.roleInClub);
                    $('#memberStatus').val(member.memberStatus);
                    $('#joinDate').val(member.joinDate ? new Date(member.joinDate).toISOString().split('T')[0] : '');
                    $('#applicationReason').val(member.applicationReason || '');
                    openModal();
                } else {
                    console.error('获取成员详情失败:', result.msg);
                    showToast('获取成员详情失败: ' + result.msg, 'error');
                }
            },
            error: function(xhr, status, error) {
                console.error('获取成员详情失败:', error);
                showToast('获取成员详情失败', 'error');
            }
        });
    }

    // 保存成员
    function saveMember() {
        const member = {
            membershipId: $('#membershipId').val() || null,
            userId: parseInt($('#userId').val()),
            clubId: parseInt($('#clubId').val()),
            roleInClub: $('#roleInClub').val(),
            memberStatus: $('#memberStatus').val(),
            joinDate: $('#joinDate').val(),
            applicationReason: $('#applicationReason').val()
        };

        console.log('保存成员数据:', member);

        if (member.membershipId) {
            // 更新成员
            $.ajax({
                url: '/club_war_exploded/api/members/update/' + member.membershipId,
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(member),
                dataType: 'json',
                success: function(result) {
                    if (result.success) {
                        closeModal();
                        showToast('成员更新成功', 'success');
                        loadMemberList();
                    } else {
                        console.error('更新成员失败:', result.msg);
                        showToast('更新成员失败: ' + result.msg, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('更新成员失败:', error);
                    showToast('更新成员失败', 'error');
                }
            });
        } else {
            // 添加成员
            $.ajax({
                url: '/club_war_exploded/api/members/save',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(member),
                dataType: 'json',
                success: function(result) {
                    if (result.success) {
                        closeModal();
                        showToast('成员添加成功', 'success');
                        loadMemberList();
                    } else {
                        console.error('添加成员失败:', result.msg);
                        showToast('添加成员失败: ' + result.msg, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('添加成员失败:', error);
                    showToast('添加成员失败', 'error');
                }
            });
        }
    }

    // 显示删除确认框 - 全局函数
    window.showDeleteConfirm = function(id) {
        console.log('showDeleteConfirm函数被调用，ID:', id);
        console.log('ID类型:', typeof id);
        if (!id || id === '') {
            console.error('ID为空，无法删除');
            showToast('成员ID无效', 'error');
            return;
        }
        currentDeleteId = id;
        $('#deleteModal').removeClass('hidden');
    }

    // 关闭删除确认框
    function closeDeleteModal() {
        $('#deleteModal').addClass('hidden');
        currentDeleteId = null;
    }

    // 确认删除
    function confirmDelete() {
        if (!currentDeleteId) {
            showToast('删除失败: 无效的成员ID', 'error');
            return;
        }
        
        console.log('删除成员ID:', currentDeleteId);
        
        $.ajax({
            url: '/club_war_exploded/api/members/' + currentDeleteId,
            type: 'DELETE',
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    closeDeleteModal();
                    showToast('成员删除成功', 'success');
                    loadMemberList();
                } else {
                    console.error('删除成员失败:', result.msg);
                    showToast('删除成员失败: ' + result.msg, 'error');
                }
            },
            error: function(xhr, status, error) {
                console.error('删除成员失败:', error);
                showToast('删除成员失败', 'error');
            }
        });
    }


    // 显示提示信息
    function showToast(message, type = 'success') {
        const toast = $('#toast');
        const icon = $('#toastIcon');
        const messageEl = $('#toastMessage');
        
        messageEl.text(message);
        
        // 根据类型设置图标和颜色
        if (type === 'success') {
            icon.html('<i class="fas fa-check-circle text-green-500"></i>');
            toast.find('.border-l-4').removeClass('border-red-500 border-yellow-500').addClass('border-green-500');
        } else if (type === 'error') {
            icon.html('<i class="fas fa-exclamation-circle text-red-500"></i>');
            toast.find('.border-l-4').removeClass('border-green-500 border-yellow-500').addClass('border-red-500');
        } else if (type === 'warning') {
            icon.html('<i class="fas fa-exclamation-triangle text-yellow-500"></i>');
            toast.find('.border-l-4').removeClass('border-green-500 border-red-500').addClass('border-yellow-500');
        }
        
        toast.removeClass('hidden');
        
        // 3秒后自动隐藏
        setTimeout(() => {
            toast.addClass('hidden');
        }, 3000);
    }
</script>
</body>
</html>
