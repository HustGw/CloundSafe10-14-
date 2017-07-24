//
//  CSContactCell.m
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/9.
//
//

#import "CSContactCell.h"
#import "CSContact.h"
@interface CSContactCell()

@end
@implementation CSContactCell
- (id)init
{
    if (self = [super init])
    {
        _contact = [[CSContact alloc] init];
        _imgView = [[UIImageView alloc]init];
        _nameLabel = [[UILabel alloc]init];
        _note = [[UILabel alloc]init];
        
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _note.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:_imgView];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_note];
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}
- (void)setContact:(CSContact *)contact
{
    _contact = contact;
    //头像
//    _imgView.image = _contact.imageData?[UIImage imageNamed:@"headIcon"]:[UIImage imageWithData:_contact.imageData];
    _imgView.image =[UIImage imageNamed:@"headIcon"];
    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    //名字
    _nameLabel.text = _contact.name;
    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.mas_right).offset(10);
        make.top.equalTo(_imgView).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 25));
    }];
    //备注
    
    _note.text = ([_contact.note isEqualToString:@""])?@"备注:无":[NSString stringWithFormat:@"备注:%@",_contact.note];
    [_note mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.bottom.equalTo(_imgView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-70-10-10-10, 25));
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
