//
//  HFLoadMoreFooter.m
//
//  Created by 覃玉红 on 16/1/15.
//  Copyright © 2016年 覃玉红. All rights reserved.
//

#import "HFLoadMoreFooter.h"

@implementation HFLoadMoreFooter

+(instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HFLoadMoreFooter" owner:nil options:nil]lastObject];
}
@end
