//
//  CSLastDecryptionViewController.m
//  CloundSafe
//
//  Created by AlanZhang on 2017/7/11.
//
//

#import "CSLastDecryptionViewController.h"
#import "CSDecryptionImageViewController.h"
#import "CSPicture.h"
#import "CSDisplayDecryptionVedioViewContorller.h"
@interface CSLastDecryptionViewController ()
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *vedios;
@end

@implementation CSLastDecryptionViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectNull style:UITableViewStylePlain];
    self.tableView.sectionFooterHeight=0;
    self.navigationItem.title = @"选择文件类型";
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [left setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = left;
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [self loadDecryptedMedia];
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - cell select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        CSDecryptionImageViewController *vc = [[CSDecryptionImageViewController alloc] init];
        vc.images = self.images;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        CSDisplayDecryptionVedioViewContorller *vc = [[CSDisplayDecryptionVedioViewContorller alloc]init];
        vc.vedios = self.vedios;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - tableview delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"picContent"];
        cell.textLabel.text = @"图片密文";
    }else
    {
        cell.imageView.image = [UIImage imageNamed:@"vedioContent"];
        cell.textLabel.text = @"视频密文";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)loadDecryptedMedia
{
    //照片路径
    NSString *userName = [userDefaults valueForKey:@"userName"];
    NSString *photosPath = [NSString stringWithFormat:@"%@/%@",DocumentPath, userName];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath:photosPath])
    {
        NSMutableArray *photoArr = [NSMutableArray array];
        NSMutableArray *vedioArr = [NSMutableArray array];
        NSArray *files = [fileManage subpathsAtPath:photosPath];
        for (NSString *obj in files)
        {
            if ([[obj pathExtension] isEqualToString:@"jpg"])
            {
                if (([[[obj stringByDeletingLastPathComponent] substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"img"] && ![[[obj lastPathComponent] substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"img"]) ||[[[obj stringByDeletingLastPathComponent] substringWithRange:ImportPicRange] isEqualToString:ImportPic])
                {
                    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",photosPath,obj];
                    NSURL *url = [NSURL fileURLWithPath:imagePath];
                    CSPicture *picture = [[CSPicture alloc] init];
                    [picture setSourceImageURL:url];
                    [photoArr addObject:picture];
                }
            }
            
            if ([[obj pathExtension] isEqualToString:@"mov"])
            {
                if ([[[obj stringByDeletingLastPathComponent] substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"vide"] ||
                    [[[obj stringByDeletingLastPathComponent] substringWithRange:ImportVideoRange] isEqualToString:ImportVideo])
                {
                    NSString *vedioPath = [NSString stringWithFormat:@"%@/%@",photosPath,obj];
                    NSString *coverImagePath = [[vedioPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"];
                    NSURL *coverImageURL = [NSURL fileURLWithPath:coverImagePath];
                    CSPicture *picture = [[CSPicture alloc] init];
                    [picture setSourceImageURL:coverImageURL];
                    [vedioArr addObject:picture];
                }
            }
            
        }
        self.images = [photoArr copy];
        self.vedios = [vedioArr copy];
        
    }
}



@end
