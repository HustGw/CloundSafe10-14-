//
//  CSShareContentController.m
//  CloundSafe
//
//  Created by AlanZhang on 16/8/31.
//
//

#import "CSShareContentController.h"
#import "CSPictureCollectionController.h"
#import "CSVedioCollectionController.h"
@implementation CSShareContentController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"密文类型";
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [left setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = left;
    
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
        CSPictureCollectionController *vc = [[CSPictureCollectionController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        CSVedioCollectionController *vc = [[CSVedioCollectionController alloc]init];
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
@end
