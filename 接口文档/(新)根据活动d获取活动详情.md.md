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
    "Id": 1,//活动id
    "ActivityClassId": 1,//活动类别
    "Title": "甲A联赛",//活动标题
    "Cover": "../images/20160426.jpg",
    "ActivityType": 1,//0:系统活动；1:团队活动
    "IsLeague": 1,//是否是联赛
    "JionType": 1,//0 个人 1 团队
    "Demand": "",//参加要求
    "Tel": "13011111111",//联系方式
    "ComplainTel": "010-12345678",//举报电话
    "TeamId": 0,//0:系统发布,非0为团队发布
    "ReleaseState": 0,//发布状态 0 未发布 1 已 发布
    "ReleaseTime": null,//发布时间
    "BeginTime": "2016-04-28 12:36:58",//开始时间//结束时间
    "EndTime": "2016-05-28 12:36:56",//结束时间
    "provinceCode": "1",//活动地点省代码
    "cityCode": "1",//活动地点城市代码
    "areaCode": "1",//活动地点区代码
    "ConstitutorId": 0,//组织者Id
    "EntryMoneyMin": 1.00,//活动费用最少额
    "EntryMoneyMax": 1.00,//活动费用最大额
    "Tag": "1",//活动标签
    "ReadFlag": 1//采用枚举或的方式。0:默认,1:精彩活动,2:推荐活动,4:预留
  }
}

```




