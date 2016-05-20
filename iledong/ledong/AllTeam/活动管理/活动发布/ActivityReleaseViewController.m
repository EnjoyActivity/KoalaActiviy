//
//  ActivityReleaseViewController.m
//  ledong
//
//  Created by liuxu on 16/5/20.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "ActivityReleaseViewController.h"

#define kCell1      @"cell1"
#define kCell2      @"cell2"
#define kCell3      @"cell3"
#define kCell4      @"cell4"

@interface ActivityReleaseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView* leagueTableView;
@property (nonatomic, strong)UITableView* nonleagueTableView;

@end

@implementation ActivityReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColorFromRGB(0xF2F3F4);
    [self setupNavigationBar];
    [self drawNonLeagueTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - drawUI 
- (void)setupNavigationBar {
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor redColor]];
    [customLab setText:@"发布活动"];
    customLab.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = customLab;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)drawNonLeagueTableView {
    self.nonleagueTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+100, APP_WIDTH, APP_HEIGHT-164)];
    self.nonleagueTableView.backgroundColor = UIColorFromRGB(0xF2F3F4);
    [self.view addSubview:self.nonleagueTableView];
    self.nonleagueTableView.delegate = self;
    self.nonleagueTableView.dataSource = self;
    self.nonleagueTableView.backgroundColor = UIColorFromRGB(0xF2F3F4);
    [self.nonleagueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell1];
    [self.nonleagueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell2];
    [self.nonleagueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell3];
    [self.nonleagueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell4];
    self.nonleagueTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - btn clicked 
- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startBtnClicked {
    
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.nonleagueTableView) {
        if (section == 1 || section == 3 || section == 4) {
            return 10;
        }
        else if (section == 2) {
            return 35;
        }
    }
    else if (tableView == self.leagueTableView) {
        
    }

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.nonleagueTableView == tableView) {
        if (section == 0)
            return 4;
        else if (section == 1)
            return 2;
        else if (section == 2)
            return 1;
        else if (section == 3)
            return 1;
        else if (section == 4)
            return 1;
    }
    else if (self.leagueTableView == tableView) {
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.nonleagueTableView == tableView) {
        if (indexPath.section == 0)
            return [self drawSection0Cell:self.nonleagueTableView indexPath:indexPath];
        else if (indexPath.section == 1)
            return [self drawSection1Cell:self.nonleagueTableView indexPath:indexPath];
        else if (indexPath.section == 2)
            return [self drawSection2Cell:self.nonleagueTableView indexPath:indexPath];
        else if (indexPath.section == 3)
            return [self drawSection3Cell:self.nonleagueTableView indexPath:indexPath];
        else if (indexPath.section == 4)
            return [self drawSection4Cell:self.nonleagueTableView indexPath:indexPath];
    }
    else if (self.leagueTableView == tableView) {
        
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.nonleagueTableView == tableView) {
        return 5;
    }
    else if (self.leagueTableView == tableView) {
        
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.nonleagueTableView == tableView) {
        if (indexPath.section == 2 || indexPath.section == 3) {
            return 100;
        }
    }
    else if (self.leagueTableView == tableView) {
        
    }
    return 50;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.nonleagueTableView == tableView) {
        if (section == 2) {
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            label.text = @"    活动场次";
            label.font = [UIFont systemFontOfSize:15.0];
            [label sizeToFit];
            label.textColor = UIColorFromRGB(0xB2B2B2);
            return label;
        }
    }
    else if (self.leagueTableView == tableView) {
        
    }
    
    return nil;
}

#pragma mark - draw cell
- (UITableViewCell*)drawSection0Cell:(UITableView*)tableView
                           indexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell1 forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UITextField* titleTextField = (UITextField*)[cell.contentView viewWithTag:100];
        if (!titleTextField) {
            titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, APP_WIDTH-15, cell.contentView.bounds.size.height)];
            titleTextField.tag = 100;
            [cell.contentView addSubview:titleTextField];
            titleTextField.placeholder = @"请输入活动标题";
        }
    }
    else if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"选择活动分类";
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
    }
    else if (indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"是否为联赛";
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
    }
    else if (indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"参加类型";
        cell.textLabel.textColor = UIColorFromRGB(0x999999);
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

- (UITableViewCell*)drawSection1Cell:(UITableView*)tableView
                           indexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell1 forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UITextField* titleTextField = (UITextField*)[cell.contentView viewWithTag:100];
        if (!titleTextField) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"活动开始时间";
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
        }
    }
    else if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"活动结束时间";
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
    }
    
    UILabel* lineLabel = (UILabel*)[cell.contentView viewWithTag:1000];
    if (!lineLabel) {
        lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, cell.contentView.bounds.size.height-0.5, APP_WIDTH-15, 0.5)];
        lineLabel.tag = 1000;
        lineLabel.backgroundColor = UIColorFromRGB(0xDEDEDE);
        [cell.contentView addSubview:lineLabel];
    }
    if (indexPath.row == 1)
        lineLabel.hidden = YES;

    return cell;
}

- (UITableViewCell*)drawSection2Cell:(UITableView*)tableView
                           indexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell2 forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImageView* imageView = (UIImageView*)[cell.contentView viewWithTag:99];
    if (!imageView) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 0, 0)];
        [cell.contentView addSubview:imageView];
        imageView.tag = 99;
    }
    imageView.image = [UIImage imageNamed:@"ic_location"];
    [imageView sizeToFit];

    CGFloat x = imageView.frame.size.width + imageView.frame.origin.x + 10;
    UILabel* nameLabel = (UILabel*)[cell.contentView viewWithTag:100];
    if (!nameLabel) {
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 5, 0, 0)];
        nameLabel.font = [UIFont systemFontOfSize:16.0];
        nameLabel.tag = 100;
        nameLabel.textColor = UIColorFromRGB(0x333333);
        [cell.contentView addSubview:nameLabel];
    }
    nameLabel.text = @"云端篮球馆";
    [nameLabel sizeToFit];
    
    UILabel* addLabel = (UILabel*)[cell.contentView viewWithTag:101];
    if (!addLabel) {
        addLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, nameLabel.frame.origin.y+nameLabel.frame.size.height+5, 0, 0)];
        addLabel.font = [UIFont systemFontOfSize:12.0];
        addLabel.tag = 101;
        addLabel.textColor = UIColorFromRGB(0x999999);
        [cell.contentView addSubview:addLabel];
    }
    addLabel.text = @"北京市朝阳区绿荫路128号";
    [addLabel sizeToFit];
    
    x= imageView.frame.origin.x;
    UILabel* timeLabel = (UILabel*)[cell.contentView viewWithTag:102];
    if (!timeLabel) {
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, addLabel.frame.origin.y+addLabel.frame.size.height+5, 0, 0)];
        timeLabel.font = [UIFont systemFontOfSize:12.0];
        timeLabel.tag = 102;
        timeLabel.textColor = UIColorFromRGB(0x999999);
        [cell.contentView addSubview:timeLabel];
    }
    timeLabel.text = @"报名时间 05月19日 19:00 － 05月25日 19:00";
    [timeLabel sizeToFit];
    
    UILabel* personLabel = (UILabel*)[cell.contentView viewWithTag:103];
    if (!personLabel) {
        personLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, timeLabel.frame.origin.y+timeLabel.frame.size.height+5, 0, 0)];
        personLabel.font = [UIFont systemFontOfSize:12.0];
        personLabel.tag = 103;
        personLabel.textColor = UIColorFromRGB(0x999999);
        [cell.contentView addSubview:personLabel];
    }
    personLabel.text = @"组织者:李云山";
    [personLabel sizeToFit];
    
    UILabel* moneyLabel = (UILabel*)[cell.contentView viewWithTag:104];
    if (!moneyLabel) {
        moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(APP_WIDTH-80, 0, 0, 0)];
        moneyLabel.font = [UIFont systemFontOfSize:16.0];
        moneyLabel.tag = 104;
        moneyLabel.textColor = UIColorFromRGB(0xE31B1A);
        [cell.contentView addSubview:moneyLabel];
    }
    moneyLabel.text = @"200元";
    [moneyLabel sizeToFit];
    moneyLabel.center = CGPointMake(moneyLabel.center.x, cell.contentView.bounds.size.height/2);

    return cell;
}

- (UITableViewCell*)drawSection3Cell:(UITableView*)tableView
                           indexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell3 forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel* nameLabel = (UILabel*)[cell.contentView viewWithTag:100];
    if (!nameLabel) {
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 0, 0)];
        nameLabel.font = [UIFont systemFontOfSize:16.0];
        nameLabel.tag = 100;
        nameLabel.textColor = UIColorFromRGB(0x333333);
        [cell.contentView addSubview:nameLabel];
    }
    nameLabel.text = @"场次2";
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(nameLabel.center.x, cell.contentView.bounds.size.height/2);
    
    
    UILabel* addLabel = (UILabel*)[cell.contentView viewWithTag:101];
    if (!addLabel) {
        addLabel = [[UILabel alloc]initWithFrame:CGRectMake(APP_WIDTH-80, 0, 0, 0)];
        addLabel.font = [UIFont systemFontOfSize:16.0];
        addLabel.tag = 101;
        addLabel.textColor = UIColorFromRGB(0x999999);
        [cell.contentView addSubview:addLabel];
    }
    addLabel.text = @"去添加";
    [addLabel sizeToFit];
    addLabel.center = CGPointMake(addLabel.center.x, cell.contentView.bounds.size.height/2);

    return cell;
}

- (UITableViewCell*)drawSection4Cell:(UITableView*)tableView
                           indexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell4 forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIButton* btn = [[UIButton alloc]initWithFrame:cell.contentView.bounds];
    [cell.contentView addSubview:btn];
    btn.backgroundColor = UIColorFromRGB(0xDEDEDE);
    [btn setTitle:@"发布" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    [btn addTarget:self action:@selector(startBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

@end
