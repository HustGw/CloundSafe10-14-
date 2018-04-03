//
//  CSUseguideAllViewController.m
//  CloundSafe
//
//  Created by GGF103 on 2017/8/7.
//
//

#import "CSUseguideAllViewController.h"
#import "CSUseguidesController.h"
#import "CSUseguide2Controller.h"

@interface CSUseguideAllViewController ()

@end

@implementation CSUseguideAllViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectNull style:UITableViewStylePlain];
    self.tableView.sectionFooterHeight=0;
    self.navigationItem.title = @"使用说明";
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
        CSUseguide2Controller *vc01 = [[CSUseguide2Controller alloc]init];
        [self.navigationController pushViewController:vc01 animated:YES];
    }else
    {
        CSUseguidesController *vc02 = [[CSUseguidesController alloc] init];
        [self.navigationController pushViewController:vc02 animated:YES];
        
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
        cell.textLabel.text = @"加解密的使用说明";
    }else
    {
        cell.imageView.image = [UIImage imageNamed:@"vedioContent"];
        cell.textLabel.text = @"iTunes的使用说明";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
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
