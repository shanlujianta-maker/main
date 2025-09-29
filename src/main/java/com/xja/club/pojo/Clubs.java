package com.xja.club.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 
 * @TableName clubs
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Clubs {
    /**
     * 社团唯一标识，自增
     */
    private Integer clubId;

    /**
     * 社团名称，唯一
     */
    private String clubName;

    /**
     * 社团简介
     */
    private String description;


    /**
     * 社团成立时间
     */
    private Date createdAt;

    /**
     * 社团状态 (活跃/已注销)
     */
    private String clubStatus;
}