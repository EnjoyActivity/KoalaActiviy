//
//  SplashViewController.m
//  ledong
//
//  Created by luojiao  on 16/3/25.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "SplashViewController.h"
#import "FRUtils.h"

@interface SplashViewController ()
{
    NSArray *imageArr;
    UIButton *loginButton;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation SplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageArr = [[NSArray alloc] initWithObjects:@"start", nil];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.contentOffset = CGPointZero;
    _scrollView.contentSize = CGSizeMake(APP_WIDTH * imageArr.count, 0);
    for (int i = 0; i < [imageArr count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(APP_WIDTH * i, 0, APP_WIDTH, _scrollView.frame.size.height)];
        imageView.image = [UIImage imageNamed:imageArr[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:imageView];
    }
    _scrollView.showsHorizontalScrollIndicator = FALSE;
    
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(0 , 0, 100, 30)];
    if (IS_IPHONE_4)
    {
        [loginButton setCenter:CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) * [imageArr count] - APP_WIDTH/2, APP_HEIGHT - 50)];
    }
    else
    {
        //iphone5以上
        [loginButton setCenter:CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) * [imageArr count] - APP_WIDTH/2, APP_HEIGHT - 100)];
    }
    [loginButton setBackgroundImage:[UIImage imageNamed:@"btn_startred.png"] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"立刻体验" forState:UIControlStateNormal] ;
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:loginButton];

}


- (void)loginButtonClick
{
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [userdef setObject:@"1" forKey:UserSplashKey];
    [userdef synchronize];
//    NSLog(@"+++++ %@1  +++++++",_tabbarController);

    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:_tabbarController];
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    loginNav.navigationBar.hidden = YES;
    appdelegate.window.rootViewController = loginNav;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
