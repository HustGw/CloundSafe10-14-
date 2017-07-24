//
//  CSItemView.h
//  CloundSafe
//
//  Created by LittleMian on 16/6/27.
//
//

#import <UIKit/UIKit.h>

@interface CSItemView : UIView
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *label;
- (void)addSubviewConstraint;
@end
