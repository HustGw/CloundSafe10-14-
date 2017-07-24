//
//  CSContactEditController.h
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/14.
//
//

#import <UIKit/UIKit.h>
#import "CSAddContactController.h"
@class CSContact;
@interface CSContactEditController : CSAddContactController
- (id)initWithContact:(CSContact *)contact;
@end
