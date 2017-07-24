//
//  CSAddContactCell.h
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/11.
//
//

#import <UIKit/UIKit.h>

@interface CSAddContactCell : UITableViewCell
@property (nonatomic, strong, readonly) UIButton *addButton;
@property (nonatomic, assign, readonly) ContactCellType cellType;
- (id)initWithType:(ContactCellType)cellType;
- (void)configCell;
@end
