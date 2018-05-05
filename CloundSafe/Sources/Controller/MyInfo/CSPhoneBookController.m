//
//  CSPhoneBookController.m
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/8.
//
//

#import "CSPhoneBookController.h"
#import "CSContact.h"
#import "CSSearchResultsController.h"
#import "CSContactInoContorller.h"
#import "CSContactInoContorller.h"
#import "CSAddContactController.h"
#import "ContactBL.h"
#import "BMChineseSort.h"

@interface CSPhoneBookController ()<UISearchResultsUpdating>
@property (nonatomic, strong) NSArray *contacts;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) CSSearchResultsController *searchResultController;
@property(nonatomic,strong) NSMutableArray *contactArr;

@end

@implementation CSPhoneBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"通讯录";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0/255.0 green:205.0/255.0 blue:111.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [left setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:left];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
    [right setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:right];
    
    [self.tableView setTableFooterView:[[UIView alloc]init]];//清除tableView多余的分割线
    self.searchResultController = [[CSSearchResultsController alloc]init];
    __weak __typeof(self)weakSelf = self;
    self.searchResultController.weakController = weakSelf;
    self.searchResultController.selectBlock = ^(){
        weakSelf.searchController.active = NO;
    };
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    [self.searchController.searchBar sizeToFit];
    
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [self getContact];
    
    self.indexArray = [BMChineseSort IndexWithArray:_contacts Key:@"name"];
    self.letterResultArr = [BMChineseSort sortObjectArray:_contacts Key:@"name"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refleshArrayOfNewContact) name:@"contactUpdated" object:nil];
}

- (UILabel *)contactAuthorizationLabel
{
    if (!_contactAuthorizationLabel)
    {
        _contactAuthorizationLabel = [[UILabel alloc]init];
        _contactAuthorizationLabel.alpha = 0.7;
        _contactAuthorizationLabel.font = [UIFont systemFontOfSize:15];
        _contactAuthorizationLabel.tintColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
        _contactAuthorizationLabel.text = @"您未开启通讯录权限,请前往设置中心开启。";
        [self.tableView addSubview:_contactAuthorizationLabel];
        [_contactAuthorizationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.tableView);
            make.centerY.equalTo(self.tableView).offset(-100);
            make.size.mas_equalTo(CGSizeMake(300, 25));
        }];
    }
    return _contactAuthorizationLabel;
}
- (void)refleshArrayOfNewContact
{
    ContactBL *contactBL = [[ContactBL alloc]init];
    self.contacts = [self removeRepeatedContact:[contactBL findAll]];
    self.indexArray = [BMChineseSort IndexWithArray:_contacts Key:@"name"];
    self.letterResultArr = [BMChineseSort sortObjectArray:_contacts Key:@"name"];
    [self.tableView reloadData];
}
//添加联系人
- (void)addContact
{
    CSAddContactController *vc = [[CSAddContactController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - searchController delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS [c] %@", self.searchController.searchBar.text];
    self.searchResultController.phoneSource = [self.contacts filteredArrayUsingPredicate:searchPredicate];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchResultController.tableView reloadData];
    });
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.indexArray objectAtIndex:section];
}
//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.indexArray count];
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.letterResultArr objectAtIndex:section] count];
}
//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
- (void)getContact
{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusAuthorized)
    {//有权限时
        self.contactAuthorizationLabel.hidden = YES;
        NSString *userName = [userDefaults valueForKey:@"userName"];
        NSLog(@"Lisa.通讯录.username=%@",userName);
        NSString *dbPath = [NSString stringWithFormat:@"%@/%@/%@",DocumentPath,userName,DBFILE_NAME];
        NSLog(@"Lisa.PhoneBook.dbPath=%@",dbPath);
        if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath])//首次启动
        {
            
            if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized)
            {//有权限访问
                NSError *error = nil;
                //创建数组,必须遵守CNKeyDescriptor协议,放入相应的字符串常量来获取对应的联系人信息
                NSArray <id<CNKeyDescriptor>> *keysToFetch = @[
                                                               CNContactGivenNameKey, CNContactFamilyNameKey,CNContactOrganizationNameKey,CNContactNoteKey,CNContactImageDataKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactPostalAddressesKey,CNContactUrlAddressesKey];
                //创建获取联系人的请求
                CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
                //遍历查询
                //创建CNContactStore对象,用与获取和保存通讯录信息
                self.contactArr = [[NSMutableArray alloc]init];
                CNContactStore *contactStore = [[CNContactStore alloc] init];
                [contactStore enumerateContactsWithFetchRequest:fetchRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                    if (!error) {
                        CSContact *person = [[CSContact alloc]init];
                        person.familyName = contact.familyName;
                        NSLog(@"Lisa.通讯录首次.familyname=%@",person.familyName);
                        person.givenName = contact.givenName;
                        person.phoneNumbers = contact.phoneNumbers;
                        //person.organizationName = contact.organizationName;
                        //person.urlAddresses = contact.urlAddresses;
                        //person.postalAddresses = contact.postalAddresses;
                        person.emailAddresses = contact.emailAddresses;
                        person.note = contact.note;
                        person.name = [NSString stringWithFormat:@"%@%@",person.familyName, person.givenName];
                        //person.imageData = contact.imageData;
                        [self.contactArr addObject:person];
                        
                    }else{
                        NSLog(@"error:%@", error.localizedDescription);
                    }
                }];
                self.contacts = [[NSArray alloc]initWithArray:self.contactArr];
                //创建数据库，存储联系人
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    ContactBL *contactBL = [[ContactBL alloc]init];
                    for (int i =0; i<self.contacts.count; ++i)
                    {
                        CSContact *contact = self.contacts[i];
                        contact.ID = i+1;
                        [contactBL saveContact:contact];
                    }
                    
                });
                
                
            }else
            {//无权限访问
                NSLog(@"拒绝访问通讯录");
            }
            
            
        }
        else //非首次启动,从数据库加载数据
        {
            ContactBL *contactBL = [[ContactBL alloc]init];
            self.contacts = [self removeRepeatedContact:[contactBL findAll]];
        }
    }
    else
    {
        self.contactAuthorizationLabel.hidden = NO;
        NSLog(@"您未开启通讯录权限,请前往设置中心开启");
    }
    
}

//- (NSString *)firstCharactor:(NSString *)aString
//{
//    //转成了可变字符串
//    NSMutableString *str = [NSMutableString stringWithString:aString];
//    //先转换为带声调的拼音
//    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
//    //再转换为不带声调的拼音
//    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
//    //转化为大写拼音
//    NSString *pinYin = [str capitalizedString];
//    //获取并返回首字母
//    return [pinYin substringToIndex:1];
//    NSLog(@"Lisa.aString.pinYin=%@",pinYin);
//}
//去掉从数据返回的重复记录
- (NSArray *)removeRepeatedContact:(NSArray *)soucres
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < soucres.count; ++i)
    {
        CSContact *contact = soucres[i];
        if (![dict valueForKey:contact.name])
        {
            [dict setValue:contact forKey:contact.name];
        }else
        {
            CSContact *person = [dict valueForKey:contact.name];
            
            NSMutableArray *phones = [[NSMutableArray alloc]initWithArray:person.phoneNumbers];
            [phones addObject:contact.phoneNumbers.firstObject];
            person.phoneNumbers = [self mergePhoneNumber:phones];
            
            NSMutableArray *emails = [[NSMutableArray alloc]initWithArray:person.emailAddresses];
            [emails addObject:contact.emailAddresses.firstObject];
            person.emailAddresses = [self mergeEmailNumber:emails];
            
        }
    }
    return [dict allValues];
}
//合并电话号码
- (NSArray *)mergePhoneNumber:(NSArray *)phones
{
    NSMutableDictionary *phoneDict = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < phones.count; ++i)
    {
        NSString *contactNumber = ((CNPhoneNumber *)(((CNLabeledValue *)phones[i]).value)).stringValue;
        [phoneDict setValue:@"电话" forKey:contactNumber];
    }
    NSArray *arr = [phoneDict allKeys];
    NSMutableArray *newPhones = [[NSMutableArray alloc]init];
    for (int i = 0; i < arr.count; ++i)
    {
        CNPhoneNumber *number = [[CNPhoneNumber alloc]initWithStringValue:arr[i]];
        CNLabeledValue *labeled = [[CNLabeledValue alloc]initWithLabel:[NSString stringWithFormat:@"电话%d",i+1] value:number];
        [newPhones addObject:labeled];
    }
    return [NSArray arrayWithArray:newPhones];
}
//合并邮箱
- (NSArray *)mergeEmailNumber:(NSArray *)emails
{
    NSMutableDictionary *emailDict = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < emails.count; ++i)
    {
        NSString *contactEmail = (NSString *)((CNLabeledValue *)emails[i]).value;
        [emailDict setValue:@"邮箱" forKey:contactEmail];
    }
    NSArray *arr = [emailDict allKeys];
    NSMutableArray *newEmails = [[NSMutableArray alloc]init];
    for (int i = 0; i < arr.count; ++i)
    {
        CNLabeledValue *labeled = [[CNLabeledValue alloc]initWithLabel:[NSString stringWithFormat:@"邮箱%d",i+1] value:arr[i]];
        [newEmails addObject:labeled];
    }
    return [NSArray arrayWithArray:newEmails];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.contacts)
//    {
//        return self.contacts.count;
//    }else
//    {
//        return 0;
//    }
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contactCell"];
    }
    CSContact *person = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = person.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSContactInoContorller *info = [[CSContactInoContorller alloc]initWithContact:[[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:info animated:YES];
}

@end
