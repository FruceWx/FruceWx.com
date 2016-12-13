//
//  CarMsgCell.m
//  Day10_PodDemo
//
//  Created by tarena on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "CarMsgCell.h"

@implementation CarMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
    }
    return self;
}

- (UILabel *)replyLb {
    if(_replyLb == nil) {
        _replyLb = [[UILabel alloc] init];
        [self.contentView addSubview:_replyLb];
        [_replyLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.titleLb);
            make.bottom.equalTo(self.iconIV);
        }];
        _replyLb.font = [UIFont systemFontOfSize:12];
        _replyLb.textColor = [UIColor grayColor];
        _replyLb.tag = 100;
    }
    return _replyLb;
}

- (UILabel *)timeLb {
    if(_timeLb == nil) {
        _timeLb = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLb);
            make.bottom.equalTo(self.iconIV);
        }];
        _timeLb.font = [UIFont systemFontOfSize:12];
        _timeLb.textColor = [UIColor grayColor];
        _timeLb.tag = 200;
    }
    return _timeLb;
}

- (UILabel *)titleLb {
    if(_titleLb == nil) {
        _titleLb = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLb];
        _titleLb.numberOfLines = 0;
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconIV);
            make.left.equalTo(self.iconIV.mas_right).offset(8);
            make.right.equalTo(-8);
            make.height.lessThanOrEqualTo(35);
        }];
        _titleLb.font = [UIFont systemFontOfSize:14];
        _titleLb.tag = 300;
    }
    return _titleLb;
}

- (UIImageView *)iconIV {
    if(_iconIV == nil) {
        _iconIV = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(80, 60));
            make.centerY.equalTo(0);
            make.left.equalTo(11);
        }];
        _iconIV.layer.cornerRadius = 4;
        _iconIV.tag = 400;
    }
    return _iconIV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
