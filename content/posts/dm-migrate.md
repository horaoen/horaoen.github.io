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

# 数据迁移
1. [迁移问题](https://eco.dameng.com/document/dm/zh-cn/faq/faq-mysql-dm8-migrate.html)
2. [迁移步骤](https://eco.dameng.com/document/dm/zh-cn/start/tool-dm-migrate)

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
ORDER BY i.TABLE_NAME
```
