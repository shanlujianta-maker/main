<%--
  Created by IntelliJ IDEA.
  User: yao
  Date: 2025/9/8
  Time: 上午11:06
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
    
    // 只有管理员可以访问社团管理页面
    if (!isAdmin) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<html>
<head>
    <title>社团管理</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
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
    <style type="text/tailwindcss">
        @layer utilities {
            .content-auto {
                content-visibility: auto;
            }
            .table-shadow {
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            }
            .btn-hover {
                @apply transition-all duration-200 hover:shadow-md transform hover:-translate-y-0.5;
            }
            .card {
                @apply bg-white rounded-lg shadow-md overflow-hidden;
            }
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen font-sans">
<!-- 引入导航栏组件 -->
<jsp:include page="../components/navbar.jsp" />

<main class="container mx-auto px-4 py-8">
    <div class="mb-8 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <h2 class="text-[clamp(1.2rem,2vw,1.8rem)] font-semibold text-gray-700">社团列表</h2>
        <button id="addClubBtn" class="bg-primary hover:bg-primary/90 text-white px-6 py-2.5 rounded-lg font-medium flex items-center btn-hover">
            <i class="fas fa-plus mr-2"></i>添加社团
        </button>
    </div>

    <!-- 搜索组件 -->
    <div class="card mb-6">
        <div class="p-6">
            <div class="flex flex-col lg:flex-row gap-4">
                <!-- 搜索输入框 -->
                <div class="flex-1">
                    <div class="relative">
                        <input type="text" id="searchInput" placeholder="搜索社团名称或简介..." 
                               class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all">
                        <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    </div>
                </div>
                
                <!-- 状态筛选 -->
                <div class="lg:w-48">
                    <select id="statusFilter" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all">
                        <option value="">全部状态</option>
                        <option value="active">活跃</option>
                        <option value="inactive">注销</option>
                    </select>
                </div>
                
                
                <!-- 搜索按钮 -->
                <div class="flex gap-2">
                    <button id="searchBtn" class="bg-primary hover:bg-primary/90 text-white px-6 py-3 rounded-lg font-medium flex items-center transition-all">
                        <i class="fas fa-search mr-2"></i>搜索
                    </button>
                    <button id="resetBtn" class="bg-gray-500 hover:bg-gray-600 text-white px-6 py-3 rounded-lg font-medium flex items-center transition-all">
                        <i class="fas fa-undo mr-2"></i>重置
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="overflow-x-auto">
            <table class="w-full text-left">
                <thead class="bg-gray-100 text-gray-700">
                <tr>
                    <th class="px-6 py-4 font-semibold">社团ID</th>
                    <th class="px-6 py-4 font-semibold">社团名称</th>
                    <th class="px-6 py-4 font-semibold">社团简介</th>
                    <th class="px-6 py-4 font-semibold">社团状态</th>
                    <th class="px-6 py-4 font-semibold">操作</th>
                </tr>
                </thead>
                <tbody id="clubTableBody" class="divide-y divide-gray-200">
                <!-- 社团数据通过 JS 动态加载 -->
                <tr class="animate-pulse">
                    <td class="px-6 py-4"><div class="h-6 bg-gray-200 rounded w-16"></div></td>
                    <td class="px-6 py-4"><div class="h-6 bg-gray-200 rounded w-32"></div></td>
                    <td class="px-6 py-4"><div class="h-6 bg-gray-200 rounded w-24"></div></td>
                    <td class="px-6 py-4"><div class="h-9 bg-gray-200 rounded w-32"></div></td>
                </tr>
                <tr class="animate-pulse">
                    <td class="px-6 py-4"><div class="h-6 bg-gray-200 rounded w-16"></div></td>
                    <td class="px-6 py-4"><div class="h-6 bg-gray-200 rounded w-32"></div></td>
                    <td class="px-6 py-4"><div class="h-6 bg-gray-200 rounded w-24"></div></td>
                    <td class="px-6 py-4"><div class="h-9 bg-gray-200 rounded w-32"></div></td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</main>

<!-- 添加/编辑社团模态框 -->
<div id="clubModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
    <div class="bg-white rounded-lg w-full max-w-md mx-4 transform transition-all duration-300 scale-95 opacity-0" id="modalContent">
        <div class="p-6">
            <div class="flex justify-between items-center mb-4">
                <h3 id="modalTitle" class="text-xl font-semibold text-gray-800">添加社团</h3>
                <button id="closeModal" class="text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>

            <form id="clubForm">
                <input type="hidden" id="clubId">
                <div class="mb-4">
                    <label for="clubName" class="block text-gray-700 font-medium mb-2">社团名称</label>
                    <input type="text" id="clubName" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all" required>
                </div>
                <div class="mb-6">
                    <label for="clubType" class="block text-gray-700 font-medium mb-2">社团简介</label>
                    <textarea id="clubType" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all" rows="3" placeholder="请输入社团简介" required></textarea>
                </div>
                <div class="mb-6">
                    <label for="clubStatus" class="block text-gray-700 font-medium mb-2">社团状态</label>
                    <select id="clubStatus" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all" required>
                        <option value="">请选择状态</option>
                        <option value="active">活跃</option>
                        <option value="inactive">注销</option>
                    </select>
                </div>
                <div class="flex justify-end gap-3">
                    <button type="button" id="cancelBtn" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-all">取消</button>
                    <button type="submit" class="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary/90 transition-all">保存</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 确认删除模态框 -->
<div id="deleteModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
    <div class="bg-white rounded-lg w-full max-w-md mx-4 p-6 transform transition-all duration-300 scale-95 opacity-0" id="deleteModalContent">
        <h3 class="text-xl font-semibold text-gray-800 mb-4">确认删除</h3>
        <p class="text-gray-600 mb-6">您确定要删除这个社团吗？此操作不可撤销。</p>
        <input type="hidden" id="deleteClubId">
        <div class="flex justify-end gap-3">
            <button id="cancelDeleteBtn" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-all">取消</button>
            <button id="confirmDeleteBtn" class="px-4 py-2 bg-danger text-white rounded-lg hover:bg-danger/90 transition-all">删除</button>
        </div>
    </div>
</div>

<!-- 提示消息 -->
<div id="toast" class="fixed top-4 right-4 px-6 py-3 rounded-lg shadow-lg transform translate-x-full transition-transform duration-300 z-50 flex items-center">
    <i id="toastIcon" class="mr-2"></i>
    <span id="toastMessage"></span>
</div>

<script src="../js/jquery.min.js"></script>
<script src="../js/club_api.js"></script>
<script>
    // 页面加载时获取社团列表
    $(function() {
        loadClubList();

        // 使用事件委托绑定动态生成的按钮事件
        $(document).on('click', '.editBtn', function() {
            const id = $(this).data('id');
            console.log('编辑按钮点击，ID:', id);
            editClub(id);
        });

        $(document).on('click', '.deleteBtn', function() {
            const id = $(this).data('id');
            console.log('删除按钮点击，ID:', id);
            showDeleteConfirm(id);
        });

        // 添加社团按钮点击事件
        $('#addClubBtn').click(function() {
            $('#modalTitle').text('添加社团');
            $('#clubForm')[0].reset();
            $('#clubId').val('');
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
        $('#statusFilter').change(function() {
            performSearch();
        });

        // 重置按钮
        $('#resetBtn').click(function() {
            resetSearch();
        });

        // 关闭删除确认框
        $('#cancelDeleteBtn').click(closeDeleteModal);

        // 提交表单
        $('#clubForm').submit(function(e) {
            e.preventDefault();
            saveClub();
        });

        // 确认删除
        $('#confirmDeleteBtn').click(confirmDelete);
    });

    // 搜索功能
    function performSearch() {
        const searchTerm = $('#searchInput').val().trim();
        const statusFilter = $('#statusFilter').val();
        console.log('搜索条件:', { searchTerm, statusFilter });
        
        // 获取所有社团数据
        clubApi.getClubList(
            function(data) {
                let filteredData = data;
                
                // 按搜索词筛选（社团名称或简介）
                if (searchTerm) {
                    filteredData = filteredData.filter(club => 
                        club.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                        club.type.toLowerCase().includes(searchTerm.toLowerCase())
                    );
                }
                
                // 按状态筛选
                if (statusFilter) {
                    filteredData = filteredData.filter(club => club.status === statusFilter);
                }
                
                
                console.log('筛选后的数据:', filteredData);
                displayClubList(filteredData);
            },
            function(error) {
                console.error('搜索失败:', error);
                showToast('搜索失败', 'error');
            }
        );
    }

    // 重置搜索
    function resetSearch() {
        $('#searchInput').val('');
        $('#statusFilter').val('');
        loadClubList(); // 重新加载所有数据
    }

    // 显示社团列表（通用函数）
    function displayClubList(data) {
        console.log('displayClubList接收到的数据:', data);
        let html = '';
        if (data.length === 0) {
            html = `
                <tr>
                    <td colspan="6" class="px-6 py-12 text-center text-gray-500">
                        <div class="flex flex-col items-center">
                            <i class="fas fa-search-minus text-4xl mb-3 text-gray-300"></i>
                            <p>暂无匹配的社团数据</p>
                        </div>
                    </td>
                </tr>
            `;
        } else {
            data.forEach((clubData, index) => {
                console.log('处理第' + index + '个社团:', clubData);
                console.log('clubData.id:', clubData.id);
                console.log('clubData.name:', clubData.name);
                console.log('clubData.type:', clubData.type);
                
                const clubId = clubData.id;
                const clubName = clubData.name;
                const clubType = clubData.type;
                const clubStatus = clubData.status;
                
                console.log('提取的变量 - clubId:', clubId, 'clubName:', clubName, 'clubType:', clubType, 'clubStatus:', clubStatus);
                
                // 使用字符串拼接而不是模板字符串
                const rowHtml = '<tr class="hover:bg-gray-50 transition-colors">' +
                    '<td class="px-6 py-4 font-medium">' + (clubId || 'N/A') + '</td>' +
                    '<td class="px-6 py-4">' + (clubName || 'N/A') + '</td>' +
                    '<td class="px-6 py-4 text-sm text-gray-600 max-w-xs truncate" title="' + (clubType || 'N/A') + '">' +
                        (clubType || 'N/A') +
                    '</td>' +
                    '<td class="px-6 py-4">' +
                        '<span class="px-2 py-1 rounded-full text-xs font-medium ' +
                        (clubStatus === 'active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800') + '">' +
                            (clubStatus === 'active' ? '活跃' : '注销') +
                        '</span>' +
                    '</td>' +
                    '<td class="px-6 py-4">' +
                        '<button class="editBtn text-primary hover:text-primary/80 mr-3" data-id="' + (clubId || '') + '">' +
                            '<i class="fas fa-edit mr-1"></i>编辑' +
                        '</button>' +
                        '<button class="deleteBtn text-danger hover:text-danger/80" data-id="' + (clubId || '') + '">' +
                            '<i class="fas fa-trash mr-1"></i>删除' +
                        '</button>' +
                    '</td>' +
                '</tr>';
                
                console.log('生成的HTML片段:', rowHtml);
                html += rowHtml;
            });
        }
        console.log('最终生成的HTML:', html);
        $('#clubTableBody').html(html);
    }

    // 加载社团列表
    function loadClubList() {
        clubApi.getClubList(
            function(data) {
                console.log('loadClubList接收到的数据:', data);
                displayClubList(data);
            },
            function(error) {
                console.error('加载社团列表失败:', error);
                $('#clubTableBody').html(`
                    <tr>
                        <td colspan="6" class="px-6 py-12 text-center text-red-500">
                            <div class="flex flex-col items-center">
                                <i class="fas fa-exclamation-triangle text-4xl mb-3"></i>
                                <p>加载失败，请稍后重试</p>
                            </div>
                        </td>
                    </tr>
                `);
            }
        );
    }

    // 打开模态框
    function openModal() {
        $('#clubModal').removeClass('hidden');
        setTimeout(() => {
            $('#modalContent').removeClass('scale-95 opacity-0').addClass('scale-100 opacity-100');
        }, 10);
    }

    // 关闭模态框
    function closeModal() {
        $('#modalContent').removeClass('scale-100 opacity-100').addClass('scale-95 opacity-0');
        setTimeout(() => {
            $('#clubModal').addClass('hidden');
        }, 300);
    }

    // 编辑社团
    function editClub(id) {
        console.log('editClub函数被调用，ID:', id);
        if (!id) {
            console.error('ID为空，无法编辑');
            showToast('社团ID无效', 'error');
            return;
        }
        clubApi.getClubById(id, 
            function(club) {
                console.log('获取到的社团数据:', club);
                $('#modalTitle').text('编辑社团');
                $('#clubId').val(club.id);
                $('#clubName').val(club.name);
                $('#clubType').val(club.type);
                $('#clubStatus').val(club.status);
                openModal();
            },
            function(error) {
                console.error('获取社团详情失败:', error);
                showToast('获取社团详情失败', 'error');
            }
        );
    }

    // 保存社团
    function saveClub() {
        const club = {
            id: $('#clubId').val(),
            name: $('#clubName').val(),
            type: $('#clubType').val(),
            status: $('#clubStatus').val()
        };

        if (club.id) {
            // 更新社团
            clubApi.updateClub(club, 
                function(result) {
                    closeModal();
                    showToast('社团更新成功', 'success');
                    loadClubList();
                },
                function(error) {
                    console.error('更新社团失败:', error);
                    showToast('更新社团失败: ' + error, 'error');
                }
            );
        } else {
            // 添加社团
            clubApi.addClub(club, 
                function(result) {
                    closeModal();
                    showToast('社团添加成功', 'success');
                    loadClubList();
                },
                function(error) {
                    console.error('添加社团失败:', error);
                    showToast('添加社团失败: ' + error, 'error');
                }
            );
        }
    }

    // 显示删除确认
    function showDeleteConfirm(id) {
        $('#deleteClubId').val(id);
        $('#deleteModal').removeClass('hidden');
        setTimeout(() => {
            $('#deleteModalContent').removeClass('scale-95 opacity-0').addClass('scale-100 opacity-100');
        }, 10);
    }

    // 关闭删除确认框
    function closeDeleteModal() {
        $('#deleteModalContent').removeClass('scale-100 opacity-100').addClass('scale-95 opacity-0');
        setTimeout(() => {
            $('#deleteModal').addClass('hidden');
        }, 300);
    }

    // 确认删除
    function confirmDelete() {
        const id = $('#deleteClubId').val();
        console.log('confirmDelete函数被调用，ID:', id);
        if (!id) {
            console.error('ID为空，无法删除');
            showToast('社团ID无效', 'error');
            return;
        }
        clubApi.deleteClub(id, 
            function(result) {
                closeDeleteModal();
                showToast('社团删除成功', 'success');
                loadClubList();
            },
            function(error) {
                console.error('删除社团失败:', error);
                showToast('删除社团失败: ' + error, 'error');
            }
        );
    }


    // 显示提示消息
    function showToast(message, type) {
        const toast = $('#toast');
        const icon = $('#toastIcon');

        // 设置图标和样式
        if (type === 'success') {
            toast.removeClass('bg-danger bg-warning').addClass('bg-success text-white');
            icon.removeClass('fas fa-times-circle fas fa-exclamation-triangle').addClass('fas fa-check-circle');
        } else if (type === 'error') {
            toast.removeClass('bg-success bg-warning').addClass('bg-danger text-white');
            icon.removeClass('fas fa-check-circle fas fa-exclamation-triangle').addClass('fas fa-times-circle');
        } else if (type === 'warning') {
            toast.removeClass('bg-success bg-danger').addClass('bg-warning text-white');
            icon.removeClass('fas fa-check-circle fas fa-times-circle').addClass('fas fa-exclamation-triangle');
        }

        // 设置消息并显示
        $('#toastMessage').text(message);
        toast.removeClass('translate-x-full').addClass('translate-x-0');

        // 3秒后自动隐藏
        setTimeout(() => {
            toast.removeClass('translate-x-0').addClass('translate-x-full');
        }, 3000);
    }
</script>
</body>
</html>
