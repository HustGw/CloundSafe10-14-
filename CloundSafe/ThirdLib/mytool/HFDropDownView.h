//
//  HFDropDownView.h
//  自定义下拉菜单
//  Created by 覃玉红 on 16/1/11.
//  Copyright © 2016年 覃玉红. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HFDropDownView;

@protocol HFDropDownViewDelegate<NSObject>
@optional
-(void)DropDownViewDidDismiss:(HFDropDownView*)view;
-(void)DropDownViewDidShow:(HFDropDownView*)view;
@end

@interface HFDropDownView : UIView
+(instancetype)menu;
-(void)showFrom:(UIView*)from;
-(void)dismiss;
-(void)setContent:(UIView*)content;

//需要显示的内容
@property(nonatomic,strong)UIView*content;
//内容控制器
@property(nonatomic,strong)UIViewController*contentController;

@property(nonatomic,weak)id<HFDropDownViewDelegate> delegate;
@end
