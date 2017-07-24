//
//  DefineFiles.h
//
//  Created by 覃玉红 on 15/7/12.
//  Copyright (c) 2015年 覃玉红. All rights reserved.
//
#import<Availability.h>

#ifndef _____DefineFiles_h
#define _____DefineFiles_h
#import<UIKit/UIKit.h>
#import<Foundation/Foundation.h>

//随机色
#define HFRandomColor   [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];

#define HFColor(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0];

//自定义输出宏
#ifdef DEBUG
#define HFLog(...) NSLog(__VA_ARGS__)
#else
#define HFLog(...)
#endif


#endif
