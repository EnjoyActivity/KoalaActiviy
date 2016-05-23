//
//  MySettingViewController.m
//  ledong
//
//  Created by TDD on 16/3/3.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "MySettingViewController.h"
#import "ReBindingViewController.h"

@interface MySettingViewController ()

@end

@implementation MySettingViewController

- (void)viewDidLoad {
    self.titleName = @"我的设置";
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self setButton];
    
}


- (void)setButton
{
    [self.aboutUsButton setTitle:@"联系我们" forState:UIControlStateNormal];
    [self.clearButton setTitle:@"清除缓存" forState:UIControlStateNormal];
    [self.aboutUsButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, APP_WIDTH - 80)];
    [self.clearButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, APP_WIDTH - 90)];
    [self.aboutUsButton setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    [self.aboutUsButton setImageEdgeInsets:UIEdgeInsetsMake(0, APP_WIDTH - 38, 0, 0)];
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _clearLabel.text = [NSString stringWithFormat:@"%.2fM",[self folderSizeAtPath:directory]];
    
}

#pragma mark - button Click
- (IBAction)aboutUsButtonClick:(id)sender {
}
- (IBAction)noticeSwitch:(id)sender {
}

- (IBAction)messageSwitch:(id)sender {
}

- (IBAction)clearButtonClick:(id)sender {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:directory error:nil];
    for (NSString *file in files) {
        BOOL isDir = NO;
        NSString *filePath = [directory stringByAppendingString:[NSString stringWithFormat:@"/%@",file]];
        if ([fileManager fileExistsAtPath:filePath isDirectory:&isDir]) {
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _clearLabel.text = [NSString stringWithFormat:@"%.2fM",0.0];
    [Dialog toast:@"清除成功"];
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//获取文件夹大小
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
