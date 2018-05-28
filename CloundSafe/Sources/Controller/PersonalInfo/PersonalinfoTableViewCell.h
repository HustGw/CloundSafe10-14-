//
//  PersonalinfoTableViewCell.h
//  CloundSafe
//
//  Created by 宁莉莎 on 2018/5/27.
//

#import <UIKit/UIKit.h>

@interface PersonalinfoTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *note;
@property (nonatomic, strong)UILabel *note01;
-(void)setTablecell:(NSString *)img;
@end
