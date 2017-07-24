//
//  CSNewContactNameCell.m
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/10.
//
//

#import "CSNewContactNameCell.h"
#import "MyTextField.h"
@implementation CSNewContactNameCell

- (id)init
{
    if (self = [super init])
    {
        _imgView = [[UIImageView alloc]init];
        _nameField = [[MyTextField alloc]init];
        
        _nameField.placeholder = @"姓名";
        [_nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_nameField addTarget:self action:@selector(completeInput) forControlEvents:UIControlEventEditingDidEnd];
        [self.contentView addSubview:_imgView];
        [self.contentView addSubview:_nameField];

        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, kScreenWidth);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)textFieldDidChange :(UITextField *)theTextField
{
//    self.textChangeBlock(theTextField.text);
}
- (void)completeInput
{
    self.completeInputBlock(self.nameField.text);
}
- (void)configCell
{
    _imgView.image = [UIImage imageNamed:@"headIcon"];
    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [_nameField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.mas_right).offset(10);
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(20);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
