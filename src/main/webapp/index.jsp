<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome（图标库） -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">


    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园社团活动管理系统</title>
    <!-- 引入外部资源 -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Tailwind 自定义配置（可选，如主题色） -->
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#4F46E5', // 主色调：靛蓝色，体现活力与科技感
                        secondary: '#10B981', // 辅助色：绿色，用于强调按钮
                    },
                    fontFamily: {
                        sans: ['Inter', 'system-ui', 'sans-serif'],
                    },
                }
            }
        }
    </script>

    <!-- 引入导航栏样式 -->
    <link rel="stylesheet" href="css/navbar.css">
    
    <!-- 自定义工具类（可选） -->
    <style type="text/tailwindcss">
        @layer utilities {
            .content-auto {
                content-visibility: auto;
            }
        }
    </style>
</head>
<body class="bg-gray-50 font-sans">
<!-- 引入导航栏组件 -->
<jsp:include page="components/navbar.jsp" />

<!-- 英雄区（核心宣传区域） -->
<section class="bg-gradient-to-r from-primary/90 to-primary">
    <div class="container mx-auto px-4 py-16 md:py-24 flex flex-col md:flex-row items-center">
        <div class="md:w-1/2 mb-8 md:mb-0 text-white">
            <h2 class="text-3xl md:text-4xl font-bold mb-4">发现你的兴趣社区</h2>
            <p class="text-lg md:text-xl mb-6 opacity-90">加入校园社团，参与精彩活动，拓展社交圈，丰富校园生活</p>
            <div class="flex flex-col sm:flex-row gap-4">
                <a href="admin/club_list.jsp" class="bg-white text-primary font-medium px-6 py-3 rounded-md hover:bg-gray-100 transition-all inline-block">
                    <i class="fas fa-search mr-2"></i>浏览社团
                </a>
                <a href="admin/activity_list.jsp" class="bg-transparent border-2 border-white text-white font-medium px-6 py-3 rounded-md hover:bg-white/10 transition-all inline-block">
                    <i class="fas fa-calendar-alt mr-2"></i>查看活动
                </a>
            </div>
        </div>
        <div class="md:w-1/2">
            <img src="img/a.jpg" alt="社团活动场景" class="rounded-lg shadow-xl w-full">
        </div>
    </div>
</section>

<script>
    // 页面加载时检查登录状态
    window.addEventListener('load', function() {
        const realName = '<%= session.getAttribute("realName") != null ? session.getAttribute("realName") : "" %>';
        if (!realName) {
            alert('请先登录系统');
            window.location.href = 'admin/login.jsp';
        }
    });
</script>

</body>
</html>
