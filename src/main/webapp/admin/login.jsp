<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园社团活动管理系统 - 登录</title>
    <!-- 引入外部资源 -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>

    <!-- Tailwind 配置 -->
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#4F46E5',
                        secondary: '#10B981',
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
            .form-input-focus {
                @apply focus:border-primary focus:ring-2 focus:ring-primary/20 focus:outline-none;
            }
            .card-shadow {
                @apply shadow-lg hover:shadow-xl transition-shadow duration-300;
            }
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center p-4">
<div class="w-full max-w-6xl grid md:grid-cols-2 gap-8">
    <!-- 左侧图片区域 -->
    <div class="hidden md:block relative rounded-xl overflow-hidden h-[500px]">
        <img src="https://picsum.photos/seed/campus/800/1000" alt="校园风光" class="w-full h-full object-cover">
        <div class="absolute inset-0 bg-gradient-to-r from-primary/80 to-primary/40 flex flex-col justify-center p-8">
            <h2 class="text-white text-3xl md:text-4xl font-bold mb-4">校园社团活动管理系统</h2>
            <p class="text-white/90 text-lg mb-6">便捷管理社团活动，丰富校园文化生活</p>
            <div class="space-y-4">
                <div class="flex items-center text-white">
                    <i class="fas fa-check-circle mr-3 text-xl"></i>
                    <span>一站式社团活动管理解决方案</span>
                </div>
                <div class="flex items-center text-white">
                    <i class="fas fa-check-circle mr-3 text-xl"></i>
                    <span>高效的成员管理与活动组织</span>
                </div>
                <div class="flex items-center text-white">
                    <i class="fas fa-check-circle mr-3 text-xl"></i>
                    <span>数据化分析社团发展情况</span>
                </div>
            </div>
        </div>
    </div>

    <!-- 右侧登录表单 -->
    <div class="bg-white rounded-xl p-6 md:p-8 card-shadow">
        <div class="text-center mb-8">
            <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-primary/10 mb-4">
                <i class="fas fa-user-circle text-primary text-3xl"></i>
            </div>
            <h3 class="text-2xl font-bold text-gray-800">用户登录</h3>
            <p class="text-gray-500 mt-2">请输入账号密码登录系统</p>
        </div>

        <!-- 登录表单 -->
        <!-- 错误信息显示 -->
        <% if (request.getAttribute("msg") != null) { %>
        <div id="errorMessage" class="mb-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded-lg">
            <i class="fas fa-exclamation-triangle mr-2"></i>
            <%= request.getAttribute("msg") %>
        </div>
        <% } %>
        
        <form id="loginForm" action="${pageContext.request.contextPath}/user/login" method="post">
            <!-- 用户名输入 -->
            <div class="mb-5">
                <label for="username" class="block text-gray-700 mb-2 text-sm font-medium">用户名</label>
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <i class="fas fa-user text-gray-400"></i>
                    </div>
                    <input type="text" id="username" name="userPhone"
                           class="w-full pl-10 py-3 border border-gray-300 rounded-lg form-input-focus"
                           placeholder="请输入用户名" required>
                </div>
                <p class="error-message text-red-500 text-xs mt-1 hidden"></p>
            </div>

            <!-- 密码输入 -->
            <div class="mb-6">
                <div class="mb-2">
                    <label for="password" class="block text-gray-700 text-sm font-medium">密码</label>
                </div>
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <i class="fas fa-lock text-gray-400"></i>
                    </div>
                    <input type="password" id="password" name="password"
                           class="w-full pl-10 py-3 border border-gray-300 rounded-lg form-input-focus"
                           placeholder="请输入密码" required>
                    <button type="button" id="togglePassword" class="absolute inset-y-0 right-0 pr-3 flex items-center">
                        <i class="fas fa-eye-slash text-gray-400"></i>
                    </button>
                </div>
                <p class="error-message text-red-500 text-xs mt-1 hidden"></p>
            </div>


            <!-- 登录按钮 -->
            <button type="submit"
                    class="w-full bg-primary hover:bg-primary/90 text-white font-medium py-3 px-4 rounded-lg transition-colors duration-300 flex items-center justify-center">
                <i class="fas fa-sign-in-alt mr-2"></i> 登录
            </button>
        </form>

        <!-- 底部链接 -->
        <div class="mt-8 text-center text-gray-600 text-sm">
            <span>还没有账号? </span>
            <a href="javascript:void(0)" id="registerBtn" class="text-blue-600 font-medium hover:underline">去注册</a>
        </div>
    </div>
</div>

<!-- 注册模态框 -->
<div id="registerModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden opacity-0 transition-opacity duration-300">
    <div class="bg-white rounded-xl p-6 md:p-8 w-full max-w-md mx-4 transform transition-transform duration-300 scale-95 translate-y-4">
        <div class="flex justify-between items-center mb-6">
            <h3 class="text-2xl font-bold text-gray-800">用户注册</h3>
            <button id="closeRegisterModalBtn" class="text-gray-400 hover:text-gray-600">
                <i class="fas fa-times text-xl"></i>
            </button>
        </div>
<%--表单内容--%>
        <form id="registerForm">
            <!-- 真实姓名 -->
            <div class="mb-4">
                <label for="realName" class="block text-gray-700 mb-2 text-sm font-medium">真实姓名</label>
                <input type="text" id="realName" name="realName"
                       class="w-full py-3 px-4 border border-gray-300 rounded-lg"
                       placeholder="请输入真实姓名" required>
                <p class="error-message"></p>
            </div>

            <!-- 手机号 -->
            <div class="mb-4">
                <label for="userPhone" class="block text-gray-700 mb-2 text-sm font-medium">手机号</label>
                <input type="tel" id="userPhone" name="userPhone"
                       class="w-full py-3 px-4 border border-gray-300 rounded-lg"
                       placeholder="请输入手机号" required pattern="[0-9]{11}">
                <p class="error-message"></p>
            </div>

            <!-- 用户类型 -->
            <div class="mb-4">
                <label for="userType" class="block text-gray-700 mb-2 text-sm font-medium">用户类型</label>
                <select id="userType" name="userType"
                        class="w-full py-3 px-4 border border-gray-300 rounded-lg" required>
                    <option value="">请选择用户类型</option>
                    <option value="student">学生</option>
                    <option value="admin">管理员</option>
                </select>
                <p class="error-message"></p>
            </div>

            <!-- 密码 -->
            <div class="mb-4">
                <label for="registerPassword" class="block text-gray-700 mb-2 text-sm font-medium">密码</label>
                <input type="password" id="registerPassword" name="userPassword"
                       class="w-full py-3 px-4 border border-gray-300 rounded-lg"
                       placeholder="请输入密码" required minlength="6">
                <p class="error-message"></p>
            </div>

            <!-- 确认密码 -->
            <div class="mb-6">
                <label for="confirmPassword" class="block text-gray-700 mb-2 text-sm font-medium">确认密码</label>
                <input type="password" id="confirmPassword"
                       class="w-full py-3 px-4 border border-gray-300 rounded-lg"
                       placeholder="请再次输入密码" required>
                <p class="error-message"></p>
            </div>

            <!-- 注册按钮 -->
            <button type="submit"
                    class="w-full bg-green-600 hover:bg-green-700 text-white font-medium py-3 px-4 rounded-lg transition-colors duration-300">
                立即注册
            </button>
        </form>
    </div>
</div>
<!-- 成功提示框 -->
<div id="successToast" class="fixed top-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg transform transition-transform duration-300 translate-y-[-100px]">
    <div class="flex items-center">
        <i class="fas fa-check-circle mr-2"></i>
        <span id="toastMessage"></span>
    </div>
</div>


<!-- 登录表单脚本 -->
<script>

    // 注册模态框控制
    const registerModal = document.getElementById('registerModal');
    const registerBtn = document.getElementById('registerBtn');
    const closeRegisterModalBtn = document.getElementById('closeRegisterModalBtn');

    function openRegisterModal() {
        registerModal.classList.remove('hidden');
        // 触发重排后添加动画类
        setTimeout(() => {
            registerModal.classList.add('opacity-100');
            registerModal.querySelector('div').classList.remove('scale-95', 'translate-y-4');
            registerModal.querySelector('div').classList.add('scale-100', 'translate-y-0');
        }, 10);
    }

    function closeRegisterModal() {
        registerModal.classList.remove('opacity-100');
        registerModal.querySelector('div').classList.remove('scale-100', 'translate-y-0');
        registerModal.querySelector('div').classList.add('scale-95', 'translate-y-4');

        setTimeout(() => {
            registerModal.classList.add('hidden');
            // 重置表单
            document.getElementById('registerForm').reset();
            // 清除错误信息
            document.querySelectorAll('.error-message').forEach(el => {
                el.classList.add('hidden');
            });
        }, 300);
    }

    // 绑定事件
    registerBtn.addEventListener('click', openRegisterModal);
    closeRegisterModalBtn.addEventListener('click', closeRegisterModal);

    // 点击模态框外部关闭
    registerModal.addEventListener('click', function(e) {
        if (e.target === registerModal) {
            closeRegisterModal();
        }
    });

    // ESC键关闭模态框
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && !registerModal.classList.contains('hidden')) {
            closeRegisterModal();
        }
    });


    $(document).ready(function() {

        // 显示注册模态框
        $('#registerLink').click(function(e) {
            e.preventDefault();
            $('#registerModal').removeClass('hidden');
            $('body').addClass('overflow-hidden');
        });

        // 关闭模态框
        $('#closeModal, .login-link').click(function(e) {
            e.preventDefault();
            closeModal();
        });

        // 点击模态框外部关闭
        $('#registerModal').click(function(e) {
            if (e.target === this) {
                closeModal();
            }
        });

        function closeModal() {
            $('#registerModal').addClass('hidden');
            $('body').removeClass('overflow-hidden');
            $('#registerForm')[0].reset();
            $('.error-message').addClass('hidden');
            $('input, select').removeClass('border-red-500');
        }

        // 注册表单验证
        $('#registerForm').submit(function(e) {
            e.preventDefault();

            let isValid = true;

            // 验证真实姓名
            const realName = $('#realName').val().trim();
            if (realName === '') {
                showError($('#realName'), '请输入真实姓名');
                isValid = false;
            } else {
                hideError($('#realName'));
            }

            // 验证手机号
            const userPhone = $('#userPhone').val().trim();
            const phoneRegex = /^1[3-9]\d{9}$/;
            if (userPhone === '') {
                showError($('#userPhone'), '请输入手机号');
                isValid = false;
            } else if (!phoneRegex.test(userPhone)) {
                showError($('#userPhone'), '请输入正确的手机号格式');
                isValid = false;
            } else {
                hideError($('#userPhone'));
            }

            // 验证用户类型
            const userType = $('#userType').val();
            if (userType === '') {
                showError($('#userType'), '请选择用户类型');
                isValid = false;
            } else {
                hideError($('#userType'));
            }

            // 验证密码
            const password = $('#registerPassword').val();
            if (password === '') {
                showError($('#registerPassword'), '请输入密码');
                isValid = false;
            } else if (password.length < 6) {
                showError($('#registerPassword'), '密码长度不能少于6位');
                isValid = false;
            } else {
                hideError($('#registerPassword'));
            }

            // 验证确认密码
            const confirmPassword = $('#confirmPassword').val();
            if (confirmPassword === '') {
                showError($('#confirmPassword'), '请确认密码');
                isValid = false;
            } else if (confirmPassword !== password) {
                showError($('#confirmPassword'), '两次输入的密码不一致');
                isValid = false;
            } else {
                hideError($('#confirmPassword'));
            }

            if (isValid) {
                // 提交表单
                $.ajax({
                    url: '${pageContext.request.contextPath}/user/register',
                    type: 'POST',
                    data: $(this).serialize(),
                    success: function(response) {
                        if (response.success) {
                            showSuccess('注册成功！请登录');
                            closeModal();
                        } else {
                            showError($('#userPhone'), response.message || '注册失败');
                        }
                    },
                    error: function() {
                        showError($('#userPhone'), '注册失败，请稍后重试');
                    }
                });
            }

            return false;
        });

        // 显示成功提示
        function showSuccess(message) {
            $('#toastMessage').text(message);
            $('#successToast').removeClass('translate-y-[-100px]').addClass('translate-y-0');
            setTimeout(() => {
                $('#successToast').removeClass('translate-y-0').addClass('translate-y-[-100px]');
            }, 3000);
        }

        // 显示错误信息
        function showError(input, message) {
            const errorElement = input.closest('div').find('.error-message');
            errorElement.text(message).removeClass('hidden');
            input.addClass('border-red-500');
        }

        // 隐藏错误信息
        function hideError(input) {
            const errorElement = input.closest('div').find('.error-message');
            errorElement.addClass('hidden');
            input.removeClass('border-red-500');
        }

        // 输入框获取焦点时清除错误
        $('input, select').focus(function() {
            hideError($(this));
        });

        // 切换密码可见性
        $('#togglePassword').click(function() {
            const passwordInput = $('#password');
            const type = passwordInput.attr('type') === 'password' ? 'text' : 'password';
            passwordInput.attr('type', type);

            // 切换图标
            const icon = $(this).find('i');
            if (type === 'password') {
                icon.removeClass('fa-eye').addClass('fa-eye-slash');
            } else {
                icon.removeClass('fa-eye-slash').addClass('fa-eye');
            }
        });

        // 表单验证
        // 隐藏错误信息当用户开始输入时
        $('#username, #password').on('input', function() {
            $('#errorMessage').fadeOut();
        });

        $('#loginForm').submit(function(e) {
            let isValid = true;

            // 验证用户名
            const username = $('#username').val().trim();
            if (username === '') {
                showError($('#username'), '请输入用户名/手机号');
                isValid = false;
            } else {
                hideError($('#username'));
            }

            // 验证密码
            const password = $('#password').val().trim();
            if (password === '') {
                showError($('#password'), '请输入密码');
                isValid = false;
            } else if (password.length < 6) {
                showError($('#password'), '密码长度不能少于6位');
                isValid = false;
            } else {
                hideError($('#password'));
            }

            return isValid;
        });
    });
</script>

</body>
</html>
