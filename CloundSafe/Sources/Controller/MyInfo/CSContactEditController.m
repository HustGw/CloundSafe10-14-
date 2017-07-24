//
//  CSContactEditController.m
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/14.
//
//

#import "CSContactEditController.h"
#import "CSContactNoteCell.h"
#import "CSContact.h"
#import "ContactBL.h"
@interface CSContactEditController ()
@property (nonatomic, strong) NSMutableArray *phones;
@property (nonatomic, strong) NSMutableArray *emails;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *oldName;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) CSContact *contact;
@end

@implementation CSContactEditController
- (id)initWithContact:(CSContact *)contact
{
    if (self = [super init])
    {
        self.contact = contact;
        self.phones = [self mutableArrayFromContact:contact.phoneNumbers];
        self.emails = [self mutableArrayFromContact:contact.emailAddresses];
        self.name = contact.name;
        self.note = contact.note;
        self.oldName = self.name;
    }
    return self;
}

- (NSMutableArray *)mutableArrayFromContact:(NSArray *)array
{
    CNLabeledValue *obj = array.firstObject;
    id value = obj.value;
    if ([value isKindOfClass:[CNPhoneNumber class]])
    {
        NSMutableArray *phones = [[NSMutableArray alloc]init];
        for (CNLabeledValue *labeledValue in array)
        {
            CNPhoneNumber *number = labeledValue.value;
            [phones addObject:number.stringValue];
        }
        return phones;
    }else//([value isKindOfClass:[NSString class]])
    {
        NSMutableArray *emails = [[NSMutableArray alloc]init];
        for (CNLabeledValue *labeledValue in array)
        {
            [emails addObject:labeledValue.value];
        }
        return emails;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"编辑";
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(submitUpdate)];
    [right setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:right];
    [self.tableView setTableFooterView:[self deleteContactView]];
}
- (UIView *)deleteContactView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
    UIView *upLine = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 0.5)];
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, 59, kScreenWidth, 0.5)];
    [view addSubview:upLine];
    [view addSubview:downLine];
    upLine.backgroundColor = segmenteLineColor;
    downLine.backgroundColor = segmenteLineColor;
    
    UIButton *deleteContactButton = [[UIButton alloc]init];
    [view addSubview:deleteContactButton];
    [deleteContactButton setBackgroundColor:[UIColor whiteColor]];
    [deleteContactButton setTitle:@"删除联系人" forState:UIControlStateNormal];
    deleteContactButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleteContactButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteContactButton addTarget:self action:@selector(deleteContact) forControlEvents:UIControlEventTouchUpInside];
    [deleteContactButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(view).offset(20);
        make.bottom.equalTo(view).offset(-1);
    }];
    return view;
}
- (void)deleteContact
{
    ContactBL *contactBL = [[ContactBL alloc]init];
    [contactBL removeContactByName:self.contact.name];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contactUpdated" object:nil];
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}
//提交修改
- (void)submitUpdate
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
        }else//执行更新
        {
            ContactBL *contactBL = [[ContactBL alloc]init];
            CSContact *updatedContact = [self modifiedContactWithName:self.name phones:self.phones emails:self.emails note:self.note andID:self.contact.ID];
            //先删除
            if ([contactBL removeContactByName:self.oldName] == 1)//删除成功，执行插入
            {
                [contactBL insertContact:updatedContact];
            }
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"contactUpdated" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateContactInfo" object:updatedContact];
            
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
- (CSContact *)modifiedContactWithName:(NSString *)name phones:(NSArray *)phones emails:(NSArray *)emails note:(NSString *)note andID:(int)ID
{
    CSContact *contact = [[CSContact alloc]init];
    contact.name = name;
    contact.ID = ID;

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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
