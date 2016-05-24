//
//  SearchActiveVC.h
//  ledong
//
//  Created by luojiao  on 16/4/20.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchActiveVC : BaseViewController

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *textField;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *historyTableView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *gobackButton;
@property (unsafe_unretained, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIImageView *btnImage;
//@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic,strong) UITableView *resultTableView;
@property (strong, nonatomic) IBOutlet UILabel *resultCountLabel;


@end
