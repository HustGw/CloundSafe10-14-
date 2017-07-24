//
//  CSContactCell.h
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/9.
//
//

#import <UIKit/UIKit.h>
@class CSContact;
@interface CSContactCell : UITableViewCell
@property (nonatomic, strong, readonly) CSContact *contact;
@property (nonatomic, strong, readonly) UIImageView *imgView;
@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *note;
- (void)setContact:(CSContact *)contact;
@end
