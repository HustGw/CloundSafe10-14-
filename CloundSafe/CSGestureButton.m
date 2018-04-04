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
//       // self.frame = CGRectMake(0, 0, 13, 13);
//        [self.layer setCornerRadius:self.frame.size.width/2];
//        [self.layer setBorderWidth:2];
//        self.layer.borderColor = [UIColor colorWithRed:0.19 green:0.76 blue:0.49 alpha:1].CGColor;
//
        
        [self setImage:[UIImage imageNamed:@"gesture"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"gesture_selected"] forState:UIControlStateSelected];
    }
    return self;
}


@end
