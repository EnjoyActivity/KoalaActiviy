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
#import "ParameterTableViewController.h"
#import "ContactTypeViewController.h"
#import "SessionInfoViewController.h"
#import "ActivityAddressViewController.h"//废弃
#import "LocationChoiceViewController.h"
#import "AdressCityVC.h"

#define kCell1              @"cell1"
#define kCell2              @"cell2"
#define kCell3              @"cell3"
#define kCell4              @"cell4"
#define kCell5              @"cell5"
#define kCell6              @"cell6"
#define kCell7              @"cell7"
#define kCell8              @"cell8"
#define kCell9              @"cell9"
#define KTextFieldAsObj     @"textFieldAssociatedObject"

typedef enum gameType {
    gameTypeLeague = 1,
    gameTypenonLeague = 0
}gameType;

typedef enum joinType {
    joinTypePerson = 0,
    joinTypeTeam = 1
}joinType;

typedef enum imagePickerFromType {
    imagePickerFromTypeHeader = 0,
    imagePickerFromTypeDetail
}imagePickerFromType;

@interface ActivityReleaseViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate> {
    @private
    BOOL _keyboardShow;
    BOOL _scrollViewDidScroll;
    CGFloat _mainScrollViewContentSizeheight;
    CGFloat _mainScrollViewoffsetY;
}

@property (nonatomic, strong)UITableView* leagueTableView;
@property (nonatomic, strong)UITableView* nonleagueTableView;
@property (nonatomic, strong)UIScrollView* headerScrollView;
@property (nonatomic, strong)UIView* addImgBtnView;
@property (nonatomic, assign)imagePickerFromType imgFromType;
@property (nonatomic, strong)NSMutableArray* coverPhotoImages;
@property (nonatomic, strong)NSMutableArray* detailPhotoImages;
@property (nonatomic, strong)NSMutableArray* detailPhotoImages_show;
@property (nonatomic, strong)NSIndexPath* textFieldPath;
@property (nonatomic, strong)UILabel* tipLabel;
@property (nonatomic, strong)UIScrollView* detailImageScrollView;
@property (nonatomic, strong)UIButton* btn;
@property (nonatomic, strong)UITextField* costTextField;
@property (nonatomic, strong)UITextField* marginTextField;
@property (nonatomic, strong)NSTimer* timer;
@property (atomic, assign)BOOL isComplete;
@property (nonatomic, strong)UIImageView* corverImgView;

//发布请求参数
@property (nonatomic, assign)gameType gameType;                                 //活动是否联赛
@property (nonatomic, assign)joinType joinType;                                 //参加类型
@property (nonatomic, strong)NSString* phoneNum;                                //联系电话
@property (nonatomic, strong)NSString* complainTelNum;                          //举报电话
@property (nonatomic, strong)NSString* activityDetailText;                      //活动详情
@property (nonatomic, strong)NSString* titleStr;                                //活动标题
@property (nonatomic, strong)NSString* corverImgPath;                           //封面图片路径
@property (nonatomic, strong)NSMutableDictionary* selectActivityDict;           //选择的活动类别
@property (nonatomic, strong)NSMutableDictionary* timeSigningUpDict;            //报名时间
@property (nonatomic, strong)NSMutableDictionary* timeActivityDict;             //活动时间
@property (nonatomic, strong)NSMutableDictionary* signingUpPersonCountDict;     //报名人数情况
@property (nonatomic, strong)NSMutableDictionary* moneyDict;                    //费用
@property (nonatomic, strong)NSMutableDictionary* activityAddress;              //活动地点
@property (nonatomic, strong)NSMutableArray* activitySessionArray;              //活动场次

@end

@implementation ActivityReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xF2F3F4);
    self.joinType = joinTypePerson;
    [self initParameter];
    [self setupNavigationBar];
    [self setupHeaderImgScrollView];
    [self drawNonLeagueTableView];
    [self drawLeagueTableView];
    [self addKeyboardNotification];
    
    [self setupCheckParameterTimer];
}

- (void)dealloc {
    [self releaseResource];
    [self removeKeyboardNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self releaseResource];
}

- (void)initParameter {
    self.isComplete = NO;
    self.gameType = gameTypenonLeague;
    
    self.coverPhotoImages = [NSMutableArray array];
    self.detailPhotoImages = [NSMutableArray array];
    self.detailPhotoImages_show = [NSMutableArray array];
    self.activitySessionArray = [NSMutableArray array];
    
    self.selectActivityDict = [NSMutableDictionary dictionary];
    self.timeSigningUpDict = [NSMutableDictionary dictionary];
    self.timeActivityDict = [NSMutableDictionary dictionary];
    self.signingUpPersonCountDict = [NSMutableDictionary dictionary];
    self.moneyDict = [NSMutableDictionary dictionary];
    //self.activityAddress = [NSMutableDictionary dictionary];
}

- (void)releaseResource {
    self.coverPhotoImages = nil;
    self.detailPhotoImages = nil;
    self.leagueTableView = nil;
    self.nonleagueTableView = nil;
}

- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)setupCheckParameterTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(doTimer) userInfo:nil repeats:YES];
}

#pragma mark - drawUI
- (void)setupNavigationBar {
    self.navigationItem.title = @"发布活动";
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
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
    [self.leagueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell9];
    self.leagueTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leagueTableView.hidden = YES;
}

#pragma mark - btn clicked 
- (void)addDetailImageBtnClicked {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        self.imgFromType = imagePickerFromTypeDetail;
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

- (void)personTypeBtnClicked {
    self.joinType = joinTypePerson;
    [self.nonleagueTableView reloadData];
    [self.leagueTableView reloadData];
}

- (void)teamTypeBtnClicked {
    self.joinType = joinTypeTeam;
    [self.nonleagueTableView reloadData];
    [self.leagueTableView reloadData];
}

- (void)addCoverPhotoClicked {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        self.imgFromType = imagePickerFromTypeHeader;
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
    [self.timer invalidate];
    self.timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startBtnClicked {
    //[self saveActivity];
    [self commitActivity];
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
- (void)keyboardWillShow:(NSNotification *) notif {
    if (self.gameType == gameTypenonLeague)
        return;
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if (![firstResponder isKindOfClass:[UITextView class]]) {
        _mainScrollViewContentSizeheight = self.leagueTableView.contentSize.height;
        _mainScrollViewoffsetY = self.leagueTableView.contentOffset.y;
        return;
    }
    if (_keyboardShow)
        return;

    _scrollViewDidScroll = YES;
    _mainScrollViewContentSizeheight = self.leagueTableView.contentSize.height;
    _mainScrollViewoffsetY = self.leagueTableView.contentOffset.y;
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;

    CGFloat y = _mainScrollViewoffsetY+keyboardSize.height-80;
    CGFloat sizeHeigth = 0;
    sizeHeigth = _mainScrollViewContentSizeheight+keyboardSize.height;
    _keyboardShow = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.leagueTableView setContentSize:CGSizeMake(APP_WIDTH, sizeHeigth)];
        [self.leagueTableView setContentOffset:CGPointMake(0, y) animated:YES];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _scrollViewDidScroll = NO;
        });
    }];
}

- (void)keyboardDidHide:(NSNotification *) notif {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSString* str = ((UITextField*)firstResponder).text;
        if (firstResponder.tag == 100) //活动标题
            self.titleStr = str;
        else {
            str = self.costTextField.text;
            [self.moneyDict setValue:str forKey:@"cost"];
            str = self.marginTextField.text;
            [self.moneyDict setValue:str forKey:@"margin"];
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.leagueTableView setContentSize:CGSizeMake(APP_WIDTH, _mainScrollViewContentSizeheight)];
        [self.leagueTableView setContentOffset:CGPointMake(0, _mainScrollViewoffsetY) animated:YES];
        _keyboardShow = NO;
    } completion:nil];
}

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
    else {
        self.activityDetailText = textView.text;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_scrollViewDidScroll)
        return;
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.nonleagueTableView) {
        if (section == 1 )
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
        else if (section == 2) {
            return self.activitySessionArray.count+1;
        }
        else if (section == 3)
            return 1;
    }
    else if (self.leagueTableView == tableView) {
        if (section == 0)
            return 4;
        else if (section == 1 || section == 2 || section == 4)
            return 2;
        else if (section == 3) {
            if (self.joinType == joinTypePerson)
                return 1;
            else if (self.joinType == joinTypeTeam)
                return 3;
        }
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
                return [self drawSection2ListCell:self.nonleagueTableView indexPath:indexPath];
            case 3:
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
        return 4;
    else if (self.leagueTableView == tableView)
        return 9;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.nonleagueTableView == tableView) {
        if (indexPath.section == 2)
            return 100;
    }
    else if (self.leagueTableView == tableView) {
        if (indexPath.section == 5)
            return 75;
        else if (indexPath.section == 6)
            return 45;
        else if (indexPath.section == 7)
            return 150;
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
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self.view endEditing:YES];
        ParameterTableViewController* VC = [[ParameterTableViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
        VC.vcTitle = @"活动分类";
        [VC setSelectCellBlock:^(NSDictionary *dict) {
            weakSelf.selectActivityDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [weakSelf.leagueTableView reloadData];
            [weakSelf.nonleagueTableView reloadData];
        }];
        return;
    }
    
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
                if (indexPath.row == 0)  {
                    label = (UILabel*)[cell.contentView viewWithTag:300];
                    [weakSelf.timeActivityDict setValue:dateStr forKey:@"beginTime"];
                }
                else if (indexPath.row == 1) {
                    label = (UILabel*)[cell.contentView viewWithTag:400];
                    [weakSelf.timeActivityDict setValue:dateStr forKey:@"endTime"];
                }
                label.text = dateStr;
                [label sizeToFit];
                label.frame = CGRectMake(APP_WIDTH-label.frame.size.width-30, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
            }];
            [self.view addSubview:datePickView];
        }
        else if (indexPath.section == 2) {
            [self.view endEditing:YES];
            SessionInfoViewController* Vc = [[SessionInfoViewController alloc]init];
            BOOL isModify = NO;
            NSDictionary* tempDict = nil;
            if (self.activitySessionArray.count > indexPath.row) {
                tempDict = self.activitySessionArray[indexPath.row];
                if (tempDict)
                    isModify = YES;
            }
            [Vc setCompleteBlock:^(BOOL isMoidfy, NSDictionary *dict) {
                if (isModify) {
                    [weakSelf.activitySessionArray removeObjectAtIndex:indexPath.row];
                    [weakSelf.activitySessionArray insertObject:dict atIndex:indexPath.row];
                }
                else {
                    [weakSelf.activitySessionArray addObject:dict];
                }
                [weakSelf.nonleagueTableView reloadData];
            } isModify:isModify];
            if (tempDict)
                [Vc setPreDict:tempDict];
            [self.navigationController pushViewController:Vc animated:YES];
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
                if (indexPath.section == 1 && indexPath.row == 0) {
                    label = (UILabel*)[cell.contentView viewWithTag:300];
                    [weakSelf.timeSigningUpDict setValue:dateStr forKey:@"beginTime"];
                }
                else if (indexPath.section == 1 && indexPath.row == 1) {
                    label = (UILabel*)[cell.contentView viewWithTag:400];
                    [weakSelf.timeSigningUpDict setValue:dateStr forKey:@"endTime"];
                }
                else if (indexPath.section == 2 && indexPath.row == 0)  {
                    label = (UILabel*)[cell.contentView viewWithTag:300];
                    [weakSelf.timeActivityDict setValue:dateStr forKey:@"beginTime"];
                }
                else if (indexPath.section == 2 && indexPath.row == 1) {
                    label = (UILabel*)[cell.contentView viewWithTag:400];
                    [weakSelf.timeActivityDict setValue:dateStr forKey:@"endTime"];
                }
                label.text = dateStr;
                [label sizeToFit];
                label.frame = CGRectMake(APP_WIDTH-label.frame.size.width-30, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
            }];
            [self.view addSubview:datePickView];
        }
        else if (indexPath.section == 6) {
            [self.view endEditing:YES];
            ContactTypeViewController* Vc = [[ContactTypeViewController alloc]init];
            [self.navigationController pushViewController:Vc animated:YES];
            [Vc setCompleteSelect:^(NSString* phoneNum, NSString* complainTelNum) {
                weakSelf.phoneNum = phoneNum;
                weakSelf.complainTelNum = complainTelNum;
                [weakSelf.leagueTableView reloadData];
            }];
        }
        else if (indexPath.section == 5) {
            [self.view endEditing:YES];
            AdressCityVC* Vc = [[AdressCityVC alloc]init];
            Vc.isSearch = YES;
            Vc.locationResult = ^(NSDictionary *dict) {
                weakSelf.activityAddress = [NSMutableDictionary dictionaryWithDictionary:dict];
                [weakSelf.leagueTableView reloadData];
            };
            
            [self.navigationController pushViewController:Vc animated:YES];
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

        if (weakSelf.imgFromType == imagePickerFromTypeHeader) {
            if (!weakSelf.corverImgView) {
                weakSelf.corverImgView = [[UIImageView alloc]initWithFrame:weakSelf.addImgBtnView.frame];
            }
            weakSelf.corverImgView.image = newImage;
            [weakSelf.headerScrollView addSubview:weakSelf.corverImgView];
            
            weakSelf.addImgBtnView.frame = CGRectMake(weakSelf.corverImgView.frame.size.width+weakSelf.corverImgView.frame.origin.x+10, weakSelf.addImgBtnView.frame.origin.y, weakSelf.addImgBtnView.frame.size.width, weakSelf.addImgBtnView.frame.size.height);
            weakSelf.headerScrollView.contentSize = CGSizeMake(weakSelf.addImgBtnView.frame.size.width+weakSelf.addImgBtnView.frame.origin.x + 10, weakSelf.headerScrollView.contentSize.height);
            
            weakSelf.coverPhotoImages = nil;
            weakSelf.coverPhotoImages = [NSMutableArray array];
            [weakSelf.coverPhotoImages addObject:image];
            [weakSelf uploadImg:image];
        }
        else if (weakSelf.imgFromType == imagePickerFromTypeDetail) {
            [weakSelf.detailPhotoImages addObject:image];
            [weakSelf.detailPhotoImages_show addObject:newImage];
            for (UIView* subView in weakSelf.detailImageScrollView.subviews)
                [subView removeFromSuperview];
            
            CGSize newSize;
            CGFloat x = 15;
            for (UIImage* tempImage in weakSelf.detailPhotoImages_show) {
                UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 0, 65, 65)];
                imageView.image = tempImage;
                imageView.center = CGPointMake(imageView.center.x, weakSelf.detailImageScrollView.bounds.size.height/2);
                [weakSelf.detailImageScrollView addSubview:imageView];
                newSize = CGSizeMake(imageView.frame.origin.x+imageView.frame.size.width+5, weakSelf.detailImageScrollView.contentSize.height);
                x += 65 + 10;
            }
            weakSelf.detailImageScrollView.contentSize = CGSizeMake(newSize.width, newSize.height);
            
            [weakSelf uploadImg:image];
        }
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
        titleTextField.text = self.titleStr;
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
        if (self.selectActivityDict)
            activityTypeLabel.text = [self.selectActivityDict objectForKey:@"ClassName"];
        else
            activityTypeLabel.text = @"未设置";
        [activityTypeLabel sizeToFit];
        activityTypeLabel.frame = CGRectMake(APP_WIDTH-activityTypeLabel.frame.size.width-30, 0, activityTypeLabel.frame.size.width, activityTypeLabel.frame.size.height);
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
        if (self.joinType == joinTypePerson)
            [teamTypeBtn setImage:[UIImage imageNamed:@"ckb_uncheck"] forState:UIControlStateNormal];
        else if (self.joinType == joinTypeTeam)
            [teamTypeBtn setImage:[UIImage imageNamed:@"ckb_checked"] forState:UIControlStateNormal];
        else
            [teamTypeBtn setImage:[UIImage imageNamed:@"ckb_uncheck"] forState:UIControlStateNormal];
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
        if (self.joinType == joinTypeTeam)
            [personTypeBtn setImage:[UIImage imageNamed:@"ckb_uncheck"] forState:UIControlStateNormal];
        else if (self.joinType == joinTypePerson)
            [personTypeBtn setImage:[UIImage imageNamed:@"ckb_checked"] forState:UIControlStateNormal];
        else
            [personTypeBtn setImage:[UIImage imageNamed:@"ckb_uncheck"] forState:UIControlStateNormal];
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
        
        NSArray* keys = self.timeActivityDict.allKeys;
        if (self.timeActivityDict && [keys containsObject:@"beginTime"])
            startTimeLabel.text = [self.timeActivityDict objectForKey:@"beginTime"];
        else
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
        
        NSArray* keys = self.timeActivityDict.allKeys;
        if (self.timeActivityDict && [keys containsObject:@"endTime"])
            endTimeLabel.text = [self.timeActivityDict objectForKey:@"endTime"];
        else
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

- (UITableViewCell*)drawSection2ListCell:(UITableView*)tableView
                           indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.activitySessionArray.count)
        return [self drawSection3Cell:tableView indexPath:indexPath];
    return [self drawSection2Cell:tableView indexPath:indexPath];
}

- (UITableViewCell*)drawSection2Cell:(UITableView*)tableView
                           indexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell2 forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary* dict = self.activitySessionArray[indexPath.row];
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
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 10, 0, 0)];
        nameLabel.font = [UIFont systemFontOfSize:16.0];
        nameLabel.tag = 100;
        nameLabel.textColor = UIColorFromRGB(0x333333);
        [cell.contentView addSubview:nameLabel];
    }
    
    NSDictionary* tempDict = [dict objectForKey:@"activityVenue"];
    nameLabel.text = [tempDict objectForKey:@"placeName"];
    [nameLabel sizeToFit];
    if (nameLabel.frame.size.width > 150) {
        nameLabel.frame = CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y, 150, nameLabel.frame.size.height);
    }
    
    UILabel* addLabel = (UILabel*)[cell.contentView viewWithTag:101];
    if (!addLabel) {
        addLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, nameLabel.frame.origin.y+nameLabel.frame.size.height+5, 0, 0)];
        addLabel.font = [UIFont systemFontOfSize:12.0];
        addLabel.tag = 101;
        addLabel.textColor = UIColorFromRGB(0x999999);
        [cell.contentView addSubview:addLabel];
    }
    addLabel.text = [tempDict objectForKey:@"Address"];
    [addLabel sizeToFit];
    if (addLabel.frame.size.width > 150) {
        addLabel.frame = CGRectMake(addLabel.frame.origin.x, addLabel.frame.origin.y, 150, addLabel.frame.size.height);
    }
    
    x= imageView.frame.origin.x;
    UILabel* timeLabel = (UILabel*)[cell.contentView viewWithTag:102];
    if (!timeLabel) {
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, addLabel.frame.origin.y+addLabel.frame.size.height+10, 0, 0)];
        timeLabel.font = [UIFont systemFontOfSize:12.0];
        timeLabel.tag = 102;
        timeLabel.textColor = UIColorFromRGB(0x999999);
        [cell.contentView addSubview:timeLabel];
    }
    timeLabel.text = [NSString stringWithFormat:@"报名时间:%@-%@", [dict objectForKey:@"applyBeginTime"], [dict objectForKey:@"applyEndTime"]];
    [timeLabel sizeToFit];
    
//    UILabel* personLabel = (UILabel*)[cell.contentView viewWithTag:103];
//    if (!personLabel) {
//        personLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, timeLabel.frame.origin.y+timeLabel.frame.size.height+5, 0, 0)];
//        personLabel.font = [UIFont systemFontOfSize:12.0];
//        personLabel.tag = 103;
//        personLabel.textColor = UIColorFromRGB(0x999999);
//        [cell.contentView addSubview:personLabel];
//    }
//    personLabel.text = [NSString stringWithFormat:@"组织者：%@", [dict objectForKey:@"organizers"]];
//    [personLabel sizeToFit];
    
    UILabel* moneyLabel = (UILabel*)[cell.contentView viewWithTag:104];
    if (!moneyLabel) {
        moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(APP_WIDTH-80, 0, 0, 0)];
        moneyLabel.font = [UIFont systemFontOfSize:16.0];
        moneyLabel.tag = 104;
        moneyLabel.textColor = UIColorFromRGB(0xE31B1A);
        [cell.contentView addSubview:moneyLabel];
    }
    moneyLabel.text = [NSString stringWithFormat:@"%@元", [dict objectForKey:@"activityCost"]];
    [moneyLabel sizeToFit];
    moneyLabel.frame = CGRectMake(APP_WIDTH-30-moneyLabel.frame.size.width, 0, moneyLabel.frame.size.width, moneyLabel.frame.size.height);
    moneyLabel.center = CGPointMake(moneyLabel.center.x, cell.contentView.bounds.size.height/2);
    
    UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.contentView.bounds.size.height-10, APP_WIDTH, 10)];
    lineLabel.backgroundColor = UIColorFromRGB(0xF2F3F4);
    [cell.contentView addSubview:lineLabel];

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
    nameLabel.text = [NSString stringWithFormat:@"场次%ld", self.activitySessionArray.count+1];
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

    self.btn = [[UIButton alloc]initWithFrame:cell.contentView.bounds];
    [cell.contentView addSubview:self.btn];
    self.btn.backgroundColor = UIColorFromRGB(0xDEDEDE);
    [self.btn setTitle:@"发布" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btn.userInteractionEnabled = NO;
    if (self.isComplete) {
        self.btn.backgroundColor = [UIColor redColor];
        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btn.userInteractionEnabled = YES;
    }

    [self.btn addTarget:self action:@selector(startBtnClicked) forControlEvents:UIControlEventTouchUpInside];

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
   
        NSArray* keys = self.timeSigningUpDict.allKeys;
        if (self.timeSigningUpDict && [keys containsObject:@"beginTime"])
            startTimeLabel.text = [self.timeSigningUpDict objectForKey:@"beginTime"];
        else
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
        NSArray* keys = self.timeSigningUpDict.allKeys;
        if (self.timeSigningUpDict && [keys containsObject:@"endTime"])
            endTimeLabel.text = [self.timeSigningUpDict objectForKey:@"endTime"];
        else
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
    __weak typeof(self)weakSelf = self;
    [view setCurrentSelectNum:^(NSInteger num) {
        if (indexPath.row == 0) {
            [weakSelf.signingUpPersonCountDict setValue:[NSNumber numberWithInteger:num] forKey:@"planCount"];
        }
        else if (indexPath.row == 1) {
            [weakSelf.signingUpPersonCountDict setValue:[NSNumber numberWithInteger:num] forKey:@"lowerLimitCount"];
        }
        else if (indexPath.row == 2) {
            [weakSelf.signingUpPersonCountDict setValue:[NSNumber numberWithInteger:num] forKey:@"ceilingCount"];
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
        cell.textLabel.text = @"活动最小金额";//@"费用";
        self.costTextField = (UITextField*)[cell.contentView viewWithTag:500];
        if (!self.costTextField) {
            self.costTextField = [[UITextField alloc]initWithFrame:CGRectMake(APP_WIDTH-15-70, 0, 0, 0)];
            self.costTextField.tag = 500;
            self.costTextField.placeholder = @"请输入金额";//@"请输入费用";
            self.costTextField.font = [UIFont systemFontOfSize:14.0];
            [cell.contentView addSubview:self.costTextField];
            self.costTextField.delegate = self;
            self.costTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.costTextField.textAlignment = NSTextAlignmentCenter;
            [self.costTextField sizeToFit];
        }
        NSArray* keys = self.moneyDict.allKeys;
        if (self.moneyDict && [keys containsObject:@"cost"])
            self.costTextField.text = [self.moneyDict objectForKey:@"cost"];
 
        objc_setAssociatedObject(self.costTextField, KTextFieldAsObj, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.costTextField.center = CGPointMake(self.costTextField.center.x, cell.contentView.bounds.size.height/2);
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"活动最大金额";//@"保证金";
        self.marginTextField = (UITextField*)[cell.contentView viewWithTag:501];
        if (!self.marginTextField) {
            self.marginTextField = [[UITextField alloc]initWithFrame:CGRectMake(APP_WIDTH-15-70, 0, 0, 0)];
            self.marginTextField.tag = 501;
            self.marginTextField.placeholder = @"请输入金额";//@"请输入保证金";
            self.marginTextField.font = [UIFont systemFontOfSize:14.0];
            [cell.contentView addSubview:self.marginTextField];
            self.marginTextField.delegate = self;
            self.marginTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.marginTextField.textAlignment = NSTextAlignmentCenter;
            [self.marginTextField sizeToFit];
        }
        NSArray* keys = self.moneyDict.allKeys;
        if (self.moneyDict && [keys containsObject:@"margin"])
            self.marginTextField.text = [self.moneyDict objectForKey:@"margin"];

        objc_setAssociatedObject(self.marginTextField, KTextFieldAsObj, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.marginTextField.center = CGPointMake(self.marginTextField.center.x, cell.contentView.bounds.size.height/2);
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
        addLabel.numberOfLines = 0;
        addLabel.textColor = UIColorFromRGB(0x999999);
        [cell.contentView addSubview:addLabel];
    }
    
    NSString* preVince, *city, *areas;
    NSMutableString* addressTemp = [NSMutableString string];
    NSArray* keys = self.activityAddress.allKeys;
    if ([keys containsObject:@"province"]) {
        preVince = [self.activityAddress objectForKey:@"province"];
        addressTemp = (NSMutableString*)[addressTemp stringByAppendingString:preVince];
        addressTemp = (NSMutableString*)[addressTemp stringByAppendingString:@"\r\n"];
    }
    if ([keys containsObject:@"city"]) {
        city = [self.activityAddress objectForKey:@"city"];
        addressTemp = (NSMutableString*)[addressTemp stringByAppendingString:city];
        addressTemp = (NSMutableString*)[addressTemp stringByAppendingString:@"\r\n"];
    }
    if ([keys containsObject:@"district"]) {
        areas = [self.activityAddress objectForKey:@"district"];
        addressTemp = (NSMutableString*)[addressTemp stringByAppendingString:areas];
    }
    if (addressTemp.length > 0)
        addLabel.text = addressTemp;
    else
        addLabel.text = @"去定位";
    [addLabel sizeToFit];
    CGFloat width = addLabel.frame.size.width;
    if (addLabel.frame.size.width > 250)
        width = 250;
    addLabel.frame = CGRectMake(APP_WIDTH-width-30, 0, width, addLabel.frame.size.height);
    addLabel.center = CGPointMake(addLabel.center.x, cell.contentView.bounds.size.height/2);
    
    return cell;
}

- (UITableViewCell*)drawLeagueSection6Cell:(UITableView*)tableView
                                 indexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell9 forIndexPath:indexPath];
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
    if (self.phoneNum.length == 0)
        addLabel.text = @"未添加";
    else
        addLabel.text = self.phoneNum;
    [addLabel sizeToFit];
    CGFloat width = addLabel.frame.size.width;
    if (addLabel.frame.size.width > 150) {
        width = 150;
    }
    addLabel.frame = CGRectMake(APP_WIDTH-30-width, 0, width, addLabel.frame.size.height);
    addLabel.center = CGPointMake(addLabel.center.x, cell.contentView.bounds.size.height/2);
    
    return cell;
}

- (UITableViewCell*)drawLeagueSection7Cell:(UITableView*)tableView
                                 indexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell8 forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UITextView* textView = (UITextView*)[cell.contentView viewWithTag:100];
    if (!textView) {
        textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 5, APP_WIDTH-30, 120/*150*/)];
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
    
//    if (!self.detailImageScrollView) {
//        CGFloat y = textView.frame.origin.y+textView.frame.size.height+5;
//        self.detailImageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, y, APP_WIDTH-45, cell.bounds.size.height-y)];
//        [cell.contentView addSubview:self.detailImageScrollView];
//    }
    
//    UIButton* btn = (UIButton*)[self.detailImageScrollView viewWithTag:102];
//    if (!btn) {
//        btn = [[UIButton alloc]initWithFrame:CGRectMake(APP_WIDTH-40, self.detailImageScrollView.frame.origin.y+30, 0, 0)];
//        btn.tag = 102;
//        [cell.contentView addSubview:btn];
//        [btn setImage:[UIImage imageNamed:@"ic_append"] forState:UIControlStateNormal];
//        [btn sizeToFit];
//        [btn addTarget:self action:@selector(addDetailImageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    return cell;
}

- (void)commitActivity {
    NSMutableDictionary* ActivityInfo = [NSMutableDictionary dictionary];

    if (self.activityId.length > 0)
        [ActivityInfo setValue:self.activityId forKey:@"Id"];

    NSString* ActivityClassId = [self.selectActivityDict objectForKey:@"Id"];
    NSString* beginTime = [self.timeActivityDict objectForKey:@"beginTime"];
    NSString* endTime = [self.timeActivityDict objectForKey:@"endTime"];
    NSString* applyBeginTime = [self.timeSigningUpDict objectForKey:@"beginTime"];
    NSString* applyEndTime = [self.timeSigningUpDict objectForKey:@"endTime"];
    NSNumber* planNum = [self.signingUpPersonCountDict objectForKey:@"planCount"];
    NSNumber* lowerNum = [self.signingUpPersonCountDict objectForKey:@"lowerLimitCount"];
    NSNumber* maxNum = [self.signingUpPersonCountDict objectForKey:@"ceilingCount"];
    NSNumber* minMoneyNum = [self.moneyDict objectForKey:@"cost"];
    NSNumber* maxMoneyNum = [self.moneyDict objectForKey:@"margin"];
    NSString* provinceCode = [self.activityAddress objectForKey:@"provinceCode"];
    NSString* cityCode = [self.activityAddress objectForKey:@"cityCode"];
    NSString* districtCode = [self.activityAddress objectForKey:@"districtCode"];

    [ActivityInfo setValue:ActivityClassId forKey:@"ActivityClassId"];      //活动分类id
    [ActivityInfo setValue:self.titleStr forKey:@"Title"];
    [ActivityInfo setValue:self.corverImgPath forKey:@"Cover"];
    [ActivityInfo setValue:@0 forKey:@"ActivityType"];
    [ActivityInfo setValue:[NSNumber numberWithInt:self.gameType] forKey:@"IsLeague"];
    [ActivityInfo setValue:[NSNumber numberWithInt:self.joinType] forKey:@"JionType"];
    [ActivityInfo setValue:self.activityDetailText forKey:@"Demand"];       //参加要求
    [ActivityInfo setValue:self.teamId forKey:@"ReleaseUserId"];            //团队id
    [ActivityInfo setValue:@0 forKey:@"ReleaseState"];                      //0未发布，1已发布
    [ActivityInfo setValue:self.phoneNum forKey:@"Tel"];
    [ActivityInfo setValue:self.complainTelNum forKey:@"ComplainTel"];
    [ActivityInfo setValue:self.teamId forKey:@"TeamId"];
    [ActivityInfo setValue:beginTime forKey:@"BeginTime"];
    [ActivityInfo setValue:endTime forKey:@"EndTime"];
    [ActivityInfo setValue:applyBeginTime forKey:@"ApplyBeginTime"];
    [ActivityInfo setValue:applyEndTime forKey:@"ApplyEndTime"];
    [ActivityInfo setValue:lowerNum forKey:@"WillNum"];
    [ActivityInfo setValue:maxNum forKey:@"MaxNum"];
    [ActivityInfo setValue:planNum forKey:@"MaxApplyNum"];      //
    [ActivityInfo setValue:@0 forKey:@"ApplyNum"];         //已经报名数
    [ActivityInfo setValue:provinceCode forKey:@"provinceCode"];
    [ActivityInfo setValue:cityCode forKey:@"cityCode"];
    [ActivityInfo setValue:districtCode forKey:@"areaCode"];
    //[ActivityInfo setValue: forKey:@"ConstitutorId"];     组织者id
    [ActivityInfo setValue:minMoneyNum forKey:@"EntryMoneyMin"];    //活动费用最少额
    [ActivityInfo setValue:maxMoneyNum forKey:@"EntryMoneyMax"];    //活动费用最大额
    [ActivityInfo setValue:@0 forKey:@"ReadFlag"];
    [ActivityInfo setValue:@"" forKey:@"tag"];                      //活动标签

    NSMutableArray* ActivityItems = [NSMutableArray array];
    for (NSDictionary* dict in self.activitySessionArray) {
        NSNumber* planNum = [dict objectForKey:@"planCount"];
        NSNumber* maxNum = [dict objectForKey:@"maxCount"];
        NSNumber* minNum = [dict objectForKey:@"minCount"];
        NSNumber* costNum = [dict objectForKey:@"activityCost"];
        NSDictionary* tempDict = [dict objectForKey:@"activityVenue"];
        
        NSMutableDictionary* item = [NSMutableDictionary dictionary];
        if ([dict.allKeys containsObject:@"Id"])
            [item setValue:[dict objectForKey:@"Id"] forKey:@"Id"];//编辑时有id
        [item setValue:[dict objectForKey:@"remark"] forKey:@"Remark"];
        [item setValue:[dict objectForKey:@"beginTime"] forKey:@"BeginTime"];
        [item setValue:[dict objectForKey:@"endTime"] forKey:@"EndTime"];
        [item setValue:[dict objectForKey:@"applyBeginTime"] forKey:@"ApplyBeginTime"];
        [item setValue:[dict objectForKey:@"applyEndTime"] forKey:@"ApplyEndTime"];
        [item setValue:costNum forKey:@"EntryMoney"];
        [item setValue:minNum forKey:@"WillNum"];
        [item setValue:maxNum forKey:@"MaxNum"];
        [item setValue:planNum forKey:@"MaxApplyNum"];
        [item setValue:@0 forKey:@"ApplyNum"];
        //[item setValue: forKey:@"ConstitutorId"];
        [item setValue:[tempDict objectForKey:@"placeName"] forKey:@"PlaceName"];
        [item setValue:[tempDict objectForKey:@"Address"] forKey:@"Address"];
        
        NSDictionary* latlng = [tempDict objectForKey:@"latlng"];
        [item setValue:[latlng objectForKey:@"lng"] forKey:@"MapX"];
        [item setValue:[latlng objectForKey:@"lat"] forKey:@"MapY"];
        [item setValue:[tempDict objectForKey:@"provinceCode"] forKey:@"ProvinceCode"];
        [item setValue:[tempDict objectForKey:@"cityCode"] forKey:@"CityCode"];
        [item setValue:[tempDict objectForKey:@"districtCode"] forKey:@"AreaCode"];
        [ActivityItems addObject:item];
    }

    NSString* token = [HttpClient getTokenStr];
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:token forKey:@"token"];
    NSMutableDictionary* ActivityCreateUpdateModel = [NSMutableDictionary dictionary];
    [ActivityCreateUpdateModel setValue:ActivityInfo forKey:@"ActivityInfo"];
    if (self.gameType == gameTypenonLeague) {
        [ActivityCreateUpdateModel setValue:ActivityItems forKey:@"ActivityItems"];
    }
    [dict setValue:ActivityCreateUpdateModel forKey:@"ActivityCreateUpdateModel"];

    NSString *urlStr = [API_BASE_URL stringByAppendingString:API_CREATE_ACTIVITY_URL];
    SBJsonWriter* json = [[SBJsonWriter alloc]init];
    NSString *str = [json stringWithObject:dict];
    [HttpClient postJSONWithUrl:urlStr parameters:dict success:^(id responseObject) {
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSNumber* codeNum = [dict objectForKey:@"code"];
        if (codeNum.intValue == 0) {
            [Dialog simpleToast:@"创建活动成功" withDuration:1.5];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^{
        [Dialog simpleToast:@"创建活动失败！" withDuration:1.5];
    }];  
}

- (void)saveActivity {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:[HttpClient getTokenStr] forKey:@"token"];
    if (self.activityId.length > 0)
        [dict setValue:self.activityId forKey:@"id"];
    
    NSString* ActivityClassId = [self.selectActivityDict objectForKey:@"Id"];
    [dict setValue:[NSNumber numberWithInt:ActivityClassId.intValue] forKey:@"ActivityClassId"];//int
    [dict setValue:self.titleStr forKey:@"Title"];
    [dict setValue:self.corverImgPath forKey:@"Cover"];
    [dict setValue:@1 forKey:@"ActivityType"];  //0:系统活动；1:团队活动
    [dict setValue:[NSNumber numberWithInt:self.gameType] forKey:@"IsLeague"];
    [dict setValue:[NSNumber numberWithInt:self.joinType] forKey:@"JionType"];//0 个人 1 团队
    [dict setValue:self.activityDetailText forKey:@"Demand"];       //参加要求
    [dict setValue:[NSNumber numberWithInt:self.phoneNum.intValue] forKey:@"Tel"];    //int?
    [dict setValue:[NSNumber numberWithInt:self.complainTelNum.intValue] forKey:@"ComplainTel"];//int?
    [dict setValue:[NSNumber numberWithInt:self.teamId.intValue] forKey:@"TeamId"];   //int?
    [dict setValue:@0 forKey:@"ReleaseState"];//0 未发布 1 已发布
    //[dict setValue:@0 forKey:@"ReleaseTime"];  //发布时间
    NSString* beginTime = [self.timeActivityDict objectForKey:@"beginTime"];
    NSString* endTime = [self.timeActivityDict objectForKey:@"endTime"];
    [dict setValue:beginTime forKey:@"BeginTime"];
    [dict setValue:endTime forKey:@"EndTime"];
    [dict setValue:@510000 forKey:@"ProvinceCode"];
    [dict setValue:@510100 forKey:@"CityCode"];
    [dict setValue:@510104 forKey:@"AreaCode"];
    //[dict setValue:@"" forKey:@"ConstitutorId"];//组织者Id

    NSNumber* minMoneyNum = [self.moneyDict objectForKey:@"cost"];
    NSNumber* maxMoneyNum = [self.moneyDict objectForKey:@"margin"];
    [dict setValue:minMoneyNum forKey:@"EntryMoneyMin"];//活动费用最少额
    [dict setValue:maxMoneyNum forKey:@"EntryMoneyMax"];//活动费用最大额
    [dict setValue:@0 forKey:@"ReadFlag"];  //0:默认,1:精彩活动,2:推荐活动,4:预留
    //[dict setValue:@"" forKey:@"tag"];  //活动标签 int?

    NSString *urlStr = [API_BASE_URL stringByAppendingString:API_SAVE_ACTIVITY_URL];
    [HttpClient postJSONWithUrl:urlStr parameters:dict success:^(id responseObject) {
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSNumber* codeNum = [dict objectForKey:@"code"];
        if (codeNum.intValue == 0) {
            [Dialog simpleToast:@"创建活动成功" withDuration:1.5];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^{
        [Dialog simpleToast:@"创建活动失败！" withDuration:1.5];
    }];
}

- (void)uploadImg:(UIImage*)img {
    NSString* strTemp = [self getStringWithDate:[NSDate date] format:@"yyyyMMddHHmmss"];
    NSString* fileName = [NSString stringWithFormat:@"%@.png", strTemp];
    NSData * imageData = UIImagePNGRepresentation(img);
    long long length = [imageData length];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:[HttpClient getTokenStr] forKey:@"token"];
    [dict setValue:[NSNumber numberWithLongLong:length] forKey:@"ContentLength"];
    [dict setValue:@"file" forKey:@"ContentType"];
    [dict setValue:fileName forKey:@"FileName"];

    NSString *urlStr = [API_BASE_URL stringByAppendingString:API_UPLOAD_HEADERIMAGE_URL];
    
    __weak typeof(self)weakSelf = self;
    [HttpClient postJSONWithUrl:urlStr parameters:dict withImages:@[img] success:^(id responseObject) {
        [[HttpClient shareHttpClient] hiddenMessageHUD];
        SBJsonParser* json = [[SBJsonParser alloc]init];
        id jsonObject = [json objectWithString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        NSDictionary* temp = (NSDictionary*)jsonObject;
        weakSelf.corverImgPath = [temp objectForKey:@"result"];
        [Dialog simpleToast:@"上传成功！" withDuration:1.5];
    } fail:^{
        [[HttpClient shareHttpClient] hiddenMessageHUD];
        [Dialog simpleToast:@"上传失败！" withDuration:1.5];
    }];
}

- (NSString*)getStringWithDate:(NSDate*)_date format:(NSString*)_format{
    if (!_date || _format.length == 0)
        return @"";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:_format];
    NSString* dateStr = [dateFormatter stringFromDate:_date];
    return  dateStr;
}

- (void)doTimer {
    //检测参数是否填写完毕，完毕则打开发布按钮，否则置灰
    //两table共有的
    if (self.coverPhotoImages.count == 0) {//封面
        [self setStartBtnState:NO];
        return;
    }
    if (self.titleStr.length == 0) {//活动标题
        [self setStartBtnState:NO];
        return;
    }
    if (self.timeActivityDict) {    //活动时间
        NSArray* keys = self.timeActivityDict.allKeys;
        if (![keys containsObject:@"beginTime"] || ![keys containsObject:@"endTime"]) {
            [self setStartBtnState:NO];
            return;
        }
    }
    else {
        [self setStartBtnState:NO];
        return;
    }
    if (!self.selectActivityDict) { //选择的活动类别
        [self setStartBtnState:NO];
        return;
    }
    
    if (self.gameType == gameTypenonLeague) {   //nonleagueTableView独有
        if (self.activitySessionArray.count == 0) { //活动场次
            [self setStartBtnState:NO];
            return;
        }
    }
    else if (self.gameType == gameTypeLeague) { //leagueTableView独有
        if (self.phoneNum.length == 0) { //联系方式
            [self setStartBtnState:NO];
            return;
        }
        if (self.activityDetailText.length == 0) {  //活动详情
            [self setStartBtnState:NO];
            return;
        }
        if (self.timeSigningUpDict) {   //报名时间
            NSArray* keys = self.timeSigningUpDict.allKeys;
            if (![keys containsObject:@"beginTime"] || ![keys containsObject:@"endTime"]) {
                [self setStartBtnState:NO];
                return;
            }
        }
        else {
            [self setStartBtnState:NO];
            return;
        }
        if (self.signingUpPersonCountDict) {   //报名人数情况
            NSArray* keys = self.signingUpPersonCountDict.allKeys;
            if (self.joinType == joinTypePerson) {
                if (![keys containsObject:@"planCount"]) {
                    [self setStartBtnState:NO];
                    return;
                }
            }
            else if (self.joinType == joinTypeTeam) {
                if (![keys containsObject:@"planCount"] || ![keys containsObject:@"lowerLimitCount"] ||
                    ![keys containsObject:@"ceilingCount"]) {
                    [self setStartBtnState:NO];
                    return;
                }
            }
        }
        else {
            [self setStartBtnState:NO];
            return;
        }
        if (self.moneyDict) {   //费用
            NSArray* keys = self.moneyDict.allKeys;
            if (![keys containsObject:@"cost"] || ![keys containsObject:@"margin"]) {
                [self setStartBtnState:NO];
                return;
            }
        }
        else {
            [self setStartBtnState:NO];
            return;
        }
        if (!self.activityAddress) { //活动地点
            [self setStartBtnState:NO];
            return;
        }
    }
    
    [self setStartBtnState:YES];
}

- (void)setStartBtnState:(BOOL)isEnable {
    self.isComplete = isEnable;
    if (isEnable) {
        self.btn.backgroundColor = [UIColor redColor];
        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btn.userInteractionEnabled = YES;
    }
    else {
        self.btn.backgroundColor = UIColorFromRGB(0xDEDEDE);
        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btn.userInteractionEnabled = NO;
    }
}

@end
