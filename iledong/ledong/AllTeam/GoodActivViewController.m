//
//  GoodActivViewController.m
//  ledong
//
//  Created by luojiao  on 16/4/12.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "GoodActivViewController.h"
#import "GoodActivTableViewCell.h"

@interface GoodActivViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GoodActivViewController

- (void)viewDidLoad {
    self.titleName = @"精彩活动.足球";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonClick
- (IBAction)hotButton:(id)sender {
}

- (IBAction)allButton:(id)sender {
}
- (IBAction)weekButton:(id)sender {
}
- (IBAction)allAdress:(id)sender {
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"goodCell";
    GoodActivTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GoodActivTableViewCell" owner:self options:nil][0];
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
