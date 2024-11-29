+++
title = "code cheat sheet"
date = "2024-10-12"
+++

## Java
### 去除空格
```java
public String trim(String str) {
    // "\u0020" 半角空格, office空格, 全角空格
    return str.trim().replace("\u00a0", "").replace("\u3000", "");
} 
```

## Spring
### 获取Servlet相关参数
```java
ServletRequestAttributes servletRequestAttributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
HttpServletResponse response = servletRequestAttributes.getResponse();
HttpServletRequest request = servletRequestAttributes.getRequest();
```
## Library
### Hutool
#### ExcelUtil
```java
ExcelReader reader = ExcelUtil.getReader(FileUtil.file("公务用车车辆管理员信息.xlsx"), 0);
List<Map<String, Object>> carManagerMaps = reader.readAll();
//  所有用车管理员userCode
List<String> carManagersUserCode = carManagerMaps.stream()
        .map(map -> map.get("账号").toString())
        .collect(Collectors.toList());

final List<LinkedHashMap<String, String>> rows = carManagersUserCode.stream().map(userCode -> {
    LinkedHashMap<String, String> row = new LinkedHashMap<>();
    row.put("账号", userCode);
    return row;
}).collect(Collectors.toList());

ExcelWriter excelWriter = ExcelUtil.getWriter();

excelWriter.renameSheet("所有车辆管理员账号");
excelWriter.write(rows, true);

response.setContentType("application/vnd.ms-excel;charset=utf-8");
response.setHeader("Content-Disposition", "attachment;filename=test_1.xls");
ServletOutputStream out = response.getOutputStream();
excelWriter.flush(out, true);

excelWriter.close();
IoUtil.close(out);
```

```java
ExcelReader reader = ExcelUtil.getReader(FileUtil.file("path"), 0);
```
```
ExcelWriter excelWriter = ExcelUtil.getWriter();
```
### Jackson
#### Jsonstr to Obj
```java
// 字段映射
// @JsonAlias("FixedParkingNo")
// private Long fixedParkingNo;
ObjectMapper objectMapper = new ObjectMapper();
try {
    carInfos = objectMapper.readValue(new File(filePath), new TypeReference<List<CarInfo>>() {
    });
} catch (IOException e) {
    throw new RuntimeException(e);
}
```
## DB
### 时间段重叠问题
```sql
DELIMITER $$
CREATE TRIGGER check_time_overlap
    BEFORE INSERT
    ON t_meeting_pre_form
    FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1
               FROM t_meeting_pre_form
               WHERE (not (NEW.meeting_time_top >= meeting_time_bottom
                   or NEW.meeting_time_bottom <= meeting_time_top))
                 AND NEW.meeting_room_id = meeting_room_id
                 AND NEW.meeting_date = meeting_date
                 AND delete_mark = 0) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '会议室预定时间重叠';
    END IF;
    END$$
DELIMITER ;
```

