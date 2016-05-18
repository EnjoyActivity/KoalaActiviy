//
//  ApplyViewController.m
//  ledong
//
//  Created by luojiao  on 16/4/15.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "ApplyViewController.h"
#import "CollectionViewCell.h"

@interface ApplyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ApplyViewController

static NSString * const reuseIdentifier = @"ApplyCell";

- (void)viewDidLoad {
    self.titleName = @"已报名";
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier]; //xib
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
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
