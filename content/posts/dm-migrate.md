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