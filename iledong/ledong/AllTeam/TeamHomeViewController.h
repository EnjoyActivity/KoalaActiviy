//
//  TeamHomeViewController.h
//  ledong
//
//  Created by luojiao  on 16/4/28.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "BaseViewController.h"

@interface TeamHomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *membersLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *publicLabel;
@property (weak, nonatomic) IBOutlet UILabel *footLabel;
@property (weak, nonatomic) IBOutlet UIButton *membersButton;
@property (weak, nonatomic) IBOutlet UIButton *fansButton;
@property (weak, nonatomic) IBOutlet UIButton *publicButton;
@property (weak, nonatomic) IBOutlet UIButton *footButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *ActiveView;
@property (weak, nonatomic) IBOutlet UIView *footerView;





@end
