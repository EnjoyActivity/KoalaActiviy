//
//  CHLeaveAddFileSheetView.m
//  TouchCPlatform
//
//  Created by liuxu on 16/3/18.
//  Copyright (c) 2016年 changhong. All rights reserved.
//

#import "ChangeAvatarView.h"

@implementation ChangeAvatarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        UIButton *photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 50)];
        photoBtn.backgroundColor = [UIColor whiteColor];
        [photoBtn setTitle:@"拍照" forState:UIControlStateNormal];
        [photoBtn setTitleColor:RGB(51, 51, 51, 1) forState:UIControlStateNormal];
        photoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [photoBtn addTarget:self action:@selector(onPhotoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *sepLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, APP_WIDTH, 0.5)];
        sepLine.backgroundColor = [UIColor grayColor];
        
        UIButton *pictureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50.5, APP_WIDTH, 50)];
        pictureBtn.backgroundColor = [UIColor whiteColor];
        [pictureBtn setTitle:@"从相册中选择" forState:UIControlStateNormal];
        [pictureBtn setTitleColor:RGB(51, 51, 51, 1) forState:UIControlStateNormal];
        pictureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [pictureBtn addTarget:self action:@selector(onPictureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *space = [[UILabel alloc]initWithFrame:CGRectMake(0, 101, APP_WIDTH, 9)];
        space.backgroundColor = [UIColor clearColor];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 110, APP_WIDTH, 50)];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:RGB(51, 51, 51, 1) forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn addTarget:self action:@selector(onCancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:photoBtn];
        [self addSubview:sepLine];
        [self addSubview:pictureBtn];
        [self addSubview:space];
        [self addSubview:cancelBtn];
    }
    
    return self;
}

- (void)onPhotoBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTakePhotoBtnClicked)]) {
        [self popView:0.1];
        [self.delegate onTakePhotoBtnClicked];
    }
}

- (void)onPictureBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPictureBtnClicked)]) {
        [self popView:0.1];
        [self.delegate onPictureBtnClicked];
    }
}

- (void)onCancelBtnClicked:(id)sender {
    [self popView:0.3];
}

- (void)popView:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(0, APP_HEIGHT, APP_WIDTH, 160);
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        self.maskView = nil;
        [self removeFromSuperview];
    }];
}

@end
