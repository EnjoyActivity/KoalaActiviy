//
//  MainPageController.m
//  ledong
//
//  Created by dongguoju on 16/2/29.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "MainPageController.h"
#import "TeamsCell.h"
#import "SearchViewController.h"
#import "ScanViewController.h"
#import "FRUtils.h"
#import "LDActivityViewController.h"
#import "LDTeamViewController.h"
//#import "GoodActivViewController.h"
//#import "HotTeamViewController.h"

static NSString * const topAdCellIdentifier = @"TopAdCell";
static NSString * const activityCellIdentifier = @"ActivityCell";
static NSString * const hotTeamIdentifier = @"teamCell";

static CGFloat const adCollectionHeight = 280;
static CGFloat const activityCollectionHeight = 180;
static CGFloat const teamCollectionHeight = 280;

@interface MainPageController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    
    
    NSTimer *topAdTimer;
    NSInteger currentAd;
    NSMutableArray *topAdImageArray;
    //精彩活动
    NSTimer *activityTimer;
    NSInteger currentActivity;
    NSMutableArray *activityImageArray;
    NSMutableArray *activityNameArray;
    //热门团队
    
    NSTimer *teamTimer;
    NSInteger currentTeam;
    NSMutableArray *teamImageArray;
    NSMutableArray *teamHeadImageArray;
    
    UIScrollView * mainScrollView;
    
    UICollectionView * hotTeamCollectionView;
    UICollectionView * activityCollectionView;
    UICollectionView * topAdCollectionView;
    
    UIButton * locationButton;
    UIButton * scannerButton;
    UIButton * searchButton;
    
    CALayer * topAdProgressLayer;
    CALayer * activityProgressLayer;
    CALayer * hotTeamProgressLayer;
    

    
}

@end

@implementation MainPageController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *myBar = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"ic_home_on"] tag:0];
        myBar.selectedImage =[UIImage imageNamed:@"ic_home"];
        self.tabBarItem = myBar;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    topAdImageArray = [NSMutableArray arrayWithObjects:@"img_1",@"img_1b", nil];
    activityImageArray = [NSMutableArray arrayWithObjects:@"img_3",@"img_4",@"img_morebg", nil];
    activityNameArray = [NSMutableArray arrayWithObjects:@"篮球",@"足球",@"更多", nil];
    teamImageArray = [NSMutableArray arrayWithObjects:@"img_3",@"img_4",@"img_5",@"img_6",@"img_2", nil];
    teamHeadImageArray = [NSMutableArray arrayWithObjects:@"user01_44",@"user02_44",@"user01_44",@"user02_44",@"user01_44", nil];
    
    [self setUpUI];
 
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self adTimerStart];
    [self activityTimerStart];
    [self teamTimerStart];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
 
    [self adTimerStop];
    [self activityTimerStop];
    [self teamTimerStop];
}


#pragma mark - netWork



#pragma mark - ButtonClick

- (void)buttonClicked:(UIButton *)sender {
    if ([sender isEqual:locationButton]) {
        AdressCityVC *adressCityVC = [[AdressCityVC alloc] init];
        [self.navigationController pushViewController:adressCityVC animated:YES];
    } else if ([sender isEqual:scannerButton]) {
        ScanViewController *scanViewController = [[ScanViewController alloc] init];
        [self.navigationController pushViewController:scanViewController animated:YES];
    } else {
        SearchViewController *searchViewController = [[SearchViewController alloc] init];
        [self.navigationController pushViewController:searchViewController animated:YES];
    }
}


#pragma mark - CollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:topAdCollectionView]) {
        return topAdImageArray.count;
    } else if ([collectionView isEqual:activityCollectionView]) {
        return activityImageArray.count;
    }
    return teamImageArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:topAdCollectionView]) {
        UICollectionViewCell * topAdCell = [collectionView dequeueReusableCellWithReuseIdentifier:topAdCellIdentifier forIndexPath:indexPath];
        UIImageView * imageView = (UIImageView *)[topAdCell viewWithTag:2];
        imageView.image = [UIImage imageNamed:topAdImageArray[indexPath.row]];
        return topAdCell;
        
    } else if ([collectionView isEqual:activityCollectionView]) {
        UICollectionViewCell * activityCell = [collectionView dequeueReusableCellWithReuseIdentifier:activityCellIdentifier forIndexPath:indexPath];
        UIImageView * imageView = (UIImageView *)[activityCell viewWithTag:2];
        imageView.image = [UIImage imageNamed:activityImageArray[indexPath.row]];
        UILabel * label = (UILabel *)[activityCell viewWithTag:3];
        label.text = activityNameArray[indexPath.row];
        return activityCell;
    }
    TeamsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotTeamIdentifier forIndexPath:indexPath];
    cell.teamImageView.image = [FRUtils resizeImageWithImageName:teamImageArray[indexPath.row]];
    cell.headerImage.image = [FRUtils resizeImageWithImageName:teamHeadImageArray[indexPath.row]];
    return cell;
}

#pragma mark - collectionDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:topAdCollectionView]) {
        NSLog(@"ad: %ld",(long)indexPath.row);
        
    } else if ([collectionView isEqual:activityCollectionView]) {
        NSLog(@"activity: %ld",(long)indexPath.row);
        LDActivityViewController * activityVC = [[LDActivityViewController alloc] init];
        [self.navigationController pushViewController:activityVC animated:YES];
    } else if ([collectionView isEqual:hotTeamCollectionView]) {
        LDTeamViewController * teamVc = [[LDTeamViewController alloc] init];
        [self.navigationController pushViewController:teamVc animated:YES];
    }
}

#pragma mark - srcollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:topAdCollectionView])
    {
        [self adTimerPause];
    }
    else if ([scrollView isEqual:activityCollectionView])
    {
        [self activityTimerPause];
    }
    else if ([scrollView isEqual:hotTeamCollectionView])
    {
        [self teamTimerPause];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:topAdCollectionView])
    {
        // 计算当前页数索引
        currentAd = round(scrollView.contentOffset.x / APP_WIDTH);
    }
    else if ([scrollView isEqual:activityCollectionView])
    {
        currentActivity = round(scrollView.contentOffset.x / 186);
    }
    else if ([scrollView isEqual:hotTeamCollectionView])
    {
        currentTeam = round(scrollView.contentOffset.x / 246);
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isEqual:topAdCollectionView])
    {
        [self adTimerStart];
        [self adProgressMove];
    }
    else if ([scrollView isEqual:activityCollectionView])
    {
        [self activityTimerStart];
        [self activityProgressMove];
    }
    else if ([scrollView isEqual:hotTeamCollectionView])
    {
        [self teamTimerStart];
        [self teamProgressMove];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}




#pragma mark - banner & team & activ动画


- (void)adTimerStart
{
    if (!topAdTimer)
    {
        topAdTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(topAdScroll:) userInfo:nil repeats:YES];
    }
    topAdTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2.0];
}

- (void)adTimerPause
{
    if (topAdTimer && topAdTimer.isValid)
    {
        topAdTimer.fireDate = [NSDate distantFuture];
    }
}

- (void)adTimerStop
{
    if (topAdTimer && topAdTimer.isValid)
    {
        // 无效化
        [topAdTimer invalidate];
        topAdTimer = nil;
    }
}


- (void)topAdScroll:(NSTimer *)timer
{
    // 滚动视图内容的跳转
//    currentAd = ++currentAd % [topAdImageArray count];
    currentAd ++;
    currentAd = currentAd % topAdImageArray.count;
    CGPoint point = CGPointMake(APP_WIDTH * currentAd, 0);
    [topAdCollectionView setContentOffset:point animated:YES];
    [self adProgressMove];
}

- (void)adProgressMove {
    NSInteger count = topAdImageArray.count;
    CGFloat width = APP_WIDTH/count;
    NSInteger current = currentAd%count;
    CGPoint oldPosition = topAdProgressLayer.position;
    CGPoint newPoint = CGPointMake(width*current+width/2, oldPosition.y);
    [self moveAnimation:topAdProgressLayer position:newPoint];
}

- (void)activityTimerStart
{
    if (!activityTimer)
    {
        activityTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(activityScroll:) userInfo:nil repeats:YES];
    }
    activityTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2.0];
}

- (void)activityScroll:(NSTimer *)timer
{
    // 滚动视图内容的跳转
//    activPageIndex = ++activPageIndex % [activImageArr count];
    currentActivity ++;
    currentActivity = currentActivity % activityImageArray.count;
    CGFloat xOffset = (180 + 6) * currentActivity;
    CGFloat maxOffset = activityCollectionView.contentSize.width -APP_WIDTH-6;
    if (xOffset > maxOffset) {
        xOffset = maxOffset;
    }
    CGPoint point = CGPointMake(xOffset, 0);
    [activityCollectionView setContentOffset:point animated:YES];
    [self activityProgressMove];
}

- (void)activityTimerPause
{
    if (activityTimer && activityTimer.isValid)
    {
        activityTimer.fireDate = [NSDate distantFuture];
    }
}

- (void)activityTimerStop
{
    if (activityTimer && activityTimer.isValid)
    {
        // 无效化
        [activityTimer invalidate];
        activityTimer = nil;
    }
}

- (void)activityProgressMove {
    NSInteger count = activityImageArray.count;
    CGFloat width = APP_WIDTH/count;
    NSInteger current = currentActivity%count;
    CGPoint oldPosition = activityProgressLayer.position;
    CGPoint newPoint = CGPointMake(width*current+width/2, oldPosition.y);
    [self moveAnimation:activityProgressLayer position:newPoint];
}

- (void)teamTimerStart
{
    if (!teamTimer)
    {
        teamTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(teamScroll:) userInfo:nil repeats:YES];
    }
    teamTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2.0];
}

- (void)teamScroll:(NSTimer *)timer
{
    // 滚动视图内容的跳转
    currentTeam++;
    
    currentTeam = currentTeam % teamImageArray.count;
    
    CGFloat xOffset = (240 + 6) * currentTeam;
    CGFloat maxOffset = hotTeamCollectionView.contentSize.width -APP_WIDTH-6;
    if (xOffset > maxOffset) {
        xOffset = maxOffset;
    }
    CGPoint point = CGPointMake(xOffset, 0);
    [hotTeamCollectionView setContentOffset:point animated:YES];
    [self teamProgressMove];
}

- (void)teamTimerPause
{
    if (teamTimer && teamTimer.isValid)
    {
        teamTimer.fireDate = [NSDate distantFuture];
    }
}

- (void)teamTimerStop
{
    if (teamTimer && teamTimer.isValid)
    {
        // 无效化
        [teamTimer invalidate];
        teamTimer = nil;
    }
}

- (void)teamProgressMove {
    NSInteger count = teamImageArray.count;
    CGFloat width = APP_WIDTH/count;
    NSInteger current = currentTeam%count;
    CGPoint oldPosition = hotTeamProgressLayer.position;
    CGPoint newPoint = CGPointMake(width*current+width/2, oldPosition.y);
    [self moveAnimation:hotTeamProgressLayer position:newPoint];
}


- (void)moveAnimation:(CALayer *)layer position:(CGPoint)newPosition {
    CABasicAnimation * basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    basicAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
    basicAnimation.autoreverses = NO;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.duration = 0.5;
    [layer addAnimation:basicAnimation forKey:nil];
}


#pragma mark - UI
- (void)setUpUI {
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    mainScrollView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0];
    mainScrollView.showsVerticalScrollIndicator = false;
   
    [self addCollectionView];
    [self addLabel];
    [self addButton];
    [self addProgressLayer];
    
    [self.view addSubview:mainScrollView];

}

- (void)addCollectionView{
    
    UICollectionViewFlowLayout * topAdLayout = [self flowLayoutItemSize:CGSizeMake(APP_WIDTH, 280) lineSpace:0];
    topAdCollectionView = [self collectionViewFrame:CGRectMake(0, 0, APP_WIDTH, 280) layOut:topAdLayout nibName:@"MainPageTopAdCell" identifier:topAdCellIdentifier];
    
//    topAdCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 280) collectionViewLayout:topAdLayout];
//    topAdCollectionView.backgroundColor = [UIColor whiteColor];
//    [topAdCollectionView registerNib:[UINib nibWithNibName:@"MainPageTopAdCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:topAdCellIdentifier];
//    topAdCollectionView.delegate = self;
//    topAdCollectionView.dataSource = self;
    topAdCollectionView.pagingEnabled = YES;
    
    UICollectionViewFlowLayout * activityLayout = [self flowLayoutItemSize:CGSizeMake(180, 180) lineSpace:7];
    activityCollectionView = [self collectionViewFrame:CGRectMake(0, CGRectGetMaxY(topAdCollectionView.frame)+55, APP_WIDTH, 180) layOut:activityLayout nibName:@"MainPageActivityCell" identifier:activityCellIdentifier];
    
//    activityCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topAdCollectionView.frame)+55, APP_WIDTH, 180) collectionViewLayout:activityLayout];
//    [activityCollectionView registerNib:[UINib nibWithNibName:@"MainPageActivityCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:activityCellIdentifier];
//    activityCollectionView.backgroundColor = [UIColor whiteColor];
//    activityCollectionView.delegate =self;
//    activityCollectionView.dataSource = self;

    
    
    UICollectionViewFlowLayout * hotTeamLayout = [self flowLayoutItemSize:CGSizeMake(240, 280) lineSpace:6];
    hotTeamCollectionView = [self collectionViewFrame:CGRectMake(0, CGRectGetMaxY(activityCollectionView.frame)+55, APP_WIDTH, 280) layOut:hotTeamLayout nibName:@"TeamsCell" identifier:hotTeamIdentifier];
    
//    hotTeamCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(activityCollectionView.frame)+55, APP_WIDTH, 280) collectionViewLayout:hotTeamLayout];
//    [hotTeamCollectionView registerNib:[UINib nibWithNibName:@"TeamsCell" bundle:nil] forCellWithReuseIdentifier:hotTeamIdentifier];
//    hotTeamCollectionView.backgroundColor = [UIColor whiteColor];
//    hotTeamCollectionView.delegate = self;
//    hotTeamCollectionView.dataSource = self;

    
    [mainScrollView addSubview:topAdCollectionView];
    [mainScrollView addSubview:activityCollectionView];
    [mainScrollView addSubview:hotTeamCollectionView];
    
    
    mainScrollView.contentSize = CGSizeMake(APP_WIDTH, CGRectGetMaxY(hotTeamCollectionView.frame) + 12);
}

- (void)addLabel {
    CGFloat adCollectionY =  CGRectGetMaxY(topAdCollectionView.frame);
    UILabel * activityLabel = [self labelWithFrame:CGRectMake(0,adCollectionY+12, APP_WIDTH, 44) text:@"精彩活动"];
    CGFloat activityY = CGRectGetMaxY(activityCollectionView.frame);
    UILabel * hotTeamLabel = [self labelWithFrame:CGRectMake(0, activityY+12, APP_WIDTH, 44) text:@"热门团队"];
    
    [mainScrollView addSubview:activityLabel];
    [mainScrollView addSubview:hotTeamLabel];
    
}

- (void)addButton {
    
    UIImageView * coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 50)];
    
    UIImage * oldImage = [UIImage imageNamed:@"bg_toolbar@2x"];
    UIImage * newImage = [oldImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    coverImage.image = newImage;
    
    [mainScrollView addSubview:coverImage];
    
    searchButton = [self buttonWithFrame:CGRectMake(APP_WIDTH-50-18, 220, 50, 50) bgImage:[UIImage imageNamed:@"ic_search@2x.png"]];
    [mainScrollView addSubview:searchButton];
    
    scannerButton = [self buttonWithFrame:CGRectMake(APP_WIDTH - 38, 15, 20, 20) bgImage:[UIImage imageNamed:@"ic_scan"]];
    
    
    [mainScrollView addSubview:scannerButton];
    
    locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [locationButton setTitle:@"成都 " forState:UIControlStateNormal];
    [locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [locationButton setImage:[UIImage imageNamed:@"ic_triangle@2x"] forState:UIControlStateNormal];
    locationButton.transform = CGAffineTransformMakeScale(-1,1);
    locationButton.titleLabel.transform = CGAffineTransformMakeScale(-1, 1);
    locationButton.imageView.transform = CGAffineTransformMakeScale(-1, 1);
    
    CGSize size = [locationButton sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
    
    [locationButton setFrame:CGRectMake(18, 15, size.width, 20)];
    
    [mainScrollView addSubview:locationButton];
    
}

- (void)addProgressLayer {
    UIColor * bgColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
    UIColor * progressColor = [UIColor colorWithRed:226.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    
    CALayer * adProgressLayer = [self layerWithFrame:CGRectMake(0, 280, APP_WIDTH, 2) color:bgColor];
    topAdProgressLayer = [self layerWithFrame:CGRectMake(0, 280, APP_WIDTH/topAdImageArray.count, 2) color:progressColor];
    
    CALayer * activityLayer = [self layerWithFrame:CGRectMake(0, 280+180+55, APP_WIDTH, 2) color:bgColor];
    activityProgressLayer = [self layerWithFrame:CGRectMake(0, 280+180+55, APP_WIDTH/activityImageArray.count, 2) color:progressColor];
    
    CALayer * teamLayer = [self layerWithFrame:CGRectMake(0, 280+180+55+55+280, APP_WIDTH, 2) color:bgColor];
    hotTeamProgressLayer = [self layerWithFrame:CGRectMake(0, 280+180+55+55+280, APP_WIDTH/teamImageArray.count, 2) color:progressColor];
    
    [mainScrollView.layer addSublayer:adProgressLayer];
    [mainScrollView.layer addSublayer:topAdProgressLayer];
    [mainScrollView.layer addSublayer:activityLayer];
    [mainScrollView.layer addSublayer:activityProgressLayer];
    
    [mainScrollView.layer addSublayer:teamLayer];
    [mainScrollView.layer addSublayer:hotTeamProgressLayer];
    
}

- (CALayer *)layerWithFrame:(CGRect)frame color:(UIColor*)bgColor {
    CALayer * layer = [CALayer layer];
    layer.frame = frame;
    layer.backgroundColor = bgColor.CGColor;
    return layer;
}
- (UICollectionViewFlowLayout *)flowLayoutItemSize:(CGSize)size lineSpace:(CGFloat)space {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = size;
    layout.minimumLineSpacing = space;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}

- (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text {
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    return label;
}

- (UIButton *)buttonWithFrame:(CGRect)frame bgImage:(UIImage *)image {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UICollectionView *)collectionViewFrame:(CGRect)frame layOut:(UICollectionViewFlowLayout *)layOut nibName:(NSString *)name identifier:(NSString *)identifier{
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layOut];
    [collectionView registerNib:[UINib nibWithNibName:name bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = false;
    return collectionView;
}

@end
