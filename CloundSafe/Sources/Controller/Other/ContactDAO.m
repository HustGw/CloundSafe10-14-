//
//  NoteDAO.m
//  MyNotes

#import "ContactDAO.h"

@implementation ContactDAO

static ContactDAO *sharedManager = nil;

+ (ContactDAO*)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedManager = [[self alloc] init];
        
    });
    [sharedManager createEditableCopyOfDatabaseIfNeeded];
    return sharedManager;
}


- (void)createEditableCopyOfDatabaseIfNeeded {
	
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    const char* cpath = [writableDBPath UTF8String];
    int code = sqlite3_open(cpath, &db);
    if (code != SQLITE_OK)
    {
        sqlite3_close(db);
        return;
        //NSAssert(NO,@"数据库打开失败。");
    } else
    {
        char *err;
        NSString *sql = @"CREATE TABLE IF NOT EXISTS contact (\
                            id  INTEGER PRIMARY KEY AUTOINCREMENT     NOT NULL,\
                            name    TEXT                              NOT NULL,\
                            phone   TEXT                              NOT NULL,\
                            email   TEXT                                      ,\
                            note    TEXT                                       \
        );";
        const char* cSql = [sql UTF8String];
        
        if (sqlite3_exec(db, cSql,NULL,NULL,&err) != SQLITE_OK)
        {
            sqlite3_close(db);
            NSAssert(NO, @"建表失败");
        }
        sqlite3_close(db);
    }
}

- (NSString *)applicationDocumentsDirectoryFile
{
    NSString *documentDirectory = [NSString stringWithFormat:@"%@/%@",DocumentPath,[userDefaults valueForKey:@"userName"]];
    NSString *path = [documentDirectory stringByAppendingPathComponent:DBFILE_NAME];
    
	return path;
}


//插入联系人方法
-(int) create:(CSContact*)contact
{
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK)
    {
		sqlite3_close(db);
        return -1;
		//NSAssert(NO,@"数据库打开失败。");
	} else
    {
        for (int i = 0; i < contact.phoneNumbers.count; i++)
        {
            if (contact.emailAddresses.count != 0)
            {
                for (int j = 0; j < contact.emailAddresses.count; j++)
                {
                    ContactObj *contactObj = [[ContactObj alloc]initWithName:contact.name phone:((CNPhoneNumber *)((CNLabeledValue *)(contact.phoneNumbers[i])).value).stringValue email:((CNLabeledValue*)(contact.emailAddresses[j])).value note:contact.note andID:contact.ID];
                    
                    NSString *sql = @"insert into contact(name,phone,email,note) VALUES (?,?,?,?)";
                    const char* cSql = [sql UTF8String];
                    
                    sqlite3_stmt *statement;
                    //预处理过程
                    if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK)
                    {
                        
                        //绑定参数开始
                        sqlite3_bind_text(statement, 1, [contactObj.name UTF8String], -1, NULL);
                        sqlite3_bind_text(statement, 2, [contactObj.phoneNumber UTF8String], -1, NULL);
                        sqlite3_bind_text(statement, 3, [contactObj.emailAddress UTF8String], -1, NULL);
                        sqlite3_bind_text(statement, 4, [contactObj.note UTF8String], -1, NULL);
                        //执行插入
                        
                        if (sqlite3_step(statement) != SQLITE_DONE)
                        {
                            //NSAssert(NO, @"插入数据失败。");
                            return 0;
                        }
                    }
                    
                    sqlite3_finalize(statement);
                    
                }
                
            }else
            {
                ContactObj *contactObj = [[ContactObj alloc]initWithName:contact.name phone:((CNPhoneNumber *)((CNLabeledValue *)(contact.phoneNumbers[i])).value).stringValue email:@"" note:contact.note andID:contact.ID];
                
                NSString *sql = @"insert into contact(name,phone,email,note) VALUES (?,?,?,?)";
                const char* cSql = [sql UTF8String];
                
                sqlite3_stmt *statement;
                //预处理过程
                if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK)
                {
                    
                    //绑定参数开始
                    sqlite3_bind_text(statement, 1, [contactObj.name UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 2, [contactObj.phoneNumber UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 3, [contactObj.emailAddress UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 4, [contactObj.note UTF8String], -1, NULL);
                    //执行插入
                    
                    if (sqlite3_step(statement) != SQLITE_DONE)
                    {
                        //NSAssert(NO, @"插入数据失败。");
                        return 0;
                    }
                }
                
                sqlite3_finalize(statement);
                
            }
            
        }
        sqlite3_close(db);
    }
    
    return 1;
}

//按名字删除联系人
- (int) removeByName:(NSString*)name
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        //NSAssert(NO,@"数据库打开失败。");
        return -1;
    }else
    {
        NSString *sql = @"DELETE from contact where name =?";
        const char* cSql = [sql UTF8String];

        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK)
        {

                //绑定参数开始
                sqlite3_bind_text(statement, 1, [name UTF8String], -1, NULL);
                //执行
                if (sqlite3_step(statement) != SQLITE_DONE)
                {
                    //NSAssert(NO, @"删除数据失败。");
                    return 0;
                }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);

    }
    return 1;
}
//修改联系人方法
-(int) modify:(CSContact*)contact
{
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK)
    {
		sqlite3_close(db);
        return -1;
		//NSAssert(NO,@"数据库打开失败。");
	} else
    {
        NSString *sql = @"UPDATE contact set name=?,phone=?,email=?,note=? where id=?";
        const char* cSql = [sql UTF8String];
        for (int i = 0; i < contact.phoneNumbers.count; i++)
        {
            if (contact.emailAddresses.count != 0)
            {
                for (int j = 0; j < contact.emailAddresses.count; j++)
                {
                    ContactObj *contactObj = [[ContactObj alloc]initWithName:contact.name phone:((CNPhoneNumber *)((CNLabeledValue *)(contact.phoneNumbers[i])).value).stringValue email:((CNLabeledValue*)(contact.emailAddresses[j])).value note:contact.note andID:contact.ID];
                    sqlite3_stmt *statement;
                    //预处理过程
                    if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK)
                    {
                    //绑定参数开始
                        sqlite3_bind_text(statement, 1, [contactObj.name UTF8String], -1, NULL);
                        sqlite3_bind_text(statement, 2, [contactObj.phoneNumber UTF8String], -1, NULL);
                        sqlite3_bind_text(statement, 3, [contactObj.emailAddress UTF8String], -1, NULL);
                        sqlite3_bind_text(statement, 4, [contactObj.note UTF8String], -1, NULL);
                        sqlite3_bind_int(statement, 5, contactObj.ID);
                        //执行
                        if (sqlite3_step(statement) != SQLITE_DONE)
                        {
                            //NSAssert(NO, @"修改数据失败。");
                            return 0;
                        }
                    }
                    
                    sqlite3_finalize(statement);
                    sqlite3_close(db);

                }
                
            }else
            {
                ContactObj *contactObj = [[ContactObj alloc]initWithName:contact.name phone:((CNPhoneNumber *)((CNLabeledValue *)(contact.phoneNumbers[i])).value).stringValue email:@"" note:contact.note andID:contact.ID];
                sqlite3_stmt *statement;
                //预处理过程
                if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK)
                {
                    //绑定参数开始
                    sqlite3_bind_text(statement, 1, [contactObj.name UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 2, [contactObj.phoneNumber UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 3, [contactObj.emailAddress UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 4, [contactObj.note UTF8String], -1, NULL);
                    sqlite3_bind_int(statement, 5, contactObj.ID);
                    //执行
                    if (sqlite3_step(statement) != SQLITE_DONE)
                    {
                        //NSAssert(NO, @"修改数据失败。");
                        return 0;
                    }
                }
                
                sqlite3_finalize(statement);
                sqlite3_close(db);
            
            }
        
        }

    }
    return 1;
}

//查询所有数据方法
-(NSMutableArray*) findAll
{
    NSMutableArray *contactList = [[NSMutableArray alloc]init];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
	if (sqlite3_open(cpath, &db) != SQLITE_OK)
    {
		sqlite3_close(db);
        return nil;
		//NSAssert(NO,@"数据库打开失败。");
	} else
    {
        NSString *sql = @"SELECT id,name,phone,email,note FROM contact";
        const char* cSql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK)
        {
            //执行
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                int ID = (int)sqlite3_column_int(statement, 0);
                
                char *bufName = (char *) sqlite3_column_text(statement, 1);
                NSString *strName = [[NSString alloc] initWithUTF8String: bufName];
                
                char *bufPhone = (char *) sqlite3_column_text(statement, 2);
                NSString * strPhone = [[NSString alloc] initWithUTF8String: bufPhone];
                
                char *bufEmail = (char *) sqlite3_column_text(statement, 3);
                NSString * strEmail = [[NSString alloc] initWithUTF8String: bufEmail];
                
                char *bufNote = (char *) sqlite3_column_text(statement, 4);
                NSString * strNote = [[NSString alloc] initWithUTF8String: bufNote];
                
                ContactObj *obj = [[ContactObj alloc]initWithName:strName phone:strPhone email:strEmail note:strNote andID:ID];
                CSContact *contact = [self contactWithContactObj:obj];
                [contactList addObject:contact];
            }

        }

		sqlite3_finalize(statement);
		sqlite3_close(db);
		
	}
    return contactList;
}

//按照名字查询数据方法
-(CSContact*) findByName:(NSString*)name
{
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
	if (sqlite3_open(cpath, &db) != SQLITE_OK)
    {
		sqlite3_close(db);
		NSAssert(NO,@"数据库打开失败。");
	} else
    {
        
        NSString *sql = @"SELECT name,phone,email,note FROM contact where name =?";
        const char* cSql = [sql UTF8String];
        
		sqlite3_stmt *statement;
		//预处理过程
		if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK)
        {
			//准备参数
            
            const char* cName  = [name UTF8String];
            
            //绑定参数开始
			sqlite3_bind_text(statement, 1, cName, -1, NULL);
            
			//执行
			if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                char *bufName = (char *) sqlite3_column_text(statement, 0);
                NSString *strName = [[NSString alloc] initWithUTF8String: bufName];
                
                char *bufPhone = (char *) sqlite3_column_text(statement, 1);
                NSString * strPhone = [[NSString alloc] initWithUTF8String: bufPhone];
                
                char *bufEmail = (char *) sqlite3_column_text(statement, 2);
                NSString * strEmail = [[NSString alloc] initWithUTF8String: bufEmail];
                
                char *bufNote = (char *) sqlite3_column_text(statement, 3);
                NSString * strNote = [[NSString alloc] initWithUTF8String: bufNote];
                
                ContactObj *obj = [[ContactObj alloc]initWithName:strName phone:strPhone email:strEmail note:strNote andID:0];
                CSContact *contact = [self contactWithContactObj:obj];
                
                sqlite3_finalize(statement);
                sqlite3_close(db);
                
                return contact;
			}
		}
		
		sqlite3_finalize(statement);
		sqlite3_close(db);
		
	}
    return nil;
}
- (int) saveContact:(CSContact *)contact
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        return -1;
        //NSAssert(NO,@"数据库打开失败。");
    } else
    {
        for (int i = 0; i < contact.phoneNumbers.count; i++)
        {
            if (contact.emailAddresses.count != 0)
            {
                for (int j = 0; j < contact.emailAddresses.count; j++)
                {
                    ContactObj *contactObj = [[ContactObj alloc]initWithName:contact.name phone:((CNPhoneNumber *)((CNLabeledValue *)(contact.phoneNumbers[i])).value).stringValue email:((CNLabeledValue*)(contact.emailAddresses[j])).value note:contact.note andID:contact.ID];
                    
                    NSString *sql = @"insert into contact(name,phone,email,note) VALUES (?,?,?,?)";
                    const char* cSql = [sql UTF8String];
                    
                    sqlite3_stmt *statement;
                    //预处理过程
                    int code = sqlite3_prepare_v2(db, cSql, -1, &statement, NULL);
                    if (code == SQLITE_OK)
                    {
                        
                        //绑定参数开始
                        sqlite3_bind_text(statement, 1, [contactObj.name UTF8String], -1, NULL);
                        sqlite3_bind_text(statement, 2, [contactObj.phoneNumber UTF8String], -1, NULL);
                        sqlite3_bind_text(statement, 3, [contactObj.emailAddress UTF8String], -1, NULL);
                        sqlite3_bind_text(statement, 4, [contactObj.note UTF8String], -1, NULL);
                        //执行插入
                        
                        if (sqlite3_step(statement) != SQLITE_DONE)
                        {
                            return 0;
                            //NSAssert(NO, @"插入数据失败。");
                        }
                    }
                    
                    sqlite3_finalize(statement);
                    
                }

            }else
            {
                ContactObj *contactObj = [[ContactObj alloc]initWithName:contact.name phone:((CNPhoneNumber *)((CNLabeledValue *)(contact.phoneNumbers[i])).value).stringValue email:@"" note:contact.note andID:contact.ID];
                
                NSString *sql = @"insert into contact(name,phone,email,note) VALUES (?,?,?,?)";
                const char* cSql = [sql UTF8String];
                
                sqlite3_stmt *statement;
                //预处理过程
                if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK)
                {
                    
                    //绑定参数开始
                    sqlite3_bind_text(statement, 1, [contactObj.name UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 2, [contactObj.phoneNumber UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 3, [contactObj.emailAddress UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 4, [contactObj.note UTF8String], -1, NULL);
                    //执行插入
                    
                    if (sqlite3_step(statement) != SQLITE_DONE)
                    {
                        return 0;
                        //NSAssert(NO, @"插入数据失败。");
                    }
                }
                
                sqlite3_finalize(statement);

            }
            
        }
        sqlite3_close(db);
        
    }
    return 1;
}
- (CSContact *)contactWithContactObj:(ContactObj *)obj
{
    CSContact *contact = [[CSContact alloc]init];
    contact.ID = obj.ID;
    contact.name = obj.name;
    CNPhoneNumber *phone = [[CNPhoneNumber alloc]initWithStringValue:obj.phoneNumber];
    CNLabeledValue *phoneLabeledValue = [CNLabeledValue labeledValueWithLabel:@"电话" value:phone];
    contact.phoneNumbers = @[phoneLabeledValue];
    CNLabeledValue *emailLabeledValue = [CNLabeledValue labeledValueWithLabel:@"邮箱" value:obj.emailAddress];
    contact.emailAddresses = @[emailLabeledValue];
    contact.note = obj.note;
    return contact;
}
@end

@implementation ContactObj

- (id)initWithName:(NSString *)name phone:(NSString *)phoneNumber email:(NSString *)email note:(NSString *)note andID:(int)ID
{
    if (self = [super init])
    {
        self.ID = ID;
        self.name = name;
        self.phoneNumber = phoneNumber;
        self.emailAddress = email;
        self.note = note;
    }
    return self;
}


@end
