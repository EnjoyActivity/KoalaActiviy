//
//  ContactView.h
//  ledong
//
//  Created by dengjc on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactView : UIView
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *reportButton;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *reportLabel;
@property (strong, nonatomic) IBOutlet UILabel *organizeLabel;

@end
