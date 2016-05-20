//
//  AllTeamCell.m
//  ledong
//
//  Created by liuxu on 16/5/20.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "AllTeamCell.h"

#define kCellHeight     100

@implementation AllTeamCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self drawUI];
    }
    
    return self;
}

- (void)drawUI {
    self.teamImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.teamImageView];
    self.teamNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.teamNameLabel];
    self.personCountLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.personCountLabel];
    self.teamActiveCountLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.teamActiveCountLabel];
    self.payAttentionCountLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.payAttentionCountLabel];
    self.teamNameLabel.font = [UIFont systemFontOfSize:18.0];
    self.personCountLabel.font = [UIFont systemFontOfSize:12.0];
    self.teamActiveCountLabel.font = [UIFont systemFontOfSize:12.0];
    self.payAttentionCountLabel.font = [UIFont systemFontOfSize:12.0];
    self.teamActiveCountLabel.textColor = UIColorFromRGB(0xAFAFAF);
    self.payAttentionCountLabel.textColor = UIColorFromRGB(0xAFAFAF);
}

- (void)layoutSubviews {
    self.teamImageView.frame = CGRectMake(0, 0, 100, kCellHeight);
    CGFloat x = self.teamImageView.frame.origin.x + self.teamImageView.frame.size.width + 10;
    self.teamNameLabel.frame = CGRectMake(x, 10, self.teamNameLabel.frame.size.width, self.teamNameLabel.frame.size.height);
    self.personCountLabel.frame = CGRectMake(x, self.teamNameLabel.frame.origin.y+self.teamNameLabel.frame.size.height + 5, self.personCountLabel.frame.size.width, self.personCountLabel.frame.size.height);
    self.teamActiveCountLabel.frame = CGRectMake(x, kCellHeight-20, self.teamActiveCountLabel.frame.size.width, self.teamActiveCountLabel.frame.size.height);
    self.payAttentionCountLabel.frame = CGRectMake(APP_WIDTH-80, kCellHeight-20, self.payAttentionCountLabel.frame.size.width, self.payAttentionCountLabel.frame.size.height);
}

@end
