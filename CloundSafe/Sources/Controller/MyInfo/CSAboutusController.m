//
//  CSAboutusController.m
//  CloundSafe
//
//  Created by AlanZhang on 16/8/31.
//
//

#import "CSAboutusController.h"
@interface CSAboutusController()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;
@end
@implementation CSAboutusController
static NSString *const description = @"本系统可对移动端文件进行加密，包括图片，视频，从而提高文件的安全性。";
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    [leftButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    [self initSubView];
}
- (void)initSubView
{
    self.imgView = [[UIImageView alloc] init];
    self.imgView.image = [UIImage imageNamed:@"home_logo"];
    [self.view addSubview:self.imgView];
    [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.imgView.image.size);
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(kScreenHeight/4);
        
    }];
    self.label = [[UILabel alloc]init];
    self.label.text = description;
    self.label.numberOfLines = 0;
    self.label.font = [UIFont systemFontOfSize:14];
    CGSize size = [self sizeWithText:description maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:14];
    [self.view addSubview:self.label];
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(50);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo((int)size.width+1);
        make.height.mas_equalTo((int)size.height+1);
    }];
}
- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  计算字体的长和宽
 *
 *  @param text 待计算大小的字符串
 *
 *  @param fontSize 指定绘制字符串所用的字体大小
 *
 *  @return 字符串的大小
 */
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}

@end
