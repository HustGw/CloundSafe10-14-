//
//  CSMyInfoController.m
//  CloundSafe
//
//  Created by AlanZhang on 16/8/1.
//
//

#import "CSMyInfoController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "CSAboutusController.h"
#import "CSShareContentController.h"
#import "ChangePasswordViewController.h"
#import "CSImportContentController.h"
#import "CSPhoneBookController.h"
#import "CSUseguidesController.h"
#import "CSUseguideAllViewController.h"
#import "CSLastDecryptionViewController.h"
#import "CSMyEncryptionController.h"
#import "CSGestureResultViewController.h"
#import "CSGestureViewController.h"

static BOOL RemberUsername;
@interface CSMyInfoController ()<UITableViewDelegate, UITableViewDataSource,MWPhotoBrowserDelegate ,UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSMutableArray *selections;

@end
@implementation CSMyInfoController
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    NSUserDefaults *userDefaultLisa = [NSUserDefaults standardUserDefaults];
    NSNumber *Hello=[userDefaultLisa valueForKey:@"hello"];
    RemberUsername=Hello.boolValue;
    [self initTableView];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0/255.0 green:205.0/255.0 blue:111.0/255.0 alpha:1.0];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}
- (void)initTableView
{
    [self.view addSubview:[[UIView alloc]initWithFrame:CGRectZero]];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.right.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49);
    }];
    self.tableView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    
}
#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section == 1)
//    {
//        UIView *view = [[UIView alloc]init];
//        view.backgroundColor = [UIColor clearColor];
//        return view;
//    }
//    return nil;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc]init];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}



- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 5;
    }else
    {
        return 3;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"私密联系人";
            cell.imageView.image = [UIImage imageNamed:@"phonebook"];
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"iTunes的导入";
            cell.imageView.image = [UIImage imageNamed:@"export"];
        }else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"最近解密";
            cell.imageView.image = [UIImage imageNamed:@"latest"];
        }else if (indexPath.row == 3)
        {
            cell.textLabel.text = @"共享密文";
            cell.imageView.image = [UIImage imageNamed:@"share"];
        }/*else if (indexPath.row == 4)
        {
            cell.textLabel.text = @"我的加密";
            cell.imageView.image = [UIImage imageNamed:@"share"];
        }*/else
        {
            cell.textLabel.text = @"修改密码";
            cell.imageView.image = [UIImage imageNamed:@"pen"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"关于我们";
            cell.imageView.image = [UIImage imageNamed:@"aboutus"];

        }else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"使用指南";
            cell.imageView.image = [UIImage imageNamed:@"useguides"];
        }else
        {
            cell.textLabel.text = @"退出登陆";
            cell.imageView.image = [UIImage imageNamed:@"logout"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else
    {
        UILabel *logout = [[UILabel alloc]init];
        [cell addSubview:logout];
        logout.text = @"退出登录";
        logout.font = [UIFont systemFontOfSize:14];
        [logout mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell);
            make.size.mas_offset(CGSizeMake(60, 30));
        }];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            CSPhoneBookController *vc = [[CSPhoneBookController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 1)//我的导入
        {
            CSImportContentController *exportController = [[CSImportContentController alloc]init];
            [self.navigationController pushViewController:exportController animated:YES];
        }else if (indexPath.row == 2)//最近解密
        {
//            [self lastestDecryption];
            CSLastDecryptionViewController *vc = [[CSLastDecryptionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 3)//共享密文
        {
            CSShareContentController *shareContent = [[CSShareContentController alloc]init];
            [self.navigationController pushViewController:shareContent animated:YES];
        }/*else if (indexPath.row == 4)//我的加密
        {
//           CSMyEncryptionController *myEncryption = [[CSMyEncryptionController alloc]init];
//           [self.navigationController pushViewController:myEncryption animated:YES];
            NSString *userName = [userDefaults valueForKey:@"userName"];
            if([[NSUserDefaults standardUserDefaults]objectForKey:userName]==nil){
                CSGestureViewController *vc = [[CSGestureViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else{
            CSGestureResultViewController *myEncryption = [[CSGestureResultViewController alloc]init];
            [self.navigationController pushViewController:myEncryption animated:YES];
            }
        }*/else//修改密码
        {
            ChangePasswordViewController *resetPassword = [[ChangePasswordViewController alloc]init];
            [self.navigationController pushViewController:resetPassword animated:YES];
        }
    }else
    {
        if (indexPath.row == 0)//关于我们
        {
            CSAboutusController *aboutus = [[CSAboutusController alloc]init];
            [self.navigationController pushViewController:aboutus animated:YES];

        }else if(indexPath.row == 1)
        {
            CSUseguideAllViewController *useguides = [[CSUseguideAllViewController alloc]init];
            [self.navigationController pushViewController:useguides animated:YES];
        }else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"确定退出"
                                      delegate:self
                                      cancelButtonTitle:@"否"
                                      otherButtonTitles:@"是", nil];
            [alertView show];
            
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex==1)
    {
        [self logout];
    }
    
}
- (void)lastestDecryption
{
    self.photos = [self loadDecryptedMedia];
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    // Create browser
    // Options
    startOnGrid = YES;
    //    displayNavArrows = YES;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:0];

    if (displaySelectionButtons) {
        _selections = [NSMutableArray new];
        for (int i = 0; i < self.photos.count; i++) {
            [_selections addObject:[NSNumber numberWithBool:NO]];
        }
    }
    [self.navigationController pushViewController:browser animated:YES];

}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    //NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}


- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    //NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)loadDecryptedMedia
{
    //照片路径
    NSString *userName = [userDefaults valueForKey:@"userName"];
    NSString *photosPath = [NSString stringWithFormat:@"%@/%@",DocumentPath, userName];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath:photosPath])
    {
        NSMutableArray *photoArr = [NSMutableArray array];
        NSArray *files = [fileManage subpathsAtPath:photosPath];
        for (NSString *obj in files)
        {
            if ([[obj pathExtension] isEqualToString:@"jpg"])
            {
                if (([[[obj stringByDeletingLastPathComponent] substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"img"] && ![[[obj lastPathComponent] substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"img"]) ||[[[obj stringByDeletingLastPathComponent] substringWithRange:ImportPicRange] isEqualToString:ImportPic])
                {
                    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",photosPath,obj];
                    NSURL *url = [NSURL fileURLWithPath:imagePath];
                    MWPhoto *photo = [MWPhoto photoWithURL:url];
                    [photoArr addObject:photo];
                }
            }

            if ([[obj pathExtension] isEqualToString:@"mov"])
            {
                if ([[[obj stringByDeletingLastPathComponent] substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"vide"] ||
                    [[[obj stringByDeletingLastPathComponent] substringWithRange:ImportVideoRange] isEqualToString:ImportVideo])
                {
                    NSString *vedioPath = [NSString stringWithFormat:@"%@/%@",photosPath,obj];
                    NSURL *url = [NSURL fileURLWithPath:vedioPath];
                    NSString *coverImagePath = [[vedioPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"];
                    NSURL *coverImageURL = [NSURL fileURLWithPath:coverImagePath];
                    MWPhoto *photo = [MWPhoto photoWithURL:coverImageURL];
                    photo.videoURL = url;
                    [photoArr addObject:photo];
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
//-(void)useguide
//{
//    
//}
- (void)logout
{

    NSString *user_identity = [userDefaults valueForKey:@"content"];
    user_identity = [user_identity substringFromIndex:[user_identity rangeOfString:@"_"].location + 1];
    [[AFHTTPSessionManager manager] POST:LogoutURL parameters:@{@"user_identify":user_identity} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"Fail"])
        {
            [self alert:@"服务器响应失败！"];
        }else
        {
            NSString *content = responseObject[@"content"];
            if ([content isEqualToString:@"logout success"])
            {
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                UINavigationController *navigationVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
                appDelegate.window.rootViewController = navigationVC;
                NSLog(@"注销成功:%@",user_identity);
                //加密数据库文件
                NSString *dbPath = [NSString stringWithFormat:@"%@/%@/%@",DocumentPath,[userDefaults valueForKey:@"userName"],DBFILE_NAME];
                NSData *data = [NSData dataWithContentsOfFile:dbPath];
                // 或 base64EncodedStringWithOptions
                NSData *base64Data = [data base64EncodedDataWithOptions:0];
                // 将加密后的文件存储用户主目录下
                [base64Data writeToFile:dbPath atomically:YES];
                if (RemberUsername) {
                    [userDefaults removeObjectForKey:@"userPassword"];
                    [userDefaults setObject:@(NO) forKey:ISLOGIN];
                } else {
                    [userDefaults removeObjectForKey:@"userPassword"];
                    [userDefaults removeObjectForKey:@"userName"];
                    [userDefaults setObject:@(NO) forKey:ISLOGIN];
                }

            }else
            {
                [self alert:@"用户已被注销！"];
            }
        }

        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        [self alert:@"请检查网络连接！"];
    }];


}
- (void)alert:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
