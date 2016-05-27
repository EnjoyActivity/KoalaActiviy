//
//  ActiveDetailViewController.m
//  ledong
//
//  Created by dengjc on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "ActiveDetailViewController.h"
#import "TitleView.h"
#import "LocationView.h"
#import "MemberView.h"
#import "ContactView.h"
#import "ChooseForm.h"
#import "SignUpViewController.h"
#import "UIImageView+WebCache.h"

@interface ActiveDetailViewController ()
{
    NSInteger scrollViewHeight;
    UIScrollView *scrollView;
    CGFloat startPos;
    
    TitleView *titleView;
    LocationView *locationView;
    MemberView *memberView;
    ContactView *contactView;
    UILabel *contentLabel;
    
    UIButton *chooseFormBtn;
    ChooseForm *chooseFormView;
    
    UIView *maskView;
    
    NSDictionary *activityInfo;
}
@property (nonatomic,assign) int joinType;

@end

@implementation ActiveDetailViewController

- (void)setJoinType:(int)joinType {
    _joinType = joinType;
    if (_joinType==1) {
        [chooseFormView.inPersonBtn setImage:[UIImage imageNamed:@"ckb_checked"] forState:UIControlStateNormal];
        [chooseFormView.inTeamBtn setImage:[UIImage imageNamed:@"ckb_uncheck"] forState:UIControlStateNormal];
    } else {
        [chooseFormView.inPersonBtn setImage:[UIImage imageNamed:@"ckb_uncheck"] forState:UIControlStateNormal];
        [chooseFormView.inTeamBtn setImage:[UIImage imageNamed:@"ckb_checked"] forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"活动详情";
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_like"] style:UIBarButtonItemStylePlain target:self action:@selector(likeBtnClick:)];
    item1.tintColor = RGB(227, 26, 26,1);
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_repost"] style:UIBarButtonItemStylePlain target:self action:@selector(repostBtnClick:)];
    item2.tintColor = RGB(227, 26, 26,1);
    
    startPos = 0;
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    
//    activityInfo  = @{
//                          @"Id": @7,
//                          @"ActivityClassId": @1,
//                          @"Title": @"2016四川中学生足球联赛 ",
//                          @"Cover": @"../../images/2016050801.gif",
//                          @"ActivityType": @0,
//                          @"IsLeague": @1,
//                          @"JionType": @1,
//                          @"Demand": @"要求年龄12-18岁之间",
//                          @"Tel": @"15399998888",
//                          @"ComplainTel": @"028-11111111",
//                          @"ReleaseUserId": @0,
//                          @"ReleaseState": @0,
//                          @"ReleaseTime": @"",
//                          @"BeginTime": @"2016-08-01 00:00:00",
//                          @"EndTime": @"2016-09-01 00:00:00",
//                          @"ApplyBeginTime": @"2016-06-01 00:00:00",
//                          @"ApplyEndTime": @"2016-06-10 00:00:00",
//                          @"WillNum": @11,
//                          @"MaxNum": @16,
//                          @"MaxApplyNum": @32,
//                          @"ApplyNum": @0,
//                          @"provinceCode": @"510000",
//                          @"cityCode": @"510100",
//                          @"areaCode": @"0",
//                          @"ConstitutorId": @1,
//                          @"Constitutor": @"",
//                          @"EntryMoneyMin": @200,
//                          @"EntryMoneyMax": @200,
//                          @"ReadFlag": @1,
//                          @"tag": @"足球",
//                          @"activityitems": @[
//                                            @{
//                                                @"Id": @17,
//                                                @"ActivityId": @7,
//                                                @"Remark": @"2016四川中学生足球联赛第一场",
//                                                @"BeginTime": @"2016-08-01 00:00:00",
//                                                @"EndTime": @"2016-08-01 00:00:00",
//                                                @"ApplyBeginTime": @"2016-06-01 00:00:00",
//                                                @"ApplyEndTime": @"2016-06-10 00:00:00",
//                                                @"EntryMoney": @200,
//                                                @"WillNum": @20,
//                                                @"MaxNum": @30,
//                                                @"MaxApplyNum": @2,
//                                                @"ApplyNum": @0,
//                                                @"ConstitutorId": @1,
//                                                @"PlaceName": @"成都市体育馆",
//                                                @"Address": @"成都市顺城街2号",
//                                                @"MapX": @103.5,
//                                                @"MapY": @53.3,
//                                                @"ProvinceCode": @"510000",
//                                                @"CityCode": @"510100",
//                                                @"AreaCode": @"510107",
//                                                @"provinceName": @"四川省",
//                                                @"cityName": @"成都市",
//                                                @"areaName": @"武侯区",
//                                                @"ConstitutorName": @"",
//                                                @"activityItemTeams": @[],
//                                                @"activityItemUsers": @[]
//                                            }                                            ],
//                          @"activityTeams": @[],
//                          @"activityUsers": @[]
//                      };
//
//    [self setupUI];
    [self queryActiveDetailInfo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup UI
- (void)setupUI {
    [self setupScrollView];
    [self setupCoverImageView];
    [self setupTitleView];
    [self setupLocationView];
//    [self setupMemberView];
    [self setupContactView];
    [self setupDetailView];
    [self setupButton];
}

- (void)setupScrollView {
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT - 45 - 64)];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
}
- (void)setupCoverImageView {
    UIImageView *coverImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 211)];
    coverImage.backgroundColor = [UIColor purpleColor];
//    coverImage.image = [UIImage imageNamed:@"img_1"];
//    coverImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[activityInfo objectForKey:@"Cover"]]];//[UIImage imageNamed:@"img_nodata"];
    [coverImage sd_setImageWithURL:[NSURL URLWithString:[activityInfo objectForKey:@"Cover"]] placeholderImage:[UIImage imageNamed:@"img_1"]];
    [scrollView addSubview:coverImage];
    startPos = 211;
}

- (void)setupTitleView {
    titleView = (TitleView*)[[[NSBundle mainBundle]loadNibNamed:@"TitleView" owner:self options:nil]lastObject];
    titleView.frame = CGRectMake(0,startPos , APP_WIDTH, 180);
    titleView.activeTitleLabel.text = [activityInfo objectForKey:@"Title"];
    NSString *beginTime = [self formatStringFromString:[activityInfo objectForKey:@"BeginTime"]];
    NSString *endTime = [self formatStringFromString:[activityInfo objectForKey:@"EndTime"]];
    titleView.activeTimeLabel.text = [NSString stringWithFormat:@"%@ - %@",beginTime,endTime];
    NSInteger days = 0;
    if (![[activityInfo objectForKey:@"ApplyEndTime"] isKindOfClass:[NSNull class]]) {
        days = [self howManyDaysSinceNow:[activityInfo objectForKey:@"ApplyEndTime"]];
    }
    titleView.timeRemainLabel.text = [NSString stringWithFormat:@"报名剩余 %ld 天",(long)days];
    titleView.personMoneyLabel.text = [NSString stringWithFormat:@"%@",[activityInfo objectForKey:@"EntryMoneyMin"]];
    [titleView.personMoneyLabel sizeToFit];
    titleView.teamMoneyLabel.text = [NSString stringWithFormat:@"%@",[activityInfo objectForKey:@"EntryMoneyMax"]];
    [titleView.teamMoneyLabel sizeToFit];
    //剩余人、团队
    int remainPerson = [[activityInfo objectForKey:@"MaxNum"]intValue] - [[activityInfo objectForKey:@"WillNum"]intValue];
    titleView.remainPersonLabel.text = [NSString stringWithFormat:@"剩余 %d",remainPerson];
    titleView.remainPersonLabel.hidden = YES;
    int remainTeam = [[activityInfo objectForKey:@"MaxApplyNum"]intValue] - [[activityInfo objectForKey:@"ApplyNum"]intValue];
    titleView.remainTeamLabel.text = [NSString stringWithFormat:@"剩余 %d",remainTeam];
    titleView.remainTeamLabel.hidden = YES;
    
    startPos += 180;
    UILabel *sepLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, startPos, APP_WIDTH - 36, 0.5)];
    sepLabel.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:titleView];
    [scrollView addSubview:sepLabel];
    startPos += 0.5;
}

- (void)setupLocationView {
    locationView = (LocationView*)[[[NSBundle mainBundle]loadNibNamed:@"LocationView" owner:self options:nil]lastObject];
    NSArray *items = [activityInfo objectForKey:@"activityitems"];
    if (items.count!=0) {
        NSDictionary *dic = [items objectAtIndex:0];
        locationView.locationLabel.text = [dic objectForKey:@"PlaceName"];
        locationView.detailLocationLabel.text = [dic objectForKey:@"Address"];
    }
    locationView.distanceLabel.text = @"0.0km";
    [locationView.distanceLabel sizeToFit];
    locationView.frame = CGRectMake(0,startPos , APP_WIDTH, 80);
    startPos += 80;
    [scrollView addSubview:locationView];
}

- (void)setupMemberView {
    memberView = (MemberView*)[[[NSBundle mainBundle]loadNibNamed:@"MemberView" owner:self options:nil]lastObject];
    memberView.frame = CGRectMake(0,startPos , APP_WIDTH, 80);
    startPos += 80;
    [scrollView addSubview:memberView];
}

- (void)setupContactView {
    contactView = (ContactView*)[[[NSBundle mainBundle]loadNibNamed:@"ContactView" owner:self options:nil]lastObject];
    contactView.frame = CGRectMake(0,startPos , APP_WIDTH, 160);
    [contactView.infoButton addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [contactView.reportButton addTarget:self action:@selector(complainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    startPos += 160;
    
    UILabel *sepLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, startPos, APP_WIDTH - 36, 0.5)];
    sepLabel.backgroundColor = [UIColor lightGrayColor];
    
    [scrollView addSubview:contactView];
    [scrollView addSubview:sepLabel];
    startPos += 0.5;
    
//    scrollView.contentSize = CGSizeMake(APP_WIDTH, startPos);
}

- (void)setupDetailView {
    startPos += 12;
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, startPos, 0, 0)];
    detailLabel.text = @"活动详情";
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.font = [UIFont systemFontOfSize:18];
    detailLabel.textColor = RGB(51, 51, 51, 1);
    [detailLabel sizeToFit];
    detailLabel.center = CGPointMake(APP_WIDTH/2, startPos + detailLabel.frame.size.height/2);
    
    startPos += detailLabel.frame.size.height;
    startPos += 10;
    
    contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, startPos, APP_WIDTH-36, 0)];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = RGB(153, 153, 153, 1);
    contentLabel.text = [activityInfo objectForKey:@"Demand"];//@"如果遇到提示，就得考虑约束不全的问题了。比如你的底部有一个动态高度的label，设计为与的\n距离为1，与其上的一个控件距离为0，你想着label的高度由的高度来控制，即依赖scrollview的高度，岂不知scrollview的高度是根\n据内部subview的高度来计算的，也就是依赖于后者的。这种情况就最好用代码设置了。";
    contentLabel.numberOfLines = 0;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
    //设置字体颜色
    [text addAttribute:NSForegroundColorAttributeName value:RGB(153, 153, 153, 1) range:NSMakeRange(0, text.length)];
    //设置缩进、行距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 0;
    style.firstLineHeadIndent = 30;
    style.lineSpacing = 5;
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    //------
    contentLabel.attributedText = text;
    [contentLabel sizeToFit];
    contentLabel.frame = CGRectMake(18, startPos, APP_WIDTH - 36, contentLabel.frame.size.height + 18);
    startPos += contentLabel.frame.size.height;
    
    [scrollView addSubview:detailLabel];
    [scrollView addSubview:contentLabel];
    scrollView.contentSize = CGSizeMake(APP_WIDTH, startPos);
    
}

- (void)setupButton {
    chooseFormBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, APP_HEIGHT - 45 - 64, APP_WIDTH/2, 45)];
    [chooseFormBtn setTitle:@"选择参加形式" forState:UIControlStateNormal];
    [chooseFormBtn setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
    [chooseFormBtn setTitleColor:RGB(227, 26, 26,1) forState:UIControlStateNormal];
    chooseFormBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    chooseFormBtn.backgroundColor = [UIColor whiteColor];
    UILabel *sepLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH/2, 0.5)];
    sepLabel.backgroundColor = [UIColor lightGrayColor];
    [chooseFormBtn addSubview:sepLabel];
    [chooseFormBtn addTarget:self action:@selector(chooseForm:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *signUpBtn = [[UIButton alloc]initWithFrame:CGRectMake(APP_WIDTH/2, APP_HEIGHT - 45 - 64, APP_WIDTH/2, 45)];
    [signUpBtn setTitle:@"报名" forState:UIControlStateNormal];
    signUpBtn.titleLabel.textColor = [UIColor whiteColor];
    signUpBtn.backgroundColor = RGB(227, 26, 26,1);
    signUpBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [signUpBtn addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:chooseFormBtn];
    [self.view addSubview:signUpBtn];
}

#pragma mark - button methods
- (void)repostBtnClick:(id)sender {
    
}

- (void)likeBtnClick:(id)sender {
    
}

- (void)chooseForm:(UIButton*)sender {
    _joinType = 1;
    chooseFormView = (ChooseForm*)[[[NSBundle mainBundle]loadNibNamed:@"ChooseForm" owner:self options:nil]lastObject];
    [chooseFormView.inPersonBtn addTarget:self action:@selector(choosePersonForm:) forControlEvents:UIControlEventTouchUpInside];
    [chooseFormView.inTeamBtn addTarget:self action:@selector(chooseTeamForm:) forControlEvents:UIControlEventTouchUpInside];
    [chooseFormView.signUpBtn addTarget:self action:@selector(signUpInChooseForm:) forControlEvents:UIControlEventTouchUpInside];
    [chooseFormView.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [chooseFormView.okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.5;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideMask:)];
    [maskView addGestureRecognizer:tapGes];
    chooseFormView.frame = CGRectMake(0, APP_HEIGHT, APP_WIDTH, 216);
    [[[UIApplication sharedApplication]keyWindow]addSubview:maskView];
    [[[UIApplication sharedApplication]keyWindow]addSubview:chooseFormView];
    
    [UIView animateWithDuration:0.5 animations:^{
        chooseFormView.frame = CGRectMake(0, APP_HEIGHT-216, APP_WIDTH, 216);
    } completion:nil];
}

- (void)signUp:(UIButton*)sender {
//    [maskView removeFromSuperview];
//    [chooseFormView removeFromSuperview];
    if ([chooseFormBtn.currentTitle isEqualToString:@"选择参加形式"]) {
        [Dialog toast:@"请选择参加形式"];
        return;
    }
    SignUpViewController *vc = [[SignUpViewController alloc]init];
    vc.joinType = _joinType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)signUpInChooseForm:(UIButton*)sender {
    [maskView removeFromSuperview];
    [chooseFormView removeFromSuperview];
    SignUpViewController *vc = [[SignUpViewController alloc]init];
    vc.joinType = _joinType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)choosePersonForm:(UIButton*)sender {
    if (_joinType==2) {
        self.joinType = 1;
        [chooseFormView.chooseFormBtn setTitle:@"已选择\"个人参加\"" forState:UIControlStateNormal];
    }
}

- (void)chooseTeamForm:(UIButton*)sender {
    if (_joinType==1) {
        self.joinType = 2;
        [chooseFormView.chooseFormBtn setTitle:@"已选择\"团队参加\"" forState:UIControlStateNormal];
    }
}

- (void)infoBtnClick:(UIButton*)sender {
    [self makePhone:[activityInfo objectForKey:@"Tel"]];
}

- (void)complainBtnClick:(UIButton*)sender {
    [self makePhone:[activityInfo objectForKey:@"ComplainTel"]];
}

- (void)cancelBtnClick:(id)sender {
    [maskView removeFromSuperview];
    [chooseFormView removeFromSuperview];

}
- (void)okBtnClick:(id)sender {
    [maskView removeFromSuperview];
    [chooseFormView removeFromSuperview];
    if (_joinType==1) {
        [chooseFormBtn setTitle:@"已选择\"个人参加\"" forState:UIControlStateNormal];
    } else {
        [chooseFormBtn setTitle:@"已选择\"团队参加\"" forState:UIControlStateNormal];
    }
}

- (void)hideMask:(UIGestureRecognizer*)ges {
    [maskView removeFromSuperview];
    [chooseFormView removeFromSuperview];
}
#pragma mark - inner methods
- (void)queryActiveDetailInfo {
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE_URL,API_ACTIVITYDETAIL_URL];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc]init];
    [postDic setObject:[HttpClient getTokenStr] forKey:@"token"];
    [postDic setObject:@(self.Id) forKey:@"Id"];
    
    [HttpClient postJSONWithUrl:url parameters:postDic success:^(id reponseObject){
        NSDictionary* temp = (NSDictionary*)reponseObject;
        if ([[temp objectForKey:@"code"]intValue]!=0) {
            [Dialog toast:[temp objectForKey:@"msg"]];
            return;
        }
        activityInfo = [temp objectForKey:@"result"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupUI];
        });
    }fail:^{
        
    }];
}

//格式为“8月1日 周一 00：00”
- (NSString*)formatStringFromString:(NSString*)dateStr {
    NSArray *weekday = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date= [dateFormatter dateFromString:dateStr];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour |NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    NSString *resultStr = [NSString stringWithFormat:@"%ld月%ld日 %@ %02ld:%02ld",(long)[comps month],(long)[comps day],weekday[[comps weekday]-1],(long)[comps hour],(long)[comps minute]];
    
    return resultStr;
}

- (NSInteger)howManyDaysSinceNow:(NSString*)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *date= [dateFormatter dateFromString:dateStr];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlag = NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unitFlag fromDate:[NSDate date] toDate:date options:0];
    return [components day] + 1;
}
//make phone
- (void)makePhone:(NSString*)phone {
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phone]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

@end
