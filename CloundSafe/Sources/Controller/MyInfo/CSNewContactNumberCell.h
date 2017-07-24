//
//  CSNewContactNumberCell.h
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/11.
//
//

#import <UIKit/UIKit.h>
@class MyTextField;
typedef void(^completeInputPhone)(NSString *number);
typedef void(^deleteNumber)(NSString *number);
typedef void(^textChange)(NSString *text);
@interface CSNewContactNumberCell : UITableViewCell
@property (nonatomic, strong, readonly) UIButton *delButton;
@property (nonatomic, strong, readonly) UIButton *phontTypeButton;
@property (nonatomic, strong, readonly) UIImageView *imgView;
@property (nonatomic, strong, readonly) MyTextField *phoneField;
@property (nonatomic, assign, readonly) ContactCellType cellType;
@property (nonatomic, copy) completeInputPhone completeInputBlock;
@property (nonatomic, copy) deleteNumber deleteNumberBlock;
@property (nonatomic, copy) textChange textChangeBlock;
- (id)initWithType:(ContactCellType)cellType;//全能化初始方法
- (void)configCell;
@end
