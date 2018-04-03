//
//  CSUseguide2Controller.m
//  CloundSafe
//
//  Created by GGF103 on 2017/8/7.
//
//

#import "CSUseguide2Controller.h"

@interface CSUseguide2Controller ()

@property (nonatomic, strong) UILabel *label01;
@property (nonatomic, strong) UILabel *label02;
@property (nonatomic, strong) UILabel *label03;
@property (nonatomic, strong) UILabel *label04;
@property (nonatomic, strong) UILabel *label05;
@property (nonatomic, strong) UILabel *label06;
@property (nonatomic, strong) UILabel *label07;
@property (nonatomic, strong) UILabel *label08;
@property (nonatomic, strong) UILabel *label09;
@property (nonatomic, strong) UILabel *label10;
@property (nonatomic, strong) UIView* View01;
@property(nonatomic,strong)UIScrollView *ScrollView;
@end

@implementation CSUseguide2Controller

static NSString *const description01=@"1 照片和视频加密说明";
static NSString *const description02=@"        照片和视频加密之后会提示是否在原相册中删除原文件，点击删除或者保留都将不影响您的数据存储安全，点击保留相当于我们为您备份了一份加密的数据，点击删除将在系统相册中删除，在云加密APP当中保留了一份加密完成的密文和密钥。若未提示是否在系统相册中删除原文件，则系统默认在原相册删除原文件，您可以通过云加密APP在加密当中找到您加密的图片和视频、以及其他数据文档。";
static NSString *const description03=@"2 解密之后的图片还原至系统相册之后该如何进行查找?";
static NSString *const description04=@"        解密之后的图片会在系统相册当中独立生成一个云加密的子相册，解密之后的图片数据可在此相册找到，如果不记得解密了哪些数据，也可以通过“我”的菜单中找到最近解密菜单，找到最近解密的图片、视频等数据。";
static NSString *const description05=@"3 数据存储方式";
static NSString *const description06=@"        我们加密的算法是一种独立加密算法，用算法将您的照片、视频进行分离，生成密文和密钥，我们将通过加密等级最高的存储服务器将密钥部分进行加密，密文部分由于缺失重要数据将会变成不完整的，显示出来的就会是乱码，从而最大程度上保证数据的安全。";
static NSString *const description07=@"4 数据备份";
static NSString *const description08=@"        请每隔一段时间将设备（iphone或ipad或ipod）数据备份到电脑上ITUNES。操作步骤：设备连接电脑，电脑上打开ITUNES，点击设备—摘要—手动备份和恢复—立即备份（如果弹出框提示是否备份应用程序，请点击备用应用程序）；";
static NSString *const description09=@"5 数据恢复";
static NSString *const description10=@"        如果您更换手机后，想继续使用这个APP，请先把老手机数据备份到ITUNES，然后新手机连接电脑，打开ITUNES用备份数据设置新手机，然后下载APP，登录原有账号即可。";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"使用说明";
    _View01 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20,1.2*self.view.bounds.size.height)];
    _View01.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backforward)];
    [leftButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    self.ScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.ScrollView.contentSize=CGSizeMake(self.view.bounds.size.width, 1.2*self.view.bounds.size.height);
    self.ScrollView.alwaysBounceVertical=YES;
    self.ScrollView.scrollEnabled=YES;
    self.ScrollView.showsVerticalScrollIndicator = YES;
    self.ScrollView.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self initsubview];
    [self.View01 addSubview:self.ScrollView];
    [self.view addSubview:self.View01];
}

-(void)initsubview
{
    CGSize size01 = [self sizeWithText:description01 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:18];
    self.label01= [[UILabel alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width-20,size01.height)];
    self.label01.text = description01;
    self.label01.numberOfLines = 0;
    self.label01.font = [UIFont systemFontOfSize:18];
    [self.ScrollView addSubview:self.label01];
    CGSize size02 = [self sizeWithText:description02 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:18];
    self.label02= [[UILabel alloc]initWithFrame:CGRectMake(0,size01.height, self.view.bounds.size.width-20,size02.height)];
    self.label02.text = description02;
    self.label02.numberOfLines = 0;
    self.label02.font = [UIFont systemFontOfSize:16];
    [self.ScrollView addSubview:self.label02];
    CGSize size03 = [self sizeWithText:description03 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:18];
    self.label03= [[UILabel alloc]initWithFrame:CGRectMake(0,size01.height+size02.height, self.view.bounds.size.width-20,size03.height)];
    self.label03.text = description03;
    self.label03.numberOfLines = 0;
    self.label03.font = [UIFont systemFontOfSize:18];
    [self.ScrollView addSubview:self.label03];
    CGSize size04 = [self sizeWithText:description04 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:18];
    self.label04= [[UILabel alloc]initWithFrame:CGRectMake(0,size01.height+size02.height+size03.height, self.view.bounds.size.width-20,size04.height)];
    self.label04.text = description04;
    self.label04.numberOfLines = 0;
    self.label04.font = [UIFont systemFontOfSize:16];
    [self.ScrollView addSubview:self.label04];
    CGSize size05 = [self sizeWithText:description05 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:18];
    self.label05= [[UILabel alloc]initWithFrame:CGRectMake(0,size01.height+size02.height+size03.height+size04.height, self.view.bounds.size.width-20,size05.height)];
    self.label05.text = description05;
    self.label05.numberOfLines = 0;
    self.label05.font = [UIFont systemFontOfSize:18];
    [self.ScrollView addSubview:self.label05];
    CGSize size06 = [self sizeWithText:description06 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:18];
    self.label06= [[UILabel alloc]initWithFrame:CGRectMake(0,size01.height+size02.height+size03.height+size04.height+size05.height, self.view.bounds.size.width-20,size06.height)];
    self.label06.text = description06;
    self.label06.numberOfLines = 0;
    self.label06.font = [UIFont systemFontOfSize:16];
    [self.ScrollView addSubview:self.label06];
    CGSize size07 = [self sizeWithText:description07 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:18];
    self.label07= [[UILabel alloc]initWithFrame:CGRectMake(0,size01.height+size02.height+size03.height+size04.height+size05.height+size06.height, self.view.bounds.size.width-20,size07.height)];
    self.label07.text = description07;
    self.label07.numberOfLines = 0;
    self.label07.font = [UIFont systemFontOfSize:18];
    [self.ScrollView addSubview:self.label07];
    CGSize size08 = [self sizeWithText:description08 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:18];
    self.label08= [[UILabel alloc]initWithFrame:CGRectMake(0,size01.height+size02.height+size03.height+size04.height+size05.height+size06.height+size07.height, self.view.bounds.size.width-20,size08.height)];
    self.label08.text = description08;
    self.label08.numberOfLines = 0;
    self.label08.font = [UIFont systemFontOfSize:16];
    [self.ScrollView addSubview:self.label08];
    CGSize size09 = [self sizeWithText:description09 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:18];
    self.label09= [[UILabel alloc]initWithFrame:CGRectMake(0,size01.height+size02.height+size03.height+size04.height+size05.height+size06.height+size07.height+size08.height, self.view.bounds.size.width-20,size09.height)];
    self.label09.text = description09;
    self.label09.numberOfLines = 0;
    self.label09.font = [UIFont systemFontOfSize:18];
    [self.ScrollView addSubview:self.label09];
    CGSize size10 = [self sizeWithText:description10 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:18];
    self.label10= [[UILabel alloc]initWithFrame:CGRectMake(0,size01.height+size02.height+size03.height+size04.height+size05.height+size06.height+size07.height+size08.height+size09.height, self.view.bounds.size.width-20,size10.height)];
    self.label10.text = description10;
    self.label10.numberOfLines = 0;
    self.label10.font = [UIFont systemFontOfSize:16];
    [self.ScrollView addSubview:self.label10];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
