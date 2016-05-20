//
//  CHLeaveAddFileSheetView.h
//  TouchCPlatform
//
//  Created by liuxu on 16/3/18.
//  Copyright (c) 2016年 changhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeAvatarViewDelegate <NSObject>

@optional
- (void)onTakePhotoBtnClicked;
- (void)onPictureBtnClicked;

@end

@interface ChangeAvatarView : UIView

@property (nonatomic, weak)UIView* maskView;
@property (nonatomic, weak)id<ChangeAvatarViewDelegate> delegate;

@end
