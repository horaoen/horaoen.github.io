+++
title = "达梦数据库迁移"
date = "2024-10-28"
+++

# 环境
1. 客户端：macos使用dbeaver, IDEA: 使用mysql连接修改驱动使用达梦数据库连接驱动
# 函数
1. str_to_date => to_date(date1, 'YYYY-MM-DD HH24:MI:SS')
2. group_concat => wm_concat / listagg
3. date_sub => add_days / add_months
4. current_time => current_date() / sysdate() / curdate()
5. date(var) => trunc(var) 
6. convert => cast
7. convert(str, SIGNED) => to_number(REGEXP_SUBSTR(str, '[0-9]+'))
8. match_partern = REPLACE('${ew.department}', ',', '|'), REGEXP  match_partern => REGEXP_LIKE(var1, match_partern)
9. if函数传参数为null时（部分环境支持，兼容性不好），替换为case ... when ... else ...end
10. DATEDIFF 必须指定date_unit
11. WITH RECURSIVE cte1 => WITH cte1(var)

# 数据迁移
1. [迁移问题](https://eco.dameng.com/document/dm/zh-cn/faq/faq-mysql-dm8-migrate.html)
2. [迁移步骤](https://eco.dameng.com/document/dm/zh-cn/start/tool-dm-migrate)
3. source -> start
# 数据校验
## 比对索引
1. mysql
```sql
SELECT a.TABLE_SCHEMA,
       a.TABLE_NAME,
       a.index_name,
       GROUP_CONCAT(column_name ORDER BY seq_in_index) AS `Columns`
FROM information_schema.statistics a
where a.TABLE_SCHEMA = 'xzfw_pro1019' and a.COLUMN_NAME != 'id'
GROUP BY a.TABLE_SCHEMA,a.TABLE_NAME,a.index_name
order by INDEX_NAME;
```
2. dm
```sql
SELECT 
    i.OWNER AS TABLE_SCHEMA,
    i.TABLE_NAME,
    i.INDEX_NAME,
    LISTAGG(c.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY c.COLUMN_POSITION) AS Columns
FROM 
    DBA_INDEXES i
JOIN 
    DBA_IND_COLUMNS c ON i.OWNER = c.INDEX_OWNER AND i.INDEX_NAME = c.INDEX_NAME
 WHERE i.OWNER = 'xzfw_pro1019' AND c.COLUMN_NAME != 'id'
GROUP BY 
    i.OWNER, i.TABLE_NAME, i.INDEX_NAME
ORDER BY i.INDEX_NAME
```

## 相关数据操作
1. 清空数据库表
```sql
BEGIN
    FOR rec IN (SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = 'XZFW') LOOP
        EXECUTE IMMEDIATE 'DROP TABLE XZFW.' || rec.TABLE_NAME || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
```

### 其余tips
#### 查询约束
```sql
 SELECT 
    CONSTRAINT_NAME, 
    CONSTRAINT_TYPE, 
    SEARCH_CONDITION, 
    R_CONSTRAINT_NAME, 
    DELETE_RULE, 
    STATUS, 
    DEFERRABLE, 
    VALIDATED, 
    GENERATED
FROM 
    USER_CONSTRAINTS
WHERE 
    TABLE_NAME = 'T_WORKFLOW_WORK_ITEM' AND
    OWNER = 'XZFW';
```
#### 删除约束
```sql
ALTER TABLE XZFW.T_WORKFLOW_PROCESS_INST DROP CONSTRAINT CONS134220360;
```

#### 查询索引
```sql
 SELECT 
       I.INDEX_NAME AS INDEX_NAME,
       IC.COLUMN_NAME AS COLUMN_NAME,
       IC.COLUMN_POSITION AS COLUMN_POSITION,
       I.UNIQUENESS AS UNIQUENESS
   FROM 
       USER_INDEXES I
   JOIN 
       USER_IND_COLUMNS IC ON I.INDEX_NAME = IC.INDEX_NAME
   WHERE 
       I.TABLE_NAME = 'T_WORKFLOW_WORK_ITEM';
```

#### 删除索引
```sql
DROP INDEX XZFW.INDEX33559470;
```

#### 创建索引
```sql
CREATE INDEX T_WORKFLOW_WORK_ITEM_WORK_ITEM_ID_IDX ON XZFW.T_WORKFLOW_WORK_ITEM (WORK_ITEM_ID);
CREATE INDEX T_WORKFLOW_PROCESS_INST_PROCESS_INST_ID_IDX ON XZFW.T_WORKFLOW_PROCESS_INST (PROCESS_INST_ID);
```

#### 删除聚合索引
```
