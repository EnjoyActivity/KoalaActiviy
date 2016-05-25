//
//  SignUpViewController.m
//  ledong
//
//  Created by dengjc on 16/5/25.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignTitleView.h"
#import "ChooseTeamView.h"
#import "ContactInfoView.h"

@interface SignUpViewController ()
{
    UIScrollView *scrollView;
    
    SignTitleView *titleView;//场次
    ChooseTeamView *chooseTeamView;//团队选择
    ContactInfoView *infoView;//联系人信息
    UILabel *preferentialLabel;//优惠
        
    int startPos;
    
    UILabel *totalMoneyLabel;
}
@property (strong, nonatomic) IBOutlet UIView *totalMoneyView;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(242, 243, 244, 1);
    self.title = @"提交报名订单";
    startPos = 9;
    
    [self setupScrollView];
    [self setupTitleView];
    if (_joinType==2) {
        [self setupChooseTeamView];
    }
    [self setupInfoView];
    [self setupPreferentialView];
    [self setupTotalMoneyView:@"200"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupScrollView {
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT -  50 - 64)];
    
    [self.view addSubview:scrollView];
}

- (void)setupTitleView {
    titleView = (SignTitleView*)[[[NSBundle mainBundle]loadNibNamed:@"SignTitleView" owner:self options:nil]lastObject];
    titleView.frame = CGRectMake(0,startPos , APP_WIDTH, 100);
    startPos += 100;
    if (_joinType == 2) {
        startPos += 9;
    }
    [scrollView addSubview:titleView];
}
//选择参加团队
- (void)setupChooseTeamView {
    chooseTeamView = (ChooseTeamView*)[[[NSBundle mainBundle]loadNibNamed:@"ChooseTeamView" owner:self options:nil]lastObject];
    chooseTeamView.frame = CGRectMake(0,startPos , APP_WIDTH, 100);
    startPos += 100;
    [scrollView addSubview:chooseTeamView];
}
//填写联系人信息
- (void)setupInfoView {
    infoView = (ContactInfoView*)[[[NSBundle mainBundle]loadNibNamed:@"ContactInfoView" owner:self options:nil]lastObject];
    infoView.frame = CGRectMake(0,startPos , APP_WIDTH, 137);
    startPos += 146;
    [scrollView addSubview:infoView];
}
//优惠
- (void)setupPreferentialView {
    UIView *containView = [[UIView alloc]initWithFrame:CGRectMake(0, startPos, APP_WIDTH, 50)];
    containView.backgroundColor = [UIColor whiteColor];
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    tipLabel.text = @"使用优惠";
    tipLabel.textColor = RGB(51, 51, 51, 1);
    tipLabel.font = [UIFont systemFontOfSize:15];
    [tipLabel sizeToFit];
    tipLabel.center = CGPointMake(20 + tipLabel.frame.size.width/2, 25);
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(APP_WIDTH - 20 - 8.5,17 , 8.5, 16)];
    imgView.image = [UIImage imageNamed:@"ic_more"];
    
    preferentialLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    preferentialLabel.textColor = RGB(227, 26, 26, 1);
    preferentialLabel.text = @"0张可用";
    preferentialLabel.font = [UIFont systemFontOfSize:15];
    [preferentialLabel sizeToFit];
    CGSize size = preferentialLabel.frame.size;
    preferentialLabel.center = CGPointMake(imgView.frame.origin.x - 10 - size.width/2, 25);
    
    [containView addSubview:tipLabel];
    [containView addSubview:imgView];
    [containView addSubview:preferentialLabel];
    
    [scrollView addSubview:containView];
    
    startPos +=59;
    
    scrollView.contentSize = CGSizeMake(APP_WIDTH, startPos);
}

- (void)setupTotalMoneyView:(NSString*)totalMoney {
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    tipLabel.textColor = RGB(227, 26, 26, 1);
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.text = @"合计：";
    [tipLabel sizeToFit];
    
    totalMoneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    totalMoneyLabel.font = [UIFont systemFontOfSize:20];
    totalMoneyLabel.textColor = RGB(227, 26, 26, 1);
    totalMoneyLabel.text = totalMoney;
    [totalMoneyLabel sizeToFit];
    
    UILabel *unitLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    unitLabel.textColor = RGB(227, 26, 26, 1);
    unitLabel.font = [UIFont systemFontOfSize:12];
    unitLabel.text = @"元";
    [unitLabel sizeToFit];
    
    int totalWidth = tipLabel.frame.size.width + totalMoneyLabel.frame.size.width + unitLabel.frame.size.width;
    tipLabel.center = CGPointMake((APP_WIDTH/2 - totalWidth)/2 + tipLabel.frame.size.width/2, 25);
    totalMoneyLabel.frame = CGRectMake(tipLabel.frame.origin.x + tipLabel.frame.size.width, CGRectGetMaxY(tipLabel.frame) - totalMoneyLabel.frame.size.height + 2, totalMoneyLabel.frame.size.width, totalMoneyLabel.frame.size.height);
    unitLabel.frame = CGRectMake(CGRectGetMaxX(totalMoneyLabel.frame), tipLabel.frame.origin.y, unitLabel.frame.size.width, unitLabel.frame.size.height);
    
    [_totalMoneyView addSubview:tipLabel];
    [_totalMoneyView addSubview:totalMoneyLabel];
    [_totalMoneyView addSubview:unitLabel];
}

@end
