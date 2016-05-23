//
//  SearchTeamVC.m
//  ledong
//
//  Created by luojiao  on 16/4/20.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "SearchTeamVC.h"
#import "HistoryTableViewCell.h"

static NSString * const historyCell = @"HistoryCell";
static NSString * const hotSearchCell = @"hotSearchCell";
static NSString * const teamCell = @"ActivityCell";

@interface SearchTeamVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>

@end

@implementation SearchTeamVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    self.textField.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelButtonClicked:(id)sender {
    [self.textField resignFirstResponder];
    self.contentView.hidden = NO;
    self.textField.text = nil;
    [self.resultTableView removeFromSuperview];
    self.resultTableView = nil;
}

- (IBAction)gobackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clearSearchHistory:(id)sender {
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
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:teamCell forIndexPath:indexPath];
        cell.sNameLabel.text = @"hahahahh";
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
    label.text = @"热门团队";
    return cell;
}

#pragma mark - UI

- (void)setUpUI {
    [self.collectionView registerNib:[UINib nibWithNibName:@"HotSearchCell" bundle:nil] forCellWithReuseIdentifier:hotSearchCell];
    
    [self.gobackButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.gobackButton setImageEdgeInsets:UIEdgeInsetsMake(4, -18, 0, 0)];
    
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTableView.tableFooterView = self.footerView;
    
    [self.contentTableView registerNib:[UINib nibWithNibName:@"SearchHistoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:historyCell];//teamCell
    self.footerImage.image = [FRUtils resizeImageWithImageName:@"btn_white"];
}

- (UITableView *)resultTableView {
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, APP_WIDTH, APP_HEIGHT-66) style:UITableViewStylePlain];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        _resultTableView.backgroundColor = [UIColor whiteColor];
        _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _resultTableView.tableHeaderView = self.headerView;
        [_resultTableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:teamCell];
    }
    return _resultTableView;
}


@end
