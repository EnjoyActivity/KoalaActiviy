# 获取活动详情

## URL
[BASE_URL](..) + `Activity/GetActivityById`

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
| id | true | int | 活动id |



## 返回结果
JSON示例：
```
{
    "msg": "系统处理成功",
    "code": 0,
    "result": {
        "Id": 7,
        "ActivityClassId": 1,
        "Title": "2016四川中学生足球联赛 ",
        "Cover": "../../images/2016050801.gif",
        "ActivityType": 0,
        "IsLeague": 1,
        "JionType": 1,
        "Demand": "要求年龄12-18岁之间",
        "Tel": "15399998888",
        "ComplainTel": "028-11111111",
        "ReleaseUserId": 0,
        "ReleaseState": 0,
        "ReleaseTime": null,
        "BeginTime": "2016-08-01 00:00:00",
        "EndTime": "2016-09-01 00:00:00",
        "ApplyBeginTime": "2016-06-01 00:00:00",
        "ApplyEndTime": "2016-06-10 00:00:00",
        "WillNum": 11,
        "MaxNum": 16,
        "MaxApplyNum": 32,
        "ApplyNum": 0,
        "provinceCode": "510000",
        "cityCode": "510100",
        "areaCode": "0",
        "ConstitutorId": 1,
        "Constitutor": null,
        "EntryMoneyMin": 200,
        "EntryMoneyMax": 200,
        "ReadFlag": 1,
        "tag": "足球",
        "activityitems": [
            {
                "Id": 17,
                "ActivityId": 7,
                "Remark": "2016四川中学生足球联赛第一场",
                "BeginTime": "2016-08-01 00:00:00",
                "EndTime": "2016-08-01 00:00:00",
                "ApplyBeginTime": "2016-06-01 00:00:00",
                "ApplyEndTime": "2016-06-10 00:00:00",
                "EntryMoney": 200,
                "WillNum": 20,
                "MaxNum": 30,
                "MaxApplyNum": 2,
                "ApplyNum": 0,
                "ConstitutorId": 1,
                "PlaceName": "成都市体育馆",
                "Address": "成都市顺城街2号",
                "MapX": 103.5,
                "MapY": 53.3,
                "ProvinceCode": "510000",
                "CityCode": "510100",
                "AreaCode": "510107",
                "provinceName": "四川省",
                "cityName": "成都市",
                "areaName": "武侯区",
                "ConstitutorName": null,
                "activityItemTeams": [],
                "activityItemUsers": []
            },
            {
                "Id": 20,
                "ActivityId": 7,
                "Remark": "2016四川中学生足球联赛第二场",
                "BeginTime": "2016-08-06 00:00:00",
                "EndTime": "2016-08-06 00:00:00",
                "ApplyBeginTime": "2016-06-01 00:00:00",
                "ApplyEndTime": "2016-06-10 00:00:00",
                "EntryMoney": 200,
                "WillNum": 20,
                "MaxNum": 30,
                "MaxApplyNum": 2,
                "ApplyNum": 0,
                "ConstitutorId": 1,
                "PlaceName": "四川省体育馆",
                "Address": "成都市人们南路三段X号",
                "MapX": 103.6,
                "MapY": 53.7,
                "ProvinceCode": "510000",
                "CityCode": "510100",
                "AreaCode": "510107",
                "provinceName": "四川省",
                "cityName": "成都市",
                "areaName": "武侯区",
                "ConstitutorName": null,
                "activityItemTeams": [],
                "activityItemUsers": []
            }
        ],
        "activityTeams": [],
        "activityUsers": []
    }
}
```




