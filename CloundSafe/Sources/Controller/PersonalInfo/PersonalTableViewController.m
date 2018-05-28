//
//  PersonalTableViewController.m
//  CloundSafe
//
//  Created by 宁莉莎 on 2018/5/18.
//

#import "PersonalTableViewController.h"
#import "ResetEmailViewController.h"
#import "PersonalTableViewCell.h"
#import "PersonalinfoTableViewCell.h"
#import "ChangePasswordViewController.h"

@interface PersonalTableViewController ()<UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    NSString *empemail;
    NSString *empimage;
    UIView *phoneView;
}
@property (nonatomic, strong) MBProgressHUD    *HUD;
@property (nonatomic, strong) NSDictionary *dictionary02;
@end

@implementation PersonalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self Inquiry];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0/255.0 green:205.0/255.0 blue:111.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"个人信息";
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    [leftButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(id)initwithdic:(NSDictionary *)dic
{
        self.dictionary02 = dic;
        NSLog(@"the dic is %@",dic);
        empemail = [NSString stringWithFormat:@"%@",dic[@"emp_email"]];
        empimage = [NSString stringWithFormat:@"%@",dic[@"emp_image"]];
      return self;
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        PersonalTableViewCell *cell01 = [[PersonalTableViewCell alloc]init];
        [cell01 setTablecell:empimage];
        return cell01;
    }else if (indexPath.row == 1)
        {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"账号";
        NSString *username = [userDefaults valueForKey:@"userName"];
        NSLog(@"username is %@",username);
        cell.detailTextLabel.text =@"135677";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        }if (indexPath.row == 2) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"性别";
            cell.userInteractionEnabled = YES;
            phoneView = cell.contentView;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else if(indexPath.row == 3){
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"邮箱";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.textLabel.text = @"修改密码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.imageView.image = [UIImage imageNamed:@"pen"];
            return cell;
        }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {

    }else if (indexPath.row == 1)
        {
           [self showSuccess:@"手机号不能更改哟"];
        }else if (indexPath.row == 2)
            {
           UITapGestureRecognizer *top = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesBegan: withEvent:)];
            top.delegate = self;
            [phoneView addGestureRecognizer:top];
            }else if(indexPath.row == 3)
                {
                ResetEmailViewController *ResetEVC = [[ResetEmailViewController alloc]init];
                [self.navigationController pushViewController:ResetEVC animated:YES];
                }else if(indexPath.row == 4)
                    {
                    ChangePasswordViewController *resetPassword = [[ChangePasswordViewController alloc]init];
                    [self.navigationController pushViewController:resetPassword animated:YES];
                    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{        //选取照片上传
    UITouch *touch = [[event allTouches] anyObject];
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIApplication *action = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        UIApplication *action01 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"two");
            
        }];
        UIApplication *action02 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"cancle");
        }];
        [actionSheet addAction:action];
        [actionSheet addAction:action01];
        [actionSheet addAction:action02];
        [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)showSuccess:(NSString *)success
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    self.HUD.mode = MBProgressHUDModeCustomView;
    self.HUD.label.text = success;
    [self.HUD hideAnimated:YES afterDelay:0.6];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        {
        return 90;
        }else
            {
            return 40;
            }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    return view;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}





/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
