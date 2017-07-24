//
//  CSAddContactCell.m
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/11.
//
//

#import "CSAddContactCell.h"

@interface CSAddContactCell()
@property (nonatomic, strong, readonly) UILabel *label;
@property (nonatomic, strong, readonly) UIView *line;
@end
@implementation CSAddContactCell

- (id)initWithType:(ContactCellType)cellType
{
    if (self = [super init])
    {
        _addButton = [[UIButton alloc]init];
        _label = [[UILabel alloc]init];
        _cellType = cellType;
        _line = [[UIView alloc]init];
        
        [self.contentView addSubview:_addButton];
        [self.contentView addSubview:_label];
        [self.contentView addSubview:_line];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        
    }
    return self;
}
- (id)init
{
    return [self initWithType:phone];
}
- (void)configCell
{
    [_addButton setImage:[UIImage imageNamed:@"addIcon"] forState:UIControlStateNormal];
    [_addButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
    
    _label.text = (_cellType == phone)?@"电话":@"电子邮件";
    _label.font = [UIFont systemFontOfSize:15];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addButton.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    _line.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
    
    [_line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-1);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
