//
//  CSAddContactController.m
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/10.
//
//

#import "CSAddContactController.h"
#import "CSNewContactNameCell.h"
#import "CSNewContactNumberCell.h"
#import "CSAddContactCell.h"
#import "MyTextField.h"
#import "CSContact.h"
#import "ContactBL.h"
#import "CSContactNoteCell.h"
@interface CSAddContactController ()
@property (nonatomic, strong) NSMutableArray *phones;
@property (nonatomic, strong) NSMutableArray *emails;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation CSAddContactController

- (id)init
{
    if (self = [super init])
    {
        self.phones = [[NSMutableArray alloc]init];
        self.emails = [[NSMutableArray alloc]init];
        self.name = @"";
        self.note = @"";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新建联系人";
    self.completeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 20)];
    self.completeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.completeButton addTarget:self action:@selector(completeAddContact) forControlEvents:UIControlEventTouchUpInside];
    [self.completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.completeButton]];
    
    self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 20)];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.cancelButton]];
    [self.tableView setTableFooterView:[[UIView alloc]init]];//清除tableView多余的分割线

}

- (void)completeAddContact
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//收起键盘
    BOOL isHavePhone = NO;
    BOOL isHaveEmail = NO;
    BOOL isHaveName = NO;
    for (NSString *phone in self.phones)
    {
        if (![phone isEqualToString:@""])
        {
            isHavePhone = YES;
            break;
        }
    }
    for (NSString *email in self.emails)
    {
        if (![email isEqualToString:@""])
        {
            isHaveEmail = YES;
            break;
        }
    }
    if (![self.name isEqualToString:@""]) {
        isHaveName = YES;
    }
    if (isHaveEmail || isHavePhone || isHaveName)
    {
        if (isHaveName == NO)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"名字不能为空！" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else if (isHavePhone == NO)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"号码不能为空！" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else//执行插入
        {
            ContactBL *contactBL = [[ContactBL alloc]init];
            [contactBL insertContact:[self contactWithName:self.name Phones:self.phones emails:self.emails andNote:self.note]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"contactUpdated" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写信息！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];

    }

//    NSLog(@"phone ->%@",self.phones);
//    NSLog(@"email ->%@",self.emails);
}
- (CSContact *)contactWithName:(NSString *)name Phones:(NSArray *)phones emails:(NSArray *)emails andNote:(NSString *)note
{
    CSContact *contact = [[CSContact alloc]init];
    contact.name = name;
    NSMutableArray *phoneNumers = [[NSMutableArray alloc] init];
    for (NSString *number in phones)
    {
        CNPhoneNumber *phone = [[CNPhoneNumber alloc]initWithStringValue:number];
        CNLabeledValue *phoneLabeledValue = [CNLabeledValue labeledValueWithLabel:@"电话" value:phone];
        [phoneNumers addObject:phoneLabeledValue];
    }
    contact.phoneNumbers = [[NSArray alloc]initWithArray:phoneNumers];
    
    NSMutableArray *emailAddresses = [[NSMutableArray alloc]init];
    for (NSString *email in emails)
    {
        CNLabeledValue *emailLabeledValue = [CNLabeledValue labeledValueWithLabel:@"邮箱" value:email];
        [emailAddresses addObject:emailLabeledValue];
    }
    contact.emailAddresses = [[NSArray alloc]initWithArray:emailAddresses];
    contact.note = note;
    return contact;
}
- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0)
    {
        return 1;
    }else if (section == 1)
    {
        return 1+self.phones.count;
    }else if (section == 2)
    {
        return 1+self.emails.count;
    }else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)//姓名栏
    {
        CSNewContactNameCell *cell = [[CSNewContactNameCell alloc]init];
        __weak __typeof(self)weakSelf = self;
        cell.completeInputBlock = ^(NSString *name){
            weakSelf.name = name;
        };
        if (self.name)
        {
            cell.nameField.text = self.name;
        }
        
        [cell configCell];
        return cell;
    }else if (indexPath.section == 1)//电话号码栏
    {
        if (indexPath.row == self.phones.count)//电话添加栏
        {
            CSAddContactCell *cell = [[CSAddContactCell alloc]initWithType:phone];
            cell.addButton.tag = 10;
            [cell.addButton addTarget:self action:@selector(addContactInfo:) forControlEvents:UIControlEventTouchUpInside];
            [cell configCell];
            return cell;
        }else//电话填写栏
        {
            CSNewContactNumberCell *cell = [[CSNewContactNumberCell alloc]initWithType:phone];
            __weak __typeof(self)weakSelf = self;
            cell.deleteNumberBlock = ^(NSString *number){
                //NSLog(@"当前index.row = %ld",indexPath.row);
                [weakSelf.phones removeObjectAtIndex:indexPath.row];
                [weakSelf.tableView reloadData];
            };
            cell.completeInputBlock = ^(NSString *number){
                //NSLog(@"phone number = %@",number);
                //NSLog(@"当前cell indexpath.row = %ld, 当前phones下标 = %ld",indexPath.row,indexPath.row);
                //NSLog(@"当前phone数组->%@,当前数组大小->%ld",weakSelf.phones,[weakSelf.phones count]);
                [weakSelf.phones replaceObjectAtIndex:indexPath.row withObject:number];
            };
            
            cell.phoneField.text = self.phones[indexPath.row];
            [cell configCell];
            return cell;
        }
    }else if (indexPath.section == 2)//邮箱号码栏
    {
        if (indexPath.row == self.emails.count)//邮箱添加栏
        {
            CSAddContactCell *cell = [[CSAddContactCell alloc]initWithType:email];
            cell.addButton.tag = 20;
            [cell.addButton addTarget:self action:@selector(addContactInfo:) forControlEvents:UIControlEventTouchUpInside];
            [cell configCell];
            return cell;
        }else//邮箱填写栏
        {
            CSNewContactNumberCell *cell = [[CSNewContactNumberCell alloc]initWithType:email];
            __weak __typeof(self)weakSelf = self;
            cell.deleteNumberBlock = ^(NSString *number){
                //NSLog(@"当前index.row = %ld",indexPath.row);
                [weakSelf.emails removeObjectAtIndex:indexPath.row];
                [weakSelf.tableView reloadData];
            };
            cell.completeInputBlock = ^(NSString *number){
                //NSLog(@"phone number = %@",number);
                //NSLog(@"当前cell indexpath.row = %ld, 当前email下标 = %ld",indexPath.row,indexPath.row);
                //NSLog(@"当前email数组->%@,当前数组大小->%ld",weakSelf.emails,[weakSelf.emails count]);
                [weakSelf.emails replaceObjectAtIndex:indexPath.row withObject:number];
            };
            cell.phoneField.text = self.emails[indexPath.row];
            [cell configCell];
            return cell;
        }
    }else//备注栏
    {
        CSContactNoteCell *cell = [[CSContactNoteCell alloc]init];
        __weak __typeof(self)weakSelf = self;
        cell.completeInputBlock = ^(NSString *note){
            weakSelf.note = note;
        };
        if (self.note)
        {
            cell.textField.text = self.note;
        }
        [cell configCell];
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 80;
    }else if(indexPath.section == 3)
    {
        return 50;
    }else
    {
        return 40;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }else
    {
        return 30;
    }
}
- (void)addContactInfo:(UIButton *)button
{
    if (button.tag == 10)
    {
        NSString *phone = @"";
        [self.phones addObject:phone];
        [self.tableView reloadData];

    }else
    {
        NSString *email = @"";
        [self.emails addObject:email];
        [self.tableView reloadData];
    }
}

@end
