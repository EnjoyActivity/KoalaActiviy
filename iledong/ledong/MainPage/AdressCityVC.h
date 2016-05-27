//
//  AdressCityVC.h
//  
//
//  Created by luojiao  on 16/3/23.
//
//

#import <UIKit/UIKit.h>

typedef void(^getLocation)(NSDictionary *);

@interface AdressCityVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *searchTextfile;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;


@property (nonatomic,weak) UIViewController * destinationVc;

@property (nonatomic, copy) getLocation locationResult;
@property (nonatomic, copy) NSDictionary * locationDic;

@property (nonatomic, assign) BOOL isSearch;


@end
