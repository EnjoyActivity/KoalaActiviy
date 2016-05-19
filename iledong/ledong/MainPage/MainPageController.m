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

//static NSString * const reuseIdentifier = @"teamCell";
static NSString * const topAdCellIdentifier = @"TopAdCell";
static NSString * const activityCellIdentifier = @"ActivityCell";
static NSString * const hotTeamIdentifier = @"teamCell";
@interface MainPageController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    
    NSTimer *_timer;
    NSInteger _currentPageIndex;
    NSMutableArray *_imageNamed;
    //精彩活动
    NSTimer *activTimer;
    NSInteger activPageIndex;
    NSMutableArray *activImageArr;
    NSMutableArray *activeImageName;
    //热门团队
    NSTimer *teamTimer;
    NSInteger teamPageIndex;
    NSMutableArray *teamImageArr;
    NSMutableArray *headImageArr;
    
    UIScrollView * mainScrollView;
    UICollectionView * hotTeamCollectionView;
    UICollectionView * activityCollectionView;
    UICollectionView * topAdCollectionView;
    
    UIButton * locationButton;
    UIButton * scannerButton;
    UIButton * searchButton;
    
    
    
    
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *bannerScroll;

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
    [self setUpUI];
    self.view.backgroundColor = [UIColor whiteColor];
//    
//    self.mainScrollView.contentSize = CGSizeMake(APP_WIDTH, _activityScrollView.frame.size.height + _activView.frame.size.height + _bannerScroll.frame.size.height + _teamView.frame.size.height + _collectionView.frame.size.height + 220);
//    
    self.navigationController.navigationBarHidden = YES;
    //注册celll
//    [self.collectionView registerClass:[TeamsCell class] forCellWithReuseIdentifier:reuseIdentifier];//类文件
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.collectionView registerNib:[UINib nibWithNibName:@"TeamsCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier]; //xib
    
//    [self.searchButton setImage:[UIImage imageNamed:@"ic_search@2x.png"] forState:UIControlStateNormal];
//    [self.searchButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [self.addressButton setImage:[UIImage imageNamed:@"ic_triangle"] forState:UIControlStateNormal];
//    [self.ScanButton setImage:[UIImage imageNamed:@"ic_scan"] forState:UIControlStateNormal];
//    [self.ScanButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    
//    [self.addressButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -70)];
//    [self.addressButton setTitle:@"成都" forState:UIControlStateNormal];
//    [self.addressButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    _imageNamed = [NSMutableArray arrayWithObjects:@"img_1",@"img_1b", nil];
    activImageArr = [NSMutableArray arrayWithObjects:@"img_3",@"img_4",@"img_morebg", nil];
    activeImageName = [NSMutableArray arrayWithObjects:@"篮球",@"足球",@"更多", nil];
    teamImageArr = [NSMutableArray arrayWithObjects:@"img_3",@"img_4",@"img_5",@"img_6",@"img_2", nil];
    headImageArr = [NSMutableArray arrayWithObjects:@"user01_44",@"user02_44",@"user01_44",@"user02_44",@"user01_44", nil];
//    [self loadViewData];
//    [self showActivityScrollView];
//    [self teamShowImage];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
//    [self startTimer];
//    [self startTimerActiv];
//    [self teamStartImage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self pauseTimer];
//    [self activPauseTimer];
//    [self teamPauseTimer];
}

#pragma mark -- ButtonClick

//- (IBAction)adressCityButton:(UIButton *)sender
//{
//    AdressCityVC *adressCityVC = [[AdressCityVC alloc] init];
//    [self.navigationController pushViewController:adressCityVC animated:YES];
//}
//
//- (IBAction)scanButton:(UIButton *)sender
//{
//    ScanViewController *scanViewController = [[ScanViewController alloc] init];
//    [self.navigationController pushViewController:scanViewController animated:YES];
//}
//
//- (IBAction)searchButton:(UIButton *)sender
//{
//    SearchViewController *searchViewController = [[SearchViewController alloc] init];
//    [self.navigationController pushViewController:searchViewController animated:YES];
//}

#pragma mark -- banner & team & activ动画

//- (void)loadViewData
//{
//    _bannerScroll.pagingEnabled = YES;
//    _bannerScroll.contentOffset = CGPointZero;
//    _bannerScroll.contentSize = CGSizeMake(_bannerScroll.frame.size.width * _imageNamed.count, 0);
//    for (int i = 0; i < [_imageNamed count]; i++)
//    {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(APP_WIDTH * i, 0, APP_WIDTH, _bannerScroll.frame.size.height)];
//        imageView.image = [FRUtils resizeImageWithImageName:_imageNamed[i]];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_bannerScroll addSubview:imageView];
//    }
//    _bannerScroll.showsHorizontalScrollIndicator = FALSE;
//    [self startTimer];
//}

- (void)startTimer
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(respondsToTimer:) userInfo:nil repeats:YES];
    }
    _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2.0];
}

- (void)pauseTimer
{
    if (_timer && _timer.isValid)
    {
        _timer.fireDate = [NSDate distantFuture];
    }
}

- (void)stopTimer
{
    if (_timer && _timer.isValid)
    {
        // 无效化
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)respondsToTimer:(NSTimer *)timer
{
    // 滚动视图内容的跳转
    _currentPageIndex = ++_currentPageIndex % [_imageNamed count];
    CGPoint point = CGPointMake(_bannerScroll.frame.size.width * _currentPageIndex, 0);
    [_bannerScroll setContentOffset:point animated:YES];
}

////精彩活动ScrollView
//- (void)showActivityScrollView
//{
//    self.activityScrollView.pagingEnabled = YES;
//    self.activityScrollView.contentOffset = CGPointZero;
//    self.activityScrollView.contentSize  = CGSizeMake((180 + 6) * activImageArr.count, 0);
//    for (int i = 0; i < activImageArr.count; i++)
//    {
//        UIImageView *activImageView = [[UIImageView alloc] initWithFrame:CGRectMake((180 + 6) * i, 0, 180, 180)];
//        activImageView.image = [FRUtils resizeImageWithImageName:activImageArr[i]];
//        activImageView.contentMode = UIViewContentModeScaleAspectFit;
//        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((180 + 6) * i, 0, 180, 180)];
//        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((180 + 6) * i, 0, 180, 180)];
//        bgImageView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
//        nameLabel.text = activeImageName[i];
//        nameLabel.font = [UIFont systemFontOfSize:18];
//        nameLabel.textColor = [UIColor whiteColor];
//        nameLabel.textAlignment = UITextAlignmentCenter;
//        [self.activityScrollView addSubview:activImageView];
//        [self.activityScrollView addSubview:bgImageView];
//        [self.activityScrollView addSubview:nameLabel];
//    }
//    self.activityScrollView.showsHorizontalScrollIndicator = FALSE;
//    [self startTimerActiv];
//}

- (void)startTimerActiv
{
    if (!activTimer)
    {
        activTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(activRespondsToTimer:) userInfo:nil repeats:YES];
    }
    activTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2.0];
}

//- (void)activRespondsToTimer:(NSTimer *)timer
//{
//    // 滚动视图内容的跳转
//    activPageIndex = ++activPageIndex % [activImageArr count];
//    CGPoint point = CGPointMake((180 + 6) * activPageIndex, 0);
//    [_activityScrollView setContentOffset:point animated:YES];
//}

- (void)activPauseTimer
{
    if (activTimer && activTimer.isValid)
    {
        activTimer.fireDate = [NSDate distantFuture];
    }
}

- (void)activStopTimer
{
    if (activTimer && activTimer.isValid)
    {
        // 无效化
        [activTimer invalidate];
        activTimer = nil;
    }
}

////热门团队
//- (void)teamShowImage
//{
//    _collectionView.pagingEnabled = YES;
//    _collectionView.contentOffset = CGPointZero;
//    _collectionView.contentSize  = CGSizeMake((240 + 6) * teamImageArr.count, 0);
//    _collectionView.showsHorizontalScrollIndicator = FALSE;
//    [self teamStartImage];
//}

- (void)teamStartImage
{
    if (!teamTimer)
    {
        teamTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(teamRespondsToTimer:) userInfo:nil repeats:YES];
    }
    teamTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
}

//- (void)teamRespondsToTimer:(NSTimer *)timer
//{
//    // 滚动视图内容的跳转
//    teamPageIndex = ++teamPageIndex % [teamImageArr count];
//    CGPoint point = CGPointMake((240 + 6) * teamPageIndex, 0);
//    [_collectionView setContentOffset:point animated:YES];
//    
//}

- (void)teamPauseTimer
{
    if (teamTimer && teamTimer.isValid)
    {
        teamTimer.fireDate = [NSDate distantFuture];
    }
}

- (void)teamStopTimer
{
    if (teamTimer && teamTimer.isValid)
    {
        // 无效化
        [teamTimer invalidate];
        teamTimer = nil;
    }
}

#pragma mark -- CollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:topAdCollectionView]) {
        return _imageNamed.count;
    } else if ([collectionView isEqual:activityCollectionView]) {
        return activImageArr.count;
    }
    return teamImageArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:topAdCollectionView]) {
        UICollectionViewCell * topAdCell = [collectionView dequeueReusableCellWithReuseIdentifier:topAdCellIdentifier forIndexPath:indexPath];
        UIImageView * imageView = (UIImageView *)[topAdCell viewWithTag:2];
        imageView.image = [UIImage imageNamed:_imageNamed[indexPath.row]];
        return topAdCell;
                           
    } else if ([collectionView isEqual:activityCollectionView]) {
        UICollectionViewCell * activityCell = [collectionView dequeueReusableCellWithReuseIdentifier:activityCellIdentifier forIndexPath:indexPath];
        UIImageView * imageView = (UIImageView *)[activityCell viewWithTag:2];
        imageView.image = [UIImage imageNamed:activImageArr[indexPath.row]];
        return activityCell;
    }
    TeamsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotTeamIdentifier forIndexPath:indexPath];
    cell.teamImageView.image = [FRUtils resizeImageWithImageName:teamImageArr[indexPath.row]];
    cell.headerImage.image = [FRUtils resizeImageWithImageName:headImageArr[indexPath.row]];
    return cell;
}

#pragma mark -- srcollViewDelegate
//滑动scrollView
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    if (scrollView == _bannerScroll)
//    {
//        [self pauseTimer];
//    }
//    else if (scrollView == _activityScrollView)
//    {
//        [self activPauseTimer];
//    }
//    else if (scrollView == _collectionView)
//    {
//        [self teamPauseTimer];
//    }
//    
//}

// 开始滚动
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView == _bannerScroll)
//    {
//        // 计算当前页数索引
//        _currentPageIndex = round(scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds));
//    }
//    else if (scrollView == _activityScrollView)
//    {
//        activPageIndex = round(scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds));
//    }
//    else if (scrollView == _collectionView)
//    {
//        teamPageIndex = round(scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds));
//    }
//    // 更新分页控件当前页
//    //    _pageControl.currentPage = _currentPageIndex;
//}

#pragma mark - UI
- (void)setUpUI {
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    mainScrollView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0];
   
    [self addCollectionView];
    [self addLabel];
    [self addButton];
    
    [self.view addSubview:mainScrollView];
    
}

- (void)addCollectionView{
    
    UICollectionViewFlowLayout * topAdLayout = [self flowLayoutItemSize:CGSizeMake(APP_WIDTH, 280) lineSpace:0];
    topAdCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 280) collectionViewLayout:topAdLayout];
    topAdCollectionView.backgroundColor = [UIColor whiteColor];
    [topAdCollectionView registerNib:[UINib nibWithNibName:@"MainPageTopAdCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:topAdCellIdentifier];
    topAdCollectionView.delegate = self;
    topAdCollectionView.dataSource = self;
    
    UICollectionViewFlowLayout * activityLayout = [self flowLayoutItemSize:CGSizeMake(180, 180) lineSpace:7];
    activityCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topAdCollectionView.frame)+55, APP_WIDTH, 180) collectionViewLayout:activityLayout];
    [activityCollectionView registerNib:[UINib nibWithNibName:@"MainPageActivityCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:activityCellIdentifier];
    activityCollectionView.backgroundColor = [UIColor whiteColor];
    activityCollectionView.delegate =self;
    activityCollectionView.dataSource = self;
    
    
    UICollectionViewFlowLayout * hotTeamLayout = [self flowLayoutItemSize:CGSizeMake(240, 280) lineSpace:6];
    hotTeamCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(activityCollectionView.frame)+55, APP_WIDTH, 280) collectionViewLayout:hotTeamLayout];
    [hotTeamCollectionView registerNib:[UINib nibWithNibName:@"TeamsCell" bundle:nil] forCellWithReuseIdentifier:hotTeamIdentifier];
    hotTeamCollectionView.backgroundColor = [UIColor whiteColor];
    hotTeamCollectionView.delegate = self;
    hotTeamCollectionView.dataSource = self;
    
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
    scannerButton = [self buttonWithFrame:CGRectMake(APP_WIDTH - 38, 15, 20, 20) bgImage:[UIImage imageNamed:@"ic_scan"]];
    
    [mainScrollView addSubview:searchButton];
    [mainScrollView addSubview:scannerButton];
    
    locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [locationButton setTitle:@"成都 " forState:UIControlStateNormal];
    [locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(location:) forControlEvents:UIControlEventTouchUpInside];
    
    [locationButton setImage:[UIImage imageNamed:@"ic_triangle@2x"] forState:UIControlStateNormal];
    locationButton.transform = CGAffineTransformMakeScale(-1,1);
    locationButton.titleLabel.transform = CGAffineTransformMakeScale(-1, 1);
    locationButton.imageView.transform = CGAffineTransformMakeScale(-1, 1);
    
    CGSize size = [locationButton sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
    
    [locationButton setFrame:CGRectMake(18, 15, size.width, 20)];
    
    [mainScrollView addSubview:locationButton];
    
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
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}


@end
