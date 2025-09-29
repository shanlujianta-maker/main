
var activityApi = {
    getAllActivities: function(successCallback, errorCallback) {
        $.ajax({
            url: '/club_war_exploded/api/activities/getAllActivities',
            type: 'GET',
            dataType: 'json',
            success: successCallback,
            error: errorCallback
        });
    },
    getActivityById: function(activityId, successCallback, errorCallback) {
        $.ajax({
            url: '/club_war_exploded/api/activities/' + activityId,
            type: 'GET',
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    successCallback(result.data);
                } else {
                    errorCallback(result.msg);
                }
            },
            error: errorCallback
        });
    },
}
// 格式化状态显示（保留原有功能）
function formatStatus(status) {
    const statusMap = {
        "planning": "策划中",
        "open": "报名中",
        "ongoing": "进行中",
        "completed": "已结束",
        "cancelled": "已取消"
    };
    return statusMap[status] || status;
}

// 活动API核心方法
// 原代码可能为：$.get("/api/activities", function(activities) { ... })
// 修正为包含上下文路径的完整路径：
// 活动API核心方法


//页面加载时自动执行（通用的活动列表加载逻辑）加载活动列表
// 注意：这个函数现在由activity_manage.jsp中的同名函数覆盖，用于支持筛选功能

const API_BASE = '/club_war_exploded/api/activities';


// 渲染活动表格
function renderActivityTable(activities) {
    const tbody = $('#loadActivityList');
    tbody.empty();

    activities.forEach(activity => {
        const statusInfo = statusStyles[activity.actStatus] || { class: 'bg-gray-100 text-gray-800', text: '未知状态' };

        const row = `
            <tr class="table-row-hover hover:bg-neutral-50">
                <td class="px-6 py-4 text-sm">${activity.activityId}</td>
                <td class="px-6 py-4 text-sm font-medium text-neutral-700">${activity.activityName}</td>
                <td class="px-6 py-4 text-sm">${formatDateTime(activity.startTime)}</td>
                <td class="px-6 py-4 text-sm">${formatDateTime(activity.endTime)}</td>
                <td class="px-6 py-4 text-sm">${activity.location || '-'}</td>
                <td class="px-6 py-4 text-sm">
                    <span class="px-2 py-1 text-xs rounded-full ${statusInfo.class}">${statusInfo.text}</span>
                </td>
                <td class="px-6 py-4 text-sm">
                    <div class="flex items-center space-x-2">
                        <button class="auditBtn text-warning hover:text-warning/80 transition-colors" 
                                data-id="${activity.activityId}" data-name="${activity.activityName}">
                            <i class="fa fa-check-circle"></i>
                        </button>
                        <button class="editBtn text-primary hover:text-primary/80 transition-colors" 
                                data-id="${activity.activityId}">
                            <i class="fa fa-edit"></i>
                        </button>
                        <button class="deleteBtn text-danger hover:text-danger/80 transition-colors" 
                                data-id="${activity.activityId}">
                            <i class="fa fa-trash"></i>
                        </button>
                    </div>
                </td>
            </tr>
        `;
        tbody.append(row);
    });
}


$(document).on("click", ".editBtn", function() {
    const activityId = $(this).data("id");
    editActivity(activityId);
});

// // 格式化日期时间
// function formatDateTime(dateTimeStr) {
//     if (!dateTimeStr) return '-';
//     const date = new Date(dateTimeStr);
//     return date.toLocaleString('zh-CN');
// }

// 辅助函数：格式化日期（将后端Date转为可读性强的格式）
function formatDate(dateStr) {
    if (!dateStr) return "";
    const date = new Date(dateStr);
    return `${date.getFullYear()}-${(date.getMonth()+1).toString().padStart(2,'0')}-${date.getDate().toString().padStart(2,'0')} ${date.getHours().toString().padStart(2,'0')}:${date.getMinutes().toString().padStart(2,'0')}`;
}

// 格式化日期时间（用于表格显示）
function formatDateTime(dateTimeStr) {
    if (!dateTimeStr) return '-';
    const date = new Date(dateTimeStr);
    return date.toLocaleString('zh-CN');
}

// 全局AJAX配置（确保携带登录状态）
$(document).ready(function() {
    //alert("----> 页面加载执行")
    $.ajaxSetup({
        xhrFields: {
            withCredentials: true // 跨域时携带Cookie（Tomcat部署路径可能导致跨域）
        }
    });
    // 注意：loadActivityList() 现在由 activity_manage.jsp 中的同名函数处理
});

// 编辑活动功能
function editActivity(activityId) {
    activityApi.getActivityById(activityId, 
        function(data) {
            // 格式化日期时间用于datetime-local输入框
            const formatDateTimeForInput = (dateTimeStr) => {
                if (!dateTimeStr) return '';
                const date = new Date(dateTimeStr);
                const year = date.getFullYear();
                const month = (date.getMonth() + 1).toString().padStart(2, '0');
                const day = date.getDate().toString().padStart(2, '0');
                const hours = date.getHours().toString().padStart(2, '0');
                const minutes = date.getMinutes().toString().padStart(2, '0');
                return `${year}-${month}-${day}T${hours}:${minutes}`;
            };

            // 用获得的活动数据填充到编辑表单中
            $("#editActivityName").val(data.activityName);
            $("#editDescription").val(data.description);
            $("#editStartTime").val(formatDateTimeForInput(data.startTime));
            $("#editEndTime").val(formatDateTimeForInput(data.endTime));
            $("#editLocation").val(data.location);
            $("#editMaxParticipants").val(data.maxParticipants);
            $("#editActStatus").val(data.actStatus);
            $("#editOrganizingClubId").val(data.organizingClubId);

            // 设置活动ID到表单
            $("#editActivityForm").data('activityId', activityId);

            // 显示模态框
            $('#editActivityModal').removeClass('hidden');
            setTimeout(() => {
                $('#editActivityModal #editModalContent').removeClass('scale-95 opacity-0').addClass('scale-100 opacity-100 transition-all duration-300');
            }, 10);
        },
        function(errorMsg) {
            console.error('获取活动详情失败:', errorMsg);
            alert('获取活动详情失败，请稍后重试');
        }
    );
}

// 删除活动功能
function deleteActivity(activityId) {
    if (confirm("确定要删除该活动吗?")) {
        $.ajax({
            url: API_BASE + '/' + activityId,
            type: 'DELETE',
            success: function(result) {
                if (result.success) {
                    alert("删除成功");
                    // 注意：loadActivityList() 现在由 activity_manage.jsp 中的同名函数处理
                    if (typeof loadActivityList === 'function') {
                        loadActivityList();  // 刷新列表
                    }
                } else {
                    alert("删除失败: " + result.msg);
                }
            },
            error: function(error) {
                alert("删除失败，请稍后重试");
            }
        });
    }
}

function closeEditModal() {
    // 使用 Bootstrap 模态框的 API 关闭模态框
    $("#editActivityModal").modal('hide');
}