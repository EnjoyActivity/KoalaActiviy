//
//  LDSearchMoreViewController.h
//  ledong
//
//  Created by 郑红 on 5/26/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,moreType)
{
    moreTypeActivity,
    moreTypeTeam,
    moreTypeFriend
};

@interface LDSearchMoreViewController : UIViewController

@property (nonatomic, copy) NSString * keyWord;
@property (nonatomic, copy) NSMutableArray * activityArray;
@property (nonatomic, assign) moreType searchType;


@end
