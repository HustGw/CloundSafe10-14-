//
//  PersonalTableViewCell.m
//  CloundSafe
//
//  Created by 宁莉莎 on 2018/5/22.
//

#import "PersonalTableViewCell.h"

@implementation PersonalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)init
{
    if (self = [super init]) {
        _imgView = [[UIImageView alloc]init];
        _note = [[UILabel alloc]init];
        _note.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_note];
        [self.contentView addSubview:_imgView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setTablecell:(NSString *)img
{
    NSLog(@"the img is %@",img);
    _imgView.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img]]];
    NSLog(@"the picture is %@",_imgView.image);
    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kScreenWidth-80);
        make.centerYWithinMargins.equalTo(self.contentView).offset(0);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    _note.text = @"头像";
    [_note mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.centerYWithinMargins.equalTo(self.contentView).offset(0);
        make.size.mas_equalTo(CGSizeMake(200, 45));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
