//
//  NoteBL.h
//  MyNotes

#import <Foundation/Foundation.h>

@class CSContact;

@interface ContactBL : NSObject

//插入联系人方法
-(NSMutableArray*) createContact:(CSContact*)contact;

//查询所用数据方法
-(NSMutableArray*) findAll;

//删除单条记录
- (int) removeContactByName:(NSString *)name;

//更新记录
- (int) modifyContact:(CSContact *)contact;

//插入单条记录
- (int) insertContact:(CSContact *)contact;

//保存联系人
- (int) saveContact:(CSContact *)contact;

//按照名字查询数据方法
-(CSContact*) findByName:(NSString*)name;

@end
