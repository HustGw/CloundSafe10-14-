//
//  CSImportVedioController.m
//  CloundSafe
//
//  Created by AlanZhang on 16/9/20.
//
//

#import "CSImportVedioController.h"
#import "CSPicture.h"
@interface CSImportVedioController ()

@end

@implementation CSImportVedioController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vedioArr = [self loadVedio];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  解密视频
 */
- (void)beginDecryption:(NSString *)keyFilePath
{
    NSLog(@"开始解密");
    [self saveContent:keyFilePath];
    
    //删除key文件, scale
    [[NSFileManager defaultManager] removeItemAtPath:keyFilePath error:nil];
    
    NSString *scale = [[keyFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"scale"];
    [[NSFileManager defaultManager] removeItemAtPath:scale error:nil];

    //更新列表
    self.vedioArr = [self loadVedio];
    [self.collectionView reloadData];
    NSLog(@"解密成功");
    
    
}
- (void)saveContent:(NSString *)keyFilePath
{
    NSString *vedioPath = [[keyFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:CipherExtension];
    AgreedThenDecryption([vedioPath cStringUsingEncoding:NSASCIIStringEncoding],[keyFilePath cStringUsingEncoding:NSASCIIStringEncoding]);
    //解密在密文上进行，完成后更改后缀名为mov
    NSString *moveToPath = [[vedioPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"mov"];
    [[NSFileManager defaultManager] moveItemAtPath:vedioPath toPath:moveToPath error:nil];
    
}
- (NSArray *)loadVedio
{
    //照片路径
    NSString *userName = [userDefaults valueForKey:@"userName"];
    NSString *photosPath = [NSString stringWithFormat:@"%@/%@",DocumentPath, userName];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath:photosPath])
    {
        NSArray *files = [fileManage subpathsAtPath:photosPath];
        NSMutableArray *photoArr = [NSMutableArray array];
        for (NSString *obj in files)
        {
            BOOL directory;
            NSString *importDic = [NSString stringWithFormat:@"%@/%@",photosPath, obj];
            if ([fileManage fileExistsAtPath:importDic isDirectory:&directory])
            {
                if (directory == YES && [[obj substringWithRange:ImportVideoRange]isEqualToString:ImportVideo])
                {
                    NSArray *importFiles = [fileManage subpathsAtPath:importDic];
                    for (NSString *importObj in importFiles)
                    {
                        if ([[importObj pathExtension] isEqualToString:CipherExtension])
                        {
                            NSString *imagePath = [NSString stringWithFormat:@"%@/%@",importDic,importObj];
                            imagePath = [[imagePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"scale"];
                            UIImage *placeHodler = [UIImage imageNamed:@"placehodler"];
                            NSData *placeHodlerData = UIImagePNGRepresentation(placeHodler);
                            [placeHodlerData writeToFile:imagePath atomically:YES];
                            NSURL *url = [NSURL URLWithString:imagePath];
                            CSPicture *picture = [[CSPicture alloc]init];
                            [picture setSourceImageURL:url];
                            [photoArr addObject:picture];
                        }
                    }
                }
            }
            
        }
        return [[NSArray alloc]initWithArray:photoArr];
    }else
    {
        NSLog(@"文件夹不存在！");
        return nil;
    }
    
}

@end
