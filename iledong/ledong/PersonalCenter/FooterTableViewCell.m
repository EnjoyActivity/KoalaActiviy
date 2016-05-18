//
//  FooterTableViewCell.m
//  ledong
//
//  Created by luojiao  on 16/5/4.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "FooterTableViewCell.h"
#import "FRUtils.h"

@implementation FooterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (CGFloat)calculateRowsHight:(NSString *)titleStr :(NSArray *)imageTotal
{
    float labelHeight = 0;

    CGSize size=CGSizeMake(256, 80);
    UIFont *font=[UIFont systemFontOfSize:15];//[UIFont fontWithName:@"Arial" size:14.0f];
    NSMutableParagraphStyle *paragraph=[[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode=NSLineBreakByWordWrapping;
    NSAttributedString *attributeText=[[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraph}];
    CGSize labelsize=[attributeText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    labelsize=CGSizeMake(ceilf(labelsize.width),ceilf(labelsize.height));
    labelHeight = labelsize.height;
    
    int statusNum = (int)[imageTotal count];
    int rowNum = 0;
    if (statusNum%3 == 0)
    {
        rowNum = statusNum/3;
    }
    else
    {
        if (statusNum == 0)
        {
            rowNum = 0;
        }
        else
        {
            rowNum = statusNum/3+1;
        }
    }
    float imageSzWidth =(240-12)/3;
//    if (imageTotal.count == 2)
//    {
//        imageSzWidth = (240 - 12)/2;
//    }
//    else if(imageTotal.count == 1)
//    {
//        imageSzWidth = (240 - 12);
//    }
    float viewHight =rowNum*imageSzWidth+12;
    float rowsHight = viewHight + labelHeight;
    return rowsHight + 70;
}

- (void)updateUIWithData:(NSString *)titleStr :(NSArray *)imageTotal :(NSInteger)index :(NSInteger)rowsNum
{
    NSLog(@"index = %ld",index);
    NSLog(@"rowsNum = %ld",rowsNum);

    self.titleLabel.text = titleStr;
    float labelHeight = 0;
    
    CGSize size=CGSizeMake(256, 80);
    UIFont *font=[UIFont systemFontOfSize:15];//[UIFont fontWithName:@"Arial" size:14.0f];
    NSMutableParagraphStyle *paragraph=[[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode=NSLineBreakByWordWrapping;
    NSAttributedString *attributeText=[[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraph}];
    CGSize labelsize=[attributeText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    labelsize=CGSizeMake(ceilf(labelsize.width),ceilf(labelsize.height));
    labelHeight = labelsize.height;
    _titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, 256, labelHeight);
    
    int statusNum = (int)[imageTotal count];
    int rowNum = 0;
    if (statusNum%3 == 0)
    {
        rowNum = statusNum/3;
    }
    else
    {
        if (statusNum == 0)
        {
            rowNum = 0;
        }
        else
        {
            rowNum = statusNum/3+1;
        }
    }
    float imageSzWidth =(240-12)/3;
    //    if (imageTotal.count == 2)
    //    {
    //        imageSzWidth = (240 - 12)/2;
    //    }
    //    else if(imageTotal.count == 1)
    //    {
    //        imageSzWidth = (240 - 12);
    //    }
    float viewHight =rowNum*imageSzWidth+12;
    
    _photoView.frame = CGRectMake(_photoView.frame.origin.x, labelHeight + 10, 240, viewHight);
    
    int line = 0;
    int row = 0;
    for (int k= 0; k<[imageTotal count]; k++)
    {
        if (k%3 == 0 && k != 0)
        {
            line ++;
            row = 0;
        }
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(row*imageSzWidth+5*(row+1), (5+imageSzWidth)*line, imageSzWidth, imageSzWidth);
        imageView.tag = k;
        row++;
        imageView.image = [UIImage imageNamed:@"user01_44"];
        [_photoView addSubview:imageView];
    }
    UIImageView *lineImage = [[UIImageView alloc] init];
//    lineImage.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0  blue:244/255.0  alpha:1];
    lineImage.backgroundColor = [UIColor redColor];
    lineImage.frame = CGRectMake(85, viewHight + labelHeight + 60, APP_WIDTH - 85, 1);
    [self addSubview:lineImage];
    
    UIButton *deletButton = [[UIButton alloc] init];
    [deletButton setTitle:@"删除" forState:UIControlStateNormal];
    [deletButton setTintColor:[UIColor clearColor]];
    [deletButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    deletButton.titleLabel.font = [UIFont systemFontOfSize:15];
    deletButton.frame = CGRectMake(100, viewHight + labelHeight + 20, 50, 40);
    [self addSubview:deletButton];
    
    if (rowsNum - 1 == index)
    {
        _leftLineImage.frame = CGRectMake(22, 0, 46,25);
        _leftLineImage.image = [FRUtils resizeImageWithImageName:@"btn_white"];
    }else
    {
        _leftLineImage.frame = CGRectMake(22, 0, 46, viewHight + labelHeight + 70);
        _leftLineImage.image = [FRUtils resizeImageWithImageName:@"bg_timebox_start"];
    }


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
