//
//  SearchActiveVC.m
//  ledong
//
//  Created by luojiao  on 16/4/20.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "SearchActiveVC.h"
#import "HistoryTableViewCell.h"
#import "SearchTableViewCell.h"
#import "ActiveDetailViewController.h"

#import "LDMainPageNetWork.h"
#import "LDSearchHistory.h"

static NSString * const historyCell = @"HistoryCell";
static NSString * const activityCell = @"sActivityCell";
static NSString * const hotSearchCell = @"hotSearchCell";

@interface SearchActiveVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>
{
    NSMutableArray * historyArray;
    NSMutableArray * resultArray;
    NSMutableArray * hotSearchArray;
    
    NSString * searchKeyWord;
}

@end

@implementation SearchActiveVC


- (void)viewDidLoad {
    [super viewDidLoad];
    historyArray = [NSMutableArray array];
    NSArray * historyTemp = [[LDSearchHistory defaultInstance] getSearchHitory:activityHistory];
    [historyArray addObjectsFromArray:historyTemp];
    
    resultArray = [NSMutableArray array];
    hotSearchArray = [NSMutableArray array];
    [self setUpUI];
    [self requestHotSearch];
    
  
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NetWork

- (void)requestWithKeyWord:(NSString *)keyWord {
    NSString * token = [HttpClient getTokenStr];
    if (token.length == 0) {
        return;
    }

    NSDictionary * dic = @{
                           @"token":token,
                           @"page":[NSNumber numberWithInt:1],
                           @"PageSize":[NSNumber numberWithInt:10],
                           @"tag":keyWord
                           };
     [[LDMainPageNetWork defaultInstance] postPath:MQueryActivity parameter:dic success:^(id result) {
         resultArray = [(NSArray *)result copy];
         dispatch_async(dispatch_get_main_queue(), ^{
             self.resultCountLabel.text = [NSString stringWithFormat:@"相关搜索结果%lu个",(unsigned long)resultArray.count];
             [self.resultTableView reloadData];
         });
     } fail:^(NSError *error) {
         
     }];
    
}

- (void)requestHotSearch {
    NSDictionary * dic = @{
                           @"keywords":@"",
                           @"pagesize":[NSNumber numberWithInt:6],
                           @"ownertype":[NSNumber numberWithInt:0]
                           };
    [[LDMainPageNetWork defaultInstance] postPath:MGetHotSearch parameter:dic success:^(id result) {
        hotSearchArray = [(NSArray *)result copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    } fail:^(NSError *error) {
        
    }];
    
}

#pragma mark - buttonAction

- (IBAction)gobackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clearSearchButton:(id)sender
{
    [historyArray removeAllObjects];
    [self.historyTableView reloadData];
    [[LDSearchHistory defaultInstance] removeHistory:activityHistory];
    
}


- (IBAction)cancelButtonClicked:(id)sender {
//    self.textField.text = nil;
//    [self.textField resignFirstResponder];
//    [self.resultTableView setHidden:YES];
//    self.contentView.hidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return YES;
    }
    searchKeyWord = textField.text;
    [textField resignFirstResponder];
    [historyArray insertObject:searchKeyWord atIndex:0];
    [[LDSearchHistory defaultInstance] addSearchHistory:activityHistory Array:@[searchKeyWord]];
    
    [self requestWithKeyWord:searchKeyWord];
    [self.resultTableView setHidden:NO];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self.resultTableView setHidden:YES];

    [self.historyTableView reloadData];
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
        return historyArray.count;
    }
    else
    {
        return resultArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.historyTableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCell forIndexPath:indexPath];
        UILabel * label = (UILabel *)[cell viewWithTag:2];
        label.text = historyArray[indexPath.row];
        return cell;
    }
    else
    {
        SearchTableViewCell *cell = (SearchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:activityCell forIndexPath:indexPath];
        NSDictionary * dic = resultArray[indexPath.row];
        NSString * imageStr = [dic objectForKey:@"Cover"];
        NSURL * imageUrl = [NSURL URLWithString:imageStr];
        NSString * name = [dic objectForKey:@"Title"];
        
        NSString * minMoney = [dic objectForKey:@"EntryMoneyMin"];
        NSString * maxMOney = [dic objectForKey:@"EntryMoneyMax"];
        
        NSString * className = [dic objectForKey:@"ClassName"];
        NSString * area = [dic objectForKey:@"areaName"];
        
        NSString * time = [dic objectForKey:@"BeginTime"];
        [cell.headImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"img_2@2x"]];
        cell.activityName.text = name;
        cell.keyWord = searchKeyWord;
        NSString * price = [NSString stringWithFormat:@"%@-%@元",minMoney,maxMOney];
        
        NSString * detail = [NSString stringWithFormat:@"%@|%@ %@",className,area,time];
        
        [cell updateName:name detail:detail price:price];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.historyTableView]) {
        searchKeyWord = historyArray[indexPath.row];
        self.textField.text = searchKeyWord;
        [self requestWithKeyWord:searchKeyWord];
        [self.resultTableView setHidden:NO];
    }
    else
    {
        ActiveDetailViewController * activityVc = [[ActiveDetailViewController alloc] init];
        NSDictionary * dic = resultArray[indexPath.row];
        activityVc.Id = [[dic objectForKey:@"Id"] intValue];
        [self.navigationController pushViewController:activityVc animated:YES];
    }
    
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MIN(6, hotSearchArray.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotSearchCell forIndexPath:indexPath];
    UILabel * label = (UILabel *)[cell viewWithTag:2];
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    NSDictionary * dic = hotSearchArray[indexPath.row];
    label.text = [dic objectForKey:@"Name"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = hotSearchArray[indexPath.row];
    searchKeyWord = dic[@"Name"];
    self.textField.text = searchKeyWord;
    [self.resultTableView setHidden:NO];
    [historyArray insertObject:searchKeyWord atIndex:0];
//    [self addSearchHistory];
    [[LDSearchHistory defaultInstance] addSearchHistory:activityHistory Array:@[searchKeyWord]];
    
    [self requestWithKeyWord:searchKeyWord];
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
    
    [self.view addSubview:self.resultTableView];

}

- (UITableView *)resultTableView {
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, APP_WIDTH, APP_HEIGHT-66) style:UITableViewStylePlain];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        _resultTableView.backgroundColor = [UIColor whiteColor];
        _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _resultTableView.tableHeaderView = self.headerView;
        _resultTableView.hidden = YES;
        [_resultTableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:activityCell];
    }
    return _resultTableView;
}

@end
