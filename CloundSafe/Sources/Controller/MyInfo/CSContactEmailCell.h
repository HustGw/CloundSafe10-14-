//
//  CSContactEmailCell.h
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/17.
//
//

#import <UIKit/UIKit.h>

@interface CSContactEmailCell : UITableViewCell
@property (nonatomic, strong, readonly) UILabel *label;
@property (nonatomic, strong, readonly) UIButton *sendEmailButton;
@property (nonatomic, strong, readonly) NSString *emailAddress;
- (id)initWithEmail:(NSString *)email;
- (void)configCell;
@end
