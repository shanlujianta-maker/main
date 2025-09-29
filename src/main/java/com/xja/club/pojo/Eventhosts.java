package com.xja.club.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 
 * @TableName eventhosts
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Eventhosts {
    /**
     * 举办记录唯一标识，自增
     */
    private Integer hostId;

    /**
     * 活动ID
     */
    private Integer activityId;

    /**
     * 举办活动的社团ID
     */
    private Integer clubId;

    /**
     * 活动创建时间
     */
    private Date createdAt;
}