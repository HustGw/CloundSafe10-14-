//
//  CSPhoneBookController.h
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/8.
//
//

#import <UIKit/UIKit.h>

@interface CSPhoneBookController : UITableViewController
@property (nonatomic, strong) UILabel *contactAuthorizationLabel;
- (void)getContact;
@end
