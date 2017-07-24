//
//  HFuser.h
//  新浪微博
//  用户模型
//  Created by 覃玉红 on 16/1/15.
//  Copyright © 2016年 覃玉红. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFuser : NSObject
//字符串类型用户UID
@property(nonatomic,copy)NSString* name;
//好友昵称
@property(nonatomic,copy)NSString* idstr;
//用户头像地址
@property(nonatomic,copy)NSString* profile_image_url;

//+(HFuser*)userWithDict:(NSDictionary*)dict;
@end
