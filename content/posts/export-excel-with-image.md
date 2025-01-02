+++
title = "excel导出插入图片"
date = "2025-01-02"
+++

## dependency
```xml
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>easyexcel</artifactId>
    <version>3.2.1</version>
</dependency>
```
## imp
```java
public class CustomImageModifyHandler implements CellWriteHandler {
    private final List<String> repeats = new ArrayList<>();

    private void insertImage(Sheet sheet, Cell cell, byte[] pictureData, int i) {
        int picWidth = Units.pixelToEMU(60);
        int index = sheet.getWorkbook().addPicture(pictureData, HSSFWorkbook.PICTURE_TYPE_PNG);
        Drawing drawing = sheet.getDrawingPatriarch();
        if (drawing == null) {
            drawing = sheet.createDrawingPatriarch();
        }
        CreationHelper helper = sheet.getWorkbook().getCreationHelper();
        ClientAnchor anchor = helper.createClientAnchor();
        // 设置图片坐标
        anchor.setDx1(picWidth * i);
        anchor.setDx2(picWidth + picWidth * i);
        anchor.setDy1(0);
        anchor.setDy2(0);
        //设置图片位置
        anchor.setCol1(cell.getColumnIndex());
        anchor.setCol2(cell.getColumnIndex());
        anchor.setRow1(cell.getRowIndex());
        anchor.setRow2(cell.getRowIndex() + 1);
        // 设置图片可以随着单元格移动
        anchor.setAnchorType(ClientAnchor.AnchorType.MOVE_AND_RESIZE);
        drawing.createPicture(anchor, index);
    }

    @Override
    public void afterCellDataConverted(WriteSheetHolder writeSheetHolder, WriteTableHolder writeTableHolder, WriteCellData<?> cellData, Cell cell, Head head, Integer relativeRowIndex, Boolean isHead) {
        //  在 数据转换成功后 不是头就把类型设置成空
        if (isHead) {
            return;
        }
        //将要插入图片的单元格的type设置为空,下面再填充图片
        if (cellData.getData() != null || cellData.getData() instanceof ArrayList) {
            cellData.setType(CellDataTypeEnum.EMPTY);
        }
    }

    @Override
    @SuppressWarnings("rawtypes")
    public void afterCellDispose(WriteSheetHolder writeSheetHolder, WriteTableHolder writeTableHolder, List<WriteCellData<?>> cellDataList, Cell cell, Head head, Integer relativeRowIndex, Boolean isHead) {
        //  在 单元格写入完毕后 ，自己填充图片
        if (isHead || CollectionUtils.isEmpty(cellDataList)) {
            return;
        }
        boolean listFlag = false;
        ArrayList data = null;
        Sheet sheet = cell.getSheet();
        // 此处为ListUrlConverterUtil的返回值
        if (cellDataList.get(0).getData() instanceof ArrayList) {
            data = (ArrayList) cellDataList.get(0).getData();
            if (data.isEmpty()) {
                return;
            }
            if (data.get(0) instanceof CellData) {
                CellData cellData = (CellData) data.get(0);
                if (cellData instanceof WriteCellData) {
                    listFlag = true;
                } else {
                    return;
                }
            }
        }
        if (!listFlag && cellDataList.get(0).getData() == null) {
            return;
        }
        String key = cell.getRowIndex() + "_" + cell.getColumnIndex();
        if (repeats.contains(key)) {
            return;
        }
        repeats.add(key);
        // 默认要导出的图片大小为60*60px,60px的行高大约是900,60px列宽大概是248*8
        sheet.getRow(cell.getRowIndex()).setHeight((short) 900);
        if (listFlag && 240 * 8 * data.size() < 3000) {
            sheet.setColumnWidth(cell.getColumnIndex(), 3000);
        } else {
            sheet.setColumnWidth(cell.getColumnIndex(), listFlag ? 240 * 8 * data.size() : 240 * 8);
        }
        if (listFlag) {
            for (int i = 0; i < data.size(); i++) {
                WriteCellData cellData = (WriteCellData) data.get(i);
                if (cellData.getData() == null) {
                    continue;
                }
                this.insertImage(sheet, cell, (byte[]) cellData.getData(), i);
            }
        } else {
            // cellDataList 是list的原因是 填充的情况下 可能会多个写到一个单元格 但是如果普通写入 一定只有一个
            this.insertImage(sheet, cell, (byte[]) cellDataList.get(0).getData(), 0);
        }
    }
}
```

```java
public class ListUrlImageConverter implements Converter<List<URL>> {
    public static int urlConnectTimeout = 1000;
    public static int urlReadTimeout = 5000;

    @Override
    public Class<?> supportJavaTypeKey() {
        return List.class;
    }

    @Override
    @SuppressWarnings({"rawtypes", "unchecked"})
    public WriteCellData<?> convertToExcelData(List<URL> value, ExcelContentProperty contentProperty, GlobalConfiguration globalConfiguration) throws Exception {
        List<WriteCellData> data = new ArrayList<>();
        for (URL url : value) {
            InputStream inputStream = null;
            try {
                URLConnection urlConnection = url.openConnection();
                urlConnection.setConnectTimeout(urlConnectTimeout);
                urlConnection.setReadTimeout(urlReadTimeout);
                inputStream = urlConnection.getInputStream();
                byte[] bytes = IoUtils.toByteArray(inputStream);
                WriteCellData cellData = new WriteCellData(bytes);
                cellData.setData(bytes);
                data.add(cellData);
            } finally {
                if (inputStream != null) {
                    inputStream.close();
                }
            }
        }
        WriteCellData cellData = new WriteCellData();
        cellData.setData(data);
        cellData.setType(CellDataTypeEnum.EMPTY);
        return cellData;
    }
}
```
## usage
```java
@ExcelProperty(value = "相关附件", converter = ListUrlImageConverter.class)
@ColumnWidth(value = 40)
private List<URL> imgUrls;
```
```java
response.setHeader("Content-Disposition", "attachment;filename=" + fileName + ".xlsx");
                    EasyExcel.write(response.getOutputStream(), AssignTaskForExportVo.class)
                            .registerWriteHandler(new CustomImageModifyHandler()).sheet()
                            .doWrite(assignTaskForExportVos);
```