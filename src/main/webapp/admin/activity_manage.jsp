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
    
    // 如果不是老师或社长，重定向到首页
    if (!isAdmin) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<html>
<head>
    <title>活动管理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <!-- 引入导航栏样式 -->
    <link rel="stylesheet" href="../css/navbar.css">

    <script>
        // 配置Tailwind自定义主题
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#165DFF',
                        secondary: '#36CFC9',
                        success: '#52C41A',
                        warning: '#FAAD14',
                        danger: '#FF4D4F',
                        neutral: {
                            100: '#F5F7FA',
                            200: '#E4E6EB',
                            300: '#C9CDD4',
                            400: '#86909C',
                            500: '#4E5969',
                            600: '#272E3B',
                            700: '#1D2129',
                        }
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
            .card-shadow {
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            }
            .btn-hover {
                transition: all 0.3s ease;
            }
            .btn-hover:hover {
                transform: translateY(-2px);
            }
            .table-row-hover {
                transition: background-color 0.2s ease;
            }
            .fade-in {
                animation: fadeIn 0.3s ease-in-out;
            }
            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }
            .slide-up {
                animation: slideUp 0.3s ease-out;
            }
            @keyframes slideUp {
                from { transform: translateY(20px); opacity: 0; }
                to { transform: translateY(0); opacity: 1; }
            }
            .scale-in {
                animation: scaleIn 0.2s ease-out;
            }
            @keyframes scaleIn {
                from { transform: scale(0.95); opacity: 0; }
                to { transform: scale(1); opacity: 1; }
            }
            .btn-primary {
                @apply bg-primary hover:bg-primary/90 text-white px-4 py-2 rounded-lg font-medium transition-colors;
            }
            .nav-link {
                @apply hover:text-primary transition-colors;
            }
        }
    </style>
</head>
<body class="bg-neutral-100 font-inter text-neutral-700 min-h-screen">
<!-- 引入导航栏组件 -->
<jsp:include page="../components/navbar.jsp" />

<main class="container mx-auto px-4 py-6">
    <!-- 页面标题和操作区 -->
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
        <div>
            <h2 class="text-[clamp(1.5rem,3vw,2rem)] font-bold text-neutral-700">活动管理</h2>
            <p class="text-neutral-400 mt-1">管理所有社团活动的发布与管理</p>
        </div>
        <button id="publishActivityBtn" class="btn-hover bg-primary hover:bg-primary/90 text-white px-5 py-2.5 rounded-lg font-medium flex items-center space-x-2 shadow-md hover:shadow-lg transition-all">
            <i class="fa fa-plus"></i>
            <span>发布活动</span>
        </button>
    </div>

    <!-- 通知提示框 -->
    <div id="notification" class="fixed top-20 right-4 px-6 py-3 rounded-lg shadow-lg transform translate-x-full transition-transform duration-300 z-50 flex items-center space-x-3"></div>

    <!-- 活动表格卡片 -->
    <div class="bg-white rounded-xl card-shadow overflow-hidden">
        <!-- 表格筛选区 -->
        <div class="p-4 border-b border-neutral-200">
            <div class="flex flex-col lg:flex-row gap-4">
                <!-- 搜索区域 -->
                <div class="flex flex-col md:flex-row gap-3 flex-grow">
                    <!-- 活动名称搜索 -->
                    <div class="relative flex-grow max-w-xs">
                        <i class="fa fa-search absolute left-3 top-1/2 -translate-y-1/2 text-neutral-400"></i>
                        <input type="text" id="searchActivityName" placeholder="搜索活动名称..." 
                               class="w-full pl-10 pr-4 py-2 border border-neutral-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                    </div>
                    <!-- 活动地点搜索 -->
                    <div class="relative flex-grow max-w-xs">
                        <i class="fa fa-map-marker absolute left-3 top-1/2 -translate-y-1/2 text-neutral-400"></i>
                        <input type="text" id="searchLocation" placeholder="搜索活动地点..." 
                               class="w-full pl-10 pr-4 py-2 border border-neutral-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                    </div>
                </div>
                
                <!-- 筛选区域 -->
                <div class="flex flex-wrap gap-2">
                    <select id="statusFilter" class="border border-neutral-200 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                        <option value="">所有状态</option>
                        <option value="planning">策划中</option>
                        <option value="open">报名中</option>
                        <option value="ongoing">进行中</option>
                        <option value="completed">已结束</option>
                        <option value="cancelled">已取消</option>
                    </select>
                    <button id="searchBtn" class="bg-primary hover:bg-primary/90 text-white px-4 py-2 rounded-lg transition-colors">
                        <i class="fa fa-search mr-1"></i> 搜索
                    </button>
                    <button id="resetBtn" class="bg-neutral-100 hover:bg-neutral-200 text-neutral-700 px-4 py-2 rounded-lg transition-colors">
                        <i class="fa fa-refresh mr-1"></i> 重置
                    </button>
                </div>
            </div>
        </div>

        <!-- 活动表格 -->
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead>
                <tr class="bg-neutral-50 text-left">
                    <th class="px-6 py-4 text-sm font-semibold text-neutral-500">活动ID</th>
                    <th class="px-6 py-4 text-sm font-semibold text-neutral-500">活动名称</th>
                    <th class="px-6 py-4 text-sm font-semibold text-neutral-500">开始时间</th>
                    <th class="px-6 py-4 text-sm font-semibold text-neutral-500">结束时间</th>
                    <th class="px-6 py-4 text-sm font-semibold text-neutral-500">活动地点</th>
                    <th class="px-6 py-4 text-sm font-semibold text-neutral-500">状态</th>
                    <th class="px-6 py-4 text-sm font-semibold text-neutral-500">操作</th>
                </tr>
                </thead>
                <tbody id="activityTableBody" class="divide-y divide-neutral-200">
                <!-- 活动数据通过JS动态加载 -->
                </tbody>
            </table>
        </div>

    </div>
</main>

<!-- 页脚 -->
<footer class="bg-white border-t border-neutral-200 mt-8 py-6">
    <div class="container mx-auto px-4 text-center text-neutral-500 text-sm">
        © 2025 社团活动管理系统 版权所有
    </div>
</footer>

<!-- 模态框 - 发布活动 -->
<div id="publishModal" class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center hidden fade-in">
    <div class="bg-white rounded-xl w-full max-w-2xl mx-4 transform transition-all scale-95 opacity-0" id="publishModalContent">
        <div class="p-6 border-b border-neutral-200">
            <h3 class="text-lg font-bold text-neutral-700">发布新活动</h3>
        </div>
        <form id="publishForm" class="p-6 max-h-[70vh] overflow-y-auto">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                <div>
                    <label class="block text-sm font-medium text-neutral-700 mb-1">活动名称 *</label>
                    <input type="text" name="activityName" required
                           class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                </div>
                <div>
                    <label class="block text-sm font-medium text-neutral-700 mb-1">活动地点 *</label>
                    <input type="text" name="location" required
                           class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                </div>
                <div>
                    <label class="block text-sm font-medium text-neutral-700 mb-1">开始时间 *</label>
                    <input type="datetime-local" name="startTime" required
                           class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                </div>
                <div>
                    <label class="block text-sm font-medium text-neutral-700 mb-1">结束时间 *</label>
                    <input type="datetime-local" name="endTime" required
                           class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                </div>
                <div>
                    <label class="block text-sm font-medium text-neutral-700 mb-1">主办社团ID *</label>
                    <input type="number" name="organizingClubId" required
                           class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                </div>
                <div>
                    <label class="block text-sm font-medium text-neutral-700 mb-1">最大参与人数</label>
                    <input type="number" name="maxParticipants" value="0"
                           class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                    <p class="text-xs text-neutral-400 mt-1">0表示不限制人数</p>
                </div>
            </div>
            <div class="mb-4">
                <label class="block text-sm font-medium text-neutral-700 mb-1">活动描述</label>
                <textarea name="description" rows="4"
                          class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all"
                          placeholder="请输入活动详细描述..."></textarea>
            </div>
            <div class="mb-4">
                <label class="block text-sm font-medium text-neutral-700 mb-1">初始状态</label>
                <select name="actStatus" class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                    <option value="planning">策划中</option>
                    <option value="open">报名中</option>
                    <option value="ongoing">进行中</option>
                </select>
            </div>
        </form>
        <div class="p-4 border-t border-neutral-200 flex justify-end space-x-3">
            <button id="closePublishModal" class="px-4 py-2 border border-neutral-200 rounded-lg text-neutral-700 hover:bg-neutral-50 transition-colors">取消</button>
            <button id="submitPublishBtn" class="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary/90 transition-colors">发布活动</button>
        </div>
    </div>
</div>



<!-- 模态框 - 删除确认 -->
<div id="deleteModal" class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center hidden fade-in">
    <div class="bg-white rounded-xl w-full max-w-md mx-4 transform transition-all scale-95 opacity-0" id="deleteModalContent">
        <div class="p-6 border-b border-neutral-200">
            <h3 class="text-lg font-bold text-neutral-700 flex items-center">
                <i class="fa fa-exclamation-triangle text-warning mr-2"></i>
                确认删除
            </h3>
        </div>
        <div class="p-6">
            <p class="text-neutral-600 mb-4">您确定要删除以下活动吗？此操作不可撤销。</p>
            <div class="bg-neutral-50 p-4 rounded-lg">
                <div class="text-sm text-neutral-500">活动名称</div>
                <div class="font-medium text-neutral-700" id="deleteActivityName">-</div>
            </div>
        </div>
        <div class="p-4 border-t border-neutral-200 flex justify-end space-x-3">
            <button id="cancelDeleteBtn" class="px-4 py-2 border border-neutral-200 rounded-lg text-neutral-700 hover:bg-neutral-50 transition-colors">取消</button>
            <button id="confirmDeleteBtn" class="px-4 py-2 bg-danger text-white rounded-lg hover:bg-danger/90 transition-colors">确认删除</button>
        </div>
    </div>
</div>

<!-- 编辑活动模态框 -->
<div id="editActivityModal" class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center hidden fade-in">
    <div class="bg-white rounded-xl w-full max-w-2xl mx-4 transform transition-all scale-95 opacity-0" id="editModalContent">
        <div class="p-6 border-b border-neutral-200">
            <h3 class="text-lg font-bold text-neutral-700">编辑活动</h3>
        </div>
        <form id="editActivityForm" class="p-6 max-h-[70vh] overflow-y-auto">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                <div>
                    <label class="block text-sm font-medium text-neutral-700 mb-1">活动名称 *</label>
                    <input type="text" id="editActivityName" name="activityName" required
                           class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                </div>
                <div>
                    <label class="block text-sm font-medium text-neutral-700 mb-1">活动地点 *</label>
                    <input type="text" id="editLocation" name="location" required
                           class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                </div>
                <div>
                    <label class="block text-sm font-medium text-neutral-700 mb-1">开始时间 *</label>
                    <input type="datetime-local" id="editStartTime" name="startTime" required
                           class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                </div>
                <div>
                    <label class="block text-sm font-medium text-neutral-700 mb-1">结束时间 *</label>
                    <input type="datetime-local" id="editEndTime" name="endTime" required
                           class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                </div>
                <div>
                    <label class="block text-sm font-medium text-neutral-700 mb-1">主办社团ID *</label>
                    <input type="number" id="editOrganizingClubId" name="organizingClubId" required
                           class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                </div>
                <div>
                    <label class="block text-sm font-medium text-neutral-700 mb-1">最大参与人数</label>
                    <input type="number" id="editMaxParticipants" name="maxParticipants" value="0"
                           class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                    <p class="text-xs text-neutral-400 mt-1">0表示不限制人数</p>
                </div>
            </div>
            <div class="mb-4">
                <label class="block text-sm font-medium text-neutral-700 mb-1">活动描述</label>
                <textarea id="editDescription" name="description" rows="4"
                          class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all"
                          placeholder="请输入活动详细描述..."></textarea>
            </div>
            <div class="mb-4">
                <label class="block text-sm font-medium text-neutral-700 mb-1">活动状态</label>
                <select id="editActStatus" name="actStatus" class="w-full border border-neutral-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all">
                    <option value="planning">策划中</option>
                    <option value="open">报名中</option>
                    <option value="ongoing">进行中</option>
                    <option value="completed">已结束</option>
                    <option value="cancelled">已取消</option>
                </select>
            </div>
        </form>
        <div class="p-4 border-t border-neutral-200 flex justify-end space-x-3">
            <button id="closeEditModal" class="px-4 py-2 border border-neutral-200 rounded-lg text-neutral-700 hover:bg-neutral-50 transition-colors">取消</button>
            <button id="submitEditBtn" class="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary/90 transition-colors">保存修改</button>
        </div>
    </div>
</div>

<script src="../js/jquery.min.js"></script>
<script src="../js/activity_api.js"></script>
<script>
    // 状态标签样式映射（与activity_api.js中的formatStatus对应）

    // 当前要删除的活动ID
    let currentDeleteId = null;

    $(function() {

        $('#publishActivityBtn').click(function() {
            // 显示发布模态框
            $('#publishModal').removeClass('hidden');
            setTimeout(() => {
                $('#publishModal #publishModalContent').removeClass('scale-95 opacity-0').addClass('scale-100 opacity-100 transition-all duration-300');
            }, 10);
        });
        // 关闭发布模态框
        $('#closePublishModal, #publishModal').on('click', function(e) {
            if (e.target === $('#publishModal')[0] || e.target === $('#closePublishModal')[0]) {
                closeModal('#publishModal');
                $('#publishForm')[0].reset(); // 重置表单
            }
        });

        // 提交发布表单
        $('#submitPublishBtn').click(function() {
            const form = $('#publishForm')[0];

            // 表单验证
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            const formData = {
                activityName: $('input[name="activityName"]').val(),
                description: $('textarea[name="description"]').val(),
                startTime: $('input[name="startTime"]').val(),
                endTime: $('input[name="endTime"]').val(),
                location: $('input[name="location"]').val(),
                organizingClubId: parseInt($('input[name="organizingClubId"]').val()),
                maxParticipants: parseInt($('input[name="maxParticipants"]').val()),
                actStatus: $('select[name="actStatus"]').val(),
                createdByUserId: 1 // 这里需要根据实际登录用户设置，暂时写死
            };

            // 发送AJAX请求
            $.ajax({
                url: '/club_war_exploded/api/activities/save',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(formData),
                success: function(result) {
                    if (result.success) {
                        showNotification('活动发布成功', 'success');
                        closeModal('#publishModal');
                        $('#publishForm')[0].reset();
                        loadActivityList(); // 重新加载活动列表
                    } else {
                        showNotification('发布失败: ' + result.msg, 'error');
                    }
                },
                error: function(xhr) {
                    showNotification('发布失败，请稍后重试', 'error');
                }
            });
        });


        // 移动端菜单切换
        $('#mobileMenuBtn').click(function() {
            $('#mobileMenu').toggleClass('hidden');
        });

        // 在页面加载时初始化活动列表
        $(document).ready(function() {
            loadActivityList(); // 页面加载时获取活动数据
        });

        // 搜索功能
        $('#searchBtn').click(function() {
            performSearch();
        });

        // 重置功能
        $('#resetBtn').click(function() {
            resetSearch();
        });

        // 回车键搜索
        $('#searchActivityName, #searchLocation').keypress(function(e) {
            if (e.which === 13) {
                performSearch();
            }
        });

        // 状态筛选变化时自动搜索
        $('#statusFilter').change(function() {
            performSearch();
        });



        // 删除按钮点击事件
        $(document).on('click', '.deleteBtn', function() {
            currentDeleteId = $(this).data('id');
            const activityName = $(this).closest('tr').find('td:eq(1)').text();
            $('#deleteActivityName').text(activityName);

            // 显示删除确认模态框
            $('#deleteModal').removeClass('hidden');
            setTimeout(() => {
                $('#deleteModal #deleteModalContent').removeClass('scale-95 opacity-0').addClass('scale-100 opacity-100 transition-all duration-300');
            }, 10);
        });

        // 取消删除
        $('#cancelDeleteBtn, #deleteModal').on('click', function(e) {
            if (e.target === $('#deleteModal')[0] || e.target === $('#cancelDeleteBtn')[0]) {
                closeModal('#deleteModal');
                currentDeleteId = null;
            }
        });

        // 确认删除
        $('#confirmDeleteBtn').click(function() {
            if (currentDeleteId) {
                $.ajax({
                    url: API_BASE + '/' + currentDeleteId,
                    type: 'DELETE',
                    success: function(result) {
                        closeModal('#deleteModal');
                        if (result.success) {
                            showNotification('活动已成功删除', 'success');
                            loadActivityList(); // 重新加载列表
                        } else {
                            showNotification(result.msg || '删除失败', 'error');
                        }
                        currentDeleteId = null;
                    },
                    error: function() {
                        showNotification('网络错误，请稍后重试', 'error');
                        currentDeleteId = null;
                    }
                });
            }
        });

        // 编辑按钮点击事件
        $(document).on('click', '.editBtn', function() {
            const activityId = $(this).data('id');
            editActivity(activityId);
        });

        // 关闭编辑模态框
        $('#closeEditModal, #editActivityModal').on('click', function(e) {
            if (e.target === $('#editActivityModal')[0] || e.target === $('#closeEditModal')[0]) {
                closeModal('#editActivityModal');
            }
        });

        // 提交编辑表单
        $('#submitEditBtn').click(function() {
            const form = $('#editActivityForm')[0];
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            const formData = {
                activityName: $('#editActivityName').val().trim(),
                description: $('#editDescription').val().trim(),
                startTime: $('#editStartTime').val(),
                endTime: $('#editEndTime').val(),
                location: $('#editLocation').val().trim(),
                organizingClubId: parseInt($('#editOrganizingClubId').val()),
                maxParticipants: parseInt($('#editMaxParticipants').val()) || 0,
                actStatus: $('#editActStatus').val()
            };

            // 验证时间逻辑
            if (new Date(formData.startTime) >= new Date(formData.endTime)) {
                showNotification('结束时间必须晚于开始时间', 'error');
                return;
            }

            const activityId = $('#editActivityForm').data('activityId');
            $.ajax({
                url: API_BASE + '/update/' + activityId,
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(formData),
                success: function(result) {
                    if (result.success) {
                        showNotification('活动更新成功', 'success');
                        closeModal('#editActivityModal');
                        loadActivityList(); // 重新加载列表
                    } else {
                        showNotification(result.msg || '更新失败', 'error');
                    }
                },
                error: function(xhr) {
                    showNotification('网络错误，请稍后重试', 'error');
                }
            });
        });
    });

    // 关闭模态框通用函数
    function closeModal(modalSelector) {
        $(modalSelector + ' .scale-100').removeClass('scale-100 opacity-100').addClass('scale-95 opacity-0 transition-all duration-300');
        setTimeout(() => {
            $(modalSelector).addClass('hidden');
        }, 300);
    }

    // 全局变量存储所有活动数据
    let allActivities = [];

    // 状态样式定义
    const statusStyles = {
        'planning': { class: 'bg-yellow-100 text-yellow-800', text: '策划中' },
        'open': { class: 'bg-blue-100 text-blue-800', text: '报名中' },
        'ongoing': { class: 'bg-green-100 text-green-800', text: '进行中' },
        'completed': { class: 'bg-gray-100 text-gray-800', text: '已结束' },
        'cancelled': { class: 'bg-red-100 text-red-800', text: '已取消' }
    };

    // 格式化日期时间
    function formatDateTime(dateTimeStr) {
        if (!dateTimeStr) return '-';
        const date = new Date(dateTimeStr);
        return date.toLocaleString('zh-CN');
    }

    // 修改loadActivityList函数，保存数据到全局变量
    function loadActivityList() {
        // 调用API获取数据
        activityApi.getAllActivities(
            function(activities) { // 成功回调
                allActivities = activities || []; // 保存到全局变量
                displayActivityList(allActivities); // 显示数据
            },
            function(errorMsg) { // 失败回调
                console.error('加载活动列表失败:', errorMsg);
                const tableBody = $("#activityTableBody");
                tableBody.empty();
                tableBody.append('<tr><td colspan="7" class="px-6 py-4 text-center text-red-500">加载失败，请稍后重试</td></tr>');
            }
        );
    }

    // 执行搜索功能
    function performSearch() {
        const activityName = $('#searchActivityName').val().trim();
        const location = $('#searchLocation').val().trim();
        const status = $('#statusFilter').val();

        // 如果没有搜索条件，显示所有数据
        if (!activityName && !location && !status) {
            displayActivityList(allActivities);
            return;
        }

        // 过滤数据
        const filteredActivities = allActivities.filter(activity => {
            const nameMatch = !activityName || activity.activityName.toLowerCase().includes(activityName.toLowerCase());
            const locationMatch = !location || (activity.location && activity.location.toLowerCase().includes(location.toLowerCase()));
            const statusMatch = !status || activity.actStatus === status;

            return nameMatch && locationMatch && statusMatch;
        });

        displayActivityList(filteredActivities);
    }

    // 重置搜索
    function resetSearch() {
        $('#searchActivityName').val('');
        $('#searchLocation').val('');
        $('#statusFilter').val('');
        displayActivityList(allActivities);
    }

    // 显示活动列表
    function displayActivityList(activities) {
        const tableBody = $("#activityTableBody");
        tableBody.empty();

        if (!activities || activities.length === 0) {
            tableBody.append('<tr><td colspan="7" class="px-6 py-4 text-center text-neutral-500">暂无活动数据</td></tr>');
            return;
        }

        // 遍历数据生成表格行
        activities.forEach(activity => {
            const statusInfo = statusStyles[activity.actStatus] || { class: 'bg-gray-100 text-gray-800', text: '未知状态' };
            
            const row = '<tr class="table-row-hover hover:bg-neutral-50">' +
                '<td class="px-6 py-4 text-sm">' + activity.activityId + '</td>' +
                '<td class="px-6 py-4 text-sm font-medium text-neutral-700">' + activity.activityName + '</td>' +
                '<td class="px-6 py-4 text-sm">' + formatDateTime(activity.startTime) + '</td>' +
                '<td class="px-6 py-4 text-sm">' + formatDateTime(activity.endTime) + '</td>' +
                '<td class="px-6 py-4 text-sm">' + (activity.location || '-') + '</td>' +
                '<td class="px-6 py-4 text-sm">' +
                    '<span class="px-2 py-1 text-xs rounded-full ' + statusInfo.class + '">' + statusInfo.text + '</span>' +
                '</td>' +
                '<td class="px-6 py-4 text-sm">' +
                    '<div class="flex items-center space-x-2">' +
                        '<button class="editBtn text-primary hover:text-primary/80 transition-colors" ' +
                                'data-id="' + activity.activityId + '">' +
                            '<i class="fa fa-edit"></i>' +
                        '</button>' +
                        '<button class="deleteBtn text-danger hover:text-danger/80 transition-colors" ' +
                                'data-id="' + activity.activityId + '">' +
                            '<i class="fa fa-trash"></i>' +
                        '</button>' +
                    '</div>' +
                '</td>' +
            '</tr>';
            tableBody.append(row);
        });
    }


    // 显示通知提示
    function showNotification(message, type = 'info') {
        const notification = $('#notification');
        const bgColors = {
            success: 'bg-success text-white',
            error: 'bg-danger text-white',
            info: 'bg-primary text-white',
            warning: 'bg-warning text-white'
        };

        const icons = {
            success: 'fa-check-circle',
            error: 'fa-times-circle',
            info: 'fa-info-circle',
            warning: 'fa-exclamation-circle'
        };

        notification.attr('class', `fixed top-20 right-4 px-6 py-3 rounded-lg shadow-lg transform transition-transform duration-300 z-50 flex items-center space-x-3 ${bgColors[type]}`);
        notification.html(`<i class="fa ${icons[type]}"></i><span>${message}</span>`);

        // 显示通知
        notification.removeClass('translate-x-full');

        // 3秒后自动隐藏
        setTimeout(() => {
            notification.addClass('translate-x-full');
        }, 3000);
    }
</script>
</body>
</html>