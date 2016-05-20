# 根据活动id获取活动项

## URL
[BASE_URL](..) + `Activity/GetActivityItemsByActivityId`

## HTTP请求方式
POST/GET

## 支持格式
JSON

## 是否需要登录
是。

## 请求参数
| 请求字段 | 必选 | 类型及范围 | 说明 |
| -------- | :--: | ---------- | ---- |
| token | true | string | 身份Token |
| id | false | int | 活动id|




## 返回结果
JSON示例：
```
{
    "msg": "系统处理成功",
    "code": 0,
    "result": [
        {
            "Id": 4,
            "ActivityId": 1,
            "Remark": "1111",
            "BeginTime": "/Date(1462204800000)/",
            "EndTime": "/Date(1462377600000)/",
            "EntryMoney": 200,
            "WillNum": 20,
            "MaxNum": 30,
            "ConstitutorId": 0,
            "PlaceName": "",
            "Address": "",
            "MapX": 55.33,
            "MapY": 0,
            "ProvinceCode": "",
            "CityCode": "",
            "AreaCode": "",
            "ClassName": null,
            "provinceName": "",
            "cityName": "",
            "areaName": "",
            "ConstitutorName": ""
        },
        {
            "Id": 5,
            "ActivityId": 1,
            "Remark": "1111",
            "BeginTime": "/Date(1462204800000)/",
            "EndTime": "/Date(1462377600000)/",
            "EntryMoney": 200,
            "WillNum": 20,
            "MaxNum": 30,
            "ConstitutorId": 0,
            "PlaceName": "",
            "Address": "",
            "MapX": 55.33,
            "MapY": 0,
            "ProvinceCode": "",
            "CityCode": "",
            "AreaCode": "",
            "ClassName": null,
            "provinceName": "",
            "cityName": "",
            "areaName": "",
            "ConstitutorName": ""
        }
    ]
}
```




