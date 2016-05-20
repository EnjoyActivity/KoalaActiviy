//
//  NonLeagueTableView.m
//  ledong
//
//  Created by liuxu on 16/5/20.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "NonLeagueTableView.h"

#define kCell_Section0_1  @"kCell_Section0_1"



@interface NonLeagueTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView* tableView;

@end

@implementation NonLeagueTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTableView];
    }
    
    return self;
}

#pragma mark - draw UI
- (void)setupTableView {
    self.tableView = [[UITableView alloc]initWithFrame:self.bounds];
    [self addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F3F4);
    
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 4;
    else if (section == 1)
        return 2;
    else if (section == 2)
        return 1;
    else if (section == 3)
        return 1;

    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return 0;
    else if (section == 1)
        return 10;
    else if (section == 2)
        return 30;
    else if (section == 3)
        return 10;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 50;
    else if (indexPath.section == 1)
        return 50;
    else if (indexPath.section == 2)
        return 100;
    else if (indexPath.section == 3)
        return 100;
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - draw cell
- (UITableViewCell*)drawSection0Cell:(NSIndexPath *)indexPath {
    UITableViewCell* cell = nil;

    if (indexPath.row == 0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:kCell_Section0_1 forIndexPath:indexPath];
        UITextField* titleTextField = (UITextField*)[cell.contentView viewWithTag:100];
        if (!titleTextField) {
            titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, APP_WIDTH-15, cell.contentView.bounds.size.height)];
            titleTextField.tag = 100;
            [cell.contentView addSubview:titleTextField];
            titleTextField.placeholder = @"请输入活动标题";
        }
    }
    
    
    UILabel* lineLabel = (UILabel*)[cell.contentView viewWithTag:1000];
    if (!lineLabel) {
        lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, cell.contentView.bounds.size.height-0.5, APP_WIDTH-15, 0.5)];
        lineLabel.tag = 1000;
        lineLabel.backgroundColor = UIColorFromRGB(0xDEDEDE);
        [cell.contentView addSubview:lineLabel];
    }
    if (indexPath.row == 3) 
        lineLabel.hidden = YES;

    
    
    
    return cell;
}

@end
