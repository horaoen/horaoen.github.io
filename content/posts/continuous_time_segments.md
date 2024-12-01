+++
title = "连续时间片段判断解决方案"
date = "2024-11-07"
+++

## 场景
一个账号同一个会议室不能连续多天预定(4天)超过4个小时(会议预定开始时间和结束时间不垮天)

## schema
```mysql
create table meeting_room_reserve
(
    id              bigint auto_increment comment '主键'
        primary key,
    meeting_room_id bigint                   null comment '会议室id',
    start_time      varchar(24) charset utf8 null comment '会议开始时间',
    end_time        varchar(24) charset utf8 null comment '会议结束时间',
    meeting_date    varchar(32) charset utf8 null comment '会议日期'
);
```

## 思路
1. 查出满足预定条件的会议记录（超过4小时、当前账号）
2. 即将预定的日期union步骤1查询结果的日期按照预定时间排序
3. 查询排序后的日期与前一个日期的时间间隔天数
4. 设置group_id, 间隔天数为1的日期与前一天是同一组
5. 根据group_id分组, 每组都是一个连续时间区间, 过滤出当前日期所在的分组
6. 根据连续时间天数继续过滤，如果不满足要求返回结果是1，满足是0


## final solution
```mysql
select count(*)
        from (WITH DateList AS (SELECT #{meetingDate} AS meeting_date
                                UNION
                                SELECT meeting_date
                                FROM t_meeting_pre_form t
                                WHERE t.create_user = #{userCode}
                                  AND TIMESTAMPDIFF(HOUR, STR_TO_DATE(t.meeting_time_top, '%Y-%m-%d %H:%i:%s'),
                                                    STR_TO_DATE(t.meeting_time_bottom, '%Y-%m-%d %H:%i:%s')) > 4
                                  and t.delete_mark = 0
                                  and t.meeting_room_id = #{meetingRoomId}
                                ORDER BY meeting_date),
                   RankedDates AS (SELECT meeting_date,
                                          DATEDIFF(meeting_date,
                                                   LAG(meeting_date) OVER (ORDER BY meeting_date)) AS date_diff
                                   FROM DateList),
                   ConsecutiveGroups AS (SELECT meeting_date,
                                                SUM(IF(date_diff = 1, 0, 1))
                                                    OVER (ORDER BY meeting_date) AS group_id
                                         FROM RankedDates)
              SELECT group_id, MIN(meeting_date) AS start_date, MAX(meeting_date) AS end_date
              FROM ConsecutiveGroups
              GROUP BY group_id
              HAVING DATEDIFF(MAX(meeting_date), MIN(meeting_date)) >= 3
                 and str_to_date(#{meetingDate}, '%Y-%m-%d') between str_to_date(start_date, '%Y-%m-%d') and str_to_date(end_date, '%Y-%m-%d')) as tmp
```
