//
//  CSContactNoteCell.m
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/14.
//
//

#import "CSContactNoteCell.h"
#import "MyTextField.h"
@implementation CSContactNoteCell

- (id)init
{
    if (self = [super init])
    {
        _label = [[UILabel alloc]init];
        _textField = [[MyTextField alloc]init];

        [self.contentView addSubview:_label];
        [self.contentView addSubview:_textField];
        
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, kScreenWidth);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)textFieldDidChange :(UITextField *)theTextField
{
    //    self.textChangeBlock(theTextField.text);
    self.completeInputBlock(theTextField.text);
}

- (void)configCell
{
    _label.text = @"备注";
    _label.font = [UIFont systemFontOfSize:15];
    [_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(35, 20));
    }];
    _textField.placeholder = @"10字以内";
    [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_label.mas_right).offset(10);
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
