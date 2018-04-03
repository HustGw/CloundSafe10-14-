//
//  CSContactNoteCell.h
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/14.
//
//

#import <UIKit/UIKit.h>
@class MyTextField;
typedef void(^completeInput)(NSString *note);
@interface CSContactNoteCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic, strong, readonly) UILabel *label;
@property (nonatomic, strong, readonly) UILabel *placeHolder;
@property (nonatomic, strong, readonly) MyTextField *textField;
@property (nonatomic, strong, readonly) UITextView *textView;
@property (nonatomic, strong, readonly) UILabel *stringLengthLabel;
@property (nonatomic, copy) completeInput completeInputBlock;
- (void)configCell;
-(void)textViewDidChange :(UITextView *)textView;
@end

