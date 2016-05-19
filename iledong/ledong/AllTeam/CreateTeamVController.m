//
//  CreateTeamVController.m
//  ledong
//
//  Created by luojiao  on 16/3/30.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "CreateTeamVController.h"

#define kOrighHeight 64
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CreateTeamVController ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *uploadHeaderImgBtn;
@property (weak, nonatomic) IBOutlet UIView *teamNameView;
@property (weak, nonatomic) IBOutlet UIView *teamIntroductionView;
@property (weak, nonatomic) IBOutlet UIView *teamOtherInfoView;
@property (weak, nonatomic) IBOutlet UIView *teamAuditView;
@property (weak, nonatomic) IBOutlet UIButton *StartBtn;

@end

@implementation CreateTeamVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建团队";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self layoutSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - draw UI
- (void)layoutSubView {
    CGFloat originY = 10;
    self.mainScrollView.backgroundColor = UIColorFromRGB(0xF2F3F4);
    self.mainScrollView.frame = CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT);
    
    NSString* path = [[NSBundle mainBundle]pathForResource:@"img_teamavatar_120@2x" ofType:@"png"];
    self.headerImageView.image = [UIImage imageWithContentsOfFile:path];
    [self.headerImageView sizeToFit];

    self.headerImageView.frame = CGRectMake(APP_WIDTH/2-self.headerImageView.frame.size.width/2, originY, self.headerImageView.frame.size.width, self.headerImageView.frame.size.height);
    originY = self.headerImageView.frame.origin.y + self.headerImageView.frame.size.height + 15;
    self.uploadHeaderImgBtn.frame = CGRectMake(APP_WIDTH/2-self.uploadHeaderImgBtn.frame.size.width/2, originY, self.uploadHeaderImgBtn.frame.size.width, self.uploadHeaderImgBtn.frame.size.height);
    self.uploadHeaderImgBtn.layer.borderWidth = 1.0;
    self.uploadHeaderImgBtn.layer.borderColor = UIColorFromRGB(0xDEDEDE).CGColor;
    
    self.headerView.frame = CGRectMake(0, kOrighHeight, APP_WIDTH, self.uploadHeaderImgBtn.frame.origin.y+self.uploadHeaderImgBtn.frame.size.height+10);
    originY = self.headerView.frame.origin.y + self.headerView.frame.size.height + 10;
    self.teamNameView.frame = CGRectMake(0, originY, APP_WIDTH, 55);
    originY = self.teamNameView.frame.origin.y + self.teamNameView.frame.size.height + 10;
    self.teamIntroductionView.frame = CGRectMake(0, originY, APP_WIDTH, 190);
    originY = self.teamIntroductionView.frame.origin.y + self.teamIntroductionView.frame.size.height + 10;
    self.teamOtherInfoView.frame = CGRectMake(0, originY, APP_WIDTH, 130);
    originY = self.teamOtherInfoView.frame.origin.y + self.teamOtherInfoView.frame.size.height + 10;
    self.teamAuditView.frame = CGRectMake(0, originY, APP_WIDTH, 60);
    originY = self.teamAuditView.frame.origin.y + self.teamAuditView.frame.size.height + 10;
    self.StartBtn.frame = CGRectMake(0, originY, APP_WIDTH, 40);
    originY = self.StartBtn.frame.origin.y + self.StartBtn.frame.size.height;
    
    self.mainScrollView.contentSize = CGSizeMake(APP_WIDTH, originY);
}




@end
