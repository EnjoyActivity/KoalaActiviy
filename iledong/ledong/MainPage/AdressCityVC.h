//
//  AdressCityVC.h
//  
//
//  Created by luojiao  on 16/3/23.
//
//

#import <UIKit/UIKit.h>

typedef void(^getLocation)(NSString *);

@interface AdressCityVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *searchTextfile;
@property (weak, nonatomic) IBOutlet UILabel *adressCity;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

@property (nonatomic, copy) getLocation locationResult;

@end
