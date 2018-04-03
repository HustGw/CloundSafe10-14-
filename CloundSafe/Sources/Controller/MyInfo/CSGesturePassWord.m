//
//  CSGesturePassWord.m
//  CloundSafe
//
//  Created by Esphy on 2017/7/31.
//
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#import "CSGesturePassWord.h"
#import <CommonCrypto/CommonDigest.h>
#import "CSGestureButton.h"

@interface CSGesturePassWord(){
    /** 判断是当设置密码用，还是解锁密码用*/
    PasswordState Amode;
}
/** 所有的按钮集合*/
@property (nonatomic,strong)NSMutableArray * allBtnsArray;

/** 解锁时手指经过的所有的btn集合*/
@property (nonatomic,strong)NSMutableArray * btnsArray;

/** 手指当前的触摸位置*/
@property (nonatomic,assign)CGPoint currentPoint;
@property(nonatomic,strong)NSDictionary *GesturePwd;
@end
@implementation CSGesturePassWord


-(instancetype)initWithFrame:(CGRect)frame WithState:(PasswordState)state{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        Amode = state;
        for (int i = 0; i<9; i++) {
            CSGestureButton *btn = [[CSGestureButton alloc]init];
            [btn setTag:i];
            btn.userInteractionEnabled = NO;
            if (self.lineColor == nil) {
                self.lineColor = [UIColor greenColor];
            }
            [self addSubview:btn];
        }
        
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    //  每次调用这个方法的时候如果背景颜色是default会产生缓存，如果设置了颜色之后就没有缓存，绘制之前需要清除缓存
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);//清空上下文
    for (int i = 0; i<self.btnsArray.count; i++) {
        UIButton *btn = self.btnsArray[i];
        if (i == 0) {
            CGContextMoveToPoint(ctx, btn.center.x, btn.center.y);
        }else{
            CGContextAddLineToPoint(ctx, btn.center.x, btn.center.y);
        }
    }
    if (!CGPointEqualToPoint(self.currentPoint, CGPointZero)) {//如果起点不是CGPointZero的话才来划线
        CGContextAddLineToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
    }
    
    CGContextSetLineWidth(ctx, 12);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    [self.lineColor set];
    CGContextStrokePath(ctx);
    
}
-(void)layoutSubviews{
    
    [self.allBtnsArray removeAllObjects];
    for (int index =0; index<self.subviews.count; index ++) {
        if ([self.subviews[index] isKindOfClass:[CSGestureButton class]]) {
            
            [self.allBtnsArray addObject:self.subviews[index]];
        }
    }
    // button 绘制九宫格
    [self drawUi];
    
    
}
#pragma mark Private method
-(void)drawUi{
    for (int index = 0; index<self.allBtnsArray.count; index ++) {
        //拿到每个btn
        UIButton *btn = self.subviews[index];
        
        //设置frame
        CGFloat btnW = 74;
        CGFloat btnH = 74;
        CGFloat margin = (SCREEN_WIDTH - (btnW *3))/4;
        //x = 间距 + 列号*（间距+btnW）
        CGFloat btnX = margin + (index % 3)*(margin + btnW);
        CGFloat btnY = margin + (index / 3)*(margin + btnH);
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
}
//设置密码
-(SetPwdState)pwdValue:(NSString *)str{
    NSString *userName = [userDefaults valueForKey:@"userName"];
    if ([userDefaults objectForKey:userName] == nil)  {
        //第一次设置
        NSLog(@"第一次设置发生");
        [userDefaults setValue:str forKey:userName];
        return FristPwd;
    }
    if ([str isEqualToString: [userDefaults objectForKey:userName]]) {
        //设置成功
        return SetPwdSuccess;
    }
    if (![str isEqualToString: [[NSUserDefaults standardUserDefaults]objectForKey:userName]]) {
        //二次设置不一样
        return PwdNoValue;
    }
    
    return Other;
    
}
//清空
-(void)clear{
    [self.btnsArray removeAllObjects];
    self.currentPoint = CGPointZero;
    [self setNeedsDisplay];
    self.lineColor = [UIColor greenColor];
    self.userInteractionEnabled = YES;
}
//获取触摸的点
-(CGPoint)getCurrentTouch:(NSSet<UITouch*> *)touches{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    return point;
}

-(UIButton *)getCurrentBtnWithPoint:(CGPoint) currentPoint{
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, currentPoint)) {
            return btn;
        }
    }
    return nil;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [self getCurrentTouch:touches];
    UIButton *btn = [self getCurrentBtnWithPoint:point];
    if (btn && btn.selected != YES) {
        btn.selected = YES;
        [self.btnsArray addObject:btn];
        NSLog(@" array is value %@",self.btnsArray);
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint movePoint = [self getCurrentTouch:touches];
    UIButton *btn = [self getCurrentBtnWithPoint:movePoint];
    if (btn && btn.selected !=YES) {
        btn.selected = YES;
        [self.btnsArray addObject:btn];
        NSLog(@"btn is value %@",self.btnsArray);
    }
    self.currentPoint = movePoint;
    [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UIButton *btn in self.btnsArray) {
        [btn setSelected:NO];
    }
    NSMutableString *result = [NSMutableString string];
    for (UIButton *btn in self.btnsArray) {
        [result appendString: [NSString stringWithFormat:@"%ld",(long)btn.tag]];
    }
    switch (Amode) {
        case GestureSetPassword:{
            //设置手势密码
            self.setPwdBlock([self pwdValue:result]);
        }
            break;
        case GestureResultPassword :{
            //获取手势密码结果
            if (self.sendReaultData) {
                if (self.sendReaultData(result) == YES) {
//                    进入下一个页面
                    NSLog(@"success");
                    [self clear];
                }else{
//                    弹出提示框
                    NSLog(@"手势有误");
                }
                
            }
            
        }
            break;
            
        default:
            break;
    }
    //返回结果
    [self clear];
}
#pragma mark 延时加载
-(NSMutableArray *)btnsArray{
    if (_btnsArray == nil) {
        _btnsArray = [NSMutableArray array];
    }
    return _btnsArray;
}
-(NSMutableArray *)allBtnsArray{
    if (_allBtnsArray == nil) {
        _allBtnsArray = [NSMutableArray array];
    }
    return _allBtnsArray;
}

@end
