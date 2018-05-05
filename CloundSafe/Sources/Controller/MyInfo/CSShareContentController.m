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
#import "CSUseguidesController.h"
#import "CSUseguide3Controller.h"
@implementation CSShareContentController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0/255.0 green:205.0/255.0 blue:111.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectNull style:UITableViewStylePlain];
    self.tableView.sectionFooterHeight=0;
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
    }
    else if ( indexPath.row ==1 )
    {   CSVedioCollectionController *vc = [[CSVedioCollectionController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        CSUseguide3Controller *vc = [[CSUseguide3Controller alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - tableview delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    }else if (indexPath.row == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"vedioContent"];
        cell.textLabel.text = @"视频密文";
    }else
    {
        cell.imageView.image = [UIImage imageNamed:@"useguides"];
        cell.textLabel.text = @"使用说明";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
@end
