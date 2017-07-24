//
//  CSSearchResultsController.h
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/9.
//
//

#import <UIKit/UIKit.h>
typedef void(^selectContact)();
@interface CSSearchResultsController : UITableViewController
@property (nonatomic, strong) NSArray *phoneSource;
@property (nonatomic, weak) UIViewController *weakController;
@property (nonatomic, copy) selectContact selectBlock;
@end
