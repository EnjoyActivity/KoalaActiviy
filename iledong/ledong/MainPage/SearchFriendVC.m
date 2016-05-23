//
//  SearchFriendVC.m
//  ledong
//
//  Created by luojiao  on 16/4/20.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "SearchFriendVC.h"
#import "HistoryTableViewCell.h"

static NSString * const historyCell = @"HistoryCell";
static NSString * const friendCell = @"ActivityCell";

@interface SearchFriendVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

@implementation SearchFriendVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];

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

- (IBAction)cancelButtonClicked:(id)sender {
    self.textField.text = nil;
    [self.textField resignFirstResponder];
    [self.resultTableView removeFromSuperview];
    self.resultTableView = nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCell forIndexPath:indexPath];
        cell.sNameLabel.text = @"hahahahh";
        return cell;
    }
}



#pragma mark - UI

- (void)setUpUI {
    [self.contentTableView registerNib:[UINib nibWithNibName:@"SearchHistoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:historyCell];//teamCell
    [self.gobackButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.gobackButton setImageEdgeInsets:UIEdgeInsetsMake(4, -18, 0, 0)];
    self.contentTableView.tableFooterView = self.footerView;
    
    self.footerImage.image = [FRUtils resizeImageWithImageName:@"btn_white"];
    
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
        [_resultTableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:friendCell];
    }
    return _resultTableView;
}


@end
