//
//  CSContactInoContorller.m
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/9.
//
//

#import "CSContactInoContorller.h"
#import "CSContact.h"
#import "CSContactCell.h"
#import "CSContactPhoneCell.h"
#import "CSContactEditController.h"
#import "CSContactEmailCell.h"
@interface CSContactInoContorller ()
@property (nonatomic, strong) CSContact *contact;
@property (nonatomic, strong) NSArray *emails;
@property (nonatomic, strong) NSArray *phones;
@end

@implementation CSContactInoContorller
- (id)initWithContact:(CSContact *)contact
{
    if (self = [super init])
    {
        _contact = contact;
        _emails = [self arrayOfValidEmailFromContact:contact];
        _phones = contact.phoneNumbers;
    }
    return self;
}
- (NSArray *)arrayOfValidEmailFromContact:(CSContact *)contact
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < contact.emailAddresses.count; ++i)
    {
        CNLabeledValue *labeled = contact.emailAddresses[i];
        NSString *email = labeled.value;
        if (![email isEqualToString:@""])
        {
            [arr addObject:labeled];
        }
    }
    return [NSArray arrayWithArray:arr];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setTableFooterView:[[UIView alloc]init]];//清除tableView多余的分割线
    self.navigationItem.title = @"详情";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editContact)];
    [right setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:right];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [left setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:left];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getModifiedContact:) name:@"updateContactInfo" object:nil];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getModifiedContact:(NSNotification *)obj
{
    self.contact = (CSContact *)obj.object;
    self.phones = self.contact.phoneNumbers;
    self.emails = [self arrayOfValidEmailFromContact:self.contact];
    [self.tableView reloadData];
}
- (void)editContact
{
    CSContactEditController *vc = [[CSContactEditController alloc]initWithContact:self.contact];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
     return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (section == 0)
    {
        return 1;
    }else if(section == 1)
    {
        return self.phones.count;
    }else
    {
        if (self.emails.count == 0)
        {
            return 0;
        }
        return self.emails.count;
    }

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 90;
    }else
    {
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
    {
        
        CSContactCell *cell = [[CSContactCell alloc]init];
        [cell setContact:self.contact];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.section == 1)
    {
        CSContactPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactInfoPhoneCell"];
        if (!cell)
        {
            cell = [[CSContactPhoneCell alloc]init];
        }
        cell.number = ((CNLabeledValue *)(self.phones[indexPath.row])).value;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak __typeof(self)weakSelf = self;
        cell.weakController = weakSelf;
        return cell;

    }
    else
    {
        CSContactEmailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactInfoEmailCell"];
        CNLabeledValue *labeled = self.emails[indexPath.row];
        if (!cell)
        {
            cell = [[CSContactEmailCell alloc]initWithEmail:labeled.value];
        }
        cell.label.text = (NSString *)labeled.value;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCell];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
