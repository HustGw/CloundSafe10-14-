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
        _placeHolder = [[UILabel alloc]init];
        _placeHolder.text=@"文字描述";
        _textView = [[UITextView alloc]init];
        _stringLengthLabel = [[UILabel alloc]init];
        _textView.delegate=self;
        
        _label.userInteractionEnabled=NO;
        _textView.layer.borderWidth=1;
        _textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8; //行距
        
        NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle};
        
        _textView.attributedText = [[NSAttributedString alloc]initWithString: _textView.text attributes:attributes];
        
        [self.textView addSubview:_placeHolder];
        [self.contentView addSubview:_label];
        [self.contentView addSubview:_textView];
        
        
        
        //        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 4*kScreenWidth);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)textViewDidChange :(UITextView *)textView
{
    //    self.textChangeBlock(theTextField.text);
    self.completeInputBlock(textView.text);
    self.placeHolder.hidden = YES;
    self.stringLengthLabel.text=[NSString stringWithFormat:@"%lu/100",(unsigned long)textView.text.length];
    if(textView.text.length >=100)
    {
        textView.text = [textView.text substringToIndex:100];
        self.stringLengthLabel.text = @"100/100";
    }
    if(textView.text.length == 0)
    {
        self.placeHolder.hidden = NO;
        
    }
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
    //    _textView.text= @"文字描述";
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_label.mas_right).offset(5);
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(140);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
