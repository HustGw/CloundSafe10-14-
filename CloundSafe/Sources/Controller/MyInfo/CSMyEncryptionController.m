//
//  CSMyEncryptionController.m
//  CloundSafe
//
//  Created by Esphy on 2017/7/27.
//
//

#import "CSMyEncryptionController.h"
#import "CSEncryptionImageViewController.h"
#import "CSPicture.h"
#import "CSEncryptionVedioViewController.h"

@interface CSMyEncryptionController ()
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *vedios;
@end
@implementation CSMyEncryptionController


-(void)viewDidLoad
{
    [super viewDidLoad];
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
        CSEncryptionImageViewController *vc = [[CSEncryptionImageViewController alloc] init];
        vc.images = self.images;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        CSEncryptionVedioViewController *vc = [[CSEncryptionVedioViewController alloc]init];
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
                if ([[obj pathExtension] isEqualToString:@"scale"] && [[[obj stringByDeletingLastPathComponent] substringWithRange:NSMakeRange(0, 3)]isEqualToString:@"img"])
                {
                    NSString *imageMidPath = [NSString stringWithFormat:@"%@/%@",photosPath,[obj stringByDeletingLastPathComponent]];
                    NSArray *file1 = [fileManage subpathsAtPath:imageMidPath];
                    for(NSString *obj1 in file1){
                        if([[obj1 pathExtension] isEqualToString:@"jpg"]){
                            NSString *imagePath = [NSString stringWithFormat:@"%@/%@",imageMidPath,obj1];
                            NSURL *url = [NSURL fileURLWithPath:imagePath];
                            CSPicture *picture = [[CSPicture alloc] init];
                            [picture setSourceImageURL:url];
                            [photoArr addObject:picture];
                        }
                    
                    }
                    
                }
        
                if ([[obj pathExtension]isEqualToString:@"scale"]&&[[[obj stringByDeletingLastPathComponent] substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"vide"])
                {   NSString *vedioMidPath = [NSString stringWithFormat:@"%@/%@",photosPath,[obj stringByDeletingLastPathComponent]];
                    NSArray *file2 =[fileManage subpathsAtPath:vedioMidPath];
                    for(NSString *obj2 in file2){
                        if([[obj2 pathExtension]isEqualToString:@"scale"]){
                            NSString *coverImagePath = [NSString stringWithFormat:@"%@/%@",vedioMidPath,obj2];
                            NSURL *coverImageURL = [NSURL fileURLWithPath:coverImagePath];
                            CSPicture *picture = [[CSPicture alloc] init];
                            [picture setSourceImageURL:coverImageURL];
                            [vedioArr addObject:picture];
                        }
                        if([[obj2 pathExtension]isEqualToString:@"MOV"]){
                            
                        }
                    }
                    
                    
                    
                }
            
            
        }
        self.images = [photoArr copy];
        self.vedios = [vedioArr copy];
        
    }
}



@end
