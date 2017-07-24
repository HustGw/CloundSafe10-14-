//
//  CSNewContactNameCell.h
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/10.
//
//

#import <UIKit/UIKit.h>
@class MyTextField;
typedef void(^completeInputName)(NSString *number);
typedef void(^textChange)(NSString *text);
@interface CSNewContactNameCell : UITableViewCell
@property (nonatomic, strong, readonly) UIImageView *imgView;
@property (nonatomic, strong, readonly) MyTextField *nameField;
@property (nonatomic, copy) completeInputName completeInputBlock;
@property (nonatomic, copy) textChange textChangeBlock;
- (void)configCell;
@end
