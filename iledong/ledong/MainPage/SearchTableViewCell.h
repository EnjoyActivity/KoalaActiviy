//
//  SearchTableViewCell.h
//  ledong
//
//  Created by luojiao  on 16/3/28.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString * keyWord;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *activityName;
@property (strong, nonatomic) IBOutlet UILabel *activityDetail;
@property (strong, nonatomic) IBOutlet UILabel *activityPrice;

- (void)updateImage:(UIImage *)image
               name:(NSString *)name
             detail:(NSString *)detail
              price:(NSString *)price;
@end
