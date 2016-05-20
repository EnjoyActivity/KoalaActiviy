//
//  SearchFriendVC.m
//  ledong
//
//  Created by luojiao  on 16/4/20.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "SearchFriendVC.h"
#import "FriendCollectionViewCell.h"
#import "FriendTableViewCell.h"
//#import "TeamTableViewCell.h"

static NSString * historyCell = @"HistoryCell";
static NSString * friendCell = @"friendCell";

@interface SearchFriendVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>

@end

@implementation SearchFriendVC

static NSString * const reuseIdentifier = @"friendCCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FriendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"SearchHistoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:historyCell];//teamCell
    
    [self.resultTableView registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:friendCell];
    
    [self.gobackButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.gobackButton setImageEdgeInsets:UIEdgeInsetsMake(4, -18, 0, 0)];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTableView.tableFooterView = self.footerView;
    self.footerImage.image = [FRUtils resizeImageWithImageName:@"btn_white"];
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.delegate = self;
    self.resultTableView.hidden = YES;
    self.resultTableView.tableHeaderView = self.headerView;
    self.resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearSearchHistory:(id)sender {
    
}

- (IBAction)gobackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.contentView.hidden = YES;
    self.resultTableView.hidden = NO;
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.contentTableView)
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
    if (tableView == self.contentTableView)
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
    if (tableView == self.contentTableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCell forIndexPath:indexPath];
        UILabel * label = (UILabel *)[cell viewWithTag:2];
        label.text = @"history";
        return cell;
    }
    else
    {
        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCell forIndexPath:indexPath];
        cell.friendName.text = @"hahahahh";
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
    FriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}




@end
