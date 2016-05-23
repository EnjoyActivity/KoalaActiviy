//
//  ActivityReleaseViewController.m
//  ledong
//
//  Created by liuxu on 16/5/20.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "ActivityReleaseViewController.h"
#import "CHDatePickerView.h"
#import "StepperView.h"

#define kCell1              @"cell1"
#define kCell2              @"cell2"
#define kCell3              @"cell3"
#define kCell4              @"cell4"
#define kCell5              @"cell5"
#define kCell6              @"cell6"
#define kCell7              @"cell7"
#define kCell8              @"cell8"
#define KTextFieldAsObj     @"textFieldAssociatedObject"

typedef enum gameType {
    gameTypeLeague = 0,
    gameTypenonLeague
}gameType;

typedef enum joinType {
    joinTypeNull = 0,
    joinTypePerson,
    joinTypeTeam
}joinType;

@interface ActivityReleaseViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate>

@property (nonatomic, strong)UITableView* leagueTableView;
@property (nonatomic, strong)UITableView* nonleagueTableView;
@property (nonatomic, strong)UIScrollView* headerScrollView;
@property (nonatomic, strong)UIView* addImgBtnView;
@property (nonatomic, assign)gameType gameType;
@property (nonatomic, assign)joinType joinType;
@property (nonatomic, strong)NSMutableArray* coverPhotoImages;
@property (nonatomic, strong)NSIndexPath* textFieldPath;
@property (nonatomic, strong)UILabel* tipLabel;

@end

@implementation ActivityReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.gameType = gameTypenonLeague;
    self.view.backgroundColor = UIColorFromRGB(0xF2F3F4);
    self.coverPhotoImages = [NSMutableArray array];
    [self setupNavigationBar];
    [self setupHeaderImgScrollView];
    [self drawNonLeagueTableView];
    [self drawLeagueTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - drawUI 
- (void)setupNavigationBar {
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor redColor]];
    [customLab setText:@"发布活动"];
    customLab.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
    customLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = customLab;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)setupHeaderImgScrollView {
    self.headerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, APP_WIDTH, 100)];
    [self.view addSubview:self.headerScrollView];
    self.headerScrollView.backgroundColor = UIColorFromRGB(0xF2F3F4);
    
    self.addImgBtnView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, 70, 70)];
    [self.headerScrollView addSubview:self.addImgBtnView];
    self.addImgBtnView.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc]initWithFrame:self.addImgBtnView.bounds];
    label.text = @"添加\r\n封面";
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:12.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorFromRGB(0x999999);
    [self.addImgBtnView addSubview:label];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    [tapGes addTarget:self action:@selector(addCoverPhotoClicked)];
    [self.addImgBtnView addGestureRecognizer:tapGes];
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

- (void)drawLeagueTableView {
    self.leagueTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+100, APP_WIDTH, APP_HEIGHT-164)];
    self.leagueTableView.backgroundColor = UIColorFromRGB(0xF2F3F4);
    [self.view addSubview:self.leagueTableView];
    self.leagueTableView.delegate = self;
    self.leagueTableView.dataSource = self;
    self.leagueTableView.backgroundColor = UIColorFromRGB(0xF2F3F4);
    [self.leagueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell1];
    [self.leagueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell2];
    [self.leagueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell3];
    [self.leagueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell4];
    [self.leagueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell5];
    [self.leagueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell6];
    [self.leagueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell7];
    [self.leagueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell8];
    self.leagueTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leagueTableView.hidden = YES;
}

#pragma mark - btn clicked 
- (void)personTypeBtnClicked {
    if (self.joinType == joinTypePerson)
        self.joinType = joinTypeNull;
    else
        self.joinType = joinTypePerson;
    [self.nonleagueTableView reloadData];
    [self.leagueTableView reloadData];
}

- (void)teamTypeBtnClicked {
    if (self.joinType == joinTypeTeam)
        self.joinType = joinTypeNull;
    else
        self.joinType = joinTypeTeam;
    [self.nonleagueTableView reloadData];
    [self.leagueTableView reloadData];
}

- (void)addCoverPhotoClicked {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        //支持图库、相片库
        UIImagePickerController* picker = [[UIImagePickerController alloc]init];
        picker.view.backgroundColor = [UIColor whiteColor];
        UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypePhotoLibrary|UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.sourceType = sourcheType;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"不支持获取图库及相片库，请设置权限"];
    }
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startBtnClicked {
    
}

- (void)typeBtnClicked {
    if (self.gameType == gameTypeLeague) {
        self.gameType = gameTypenonLeague;
        self.leagueTableView.hidden = YES;
        self.nonleagueTableView.hidden = NO;
        [self.nonleagueTableView reloadData];
    }
    else {
        self.gameType = gameTypeLeague;
        self.leagueTableView.hidden = NO;
        self.nonleagueTableView.hidden = YES;
        [self.leagueTableView reloadData];
    }
}

#pragma mark - delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.textFieldPath = objc_getAssociatedObject(textField, KTextFieldAsObj);
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.tipLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.tipLabel.hidden = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    if (self.gameType == gameTypenonLeague) {

    }
    else if (self.gameType == gameTypeLeague) {
        NSInteger section = self.textFieldPath.section;
        NSInteger row = self.textFieldPath.row;
        //NSLog(@"section=%ld, row=%ld", section, row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.nonleagueTableView) {
        if (section == 1 || section == 3 || section == 4)
            return 10;
        else if (section == 2)
            return 35;
    }
    else if (tableView == self.leagueTableView) {
        if (section == 1 || section == 5)
            return 35;
        else if (section == 2 || section == 3 || section == 4 ||
                 section == 6 || section == 7 || section == 8)
            return 10;
    }

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.nonleagueTableView == tableView) {
        if (section == 0)
            return 4;
        else if (section == 1)
            return 2;
        else if (section == 2 || section == 3 || section == 4)
            return 1;
    }
    else if (self.leagueTableView == tableView) {
        if (section == 0)
            return 4;
        else if (section == 1 || section == 2 || section == 4)
            return 2;
        else if (section == 3)
            return 3;
        else if (section == 5 || section == 6 || section == 7 || section == 8)
            return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.nonleagueTableView == tableView) {
        switch (indexPath.section) {
            case 0:
                return [self drawSection0Cell:self.nonleagueTableView indexPath:indexPath];
            case 1:
                return [self drawSection1Cell:self.nonleagueTableView indexPath:indexPath];
            case 2:
                return [self drawSection2Cell:self.nonleagueTableView indexPath:indexPath];
            case 3:
                return [self drawSection3Cell:self.nonleagueTableView indexPath:indexPath];
            case 4:
                return [self drawSection4Cell:self.nonleagueTableView indexPath:indexPath];
            default:
                break;
        }
    }
    else if (self.leagueTableView == tableView) {
        switch (indexPath.section) {
            case 0:
                return [self drawSection0Cell:self.leagueTableView indexPath:indexPath];
            case 1:
                return [self drawLeagueSection1Cell:self.leagueTableView indexPath:indexPath];
            case 2:
                return [self drawSection1Cell:self.leagueTableView indexPath:indexPath];
            case 3:
                return [self drawLeagueSection3Cell:self.leagueTableView indexPath:indexPath];
            case 4:
                return [self drawLeagueSection4Cell:self.leagueTableView indexPath:indexPath];
            case 5:
                return [self drawLeagueSection5Cell:self.leagueTableView indexPath:indexPath];
            case 6:
                return [self drawLeagueSection6Cell:self.leagueTableView indexPath:indexPath];
            case 7:
                return [self drawLeagueSection7Cell:self.leagueTableView indexPath:indexPath];
            case 8:
                return [self drawSection4Cell:self.leagueTableView indexPath:indexPath];
            default:
                break;
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.nonleagueTableView == tableView)
        return 5;
    else if (self.leagueTableView == tableView)
        return 9;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.nonleagueTableView == tableView) {
        if (indexPath.section == 2 || indexPath.section == 3)
            return 100;
    }
    else if (self.leagueTableView == tableView) {
        if (indexPath.section == 5)
            return 75;
        else if (indexPath.section == 6)
            return 45;
        else if (indexPath.section == 7)
            return 250;
    }
    return 50;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = UIColorFromRGB(0xB2B2B2);
    if (self.nonleagueTableView == tableView) {
        if (section == 2) {
            label.text = @"    活动场次";
            [label sizeToFit];
            return label;
        }
    }
    else if (self.leagueTableView == tableView) {
        if (section == 1) {
            label.text = @"    报名信息";
            [label sizeToFit];
            return label;
        }
        else if (section == 5) {
            label.text = @"    活动内容";
            [label sizeToFit];
            return label;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.nonleagueTableView) {
        if (indexPath.section == 1) {
            CHDatePickerView* datePickView = [[CHDatePickerView alloc]initWithSuperView:self.view completeDateInt:nil completeDateStr:^(NSString *str) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
                NSDate *date = [formatter dateFromString:str];
                [formatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
                NSString *dateStr = [formatter stringFromDate:date];
                UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                UILabel* label = nil;
                if (indexPath.row == 0)         //活动开始时间
                    label = (UILabel*)[cell.contentView viewWithTag:300];
                else if (indexPath.row == 1)    //活动结束时间
                    label = (UILabel*)[cell.contentView viewWithTag:400];
                label.text = dateStr;
                [label sizeToFit];
                label.frame = CGRectMake(APP_WIDTH-label.frame.size.width-30, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
            }];
            [self.view addSubview:datePickView];
        }
    }
    else if (tableView == self.leagueTableView) {
        if (indexPath.section == 1 || indexPath.section == 2) {
            CHDatePickerView* datePickView = [[CHDatePickerView alloc]initWithSuperView:self.view completeDateInt:nil completeDateStr:^(NSString *str) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
                NSDate *date = [formatter dateFromString:str];
                [formatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
                NSString *dateStr = [formatter stringFromDate:date];
                UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                UILabel* label = nil;
                if (indexPath.section == 1 && indexPath.row == 0)           //报名开始时间
                    label = (UILabel*)[cell.contentView viewWithTag:300];
                else if (indexPath.section == 1 && indexPath.row == 1)      //报名结束时间
                    label = (UILabel*)[cell.contentView viewWithTag:400];
                else if (indexPath.section == 2 && indexPath.row == 0)      //活动开始时间
                    label = (UILabel*)[cell.contentView viewWithTag:300];
                else if (indexPath.section == 2 && indexPath.row == 1)      //活动结束时间
                    label = (UILabel*)[cell.contentView viewWithTag:400];
                label.text = dateStr;
                [label sizeToFit];
                label.frame = CGRectMake(APP_WIDTH-label.frame.size.width-30, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
            }];
            [self.view addSubview:datePickView];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];

        UIGraphicsBeginImageContext(CGSizeMake(weakSelf.addImgBtnView.frame.size.width, weakSelf.addImgBtnView.frame.size.height));
        [image drawInRect:CGRectMake(0, 0, weakSelf.addImgBtnView.frame.size.width, weakSelf.addImgBtnView.frame.size.height)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImage* newImage = smallImage;

        UIImageView* imageView = [[UIImageView alloc]initWithFrame:weakSelf.addImgBtnView.frame];
        imageView.image = newImage;
        [weakSelf.headerScrollView addSubview:imageView];
        
        weakSelf.addImgBtnView.frame = CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+10, weakSelf.addImgBtnView.frame.origin.y, weakSelf.addImgBtnView.frame.size.width, weakSelf.addImgBtnView.frame.size.height);
        weakSelf.headerScrollView.contentSize = CGSizeMake(weakSelf.addImgBtnView.frame.size.width+weakSelf.addImgBtnView.frame.origin.x + 10, weakSelf.headerScrollView.contentSize.height);

        [weakSelf.coverPhotoImages addObject:image];
    }];
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
            titleTextField.delegate = self;
            titleTextField.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:titleTextField];
            titleTextField.placeholder = @"请输入活动标题";
        }
        objc_setAssociatedObject(titleTextField, KTextFieldAsObj, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"选择活动分类";
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        
        UILabel* activityTypeLabel = (UILabel*)[cell.contentView viewWithTag:200];
        if (!activityTypeLabel) {
            activityTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(APP_WIDTH-60, 0, 0, 0)];
            activityTypeLabel.font = [UIFont systemFontOfSize:14.0];
            activityTypeLabel.tag = 200;
            activityTypeLabel.textColor = UIColorFromRGB(0x999999);
            [cell.contentView addSubview:activityTypeLabel];
        }
        activityTypeLabel.text = @"篮球";
        [activityTypeLabel sizeToFit];
        activityTypeLabel.center = CGPointMake(activityTypeLabel.center.x, cell.contentView.bounds.size.height/2);
    }
    else if (indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"是否为联赛";
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        
        UIButton* typeBtn = (UIButton*)[cell.contentView viewWithTag:201];
        if (!typeBtn) {
            typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(APP_WIDTH-40, 10, 0, 0)];
            typeBtn.tag = 201;
            [cell.contentView addSubview:typeBtn];
            [typeBtn addTarget:self action:@selector(typeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        }
        if (tableView == self.nonleagueTableView)
            [typeBtn setImage:[UIImage imageNamed:@"ckb_uncheck"] forState:UIControlStateNormal];
        else
            [typeBtn setImage:[UIImage imageNamed:@"ckb_checked"] forState:UIControlStateNormal];
        [typeBtn sizeToFit];
        typeBtn.center = CGPointMake(typeBtn.center.x, cell.contentView.bounds.size.height/2);
    }
    else if (indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"参加类型";
        cell.textLabel.textColor = UIColorFromRGB(0x999999);

        UILabel* teamLabel = (UILabel*)[cell.contentView viewWithTag:205];
        if (!teamLabel) {
            teamLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            teamLabel.tag = 205;
            teamLabel.font = [UIFont systemFontOfSize:14.0];
            [cell.contentView addSubview:teamLabel];
        }
        teamLabel.text = @"团队";
        [teamLabel sizeToFit];
        teamLabel.frame = CGRectMake(APP_WIDTH-15-teamLabel.frame.size.width, 0, teamLabel.frame.size.width, teamLabel.frame.size.height);
        teamLabel.center = CGPointMake(teamLabel.center.x, cell.contentView.bounds.size.height/2);
        
        UIButton* teamTypeBtn = (UIButton*)[cell.contentView viewWithTag:203];
        if (!teamTypeBtn) {
            teamTypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(teamLabel.frame.origin.x-30, 10, 0, 0)];
            teamTypeBtn.tag = 203;
            [cell.contentView addSubview:teamTypeBtn];
            [teamTypeBtn addTarget:self action:@selector(teamTypeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        }
        if (self.joinType == joinTypeNull || self.joinType == joinTypePerson)
            [teamTypeBtn setImage:[UIImage imageNamed:@"ckb_uncheck"] forState:UIControlStateNormal];
        else
            [teamTypeBtn setImage:[UIImage imageNamed:@"ckb_checked"] forState:UIControlStateNormal];
        [teamTypeBtn sizeToFit];
        teamTypeBtn.center = CGPointMake(teamTypeBtn.center.x, cell.contentView.bounds.size.height/2);
        
        UILabel* personLabel = (UILabel*)[cell.contentView viewWithTag:204];
        if (!personLabel) {
            personLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            personLabel.tag = 204;
            personLabel.font = [UIFont systemFontOfSize:14.0];
            [cell.contentView addSubview:personLabel];
        }
        personLabel.text = @"个人";
        [personLabel sizeToFit];
        personLabel.frame = CGRectMake(teamTypeBtn.frame.origin.x-30-personLabel.frame.size.width, 0, personLabel.frame.size.width, personLabel.frame.size.height);
        personLabel.center = CGPointMake(personLabel.center.x, cell.contentView.bounds.size.height/2);
        
        UIButton* personTypeBtn = (UIButton*)[cell.contentView viewWithTag:202];
        if (!personTypeBtn) {
            personTypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(personLabel.frame.origin.x-30, 10, 0, 0)];
            personTypeBtn.tag = 202;
            [cell.contentView addSubview:personTypeBtn];
            [personTypeBtn addTarget:self action:@selector(personTypeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        }
        if (self.joinType == joinTypeNull || self.joinType == joinTypeTeam)
            [personTypeBtn setImage:[UIImage imageNamed:@"ckb_uncheck"] forState:UIControlStateNormal];
        else
            [personTypeBtn setImage:[UIImage imageNamed:@"ckb_checked"] forState:UIControlStateNormal];
        [personTypeBtn sizeToFit];
        personTypeBtn.center = CGPointMake(personTypeBtn.center.x, cell.contentView.bounds.size.height/2);
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"活动开始时间";
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        
        UILabel* startTimeLabel = (UILabel*)[cell.contentView viewWithTag:300];
        if (!startTimeLabel) {
            startTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            startTimeLabel.font = [UIFont systemFontOfSize:14.0];
            startTimeLabel.tag = 300;
            startTimeLabel.textColor = UIColorFromRGB(0x999999);
            [cell.contentView addSubview:startTimeLabel];
        }
        startTimeLabel.text = @"未设置";
        [startTimeLabel sizeToFit];
        startTimeLabel.frame = CGRectMake(APP_WIDTH-startTimeLabel.frame.size.width-30, 0, startTimeLabel.frame.size.width, startTimeLabel.frame.size.height);
        startTimeLabel.center = CGPointMake(startTimeLabel.center.x, cell.contentView.bounds.size.height/2);
    }
    else if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"活动结束时间";
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        
        UILabel* endTimeLabel = (UILabel*)[cell.contentView viewWithTag:400];
        if (!endTimeLabel) {
            endTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            endTimeLabel.font = [UIFont systemFontOfSize:14.0];
            endTimeLabel.tag = 400;
            endTimeLabel.textColor = UIColorFromRGB(0x999999);
            [cell.contentView addSubview:endTimeLabel];
        }
        endTimeLabel.text = @"未设置";
        [endTimeLabel sizeToFit];
        endTimeLabel.frame = CGRectMake(APP_WIDTH-endTimeLabel.frame.size.width-30, 0, endTimeLabel.frame.size.width, endTimeLabel.frame.size.height);
        endTimeLabel.center = CGPointMake(endTimeLabel.center.x, cell.contentView.bounds.size.height/2);
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

- (UITableViewCell*)drawLeagueSection1Cell:(UITableView*)tableView
                           indexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell1 forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel* addLabel = (UILabel*)[cell.contentView viewWithTag:101];
    addLabel.hidden = YES;
    
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"报名开始时间";
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        
        UILabel* startTimeLabel = (UILabel*)[cell.contentView viewWithTag:300];
        if (!startTimeLabel) {
            startTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            startTimeLabel.font = [UIFont systemFontOfSize:14.0];
            startTimeLabel.tag = 300;
            startTimeLabel.textColor = UIColorFromRGB(0x999999);
            [cell.contentView addSubview:startTimeLabel];
        }
        startTimeLabel.hidden = NO;
        startTimeLabel.text = @"未设置";
        [startTimeLabel sizeToFit];
        startTimeLabel.frame = CGRectMake(APP_WIDTH-startTimeLabel.frame.size.width-30, 0, startTimeLabel.frame.size.width, startTimeLabel.frame.size.height);
        startTimeLabel.center = CGPointMake(startTimeLabel.center.x, cell.contentView.bounds.size.height/2);
    }
    else if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"报名结束时间";
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        
        UILabel* endTimeLabel = (UILabel*)[cell.contentView viewWithTag:400];
        if (!endTimeLabel) {
            endTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            endTimeLabel.font = [UIFont systemFontOfSize:14.0];
            endTimeLabel.tag = 400;
            endTimeLabel.textColor = UIColorFromRGB(0x999999);
            [cell.contentView addSubview:endTimeLabel];
        }
        endTimeLabel.hidden = NO;
        endTimeLabel.text = @"未设置";
        [endTimeLabel sizeToFit];
        endTimeLabel.frame = CGRectMake(APP_WIDTH-endTimeLabel.frame.size.width-30, 0, endTimeLabel.frame.size.width, endTimeLabel.frame.size.height);
        endTimeLabel.center = CGPointMake(endTimeLabel.center.x, cell.contentView.bounds.size.height/2);
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
    else
        lineLabel.hidden = NO;
    
    return cell;
}

- (UITableViewCell*)drawLeagueSection3Cell:(UITableView*)tableView
                                 indexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell5 forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"计划报名数";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"每队报名人数下限";
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"每队报名人数上限";
    }

    StepperView* view = (StepperView*)[cell.contentView viewWithTag:2000];
    if (!view) {
        view = [[StepperView alloc]initWithFrame:CGRectMake(APP_WIDTH-90, 0, 70, 35)];
        [cell.contentView addSubview:view];
        view.tag = 2000;
        view.center = CGPointMake(view.center.x, cell.contentView.bounds.size.height/2);
    }
    [view setCurrentSelectNum:^(NSInteger num) {
        if (indexPath.row == 0) {
            
        }
        else if (indexPath.row == 1) {
            
        }
        else if (indexPath.row == 2) {
            
        }
    }];

    UILabel* lineLabel = (UILabel*)[cell.contentView viewWithTag:1000];
    if (!lineLabel) {
        lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, cell.contentView.bounds.size.height-0.5, APP_WIDTH-15, 0.5)];
        lineLabel.tag = 1000;
        lineLabel.backgroundColor = UIColorFromRGB(0xDEDEDE);
        [cell.contentView addSubview:lineLabel];
    }
    if (indexPath.row == 2)
        lineLabel.hidden = YES;

    return cell;
}

- (UITableViewCell*)drawLeagueSection4Cell:(UITableView*)tableView
                                 indexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell6 forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"费用";
        UITextField* textField = (UITextField*)[cell.contentView viewWithTag:100];
        if (!textField) {
            textField = [[UITextField alloc]initWithFrame:CGRectMake(APP_WIDTH-15-70, 0, 0, 0)];
            textField.tag = 100;
            textField.placeholder = @"请输入费用";
            textField.font = [UIFont systemFontOfSize:14.0];
            [cell.contentView addSubview:textField];
            textField.delegate = self;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.textAlignment = NSTextAlignmentRight;
            [textField sizeToFit];
        }
        objc_setAssociatedObject(textField, KTextFieldAsObj, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        textField.center = CGPointMake(textField.center.x, cell.contentView.bounds.size.height/2);
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"保证金";
        UITextField* textField = (UITextField*)[cell.contentView viewWithTag:101];
        if (!textField) {
            textField = [[UITextField alloc]initWithFrame:CGRectMake(APP_WIDTH-15-70, 0, 0, 0)];
            textField.tag = 101;
            textField.placeholder = @"请输入费用";
            textField.font = [UIFont systemFontOfSize:14.0];
            [cell.contentView addSubview:textField];
            textField.delegate = self;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.textAlignment = NSTextAlignmentRight;
            [textField sizeToFit];
        }
        objc_setAssociatedObject(textField, KTextFieldAsObj, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        textField.center = CGPointMake(textField.center.x, cell.contentView.bounds.size.height/2);
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

- (UITableViewCell*)drawLeagueSection5Cell:(UITableView*)tableView
                                 indexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell7 forIndexPath:indexPath];
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
    imageView.center = CGPointMake(imageView.center.x, cell.contentView.bounds.size.height/2);
    
    CGFloat x = imageView.frame.size.width + imageView.frame.origin.x + 10;
    UILabel* nameLabel = (UILabel*)[cell.contentView viewWithTag:100];
    if (!nameLabel) {
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 5, 0, 0)];
        nameLabel.font = [UIFont systemFontOfSize:14.0];
        nameLabel.tag = 100;
        nameLabel.textColor = UIColorFromRGB(0x333333);
        [cell.contentView addSubview:nameLabel];
    }
    nameLabel.text = @"活动地点";
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(nameLabel.center.x, cell.contentView.bounds.size.height/2);
    
    UILabel* addLabel = (UILabel*)[cell.contentView viewWithTag:101];
    if (!addLabel) {
        addLabel = [[UILabel alloc]initWithFrame:CGRectMake(APP_WIDTH-70, 0, 0, 0)];
        addLabel.font = [UIFont systemFontOfSize:14.0];
        addLabel.tag = 101;
        addLabel.textColor = UIColorFromRGB(0x999999);
        [cell.contentView addSubview:addLabel];
    }
    addLabel.text = @"去定位";
    [addLabel sizeToFit];
    addLabel.center = CGPointMake(addLabel.center.x, cell.contentView.bounds.size.height/2);
    
    return cell;
}

- (UITableViewCell*)drawLeagueSection6Cell:(UITableView*)tableView
                                 indexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell1 forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @"联系方式";
    
    UILabel* startTimeLabel = (UILabel*)[cell.contentView viewWithTag:300];
    startTimeLabel.hidden = YES;
    UILabel* endTimeLabel = (UILabel*)[cell.contentView viewWithTag:400];
    endTimeLabel.hidden = YES;
    
    UILabel* addLabel = (UILabel*)[cell.contentView viewWithTag:101];
    if (!addLabel) {
        addLabel = [[UILabel alloc]initWithFrame:CGRectMake(APP_WIDTH-70, 0, 0, 0)];
        addLabel.font = [UIFont systemFontOfSize:14.0];
        addLabel.tag = 101;
        addLabel.textColor = UIColorFromRGB(0x999999);
        [cell.contentView addSubview:addLabel];
    }
    addLabel.hidden = NO;
    addLabel.text = @"未添加";
    [addLabel sizeToFit];
    addLabel.center = CGPointMake(addLabel.center.x, cell.contentView.bounds.size.height/2);
    
    return cell;
}

- (UITableViewCell*)drawLeagueSection7Cell:(UITableView*)tableView
                                 indexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell8 forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UITextView* textView = (UITextView*)[cell.contentView viewWithTag:100];
    if (!textView) {
        textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 5, APP_WIDTH-30, 150)];
        textView.tag = 100;
        [cell.contentView addSubview:textView];
        textView.delegate = self;
        textView.font = [UIFont systemFontOfSize:14.0];
    }
    
    self.tipLabel = (UILabel*)[cell.contentView viewWithTag:101];
    if (!self.tipLabel) {
        self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 0, 0)];
        self.tipLabel.font = [UIFont systemFontOfSize:14.0];
        self.tipLabel.tag = 101;
        self.tipLabel.textColor = UIColorFromRGB(0x999999);
        [cell.contentView addSubview:self.tipLabel];
    }
    self.tipLabel.text = @"请输入活动详情";
    [self.tipLabel sizeToFit];
    
    UIButton* btn = (UIButton*)[cell.contentView viewWithTag:102];
    if (!btn) {
        btn = [[UIButton alloc]initWithFrame:CGRectMake(APP_WIDTH-40, cell.contentView.bounds.size.height-30, 0, 0)];
        btn.tag = 102;
        [cell.contentView addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"ic_append"] forState:UIControlStateNormal];
        [btn sizeToFit];
    }
    
    return cell;
}

@end
