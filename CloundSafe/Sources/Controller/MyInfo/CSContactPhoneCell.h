//
//  CSContactPhoneCell.h
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/9.
//
//

#import <UIKit/UIKit.h>

@interface CSContactPhoneCell : UITableViewCell
@property (nonatomic, weak) UIViewController *weakController;
@property (nonatomic, strong, readonly) CNPhoneNumber *number;
@property (nonatomic, strong, readonly) UILabel *phoneLabel;
@property (nonatomic, strong, readonly) UIButton *phoneButton;
@property (nonatomic, strong, readonly) UIButton *messageButton;
@property (nonatomic, strong, readonly) UIView *segmentLineView;
- (void)setNumber:(CNPhoneNumber *)number;
@end
