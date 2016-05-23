//
//  SearchActiveVC.m
//  ledong
//
//  Created by luojiao  on 16/4/20.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "SearchActiveVC.h"
#import "HistoryTableViewCell.h"

static NSString * const historyCell = @"HistoryCell";
static NSString * const activityCell = @"ActivityCell";
static NSString * const hotSearchCell = @"hotSearchCell";

@interface SearchActiveVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>

@end

@implementation SearchActiveVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)gobackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clearSearchButton:(id)sender
{
    
}

- (IBAction)cancelButtonClicked:(id)sender {
    self.textField.text = nil;
    [self.textField resignFirstResponder];
    [self.resultTableView removeFromSuperview];
    self.resultTableView = nil;
    self.contentView.hidden = NO;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.contentView.hidden = YES;
    [self.view addSubview:self.resultTableView];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.historyTableView)
    {
        return 44.0;
    }
    else
    {
        return 100.0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.historyTableView)
    {
        return 4;
    }
    else
    {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.historyTableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCell forIndexPath:indexPath];
        UILabel * label = (UILabel *)[cell viewWithTag:2];
        label.text = @"history";
        return cell;
    }
    else
    {
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityCell forIndexPath:indexPath];
        cell.sNameLabel.text = @"sdasd";
        return cell;
    }
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotSearchCell forIndexPath:indexPath];
    UILabel * label = (UILabel *)[cell viewWithTag:2];
    label.text = @"热门活动";
    return cell;
}

#pragma mark - UI

- (void)setUpUI {
    [self.collectionView registerNib:[UINib nibWithNibName:@"HotSearchCell" bundle:nil] forCellWithReuseIdentifier:hotSearchCell];//HotCollectionViewCell
    
    [self.historyTableView registerNib:[UINib nibWithNibName:@"SearchHistoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:historyCell];
    [self.gobackButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.gobackButton setImageEdgeInsets:UIEdgeInsetsMake(0, -18, 0, 0)];
    
    self.historyTableView.tableFooterView = self.footerView;
    self.btnImage.image = [FRUtils resizeImageWithImageName:@"btn_white"];

    self.textField.delegate = self;

}

- (UITableView *)resultTableView {
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, APP_WIDTH, APP_HEIGHT-66) style:UITableViewStylePlain];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        _resultTableView.backgroundColor = [UIColor whiteColor];
        _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _resultTableView.tableHeaderView = self.headerView;
        [_resultTableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:activityCell];
    }
    return _resultTableView;
}

@end
