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
    
    ChooseForm *chooseFormView;
    
    UIView *maskView;
}
@property (nonatomic,assign) BOOL inPersonForm;

@end

@implementation ActiveDetailViewController

- (void)setInPersonForm:(BOOL)inPersonForm {
    _inPersonForm = inPersonForm;
    if (_inPersonForm) {
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
    
//    scrollViewHeight = 0;
    startPos = 0;
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    
    [self setupScrollView];
    [self setupCoverImageView];
    [self setupTitleView];
    [self setupLocationView];
    [self setupMemberView];
    [self setupContactView];
    [self setupDetailView];
    [self setupButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup UI
- (void)setupScrollView {
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT - 45 - 64)];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
}
- (void)setupCoverImageView {
    UIImageView *coverImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 200)];
    
    coverImage.image = [UIImage imageNamed:@"img_nodata"];
    [scrollView addSubview:coverImage];
    startPos = 200;
}

- (void)setupTitleView {
    titleView = (TitleView*)[[[NSBundle mainBundle]loadNibNamed:@"TitleView" owner:self options:nil]lastObject];
    titleView.frame = CGRectMake(0,startPos , APP_WIDTH, 180);
    startPos += 180;
    UILabel *sepLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, startPos, APP_WIDTH - 36, 0.5)];
    sepLabel.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:titleView];
    [scrollView addSubview:sepLabel];
    startPos += 0.5;
}

- (void)setupLocationView {
    locationView = (LocationView*)[[[NSBundle mainBundle]loadNibNamed:@"LocationView" owner:self options:nil]lastObject];
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
    contentLabel.text = @"如果遇到提示，就得考虑约束不全的问题了。比如你的底部有一个动态高度的label，设计为与的\n距离为1，与其上的一个控件距离为0，你想着label的高度由的高度来控制，即依赖scrollview的高度，岂不知scrollview的高度是根\n据内部subview的高度来计算的，也就是依赖于后者的。这种情况就最好用代码设置了。";
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
    UIButton *chooseFormBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, APP_HEIGHT - 45 - 64, APP_WIDTH/2, 45)];
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
    _inPersonForm = YES;
    chooseFormView = (ChooseForm*)[[[NSBundle mainBundle]loadNibNamed:@"ChooseForm" owner:self options:nil]lastObject];
    [chooseFormView.inPersonBtn addTarget:self action:@selector(choosePersonForm:) forControlEvents:UIControlEventTouchUpInside];
    [chooseFormView.inTeamBtn addTarget:self action:@selector(chooseTeamForm:) forControlEvents:UIControlEventTouchUpInside];
    
    [chooseFormView.signUpBtn addTarget:self action:@selector(chooseTeamForm:) forControlEvents:UIControlEventTouchUpInside];
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.5;
    chooseFormView.maskView = maskView;
    chooseFormView.frame = CGRectMake(0, APP_HEIGHT, APP_WIDTH, 216);
    [[[UIApplication sharedApplication]keyWindow]addSubview:maskView];
    [[[UIApplication sharedApplication]keyWindow]addSubview:chooseFormView];
    
    [UIView animateWithDuration:0.5 animations:^{
        chooseFormView.frame = CGRectMake(0, APP_HEIGHT-216, APP_WIDTH, 216);
    } completion:nil];
}

- (void)signUp:(UIButton*)sender {
    
}

- (void)choosePersonForm:(UIButton*)sender {
    if (!_inPersonForm) {
        self.inPersonForm = YES;
        [chooseFormView.chooseFormBtn setTitle:@"已选择\"个人参加\"" forState:UIControlStateNormal];
    }
}

- (void)chooseTeamForm:(UIButton*)sender {
    if (_inPersonForm) {
        self.inPersonForm = NO;
        [chooseFormView.chooseFormBtn setTitle:@"已选择\"团队参加\"" forState:UIControlStateNormal];
    }
}



@end
