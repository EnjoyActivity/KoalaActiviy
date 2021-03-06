//
//  ChooseActiveItemVC.m
//  ledong
//
//  Created by dengjc on 16/5/24.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "ChooseActiveItemVC.h"
#import "SessionTableViewCell.h"
#import "ActiveItemModel.h"
#import "ActiveDetailViewController.h"

@interface ChooseActiveItemVC ()
{
    NSMutableArray *data;
}


@end

@implementation ChooseActiveItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择场次";
    data = [[NSMutableArray alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    ActiveItemModel *model = [[ActiveItemModel alloc]init];
//    model.placeName = @"绿茵足球场";
//    model.address = @"北京市朝阳区绿茵路128号";
//    model.beginTime = @"10:00";
//    model.endTime = @"12:00";
//    model.maxNum = 40;
//    model.willNum = 10;
//    model.constitutorName = @"dengjc";
//    [data addObject:model];
    
    [self queryItemById];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 182;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *userIdentifier = @"Cell";
    SessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SessionTableViewCell" owner:self options:nil][0];
    }
    ActiveItemModel *model = data[indexPath.row];
    [self setupCell:cell model:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActiveDetailViewController *vc = [[ActiveDetailViewController alloc]init];
    ActiveItemModel *model = [data objectAtIndex:indexPath.row];
    vc.Id = model.activityId;
    vc.constitutorName = model.constitutorName;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupCell:(SessionTableViewCell*)cell model:(ActiveItemModel*)model {
    cell.placeNameLabel.text = model.placeName;
    cell.addressLabel.text = model.address;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *beginDate= [dateFormatter dateFromString:model.beginTime];
    NSDate *endDate = [dateFormatter dateFromString:model.endTime];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour |NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:beginDate];
    NSString *beginDateStr = [NSString stringWithFormat:@"%ld月%ld日 %02ld:%02ld",(long)[comps month],(long)[comps day],(long)[comps hour],(long)[comps minute]];
    comps = [calendar components:unitFlags fromDate:endDate];
    NSString *endDateStr = [NSString stringWithFormat:@"%ld月%ld日 %02ld:%02ld",(long)[comps month],(long)[comps day],(long)[comps hour],(long)[comps minute]];
    cell.beginTimeLabel.text = beginDateStr;
    cell.endTimeLabel.text = [NSString stringWithFormat:@"%@结束",endDateStr];
//    cell.beginTimeLabel.text = [model.beginTime substringWithRange:NSMakeRange(5, 11)];
//    cell.endTimeLabel.text = [NSString stringWithFormat:@"%@结束",[model.beginTime substringWithRange:NSMakeRange(5, 11)]];
    cell.constitutorNameLabel.text = [NSString stringWithFormat:@"组织人：%@",model.constitutorName];
    cell.remainNumLabel.text = [NSString stringWithFormat:@"单人剩余 %d   团队剩余 %d",model.maxNum - model.willNum,model.maxApplyNum - model.applyNum];
    cell.distanceLabel.text = @"0.0km";
    [cell.distanceLabel sizeToFit];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%d",model.entryMoney];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)queryItemById {
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc]init];
    [postDic setObject:[HttpClient getTokenStr] forKey:@"token"];
    [postDic setObject:@(self.Id) forKey:@"id"];
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE_URL,API_ACTIVITYITEMS_URL];
    [HttpClient postJSONWithUrl:url parameters:postDic success:^(id response){
        NSDictionary* temp = (NSDictionary*)response;
        if ([[temp objectForKey:@"code"]intValue]!=0) {
            [Dialog toast:[temp objectForKey:@"msg"]];
            return;
        }
        
        NSArray *result = [temp objectForKey:@"result"];
        for (int i=0; i<result.count; i++) {
            NSDictionary *item = [result objectAtIndex:i];
            ActiveItemModel *model = [[ActiveItemModel alloc]init];
            model.Id = [[item objectForKey:@"Id"]intValue];
            model.activityId = [[item objectForKey:@"ActivityId"]intValue];
            model.remark = [item objectForKey:@"Remark"];
            model.beginTime = [item objectForKey:@"BeginTime"];
            model.endTime = [item objectForKey:@"EndTime"];
            model.entryMoney = [[item objectForKey:@"EntryMoney"]intValue];
            model.willNum = [[item objectForKey:@"WillNum"]intValue];
            model.maxNum = [[item objectForKey:@"MaxNum"]intValue];
            model.applyNum = [[item objectForKey:@"ApplyNum"]intValue];
            model.maxApplyNum = [[item objectForKey:@"MaxApplyNum"]intValue];
            model.constitutorId = [[item objectForKey:@"ConstitutorId"]intValue];
            model.placeName = [item objectForKey:@"PlaceName"];
            model.address = [item objectForKey:@"Address"];
            model.mapX = [[item objectForKey:@"MapX"]doubleValue];
            model.mapY = [[item objectForKey:@"MapY"]doubleValue];
            model.provinceCode = [item objectForKey:@"ProvinceCode"];
            model.cityCode = [item objectForKey:@"CityCode"];
            model.areaCode = [item objectForKey:@"AreaCode"];
            model.provinceName = [item objectForKey:@"ProvinceName"];
            model.cityName = [item objectForKey:@"cityName"];
            model.areaName = [item objectForKey:@"areaName"];
            model.constitutorName = [item objectForKey:@"ConstitutorName"];
            [data addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }fail:^{
        [SVProgressHUD showErrorWithStatus:@"网络失败，请稍后再试"];
    }];

}
@end
