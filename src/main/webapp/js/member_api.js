// 社团成员管理API
const memberApi = {
    API_BASE: '/club_war_exploded/api/members',

    // 获取所有成员列表
    getAllMembers: function(successCallback, errorCallback) {
        $.ajax({
            url: this.API_BASE + '/getAllMembers',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    console.log('获取成员列表成功:', response.data);
                    successCallback(response.data);
                } else {
                    console.error('获取成员列表失败:', response.msg);
                    errorCallback(response.msg);
                }
            },
            error: function(xhr, status, error) {
                console.error('API调用失败:', error);
                errorCallback(error);
            }
        });
    },

    // 根据ID获取成员详情
    getMemberById: function(membershipId, successCallback, errorCallback) {
        $.ajax({
            url: this.API_BASE + '/' + membershipId,
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    console.log('获取成员详情成功:', response.data);
                    successCallback(response.data);
                } else {
                    console.error('获取成员详情失败:', response.msg);
                    errorCallback(response.msg);
                }
            },
            error: function(xhr, status, error) {
                console.error('API调用失败:', error);
                errorCallback(error);
            }
        });
    },

    // 根据社团ID获取成员列表
    getMembersByClubId: function(clubId, successCallback, errorCallback) {
        $.ajax({
            url: this.API_BASE + '/club/' + clubId,
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    console.log('获取社团成员列表成功:', response.data);
                    successCallback(response.data);
                } else {
                    console.error('获取社团成员列表失败:', response.msg);
                    errorCallback(response.msg);
                }
            },
            error: function(xhr, status, error) {
                console.error('API调用失败:', error);
                errorCallback(error);
            }
        });
    },

    // 保存成员信息
    saveMember: function(member, successCallback, errorCallback) {
        $.ajax({
            url: this.API_BASE + '/save',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(member),
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    console.log('保存成员成功:', response);
                    successCallback(response);
                } else {
                    console.error('保存成员失败:', response.msg);
                    errorCallback(response.msg);
                }
            },
            error: function(xhr, status, error) {
                console.error('API调用失败:', error);
                errorCallback(error);
            }
        });
    },

    // 更新成员信息
    updateMember: function(member, successCallback, errorCallback) {
        $.ajax({
            url: this.API_BASE + '/update/' + member.membershipId,
            type: 'PUT',
            contentType: 'application/json',
            data: JSON.stringify(member),
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    console.log('更新成员成功:', response);
                    successCallback(response);
                } else {
                    console.error('更新成员失败:', response.msg);
                    errorCallback(response.msg);
                }
            },
            error: function(xhr, status, error) {
                console.error('API调用失败:', error);
                errorCallback(error);
            }
        });
    },

    // 删除成员
    deleteMember: function(membershipId, successCallback, errorCallback) {
        $.ajax({
            url: this.API_BASE + '/' + membershipId,
            type: 'DELETE',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    console.log('删除成员成功:', response);
                    successCallback(response);
                } else {
                    console.error('删除成员失败:', response.msg);
                    errorCallback(response.msg);
                }
            },
            error: function(xhr, status, error) {
                console.error('API调用失败:', error);
                errorCallback(error);
            }
        });
    },

    // 更新成员状态
    updateMemberStatus: function(membershipId, status, successCallback, errorCallback) {
        $.ajax({
            url: this.API_BASE + '/status/' + membershipId,
            type: 'PUT',
            data: { status: status },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    console.log('更新成员状态成功:', response);
                    successCallback(response);
                } else {
                    console.error('更新成员状态失败:', response.msg);
                    errorCallback(response.msg);
                }
            },
            error: function(xhr, status, error) {
                console.error('API调用失败:', error);
                errorCallback(error);
            }
        });
    },

    // 更新成员角色
    updateMemberRole: function(membershipId, role, successCallback, errorCallback) {
        $.ajax({
            url: this.API_BASE + '/role/' + membershipId,
            type: 'PUT',
            data: { role: role },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    console.log('更新成员角色成功:', response);
                    successCallback(response);
                } else {
                    console.error('更新成员角色失败:', response.msg);
                    errorCallback(response.msg);
                }
            },
            error: function(xhr, status, error) {
                console.error('API调用失败:', error);
                errorCallback(error);
            }
        });
    }
};
