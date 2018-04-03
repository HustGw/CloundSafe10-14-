//
//  CSExportContentController.m
//  CloundSafe
//
//  Created by AlanZhang on 16/9/19.
//
//

#import "CSImportContentController.h"
#import "CSImportPictureController.h"
#import "CSImportVedioController.h"
@interface CSImportContentController ()

@end

@implementation CSImportContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc]initWithFrame:CGRectNull style:UITableViewStylePlain];
    self.tableView.sectionFooterHeight=0;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [left setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:left];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        CSImportPictureController *importPic = [[CSImportPictureController alloc]init];
        [self.navigationController pushViewController:importPic animated:YES];
    }else
    {
        CSImportVedioController *importVedio = [[CSImportVedioController alloc]init];
        [self.navigationController pushViewController:importVedio animated:YES];
    }
    
}
+ (void)changeFolderName:(NSString *)folderName beforeName:(NSString *)beforeName
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *beforeFolder = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),beforeName];
    NSString *afterFolder = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),folderName];
    
    [fm createDirectoryAtPath:afterFolder withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:beforeFolder];
    NSString *path;
    while ((path = [dirEnum nextObject]) != nil) {
        [fm moveItemAtPath:[NSString stringWithFormat:@"%@/%@",beforeFolder,path]
                    toPath:[NSString stringWithFormat:@"%@/%@",afterFolder,path]
                     error:NULL];
    }
    [fm removeItemAtPath:beforeFolder error:nil];
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
