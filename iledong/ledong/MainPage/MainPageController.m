//
//  MainPageController.m
//  ledong
//
//  Created by dongguoju on 16/2/29.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "MainPageController.h"
#import "SearchViewController.h"
#import "ScanViewController.h"
#import "FRUtils.h"
#import "LDActivityViewController.h"
#import "LDTeamViewController.h"
#import "LDMainPageTeamTableViewCell.h"

#import "LDLocationManager.h"
#import "TeamHomeViewController.h"

static NSString * const topAdCellIdentifier = @"TopAdCell";
static NSString * const activityCellIdentifier = @"ActivityCell";
static NSString * const hotTeamIdentifier = @"hotTeamCell";
static NSString * const teamMoreIdentifier = @"teamMoreCell";


static CGFloat const adHeight = 280;
static CGFloat const activityHeight = 180;
static CGFloat const teamHeight = 280;

@interface MainPageController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    
    LDLocationManager * location;
    
    
    NSTimer *topAdTimer;
    NSInteger currentAd;
    NSMutableArray *topAdImageArray;
    //精彩活动
    NSTimer *activityTimer;
    NSInteger currentActivity;
    NSMutableArray * activityArray;
    //热门团队
    
    NSTimer *teamTimer;
    NSInteger currentTeam;
    NSMutableArray * teamArray;
    
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
    
    UIImage * moreImage;
    
    NSDictionary * locationInfo;
    
    NSString * cityCode;

    
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
    moreImage = [self moreTeamImage];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    
    
    topAdImageArray = [NSMutableArray array];

    
    activityArray = [NSMutableArray array];
    teamArray = [NSMutableArray array];
    [self setUpUI];
    //30.6509086063,104.0693664551
//    [self requestLocationInfo:30.6509086063 longitude:104.0693664551];
    
    [self requestActivityData];
    [self requestAdData];
    [self requestTeamData:5];

    [self getLocationInfo];
 
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
   
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self adTimerStop];
    [self activityTimerStop];
    [self teamTimerStop];
}


#pragma mark - netWork 

- (void)requestAdData {
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [requestManager GET:@"Config/FeaturesImages" parameters:@{} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * resultDic = (NSDictionary *)responseObject;
        NSInteger code = [resultDic[@"code"] integerValue];
        if (code != 0) {
            return ;
        }
        NSArray * resultArray = resultDic[@"result"];
        topAdImageArray = [resultArray copy];
   
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addAdProgress];
            [self adTimerStart];
            [topAdCollectionView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}

- (void)requestActivityData {
//    NSString * token =[HttpClient getTokenStr];
//    if (token.length == 0) {
//        [activityCollectionView reloadData];
//        return;
//    }
    
//    NSDictionary * dic = @{
//                           @"token":token
//                           };
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [requestManager GET:@"ActivityClass/GetActivityClass" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * resultDic = (NSDictionary *)responseObject;
        NSInteger code = [resultDic[@"code"] integerValue];
        if (code != 0) {
            return ;
        }
        activityArray = [resultDic[@"result"] copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addActivityProgress];
            [self activityTimerStart];
            [activityCollectionView reloadData];
        });
        
    }
    failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)requestTeamData:(int)count {
    NSDictionary * dic = @{
                           @"count":[NSNumber numberWithInt:count]
                           };
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [requestManager GET:@"Team/GetHotTeams" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * resultDic = (NSDictionary *)responseObject;
        NSInteger code = [[resultDic objectForKey:@"code"] integerValue];
        if (code != 0) {
            [hotTeamCollectionView reloadData];
            return ;
        }
        NSArray * resultArr = [resultDic objectForKey:@"result"];
        teamArray = [resultArr copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addTeamProgress];
            [self teamTimerStart];
            [hotTeamCollectionView reloadData];
        });
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}


- (void)requestLocationInfo:(double)latitude longitude:(double)longitude {
    NSDictionary * dic = @{
                           @"lng":[NSNumber numberWithDouble:longitude],
                           @"lat":[NSNumber numberWithDouble:latitude]
                           };
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [manager POST:@"map/Geolocate" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code != 0) {
            return ;
        }
        NSDictionary * result = [dic objectForKey:@"result"];
        if (result == nil) {
            return;
        }
        
        locationInfo = [result objectForKey:@"addressComponent"];
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSString * detailAddress = [result objectForKey:@"formatted_address"];
//            NSDictionary * latlon = [result objectForKey:@"location"];
//            NSDictionary * locationTemp = [result objectForKey:@"addressComponent"];
//            [FRUtils setAddressDetail:detailAddress];
//            [FRUtils setUserLatitudeLongitude:latlon];
//            [self saveLocationInfo:locationInfo];
            
//        });
    
        dispatch_async(dispatch_get_main_queue(), ^{
            cityCode = [locationInfo objectForKey:@"citycode"];
            NSString * city = [locationInfo objectForKey:@"city"];
            [locationButton setTitle:city forState:UIControlStateNormal];
            CGSize size = [locationButton sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
            [locationButton setFrame:CGRectMake(18, 15, size.width, 20)];
        });
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        [SVProgressHUD showErrorWithStatus:@"请求数据失败"];
    }];
}



#pragma mark - ButtonClick

- (void)buttonClicked:(UIButton *)sender {
    if ([sender isEqual:locationButton]) {
        AdressCityVC *adressCityVC = [[AdressCityVC alloc] init];
        adressCityVC.locationResult = ^(NSDictionary *city) {
            cityCode = [city objectForKey:@"Code"];
            NSString * title = [city objectForKey:@"Name"];
            [locationButton setTitle:title forState:UIControlStateNormal];
            CGSize size = [locationButton sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
            [locationButton setFrame:CGRectMake(18, 15, size.width, 20)];
        };
//        adressCityVC.isSearch= YES;
        adressCityVC.locationDic = locationInfo;
        adressCityVC.destinationVc = self;
        adressCityVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:adressCityVC animated:YES];
    } else if ([sender isEqual:scannerButton]) {
        ScanViewController *scanViewController = [[ScanViewController alloc] init];
        scanViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scanViewController animated:YES];
    } else {
        SearchViewController *searchViewController = [[SearchViewController alloc] init];
        searchViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchViewController animated:YES];
    }
}

- (void)getLocationInfo {
    location = [[LDLocationManager alloc] init];
    [location getLocationSuccess:^(NSDictionary * locationDic) {
        double longitude = [[locationDic objectForKey:@"longitude"] doubleValue];
        double latitude = [[locationDic objectForKey:@"latitude"] doubleValue];
        [self requestLocationInfo:latitude longitude:longitude];
        
    } fail:^(NSError * error) {
        
    }];
}


#pragma mark - CollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:topAdCollectionView]) {
        return topAdImageArray.count;
    } else if ([collectionView isEqual:activityCollectionView]) {
        return MIN(3, activityArray.count+1);
    }
    return MIN(6, teamArray.count+1);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:topAdCollectionView]) {
        return [self topAdCell:collectionView indexPath:indexPath];
        
    } else if ([collectionView isEqual:activityCollectionView]) {
        return [self activityCell:collectionView indexPath:indexPath];
        
    }
    if (indexPath.row == MIN(5, teamArray.count)) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:teamMoreIdentifier forIndexPath:indexPath];
        UIImageView * imageView = (UIImageView *)[cell viewWithTag:2];
        imageView.image = moreImage;
        return cell;
    }
    return [self teamCell:collectionView indexPath:indexPath];

    
}

- (UICollectionViewCell *)topAdCell:(UICollectionView *) collectionView indexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * topAdCell = [collectionView dequeueReusableCellWithReuseIdentifier:topAdCellIdentifier forIndexPath:indexPath];
    UIImageView * imageView = (UIImageView *)[topAdCell viewWithTag:2];
    NSString * imgUrl = [NSString stringWithFormat:@"%@%@",API_BASE_URL,topAdImageArray[indexPath.row]];
    NSURL * url = [NSURL URLWithString:imgUrl];
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_1"]];
    return topAdCell;
}

- (UICollectionViewCell *)activityCell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * activityCell = [collectionView dequeueReusableCellWithReuseIdentifier:activityCellIdentifier forIndexPath:indexPath];
    UIImageView * imageView = (UIImageView *)[activityCell viewWithTag:2];
    UILabel * label = (UILabel *)[activityCell viewWithTag:3];
    if (indexPath.row == MIN(2, activityArray.count)) {
        imageView.image = [UIImage imageNamed:@"img_morebg"];
        label.text = @"更多";
    }
    else
    {
        NSDictionary * dic = activityArray[indexPath.row];
        [imageView sd_setImageWithURL:dic[@"CoverUrl"] placeholderImage:[UIImage imageNamed:@"img_3"]];
        label.text = dic[@"ClassName"];
        
    }
    return activityCell;
}

- (LDMainPageTeamTableViewCell *)teamCell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    
    LDMainPageTeamTableViewCell *cell = (LDMainPageTeamTableViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:hotTeamIdentifier forIndexPath:indexPath];
    NSDictionary * dic = teamArray[indexPath.row];
    NSString * teamImage = [dic objectForKey:@"AvatarUrl"];
    NSURL * teamUrl = [NSURL URLWithString:teamImage];
    NSString * captainImage = [dic objectForKey:@"CaptainLogo"];
    NSString * captainStr = [NSString stringWithFormat:@"%@%@",API_BASE_URL,[captainImage substringFromIndex:3]];
    NSURL * capatinUrl = [NSURL URLWithString:captainStr];
    NSString * captainName = [dic objectForKey:@"CaptainName"];
    NSString * teamConcern = [dic objectForKey:@"Concern"];
    NSString * teamName = [dic objectForKey:@"Name"];
    
    NSString * teamMember = [dic objectForKey:@"PersonNum"];
    
    NSString * area = [dic objectForKey:@"Area"];
    NSString * teamClass = [dic objectForKey:@"ClassName"];
    
    [cell.teamImageView sd_setImageWithURL:teamUrl placeholderImage:[UIImage imageNamed:@"img_2@2x"]];
    [cell.teamCaptainImage sd_setImageWithURL:capatinUrl placeholderImage:[UIImage imageNamed:@"user01_44@2x"]];
    cell.teamCaptain.text = captainName;
    cell.teamConcernLabel.text = [NSString stringWithFormat:@"%@人关注",teamConcern];
    cell.teamNameLabel.text = teamName;
    cell.teamDeatilLabel.text = [NSString stringWithFormat:@"%@ %@ %@",teamMember,area,teamClass];
    return cell;
}

#pragma mark - collectionDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:topAdCollectionView]) {
        NSLog(@"ad: %ld",(long)indexPath.row);
        
    } else if ([collectionView isEqual:activityCollectionView]) {
        [self activitySeleted:indexPath.row];
        
    } else if ([collectionView isEqual:hotTeamCollectionView]) {
        [self teamSeleted:indexPath.row];
    }
}

- (void)activitySeleted:(NSInteger)row{
    LDActivityViewController * activityVC = [[LDActivityViewController alloc] init];
    if (row == MIN(2, activityArray.count)) {
        activityVC.activityId = 0;
        activityVC.activityClassName = @"更多";
    }
    else {
        NSDictionary * dic = activityArray[row];
        activityVC.activityClassName = [dic objectForKey:@"ClassName"];
        activityVC.activityId = [[dic objectForKey:@"Id"] integerValue];
    }
    activityVC.activityClassArray = [activityArray copy];
    activityVC.hidesBottomBarWhenPushed = YES;
//    activityVC.locationDic = locationInfo;
    activityVC.cityCode = cityCode;
    [self.navigationController pushViewController:activityVC animated:YES];
}

- (void)teamSeleted:(NSInteger)row {
    if (row == MIN(5, teamArray.count)) {
        LDTeamViewController * teamVc = [[LDTeamViewController alloc] init];
         teamVc.activityArray = [activityArray copy];
        teamVc.hidesBottomBarWhenPushed = YES;
//        teamVc.locationDic = locationInfo;
        teamVc.cityCode = cityCode;
        [self.navigationController pushViewController:teamVc animated:YES];
    }
    else
    {
        TeamHomeViewController * teamVc = [[TeamHomeViewController alloc] init];
        teamVc.hidesBottomBarWhenPushed = YES;
        NSDictionary * dic = teamArray[row];
        NSString * teamId = [dic objectForKey:@"Id"];
        teamVc.teamId = teamId;
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
    currentAd = currentAd %topAdImageArray.count;
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
    currentActivity = currentActivity % MIN(activityArray.count+1, 3);
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
    NSInteger count = MIN(activityArray.count+1, 3);
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
    
    currentTeam = currentTeam % MIN(teamArray.count+1, 6);
    
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
    NSInteger count = MIN(teamArray.count+1, 6);
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
    
    [self.view addSubview:mainScrollView];

}

- (void)addCollectionView{
    
    UICollectionViewFlowLayout * topAdLayout = [self flowLayoutItemSize:CGSizeMake(APP_WIDTH, adHeight) lineSpace:0];
    topAdCollectionView = [self collectionViewFrame:CGRectMake(0, 0, APP_WIDTH, adHeight) layOut:topAdLayout nibName:@"MainPageTopAdCell" identifier:topAdCellIdentifier];
    
    UICollectionViewFlowLayout * activityLayout = [self flowLayoutItemSize:CGSizeMake(180, 180) lineSpace:7];
    activityCollectionView = [self collectionViewFrame:CGRectMake(0, CGRectGetMaxY(topAdCollectionView.frame)+55, APP_WIDTH, activityHeight) layOut:activityLayout nibName:@"MainPageActivityCell" identifier:activityCellIdentifier];
    

    UICollectionViewFlowLayout * hotTeamLayout = [self flowLayoutItemSize:CGSizeMake(240, teamHeight) lineSpace:6];
    hotTeamCollectionView = [self collectionViewFrame:CGRectMake(0, CGRectGetMaxY(activityCollectionView.frame)+55, APP_WIDTH, teamHeight) layOut:hotTeamLayout nibName:@"LDMainPageTeamTableViewCell" identifier:hotTeamIdentifier];
    [hotTeamCollectionView registerNib:[UINib nibWithNibName:@"MainPageTeamMoreCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:teamMoreIdentifier];
    
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

- (void)addAdProgress {
    UIColor * bgColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
    UIColor * progressColor = [UIColor colorWithRed:226.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    
//    NSInteger count = MIN(<#A#>, <#B#>)
    CALayer * adProgressLayer = [self layerWithFrame:CGRectMake(0, adHeight, APP_WIDTH, 2) color:bgColor];
    topAdProgressLayer = [self layerWithFrame:CGRectMake(0, adHeight, APP_WIDTH/topAdImageArray.count, 2) color:progressColor];

    [mainScrollView.layer addSublayer:adProgressLayer];
    [mainScrollView.layer addSublayer:topAdProgressLayer];
}

- (void)addActivityProgress {
    NSInteger count = MIN(activityArray.count +1, 3);
    UIColor * bgColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
    UIColor * progressColor = [UIColor colorWithRed:226.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    CALayer * activityLayer = [self layerWithFrame:CGRectMake(0, adHeight+activityHeight+55, APP_WIDTH, 2) color:bgColor];
    activityProgressLayer = [self layerWithFrame:CGRectMake(0, adHeight+activityHeight+55, APP_WIDTH/count, 2) color:progressColor];
    [mainScrollView.layer addSublayer:activityLayer];
    [mainScrollView.layer addSublayer:activityProgressLayer];
}

- (void)addTeamProgress {
    NSInteger count = MIN(teamArray.count +1, 6);
    UIColor * bgColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
    UIColor * progressColor = [UIColor colorWithRed:226.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    CALayer * teamLayer = [self layerWithFrame:CGRectMake(0, adHeight+activityHeight+55+55+teamHeight, APP_WIDTH, 2) color:bgColor];
    hotTeamProgressLayer = [self layerWithFrame:CGRectMake(0, adHeight+activityHeight+55+55+teamHeight, APP_WIDTH/count, 2) color:progressColor];
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

- (UIImage *)moreTeamImage {
    UIImage * image;
    UIGraphicsBeginImageContext(CGSizeMake(240, 280));
    UIImage * oldImage = [UIImage imageNamed:@"img_morebg"];
    [oldImage drawInRect:CGRectMake(0, 0, 240, 280)];
    
    NSDictionary * dic = @{
                           NSFontAttributeName:[UIFont systemFontOfSize:20],
                           NSForegroundColorAttributeName:[UIColor whiteColor]
                           };
    NSAttributedString * attr = [[NSAttributedString alloc] initWithString:@"更多" attributes:dic];
    [attr drawAtPoint:CGPointMake(100, 120)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

@end
