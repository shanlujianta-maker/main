package com.xja.club.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 
 * @TableName activityregistrations
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Activityregistrations {
    /**
     * 报名记录唯一标识，自增
     */
    private Integer registrationId;

    /**
     * 报名的用户ID
     */
    private Integer userId;

    /**
     * 报名的活动ID
     */
    private Integer activityId;

    /**
     * 报名时间
     */
    private Date registrationTime;

    /**
     * 签到状态
     */
    private Object checkInStatus;

    /**
     * 签到时间
     */
    private Date checkInTime;
}