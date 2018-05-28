//
//  PersonalTableViewCell.h
//  CloundSafe
//
//  Created by 宁莉莎 on 2018/5/22.
//

#import <UIKit/UIKit.h>

@interface PersonalTableViewCell : UITableViewCell
@property (nonatomic, strong)UIImageView *imgView;
@property (nonatomic, strong)UILabel *note;
-(void)setTablecell:(NSString *)img;
@end
