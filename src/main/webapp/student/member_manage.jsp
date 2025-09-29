<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.xja.club.pojo.Users" %>
<%@ page import="com.xja.club.pojo.ClubMember" %>
<%@ page import="java.util.List" %>
<%
    // 检查用户是否登录
    Users loginUser = (Users) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("/club_war_exploded/admin/login.jsp");
        return;
    }
    
    // 检查用户类型
    if (!"student".equals(loginUser.getUserType())) {
        response.sendRedirect("/club_war_exploded/admin/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>成员管理 - 校园社团活动管理系统</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" 
          onerror="this.onerror=null;this.href='/club_war_exploded/css/font-awesome-fallback.css';">
    <style>
        .btn-primary {
            @apply bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition-colors duration-200;
        }
        .btn-secondary {
            @apply bg-gray-600 hover:bg-gray-700 text-white px-4 py-2 rounded-lg transition-colors duration-200;
        }
        .btn-danger {
            @apply bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg transition-colors duration-200;
        }
        .btn-success {
            @apply bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg transition-colors duration-200;
        }
        .btn-warning {
            @apply bg-yellow-600 hover:bg-yellow-700 text-white px-4 py-2 rounded-lg transition-colors duration-200;
        }
        .role-president {
            @apply bg-purple-100 text-purple-800 px-2 py-1 rounded-full text-xs font-medium;
        }
        .role-member {
            @apply bg-blue-100 text-blue-800 px-2 py-1 rounded-full text-xs font-medium;
        }
        .status-active {
            @apply bg-green-100 text-green-800 px-2 py-1 rounded-full text-xs font-medium;
        }
        .status-pending {
            @apply bg-yellow-100 text-yellow-800 px-2 py-1 rounded-full text-xs font-medium;
        }
        .status-rejected {
            @apply bg-red-100 text-red-800 px-2 py-1 rounded-full text-xs font-medium;
        }
    </style>
</head>
<body class="bg-gray-50">
    <!-- 导航栏 -->
    <jsp:include page="../components/navbar.jsp"/>
    
    <div class="container mx-auto px-4 py-8">
        <!-- 页面标题 -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">成员管理</h1>
            <p class="text-gray-600">管理本社团成员信息</p>
        </div>

        <!-- 用户权限信息 -->
        <div id="userInfo" class="bg-white rounded-lg shadow-md p-6 mb-6">
            <h3 class="text-lg font-semibold mb-4">当前用户信息</h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                    <span class="text-gray-600">姓名：</span>
                    <span id="userRealName" class="font-medium">加载中...</span>
                </div>
                <div>
                    <span class="text-gray-600">学号：</span>
                    <span id="userStudentId" class="font-medium">加载中...</span>
                </div>
                <div>
                    <span class="text-gray-600">社团角色：</span>
                    <span id="userRole" class="font-medium">加载中...</span>
                </div>
            </div>
        </div>

        <!-- 搜索和筛选 -->
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <div class="flex flex-col md:flex-row gap-4">
                <div class="flex-1">
                    <input type="text" id="searchInput" placeholder="搜索成员姓名、学号或联系方式..." 
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                </div>
                <div class="flex gap-2">
                    <button id="searchBtn" class="btn-primary">
                        <i class="fas fa-search mr-2"></i>搜索
                    </button>
                    <button id="refreshBtn" class="btn-secondary">
                        <i class="fas fa-refresh mr-2"></i>刷新
                    </button>
                </div>
            </div>
        </div>

        <!-- 成员列表 -->
        <div class="bg-white rounded-lg shadow-md">
            <div class="p-6 border-b border-gray-200">
                <div class="flex justify-between items-center">
                    <h3 class="text-lg font-semibold">社团成员列表</h3>
                    <div id="memberCount" class="text-gray-600">加载中...</div>
                </div>
            </div>
            
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">姓名</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">学号</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">联系方式</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">角色</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">加入时间</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">状态</th>
                            <th id="actionColumn" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">操作</th>
                        </tr>
                    </thead>
                    <tbody id="memberTableBody" class="bg-white divide-y divide-gray-200">
                        <tr>
                            <td colspan="7" class="px-6 py-4 text-center text-gray-500">加载中...</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- 编辑成员模态框 -->
    <div id="editMemberModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="bg-white rounded-lg shadow-xl max-w-md w-full">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold">编辑成员信息</h3>
                </div>
                <form id="editMemberForm" class="p-6">
                    <input type="hidden" id="editMemberId">
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">姓名</label>
                            <input type="text" id="editRealName" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" required>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">学号</label>
                            <input type="text" id="editStudentId" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" required>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">联系方式</label>
                            <input type="text" id="editPhone" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" required>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">社团角色</label>
                            <select id="editRole" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <option value="member">普通成员</option>
                                <option value="president">社团管理者</option>
                            </select>
                        </div>
                    </div>
                    <div class="flex justify-end gap-3 mt-6">
                        <button type="button" id="cancelEditBtn" class="btn-secondary">取消</button>
                        <button type="submit" class="btn-primary">保存</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 删除确认模态框 -->
    <div id="deleteConfirmModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="bg-white rounded-lg shadow-xl max-w-md w-full">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-red-600">确认删除</h3>
                </div>
                <div class="p-6">
                    <p class="text-gray-700 mb-4">确定要删除这个成员吗？此操作不可撤销。</p>
                    <div class="flex justify-end gap-3">
                        <button id="cancelDeleteBtn" class="btn-secondary">取消</button>
                        <button id="confirmDeleteBtn" class="btn-danger">删除</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 编辑状态模态框 -->
    <div id="editStatusModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="bg-white rounded-lg shadow-xl max-w-md w-full">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-blue-600">编辑成员状态</h3>
                </div>
                <div class="p-6">
                    <form id="editStatusForm">
                        <input type="hidden" id="editStatusMemberId">
                        <div class="space-y-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">姓名</label>
                                <input type="text" id="editStatusRealName" class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-50" readonly>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">学号</label>
                                <input type="text" id="editStatusStudentId" class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-50" readonly>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">联系方式</label>
                                <input type="text" id="editStatusPhone" class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-50" readonly>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">社团角色</label>
                                <input type="text" id="editStatusRole" class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-50" readonly>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">当前状态</label>
                                <input type="text" id="editStatusCurrentStatus" class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-50" readonly>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">新状态 <span class="text-red-500">*</span></label>
                                <select id="editStatusNewStatus" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" required>
                                    <option value="">请选择新状态</option>
                                    <option value="active">正常</option>
                                    <option value="applying">申请中</option>
                                    <option value="resigned">已离职</option>
                                </select>
                            </div>
                        </div>
                        <div class="flex justify-end gap-3 mt-6">
                            <button type="button" id="cancelStatusEditBtn" class="btn-secondary">取消</button>
                            <button type="submit" class="btn-primary">保存</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        let currentUser = null;
        let userClubId = null;
        let userRole = null;
        let allMembers = [];
        let filteredMembers = [];

        // 页面加载完成后初始化
        document.addEventListener('DOMContentLoaded', function() {
            loadUserInfo();
            bindEvents();
        });

        // 加载用户信息
        function loadUserInfo() {
            fetch('/club_war_exploded/api/activities/list/current-user')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        currentUser = data.data;
                        document.getElementById('userRealName').textContent = currentUser.realName;
                        document.getElementById('userStudentId').textContent = currentUser.userId;
                        
                        // 获取用户的社团信息
                        loadUserClubInfo();
                    }
                })
                .catch(error => {
                    console.error('Error loading user info:', error);
                });
        }

        // 加载用户社团信息
        function loadUserClubInfo() {
            fetch('/club_war_exploded/api/club-member/user-club-info')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        userClubId = data.data.clubId;
                        userRole = data.data.roleInClub;
                        
                        document.getElementById('userRole').textContent = 
                            userRole == 'president' ? '社团管理者' : '普通成员';
                        
                        // 根据角色显示/隐藏操作列
                        if (userRole != 'president') {
                            document.getElementById('actionColumn').style.display = 'none';
                        }
                        
                        // 用户信息加载完成后，加载成员列表
                        loadMembers();
                    }
                })
                .catch(error => {
                    console.error('Error loading user club info:', error);
                });
        }

        // 加载成员列表
        function loadMembers() {
            fetch('/club_war_exploded/api/club-member/student-members')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        allMembers = data.data;
                        filteredMembers = [...allMembers];
                        renderMembers();
                        updateMemberCount();
                    } else {
                        console.error('Error loading members:', data.message);
                        showError('加载成员列表失败：' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error loading members:', error);
                    showError('加载成员列表失败');
                });
        }

        // 渲染成员列表
        function renderMembers() {
            const tbody = document.getElementById('memberTableBody');
            if (filteredMembers.length == 0) {
                tbody.innerHTML = '<tr><td colspan="7" class="px-6 py-4 text-center text-gray-500">暂无成员数据</td></tr>';
                return;
            }

            tbody.innerHTML = filteredMembers.map(member => {
                const realName = member.realName || 'N/A';
                const userId = member.userId || 'N/A';
                const userPhone = member.userPhone || 'N/A';
                const roleInClub = member.roleInClub;
                const memberStatus = member.memberStatus;
                const joinDate = formatDate(member.joinDate);
                const membershipId = member.membershipId;
                
                const roleClass = roleInClub == 'president' ? 'role-president' : 'role-member';
                const roleText = roleInClub == 'president' ? '社团管理者' : '普通成员';
                let statusClass, statusText;
                switch(memberStatus) {
                    case 'active':
                        statusClass = 'status-active';
                        statusText = '正常';
                        break;
                    case 'applying':
                        statusClass = 'status-pending';
                        statusText = '申请中';
                        break;
                    case 'resigned':
                        statusClass = 'status-rejected';
                        statusText = '已离职';
                        break;
                    default:
                        statusClass = 'status-pending';
                        statusText = '申请中';
                }
                
                let actionButtons = '';
                if (userRole == 'president') {
                    // 只显示审核操作按钮
                    if (memberStatus == 'applying') {
                        actionButtons += '<button onclick="approveMember(' + membershipId + ')" class="text-green-600 hover:text-green-900 mr-3"><i class="fas fa-check"></i> 通过</button>';
                        actionButtons += '<button onclick="resignMember(' + membershipId + ')" class="text-red-600 hover:text-red-900 mr-3"><i class="fas fa-times"></i> 拒绝</button>';
                    } else if (memberStatus == 'resigned') {
                        actionButtons += '<button onclick="approveMember(' + membershipId + ')" class="text-green-600 hover:text-green-900 mr-3"><i class="fas fa-check"></i> 重新激活</button>';
                    }
                    // 编辑状态按钮
                    actionButtons += '<button onclick="editMemberStatus(' + membershipId + ')" class="text-blue-600 hover:text-blue-900 mr-3"><i class="fas fa-edit"></i> 编辑状态</button>';
                    // 删除按钮
                    actionButtons += '<button onclick="deleteMember(' + membershipId + ')" class="text-red-600 hover:text-red-900"><i class="fas fa-trash"></i> 删除</button>';
                }
                
                return '<tr class="hover:bg-gray-50">' +
                    '<td class="px-6 py-4 whitespace-nowrap">' +
                        '<div class="text-sm font-medium text-gray-900">' + realName + '</div>' +
                    '</td>' +
                    '<td class="px-6 py-4 whitespace-nowrap">' +
                        '<div class="text-sm text-gray-900">' + userId + '</div>' +
                    '</td>' +
                    '<td class="px-6 py-4 whitespace-nowrap">' +
                        '<div class="text-sm text-gray-900">' + userPhone + '</div>' +
                    '</td>' +
                    '<td class="px-6 py-4 whitespace-nowrap">' +
                        '<span class="' + roleClass + '">' + roleText + '</span>' +
                    '</td>' +
                    '<td class="px-6 py-4 whitespace-nowrap">' +
                        '<div class="text-sm text-gray-900">' + joinDate + '</div>' +
                    '</td>' +
                    '<td class="px-6 py-4 whitespace-nowrap">' +
                        '<span class="' + statusClass + '">' + statusText + '</span>' +
                    '</td>' +
                    '<td class="px-6 py-4 whitespace-nowrap text-sm font-medium">' +
                        actionButtons +
                    '</td>' +
                '</tr>';
            }).join('');
        }

        // 更新成员数量
        function updateMemberCount() {
            document.getElementById('memberCount').textContent = '共 ' + filteredMembers.length + ' 名成员';
        }

        // 搜索功能
        function searchMembers() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase().trim();
            if (searchTerm == '') {
                filteredMembers = [...allMembers];
            } else {
                filteredMembers = allMembers.filter(member => 
                    (member.realName && member.realName.toLowerCase().includes(searchTerm)) ||
                    (member.userId && member.userId.toString().includes(searchTerm)) ||
                    (member.userPhone && member.userPhone.includes(searchTerm))
                );
            }
            renderMembers();
            updateMemberCount();
        }

        // 编辑成员
        function editMember(membershipId) {
            const member = allMembers.find(m => m.membershipId == membershipId);
            if (!member) return;

            document.getElementById('editMemberId').value = membershipId;
            document.getElementById('editRealName').value = member.realName || '';
            document.getElementById('editStudentId').value = member.userId || '';
            document.getElementById('editPhone').value = member.userPhone || '';
            document.getElementById('editRole').value = member.roleInClub || 'member';

            document.getElementById('editMemberModal').classList.remove('hidden');
        }

        // 删除成员
        function deleteMember(membershipId) {
            document.getElementById('confirmDeleteBtn').onclick = function() {
                confirmDeleteMember(membershipId);
            };
            document.getElementById('deleteConfirmModal').classList.remove('hidden');
        }

        // 确认删除成员
        function confirmDeleteMember(membershipId) {
            fetch(`/club_war_exploded/api/club-member/delete/${membershipId}`, {
                method: 'DELETE'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showSuccess('删除成功');
                    loadMembers();
                } else {
                    showError('删除失败：' + data.message);
                }
            })
            .catch(error => {
                console.error('Error deleting member:', error);
                showError('删除失败');
            })
            .finally(() => {
                document.getElementById('deleteConfirmModal').classList.add('hidden');
            });
        }

        // 审核通过成员
        function approveMember(membershipId) {
            if (confirm('确定要通过该成员的申请吗？')) {
                updateMemberStatus(membershipId, 'active', '通过');
            }
        }

        // 拒绝成员申请（设置为已离职）
        function resignMember(membershipId) {
            if (confirm('确定要拒绝该成员的申请吗？')) {
                updateMemberStatus(membershipId, 'resigned', '拒绝');
            }
        }

        // 编辑成员状态
        function editMemberStatus(membershipId) {
            console.log('编辑状态 - membershipId:', membershipId);
            const member = allMembers.find(m => m.membershipId == membershipId);
            if (!member) {
                console.log('未找到成员:', membershipId);
                return;
            }

            console.log('找到成员:', member);
            // 填充模态框数据
            document.getElementById('editStatusMemberId').value = membershipId;
            document.getElementById('editStatusRealName').value = member.realName || 'N/A';
            document.getElementById('editStatusStudentId').value = member.userId || 'N/A';
            document.getElementById('editStatusPhone').value = member.userPhone || 'N/A';
            document.getElementById('editStatusRole').value = member.roleInClub == 'president' ? '社团管理者' : '普通成员';
            
            // 设置当前状态显示
            let currentStatusText = '';
            switch(member.memberStatus) {
                case 'active': currentStatusText = '正常'; break;
                case 'applying': currentStatusText = '申请中'; break;
                case 'resigned': currentStatusText = '已离职'; break;
                default: currentStatusText = '申请中';
            }
            document.getElementById('editStatusCurrentStatus').value = currentStatusText;
            
            // 设置下拉框选项，排除当前状态
            const statusSelect = document.getElementById('editStatusNewStatus');
            statusSelect.innerHTML = '<option value="">请选择新状态</option>';
            
            const statusOptions = [
                {value: 'active', text: '正常'},
                {value: 'applying', text: '申请中'},
                {value: 'resigned', text: '已离职'}
            ];
            
            statusOptions.forEach(option => {
                if (option.value !== member.memberStatus) {
                    const optionElement = document.createElement('option');
                    optionElement.value = option.value;
                    optionElement.textContent = option.text;
                    statusSelect.appendChild(optionElement);
                }
            });
            
            // 显示模态框
            document.getElementById('editStatusModal').classList.remove('hidden');
        }

        // 更新成员状态
        function updateMemberStatus(membershipId, status, action) {
            console.log('更新状态 - membershipId:', membershipId, 'status:', status, 'action:', action);
            const url = `/club_war_exploded/api/club-member/update-status`;
            console.log('请求URL:', url);
            
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    membershipId: parseInt(membershipId),
                    memberStatus: status
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showSuccess(action + '成功');
                    loadMembers();
                } else {
                    showError(action + '失败：' + data.message);
                }
            })
            .catch(error => {
                console.error('Error updating member status:', error);
                showError(action + '失败');
            });
        }

        // 绑定事件
        function bindEvents() {
            // 搜索按钮
            document.getElementById('searchBtn').addEventListener('click', searchMembers);
            
            // 刷新按钮
            document.getElementById('refreshBtn').addEventListener('click', loadMembers);
            
            // 搜索输入框回车
            document.getElementById('searchInput').addEventListener('keypress', function(e) {
                if (e.key == 'Enter') {
                    searchMembers();
                }
            });

            // 编辑表单提交
            document.getElementById('editMemberForm').addEventListener('submit', function(e) {
                e.preventDefault();
                saveMember();
            });

            // 取消编辑
            document.getElementById('cancelEditBtn').addEventListener('click', function() {
                document.getElementById('editMemberModal').classList.add('hidden');
            });

            // 取消删除
            document.getElementById('cancelDeleteBtn').addEventListener('click', function() {
                document.getElementById('deleteConfirmModal').classList.add('hidden');
            });

            // 编辑状态表单提交
            document.getElementById('editStatusForm').addEventListener('submit', function(e) {
                e.preventDefault();
                saveMemberStatus();
            });

            // 取消编辑状态
            document.getElementById('cancelStatusEditBtn').addEventListener('click', function() {
                document.getElementById('editStatusModal').classList.add('hidden');
            });
        }

        // 保存成员状态
        function saveMemberStatus() {
            const membershipId = document.getElementById('editStatusMemberId').value;
            const newStatus = document.getElementById('editStatusNewStatus').value;
            
            console.log('保存状态 - membershipId:', membershipId, 'newStatus:', newStatus);
            
            if (!membershipId) {
                showError('成员ID不能为空');
                return;
            }
            
            if (!newStatus) {
                showError('请选择新状态');
                return;
            }

            let actionText = '';
            switch(newStatus) {
                case 'active': actionText = '设置为正常'; break;
                case 'applying': actionText = '设置为申请中'; break;
                case 'resigned': actionText = '设置为已离职'; break;
            }

            updateMemberStatus(membershipId, newStatus, actionText);
            document.getElementById('editStatusModal').classList.add('hidden');
        }

        // 保存成员信息
        function saveMember() {
            const formData = {
                membershipId: document.getElementById('editMemberId').value,
                realName: document.getElementById('editRealName').value,
                userId: document.getElementById('editStudentId').value,
                userPhone: document.getElementById('editPhone').value,
                roleInClub: document.getElementById('editRole').value
            };

            fetch('/club_war_exploded/api/club-member/update', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showSuccess('保存成功');
                    document.getElementById('editMemberModal').classList.add('hidden');
                    loadMembers();
                } else {
                    showError('保存失败：' + data.message);
                }
            })
            .catch(error => {
                console.error('Error saving member:', error);
                showError('保存失败');
            });
        }

        // 格式化日期
        function formatDate(dateString) {
            if (!dateString) return 'N/A';
            const date = new Date(dateString);
            return date.toLocaleDateString('zh-CN');
        }

        // 显示成功消息
        function showSuccess(message) {
            alert('成功：' + message);
        }

        // 显示错误消息
        function showError(message) {
            alert('错误：' + message);
        }
    </script>
</body>
</html>
