+++
title = "datax增量数据同步"
date = "2024-12-27"
+++
# background

![增量方案](/static/posts/91fbee70-05f4-4638-8c05-46805acb31b5.png)

# datax环境

[userGuid](https://github.com/alibaba/DataX/blob/master/userGuid.md)

## table

```sql
 CREATE TABLE `tc_biz_vertical_test_0000` (
`biz_order_id` bigint(20) NOT NULL COMMENT 'id',
`key_value` varchar(4000) NOT NULL COMMENT 'Key-value的内容',
`gmt_create` datetime NOT NULL COMMENT '创建时间',
`gmt_modified` datetime NOT NULL COMMENT '修改时间',
`attribute_cc` int(11) DEFAULT NULL COMMENT '防止并发修改的标志',
`value_type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
`buyer_id` bigint(20) DEFAULT NULL COMMENT 'buyerid',
`seller_id` bigint(20) DEFAULT NULL COMMENT 'seller_id',
PRIMARY KEY (`biz_order_id`,`value_type`),
KEY `idx_biz_vertical_gmtmodified` (`gmt_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk COMMENT='tc_biz_vertical'

ALTER TABLE tc_biz_vertical_test_0000 MODIFY COLUMN biz_order_id bigint auto_increment NOT NULL COMMENT 'id';
 ```

## mock data

```sql
SET GLOBAL log_bin_trust_function_creators = 1; -- 允许创建函数
DELIMITER $$

CREATE FUNCTION mock_data()
RETURNS INT
DETERMINISTIC
BEGIN 
    DECLARE num INT DEFAULT 10000; -- 定义循环的次数
    DECLARE i INT DEFAULT 0;       -- 定义计数器

    -- 使用 WHILE 循环插入数据
    WHILE i < num DO
        INSERT INTO tc_biz_vertical_test_0000 (
            key_value, gmt_create, gmt_modified, attribute_cc, value_type, buyer_id, seller_id
        )
        VALUES ('test', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1, 1, 1, 1);
        
        SET i = i + 1; -- 增加计数器
    END WHILE;

    RETURN i; -- 返回插入的记录数
END$$

DELIMITER ;
```

## crontab
```shell
$ crontab -e
*/5 * * * *  python3 ~/dev/datax/bin/datax.py ~/dev/repo/datax-inc-sync/mysql_to_mysql.json >> ~/dev/datax/mysql_to_mysql.log &
```

## datax config
[mysql_to_mysql.json](https://github.com/horaoen/datax-inc-sync/blob/main/mysql_to_mysql.json)


