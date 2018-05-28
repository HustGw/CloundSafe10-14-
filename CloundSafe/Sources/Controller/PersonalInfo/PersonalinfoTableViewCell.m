//
//  PersonalinfoTableViewCell.m
//  CloundSafe
//
//  Created by 宁莉莎 on 2018/5/27.
//

#import "PersonalinfoTableViewCell.h"

@implementation PersonalinfoTableViewCell

-(id)init
{
    if (self = [super init])
    {
        self.note01 = [[UILabel alloc]init];
        self.note01.font = [UIFont systemFontOfSize:16];
        _note = [[UILabel alloc]init];
        _note.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_note];
        [self.contentView addSubview:self.note01];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setTablecell:(NSString *)img
{
    self.note01.text = @"img";
    [self.note01 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kScreenWidth-80);
        make.centerY.equalTo(self.contentView).offset(100);
        make.size.mas_equalTo(CGSizeMake(70, 45));
    }];
    _note.text = @"账号";
    [_note mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentView).offset(100);
        make.size.mas_equalTo(CGSizeMake(200, 45));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
