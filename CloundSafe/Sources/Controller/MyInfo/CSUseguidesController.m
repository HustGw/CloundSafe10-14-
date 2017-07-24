//
//  CSUseguidesController.m
//  CloundSafe
//
//  Created by GGF103 on 2017/6/26.
//
//

#import "CSUseguidesController.h"
#import "CSUseguide2Controller.h"

@interface CSUseguidesController()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) UILabel *label6;
@property(nonatomic,strong)UIScrollView *ScrollView;

@end


@implementation CSUseguidesController
static NSString *const description1 = @"***iTunes导入的使用***：1 获取图片或视频加密后的content密文文件，将应用中用户A账户文件夹导出来";
static NSString *const description2 = @"2 打开文件夹找出content文件";
static NSString *const description3 = @"3 将获取content密文文件导入到用户B:新建文件夹，如果是图片密文则以imtp_*的格式重命名文件夹，如果是视频密文则以imtv_*的格式重命名文件夹。将获取的content文件拷贝至用户B账户文件夹中来";
static NSString *const description4=@"4将用户B账号的文件夹覆盖itunes中用户B原有的文件夹。在手机可看到导入的文件，并请求解密。";
static NSString *const description5=@"5 用户A收到短信审核通过，用户B即可成功解密";
static NSString *const description6=@"注意⚠️所有的图片、文件、视频等加密后是无法正常查看和使用的！必须在解密之后才能使用！";


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"使用说明";
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backforward)];
    [leftButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftButton];
//    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc]initWithTitle:@"下一页" style:UIBarButtonItemStylePlain target:self action:@selector(nextforward)];
//    [rightButton setTintColor:[UIColor whiteColor]];
//    [self.navigationItem setRightBarButtonItem:rightButton];
    self.ScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.ScrollView.contentSize=CGSizeMake(self.view.bounds.size.width, 2.2*self.view.bounds.size.height);
    self.ScrollView.alwaysBounceVertical=YES;
    self.ScrollView.scrollEnabled=YES;
    self.ScrollView.showsVerticalScrollIndicator = YES;
    self.ScrollView.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self initsubview];
    [self.view addSubview:self.ScrollView];
}
-(void)initsubview
{
    CGSize size6 = [self sizeWithText:description1 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:16];
    self.label6 = [[UILabel alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, size6.height)];
    self.label6.text = description6;
    self.label6.numberOfLines = 0;
    self.label6.font = [UIFont systemFontOfSize:16];
    [self.ScrollView addSubview:self.label6];
    CGSize size1 = [self sizeWithText:description1 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:14];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0,size6.height, self.view.bounds.size.width,size1.height)];
    self.label.text = description1;
    self.label.numberOfLines = 0;
    self.label.font = [UIFont systemFontOfSize:14];
    [self.ScrollView addSubview:self.label];
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, size6.height+size1.height, self.view.bounds.size.width,0.4*self.view.bounds.size.height)];
    self.imgView.image = [UIImage imageNamed:@"useguide1"];
    [self.ScrollView addSubview:self.imgView];
    
    CGSize size2 = [self sizeWithText:description2 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:14];
    self.label1= [[UILabel alloc]initWithFrame:CGRectMake(0,size6.height+size1.height+0.4*self.view.bounds.size.height, self.view.bounds.size.width, size2.height)];
    self.label1.text = description2;
    self.label1.numberOfLines = 0;
    self.label1.font = [UIFont systemFontOfSize:14];
    [self.ScrollView addSubview:self.label1];
    
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, size6.height+size2.height+size1.height+0.4*self.view.bounds.size.height, self.view.bounds.size.width, 0.4*self.view.bounds.size.height)];
    self.imgView.image = [UIImage imageNamed:@"useguide2"];
   [self.ScrollView addSubview:self.imgView];
    
    CGSize size3 = [self sizeWithText:description3 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:14];
    self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, size6.height+size2.height+size1.height+0.8*self.view.bounds.size.height, self.view.bounds.size.width, size3.height)];
    self.label2.text = description3;
    self.label2.numberOfLines = 0;
    self.label2.font = [UIFont systemFontOfSize:14];
    [self.ScrollView addSubview:self.label2];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, size6.height+size3.height+size2.height+size1.height+0.8*self.view.bounds.size.height, self.view.bounds.size.width, 0.4*self.view.bounds.size.height)];
    self.imgView.image = [UIImage imageNamed:@"useguide3"];
     [self.ScrollView addSubview:self.imgView];
    
    CGSize size4 = [self sizeWithText:description4 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:14];
    self.label3= [[UILabel alloc]initWithFrame:CGRectMake(0, size6.height+size3.height+size2.height+size1.height+1.2*self.view.bounds.size.height, self.view.bounds.size.width, size4.height)];
    self.label3.text = description4;
    self.label3.numberOfLines = 0;
    self.label3.font = [UIFont systemFontOfSize:14];
    [self.ScrollView addSubview:self.label3];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, size6.height+size4.height+size3.height+size2.height+size1.height+1.2*self.view.bounds.size.height, self.view.bounds.size.width, 0.6*self.view.bounds.size.height)];
    self.imgView.image = [UIImage imageNamed:@"useguide4"];
    [self.ScrollView addSubview:self.imgView];
    
    CGSize size5= [self sizeWithText:description5 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:14];
    self.label4= [[UILabel alloc]initWithFrame:CGRectMake(0,size6.height+size4.height+size3.height+size2.height+size1.height+1.8*self.view.bounds.size.height, self.view.bounds.size.width, size5.height)];
    self.label4.text = description5;
    self.label4.numberOfLines = 0;
    self.label4.font = [UIFont systemFontOfSize:14];
    [self.ScrollView addSubview:self.label4];
    
}
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}
-(void)backforward
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)nextforward
//{
//    CSUseguide2Controller *useguides = [[CSUseguide2Controller alloc]init];
//    [self.navigationController pushViewController:useguides animated:YES];
//}
@end
