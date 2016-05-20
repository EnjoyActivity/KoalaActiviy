//
//  AppDelegate.m
//  ledong
//
//  Created by dongguoju on 16/2/29.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "AppDelegate.h"
#import "AllTeamController.h"
#import "MainPageController.h"
#import "PersonalCenterController.h"
#import "SplashViewController.h"
#import "LoginAndRegistViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    MainPageController *main = [[MainPageController  alloc]init];
    UINavigationController *mainNavigation = [[UINavigationController alloc]initWithRootViewController:main];
    AllTeamController *team = [[AllTeamController alloc]init];
    UINavigationController *teamNavigation = [[UINavigationController alloc]initWithRootViewController:team];
    PersonalCenterController *center = [[PersonalCenterController alloc]init];
    UINavigationController *centerNavigation = [[UINavigationController alloc]initWithRootViewController:center];
    UITabBarController *tabbarController = [[UITabBarController alloc]init];

    //    tabbarController.delegate = self;
    tabbarController.viewControllers = @[mainNavigation,teamNavigation,centerNavigation];
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    if ([[userdef objectForKey:UserSplashKey] intValue] != 1)
    {
        SplashViewController *splashViewController = [[SplashViewController alloc] init];
        splashViewController.tabbarController = tabbarController;
        self.window.rootViewController = splashViewController;
        LoginAndRegistViewController *login = [[LoginAndRegistViewController alloc] init];
        login.tabbarController = splashViewController.tabbarController;
        NSLog(@"+++++ %@1  +++++++",tabbarController);

    }
    else
    {
        self.window.rootViewController = tabbarController;
        LoginAndRegistViewController *login = [[LoginAndRegistViewController alloc] init];
        login.tabbarController = tabbarController;
        NSLog(@"+++++ %@2  +++++++",tabbarController);

    }
    
    tabbarController.tabBar.tintColor = [UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    tabbarController.tabBar.barTintColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if ([HttpClient isLogin]) {
        [FRUtils queryUserInfoFromWeb:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshUserinfo" object:nil];
        }failBlock:nil];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (void)showMainView {
    MainPageController *main = [[MainPageController  alloc]init];
    UINavigationController *mainNavigation = [[UINavigationController alloc]initWithRootViewController:main];
    AllTeamController *team = [[AllTeamController alloc]init];
    UINavigationController *teamNavigation = [[UINavigationController alloc]initWithRootViewController:team];
    PersonalCenterController *center = [[PersonalCenterController alloc]init];
    UINavigationController *centerNavigation = [[UINavigationController alloc]initWithRootViewController:center];
    UITabBarController *tabbarController = [[UITabBarController alloc]init];
    tabbarController.viewControllers = @[mainNavigation,teamNavigation,centerNavigation];
    tabbarController.tabBar.tintColor = [UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    tabbarController.tabBar.barTintColor = [UIColor whiteColor];
//    self.window.rootViewController = tabbarController;
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] setRootViewController:tabbarController];
}

@end
