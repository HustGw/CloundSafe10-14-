//
//  CSGestureButton.m
//  CloundSafe
//
//  Created by Esphy on 2017/7/31.
//
//

#import "CSGestureButton.h"

@implementation CSGestureButton

-(instancetype)init{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor yellowColor];
        [self setImage:[UIImage imageNamed:@"gesture"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"gesture_selected"] forState:UIControlStateSelected];
    }
    return self;
}


@end
