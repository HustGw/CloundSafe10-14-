//
//  HFBarButtonItemTool.h
//  设置/获取控件属性
//  Created by 覃玉红 on 15/7/12.
//  Copyright (c) 2015年 覃玉红. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Extension.h"


@interface UIBarButtonItem (extension)
+(UIBarButtonItem*)itemWithTarget:(id)target  Action:(SEL)action imageName:(NSString*)imageName  Higtlightedimaged:(NSString*)highImageName;
@end
