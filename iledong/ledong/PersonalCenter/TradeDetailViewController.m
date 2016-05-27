//
//  TradeDetailViewController.m
//  ledong
//
//  Created by dengjc on 16/5/20.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "TradeDetailViewController.h"
#import "TradeDetailTableViewCell.h"

@interface TradeDetailViewController ()

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation TradeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易明细";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view from its nib.
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup UI
- (void)setupTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, APP_WIDTH, APP_HEIGHT-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    [_tableView registerClass:[TradeDetailTableViewCell class] forCellReuseIdentifier:@"Cell"];
//    _tableView.separatorInset = UIEdgeInsetsZero;
//    _tableView.layoutMargins = UIEdgeInsetsZero;
    [self.view addSubview:_tableView];
}
#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 22)];
    label.backgroundColor = RGB(240, 240, 240, 1);
//    label.text = @"";
//    label.textColor = RGB(227, 26, 26, 1);
//    label.font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"2016年4月"];
    
    //设置字体颜色
    [text addAttribute:NSForegroundColorAttributeName value:RGB(227, 26, 26, 1) range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, text.length)];
    //设置缩进、行距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 20;//缩进
    style.firstLineHeadIndent = 20;
//    style.lineSpacing = 10;//行距
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    label.attributedText = text;
    return label;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = (TradeDetailTableViewCell*)[[[NSBundle mainBundle]loadNibNamed:@"TradeDetailTableViewCell" owner:self options:nil]lastObject];
    }
    cell.weekDayLabel.text = @"周四";
    cell.dateLabel.text = @"04-28";
    cell.moneyLabel.text = @"+100";
    cell.tradeCodeLabel.text = @"充值-交易单号2016210124154621";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
