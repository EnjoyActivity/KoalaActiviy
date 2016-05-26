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
    [historyArray addObjectsFromArray:[self getSearchHistory]];
    resultArray = [NSMutableArray array];
    hotSearchArray = [NSMutableArray array];
    [self setUpUI];
    [self requestHotSearch];
    
  
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [manager POST:@"Activity/GetActivityItemsByActivityId" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * resultDic = (NSDictionary *)responseObject;
        NSInteger code = [resultDic[@"code"] integerValue];
        if (code != 0) {
            [SVProgressHUD showErrorWithStatus:@"error"];
            return ;
        }
        NSArray * result = [resultDic objectForKey:@"result"];
        resultArray = [result copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultCountLabel.text = [NSString stringWithFormat:@"相关搜索结果%lu个",(unsigned long)resultArray.count];
            [self.resultTableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"搜索失败"];
    }];
}

- (void)requestHotSearch {
    NSDictionary * dic = @{
                           @"keywords":@"",
                           @"pagesize":[NSNumber numberWithInt:6],
                           @"ownertype":[NSNumber numberWithInt:0]
                           };
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [manager POST:@"Other/GetKeywords" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * resultDic = (NSDictionary *)responseObject;
        NSInteger code = [[resultDic objectForKey:@"code"] integerValue];
        if (code != 0) {
            return ;
        }
        NSArray * result = [resultDic objectForKey:@"result"];
        hotSearchArray = [result copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark - SearchHistory
- (NSString *)getPlistPath {
    NSString * docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * plistPath = [docPath stringByAppendingPathComponent:@"searchHistory/activityHistory.plist"];
    NSArray * history = [NSArray arrayWithContentsOfFile:plistPath];
    if (history == nil) {
        NSString * pathTemp = [docPath stringByAppendingPathComponent:@"searchHistory"];
        [[NSFileManager defaultManager] createDirectoryAtPath:pathTemp withIntermediateDirectories:nil attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:docPath contents:nil attributes:nil];
    }
    
    return plistPath;
}

- (NSArray *)getSearchHistory {
    NSString * path = [self getPlistPath];
    NSArray * arrayTemp = [NSArray arrayWithContentsOfFile:path];
    return arrayTemp;
}

- (void)addSearchHistory {
    NSString * path = [self getPlistPath];
    if (historyArray.count > 20) {
        [historyArray removeObjectsInRange:NSMakeRange(20, historyArray.count-20)];
    }
    [historyArray writeToFile:path atomically:YES];
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
    [self addSearchHistory];
    
}

- (IBAction)cancelButtonClicked:(id)sender {
    self.textField.text = nil;
    [self.textField resignFirstResponder];
    [self.resultTableView setHidden:YES];
//    self.contentView.hidden = NO;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return YES;
    }
    
    [textField resignFirstResponder];
    [historyArray insertObject:textField.text atIndex:0];
    [self addSearchHistory];
    
    [self requestWithKeyWord:textField.text];
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
        NSString * price = [NSString stringWithFormat:@"%@-%@元",minMoney,maxMOney];
        
        NSString * detail = [NSString stringWithFormat:@"%@|%@ %@",className,area,time];
        
        [cell updateName:name detail:detail price:price];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.historyTableView]) {
        NSString * historyTemp = historyArray[indexPath.row];
        self.textField.text = historyTemp;
        [self requestWithKeyWord:historyTemp];
        [self.resultTableView setHidden:NO];
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
    [self addSearchHistory];
    
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
