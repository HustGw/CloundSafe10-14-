//
//  NoteDAO.h
//  MyNotes

#import <Foundation/Foundation.h>
#import "CSContact.h"
#import "sqlite3.h"


@interface ContactDAO : NSObject
{
    sqlite3 *db;
}

+ (ContactDAO*)sharedManager;

- (NSString *)applicationDocumentsDirectoryFile;
- (void)createEditableCopyOfDatabaseIfNeeded;


//插入联系人方法
-(int) create:(CSContact*)contact;

//修改联系人方法
-(int) modify:(CSContact*)contact;

//查询所有数据方法
-(NSMutableArray*) findAll;

//按名字删除联系人
- (int) removeByName:(NSString*)name;

//按照名字查询数据方法
-(CSContact*) findByName:(NSString*)name;

//保存联系人
- (int) saveContact:(CSContact *)contact;

@end

@interface ContactObj : NSObject
@property (nonatomic, assign) int ID;
@property (nonatomic, strong) NSString *name;//名字
@property (nonatomic, strong) NSString *phoneNumber;//电话号码
@property (nonatomic, strong) NSString *emailAddress;//邮箱
@property (nonatomic, strong) NSString *note;//备注
- (id)initWithName:(NSString *)name phone:(NSString *)phoneNumber email:(NSString *)email note:(NSString *)note andID:(int)ID;

@end
