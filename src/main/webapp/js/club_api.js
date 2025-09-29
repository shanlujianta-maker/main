const clubApi = {
    getClubList: function(successCallback, errorCallback) {
        $.ajax({
            url: '/club_war_exploded/api/clubs/getAllClubs',
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                console.log('原始数据:', data);
                // 转换数据格式以匹配前端期望的格式
                const formattedData = data.map(club => {
                    console.log('单个社团数据:', club);
                    const formatted = {
                        id: club.clubId,
                        name: club.clubName,
                        type: club.description || '未分类',
                        status: club.clubStatus || 'active',
                        createdAt: club.createdAt
                    };
                    console.log('转换后的单个数据:', formatted);
                    return formatted;
                });
                console.log('转换后的数据:', formattedData);
                successCallback(formattedData);
            },
            error: function(xhr, status, error) {
                console.error('获取社团列表失败:', error);
                if (errorCallback) {
                    errorCallback(error);
                } else {
                    alert('获取社团列表失败');
                }
            }
        });
    },

    getClubById: function(clubId, successCallback, errorCallback) {
        $.ajax({
            url: '/club_war_exploded/api/clubs/' + clubId,
            type: 'GET',
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    const club = result.data;
                    const formattedClub = {
                        id: club.clubId,
                        name: club.clubName,
                        type: club.description || '未分类',
                        status: club.clubStatus,
                        createdAt: club.createdAt
                    };
                    successCallback(formattedClub);
                } else {
                    if (errorCallback) {
                        errorCallback(result.msg);
                    } else {
                        alert('获取社团详情失败: ' + result.msg);
                    }
                }
            },
            error: function(xhr, status, error) {
                console.error('获取社团详情失败:', error);
                if (errorCallback) {
                    errorCallback(error);
                } else {
                    alert('获取社团详情失败');
                }
            }
        });
    },

    addClub: function(clubData, successCallback, errorCallback) {
        const requestData = {
            clubName: clubData.name,
            description: clubData.type,
            clubStatus: 'active',
        };

        $.ajax({
            url: '/club_war_exploded/api/clubs/save',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(requestData),
            success: function(result) {
                if (result.success) {
                    if (successCallback) {
                        successCallback(result);
                    }
                } else {
                    if (errorCallback) {
                        errorCallback(result.msg);
                    } else {
                        alert('添加社团失败: ' + result.msg);
                    }
                }
            },
            error: function(xhr, status, error) {
                console.error('添加社团失败:', error);
                if (errorCallback) {
                    errorCallback(error);
                } else {
                    alert('添加社团失败');
                }
            }
        });
    },

    updateClub: function(clubData, successCallback, errorCallback) {
        const requestData = {
            clubName: clubData.name,
            description: clubData.type,
            clubStatus: clubData.status || 'active',
        };

        $.ajax({
            url: '/club_war_exploded/api/clubs/update/' + clubData.id,
            type: 'PUT',
            contentType: 'application/json',
            data: JSON.stringify(requestData),
            success: function(result) {
                if (result.success) {
                    if (successCallback) {
                        successCallback(result);
                    }
                } else {
                    if (errorCallback) {
                        errorCallback(result.msg);
                    } else {
                        alert('更新社团失败: ' + result.msg);
                    }
                }
            },
            error: function(xhr, status, error) {
                console.error('更新社团失败:', error);
                if (errorCallback) {
                    errorCallback(error);
                } else {
                    alert('更新社团失败');
                }
            }
        });
    },

    deleteClub: function(clubId, successCallback, errorCallback) {
        $.ajax({
            url: '/club_war_exploded/api/clubs/' + clubId,
            type: 'DELETE',
            dataType: 'json',
            success: function(result) {
                if (result.success) {
                    if (successCallback) {
                        successCallback(result);
                    }
                } else {
                    if (errorCallback) {
                        errorCallback(result.msg);
                    } else {
                        alert('删除社团失败: ' + result.msg);
                    }
                }
            },
            error: function(xhr, status, error) {
                console.error('删除社团失败:', error);
                if (errorCallback) {
                    errorCallback(error);
                } else {
                    alert('删除社团失败');
                }
            }
        });
    }
};