//
//  CSNewContactNumberCell.m
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/11.
//
//

#import "CSNewContactNumberCell.h"
#import "MyTextField.h"
@interface CSNewContactNumberCell()
@property (nonatomic, strong, readonly) UIView *segmentLine;
@end

@implementation CSNewContactNumberCell

- (id)initWithType:(ContactCellType)cellType
{
    if (self = [super init])
    {
        _delButton = [[UIButton alloc]init];
        _phontTypeButton = [[UIButton alloc]init];
        _imgView = [[UIImageView alloc]init];
        _segmentLine = [[UIView alloc] init];
        _phoneField = [[MyTextField alloc]init];

        _cellType = cellType;
        [_phoneField addTarget:self action:@selector(completeInput) forControlEvents:UIControlEventEditingDidEnd];
        [_phoneField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_delButton addTarget:self action:@selector(deleteNumber) forControlEvents:UIControlEventTouchUpInside];
        if (cellType == phone) {
            _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        }else{
            _phoneField.keyboardType = UIKeyboardTypeASCIICapable;
        }
        
        [self.contentView addSubview:_delButton];
        [self.contentView addSubview:_phontTypeButton];
        [self.contentView addSubview:_imgView];
        [self.contentView addSubview:_segmentLine];
        [self.contentView addSubview:_phoneField];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return self;
    
}
- (void)deleteNumber
{
    self.deleteNumberBlock(self.phoneField.text);
}

-(void)textFieldDidChange :(UITextField *)theTextField
{
//    self.textChangeBlock(theTextField.text);
    self.completeInputBlock(self.phoneField.text);
}

- (void)completeInput
{
//    self.completeInputBlock(self.phoneField.text);
}
- (id)init
{
    return [self initWithType:phone];
}
- (void)configCell
{

    //删除按键
    [_delButton setImage:[UIImage imageNamed:@"deleteNumber"] forState:UIControlStateNormal];
    
    [_delButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    //电话类型
    if (_cellType == phone) {
        [_phontTypeButton setTitle:@"电话" forState:UIControlStateNormal];
    }else{
        [_phontTypeButton setTitle:@"邮箱" forState:UIControlStateNormal];
    }
    
    [_phontTypeButton setTitleColor:[UIColor colorWithRed:21.0/255.0 green:126.0/255.0 blue:251.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    _phontTypeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_phontTypeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_delButton.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(35, 20));
    }];
    //提示标签
    _imgView.image = [UIImage imageNamed:@"nextIcon"];
//    _imgView.tintColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
//    _imgView.backgroundColor = [UIColor redColor];
    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_phontTypeButton.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    //分割线
    _segmentLine.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
    [_segmentLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.mas_right).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.top.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(0.5);
    }];
    //电话输入域
    _phoneField.placeholder = (_cellType == phone)?@"电话":@"电子邮件";
    [_phoneField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_segmentLine.mas_right).offset(5);
        make.bottom.equalTo(self.contentView).offset(0.5);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.contentView);
    }];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
