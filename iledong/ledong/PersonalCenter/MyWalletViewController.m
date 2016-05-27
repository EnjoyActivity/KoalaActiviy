//
//  MyWalletViewController.m
//  ledong
//
//  Created by TDD on 16/3/9.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "MyWalletViewController.h"
#import "TradeDetailViewController.h"
#import "MyWalletDetailTableViewCell.h"

@interface MyWalletViewController ()
{
    NSArray *dataArrSection1;
    NSMutableArray *contentArrSection1;
    NSDictionary *walletInfo;
    
}
@property (strong, nonatomic) IBOutlet UILabel *balanceMoneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *bankLabel;
@property (strong, nonatomic) IBOutlet UIView *containView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *headSpaceLabel;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    self.titleName = _navTitle;//@"我的钱包";
    [super viewDidLoad];
    self.rightButton.hidden = NO;
    [self.rightButton setTitle:@"查看明细" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(checkDetail:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBarHidden = NO;
    
    dataArrSection1 = @[@"工商银行",@"添加银行卡...",@"微信钱包"];
    contentArrSection1 = [NSMutableArray arrayWithObjects:@"尾号9999",@"",@"未绑定", nil];//@[@"尾号9999",@"",@"未绑定"];
    
    _headSpaceLabel.backgroundColor = RGB(240, 240, 240, 1);
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 36)];
    header.backgroundColor = RGB(240, 240, 240, 1);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, APP_WIDTH - 15, 36)];
    label.textColor = RGB(153, 153, 153, 1);
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"付款方式";
    [header addSubview:label];
    
    self.tableView.tableHeaderView = header;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = RGB(240, 240, 240, 1);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self queryWalletInfo];
}

#pragma mark - setup ui


#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    }
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = dataArrSection1[indexPath.row];
        cell.detailTextLabel.text = contentArrSection1[indexPath.row];
    } else {
        cell.textLabel.text = @"设置交易密码";
    }
    cell.textLabel.textColor = RGB(51, 51, 51, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = RGB(153, 153, 153, 1);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button method
- (IBAction)withDraw:(id)sender {
}

- (IBAction)recharge:(id)sender {
}

- (void)checkDetail:(id)sender {
    TradeDetailViewController *vc = [[TradeDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)queryWalletInfo {
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc]init];
    [postDic setObject:[HttpClient getTokenStr] forKey:@"token"];
    if ([_navTitle isEqualToString:@"团队钱包"]) {
        [postDic setObject:@2 forKey:@"ownertype"];
        [postDic setObject:@(_teamId) forKey:@"ownerId"];
    } else {
        [postDic setObject:@1 forKey:@"ownertype"];
    }
    [HttpClient JSONDataWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_WALLETINFO_URL] parameters:postDic success:^(id json){
        NSDictionary* temp = (NSDictionary*)json;
        if ([[temp objectForKey:@"code"]intValue]!=0) {
            [Dialog toast:[temp objectForKey:@"msg"]];
            return;
        }
        walletInfo = [temp objectForKey:@"result"];
        if (walletInfo) {
            //余额
            NSDecimal money = [[walletInfo objectForKey:@"TotalMoney"]decimalValue];
            NSLocale *zhLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            _balanceMoneyLabel.text = NSDecimalString(&money,zhLocale);
            //帐号
            NSString *account = [walletInfo objectForKey:@"Account"];
            NSString *last4 = [account substringFromIndex:account.length - 4];
            contentArrSection1[0] = [NSString stringWithFormat:@"尾号%@",last4];
            
            [self.tableView reloadData];
        }
    }fail:^{
        [Dialog toast:@"网络失败，请稍后再试"];
    }];
}

@end
