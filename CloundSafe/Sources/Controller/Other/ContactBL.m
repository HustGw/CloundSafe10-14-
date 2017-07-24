//
//  NoteBL.m
//  MyNotes

#import "ContactBL.h"
#import "ContactDAO.h"
#import "CSContact.h"
@implementation ContactBL

//插入联系人方法
-(NSMutableArray*) createContact:(CSContact*)contact
{
    ContactDAO *dao = [ContactDAO sharedManager];
    [dao create:contact];
    
    return [dao findAll];
}
//插入单条记录
- (int) insertContact:(CSContact *)contact
{
    ContactDAO *dao = [ContactDAO sharedManager];
    
    
    return [dao create:contact];
}

//删除单条记录
- (int) removeContactByName:(NSString *)name
{
    ContactDAO *dao = [ContactDAO sharedManager];
    return [dao removeByName:name];
}

//更新记录
- (int) modifyContact:(CSContact *)contact
{
    ContactDAO *dao = [ContactDAO sharedManager];
    return [dao modify:contact];
}


//查询所用数据方法
-(NSMutableArray*) findAll
{
    ContactDAO *dao = [ContactDAO sharedManager];
    return [dao findAll];
}

//保存联系人
- (int) saveContact:(CSContact *)contact
{
    ContactDAO *dao = [ContactDAO sharedManager];
    return [dao saveContact:contact];
}

//按照名字查询数据方法
-(CSContact*) findByName:(NSString*)name;
{
    ContactDAO *dao = [ContactDAO sharedManager];
    return [dao findByName:name];
}
@end
