//
//  CSUseguide3Controller.m
//  CloundSafe
//
//  Created by GGF103 on 2017/8/7.
//
//

#import "CSUseguide3Controller.h"

@interface CSUseguide3Controller ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) UILabel *label6;
@property(nonatomic,strong)UIScrollView *ScrollView;

@end

@implementation CSUseguide3Controller

static NSString *const description1 = @"1 用户A通过QQ或者微信等方式对图片点击共享，将content文件共享给用户B";
static NSString *const description3 = @"2 通过iTunes将获取的content密文文件导入到用户B:新建文件夹，如果是图片密文则以imtp_*的格式重命名文件夹，如果是视频密文则以imtv_*的格式重命名文件夹。将获取的content文件拷贝至用户B账户文件夹中来";
static NSString *const description4=@"3 将用户B账号的文件夹覆盖itunes中用户B原有的文件夹。在手机可看到导入的文件，并请求解密。";
static NSString *const description5=@"4 用户A收到短信审核通过，用户B即可成功解密";


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"使用说明";
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backforward)];
    [leftButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    self.ScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.ScrollView.contentSize=CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    self.ScrollView.alwaysBounceVertical=YES;
    self.ScrollView.scrollEnabled=YES;
    self.ScrollView.showsVerticalScrollIndicator = YES;
    self.ScrollView.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self initsubview];
    [self.view addSubview:self.ScrollView];
}
-(void)initsubview
{
    
    CGSize size1 = [self sizeWithText:description1 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:16];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width,size1.height)];
    self.label.text = description1;
    self.label.numberOfLines = 0;
    self.label.font = [UIFont systemFontOfSize:16];
    [self.ScrollView addSubview:self.label];
//    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, size1.height, self.view.bounds.size.width,0.4*self.view.bounds.size.height)];
//    self.imgView.image = [UIImage imageNamed:@"useguide1"];
//    [self.ScrollView addSubview:self.imgView];
//    
//
//    
//    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, size1.height+0.4*self.view.bounds.size.height, self.view.bounds.size.width, 0.4*self.view.bounds.size.height)];
//    self.imgView.image = [UIImage imageNamed:@"useguide2"];
//    [self.ScrollView addSubview:self.imgView];
    
    CGSize size3 = [self sizeWithText:description3 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:18];
    self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, size1.height, self.view.bounds.size.width, size3.height)];
    self.label2.text = description3;
    self.label2.numberOfLines = 0;
    self.label2.font = [UIFont systemFontOfSize:16];
    [self.ScrollView addSubview:self.label2];
    
    
    
    CGSize size4 = [self sizeWithText:description4 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:18];
    self.label3= [[UILabel alloc]initWithFrame:CGRectMake(0, size3.height+size1.height, self.view.bounds.size.width, size4.height)];
    self.label3.text = description4;
    self.label3.numberOfLines = 0;
    self.label3.font = [UIFont systemFontOfSize:16];
    [self.ScrollView addSubview:self.label3];
    
    
    
    CGSize size5= [self sizeWithText:description5 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:18];
    self.label4= [[UILabel alloc]initWithFrame:CGRectMake(0,size4.height+size3.height+size1.height, self.view.bounds.size.width, size5.height)];
    self.label4.text = description5;
    self.label4.numberOfLines = 0;
    self.label4.font = [UIFont systemFontOfSize:16];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
