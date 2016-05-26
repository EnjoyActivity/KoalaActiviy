//
//  SearchTeamVC.m
//  ledong
//
//  Created by luojiao  on 16/4/20.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "SearchTeamVC.h"
#import "HistoryTableViewCell.h"
#import "ActiveDetailViewController.h"


static NSString * const historyCell = @"HistoryCell";
static NSString * const hotSearchCell = @"hotSearchCell";
static NSString * const teamCell = @"ActivityCell";

@interface SearchTeamVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>
{
    NSMutableArray * historyArray;
    NSMutableArray * resultArray;
    NSMutableArray * hotSearchArray;
    
    NSString * searchKeyWord;
}
@end

@implementation SearchTeamVC


- (void)viewDidLoad {
    [super viewDidLoad];
    historyArray = [NSMutableArray array];
    resultArray = [NSMutableArray array];
    [historyArray addObjectsFromArray:[self getSearchHistory]];
    
    hotSearchArray = [NSMutableArray array];
  
    [self requestHotSearch];
    
    [self setUpUI];
    self.textField.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NetWork

- (void)requestTeamData:(NSString *)keyWord {
    NSDictionary * dic = @{
                           @"Page":[NSNumber numberWithInt:1],
                           @"PageSize":[NSNumber numberWithInt:100],
                           @"IsHot":[NSNumber numberWithBool:NO],
                           @"KeyWord":keyWord
                           };
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [manager POST:@"Team/QueryTeams" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * resultDic = (NSDictionary *)responseObject;
        NSInteger code = [[resultDic objectForKey:@"code"] integerValue];
        if (code != 0) {
            return ;
        }
        NSDictionary * data = [resultDic objectForKey:@"result"];
        NSArray * result = [data objectForKey:@"Data"];
        resultArray  = [result copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultCountLabel.text = [NSString stringWithFormat:@"相关搜索结果%lu个",(unsigned long)resultArray.count];
            [self.resultTableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}


- (void)requestHotSearch {
    NSDictionary * dic = @{
                           @"keywords":@"",
                           @"pagesize":[NSNumber numberWithInt:6],
                           @"ownertype":[NSNumber numberWithInt:1]
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


- (NSString *)getPlistPath {
    NSString * docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * plistPath = [docPath stringByAppendingPathComponent:@"searchHistory/teamHistory.plist"];
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
#pragma mark - ButtonAction
- (IBAction)cancelButtonClicked:(id)sender {
    [self.textField resignFirstResponder];
//    self.contentView.hidden = NO;
    self.textField.text = nil;
    [self.resultTableView setHidden:YES];
}

- (IBAction)gobackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clearSearchHistory:(id)sender {
    [historyArray removeAllObjects];
    [self addSearchHistory];
    [self.contentTableView reloadData];
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
    [self addSearchHistory];
    
    [self requestTeamData:searchKeyWord];
//    self.contentView.hidden = YES;
    [self.resultTableView setHidden:NO];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self.resultTableView setHidden:YES];
//    self.contentView.hidden = NO;
    [self.contentTableView reloadData];
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
        return historyArray.count;
    }
    else
    {
        return resultArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.contentTableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCell forIndexPath:indexPath];
        UILabel * label = (UILabel *)[cell viewWithTag:2];
        label.text = historyArray[indexPath.row];
        return cell;
    }
    else
    {
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:teamCell forIndexPath:indexPath];
        NSDictionary * dic =resultArray[indexPath.row];
        NSString * teamImage = [dic objectForKey:@"AvatarUrl"];
        NSURL * teamUrl = [NSURL URLWithString:teamImage];
        
        NSString * name = [dic objectForKey:@"Name"];
        NSString * member = [dic objectForKey:@"PersonNum"];
        cell.keyWords = searchKeyWord;
        [cell.sImageView sd_setImageWithURL:teamUrl placeholderImage:[UIImage imageNamed:@"img_avatar_100"]];
        [cell updateName:name detail:[NSString stringWithFormat:@"%@人",member]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.contentTableView]) {
        searchKeyWord = historyArray[indexPath.row];
        self.textField.text = searchKeyWord;
        [self requestTeamData:searchKeyWord];
        [self.resultTableView setHidden:NO];
    }
    else
    {
        ActiveDetailViewController * acDetail = [[ActiveDetailViewController alloc] init];
        NSDictionary * dic = resultArray[indexPath.row];
        acDetail.Id = [[dic objectForKey:@"Id"] intValue];
        [self.navigationController pushViewController:acDetail animated:YES];
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
    NSDictionary * dic = hotSearchArray[indexPath.row];
    UILabel * label = (UILabel *)[cell viewWithTag:2];
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    
    label.text = [dic objectForKey:@"Name"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = hotSearchArray[indexPath.row];
    searchKeyWord = [dic objectForKey:@"Name"];
    self.textField.text = searchKeyWord;
    [self.resultTableView setHidden:NO];
    [historyArray insertObject:searchKeyWord atIndex:0];
    [self addSearchHistory];
    
    [self requestTeamData:searchKeyWord];
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
        [_resultTableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:teamCell];
    }
    return _resultTableView;
}


@end
