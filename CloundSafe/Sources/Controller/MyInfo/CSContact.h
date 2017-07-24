//
//  CSContact.h
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/8.
//
//

#import <Foundation/Foundation.h>

@interface CSContact : NSObject
@property (nonatomic, assign) int ID;
@property (nonatomic, strong) NSString *familyName;//姓
@property (nonatomic, strong) NSString *givenName;//名字
//@property (nonatomic, strong) NSString *organizationName;//公司名字
@property (nonatomic, strong) NSArray *phoneNumbers;//电话号码
//@property (nonatomic, strong) NSArray *postalAddresses;//住址
@property (nonatomic, strong) NSArray *emailAddresses;//邮箱
//@property (nonatomic, strong) NSArray *urlAddresses;//首页
@property (nonatomic, strong) NSString *note;//备注
//@property (nonatomic, strong) NSData *imageData;//头像
@property (nonatomic, strong) NSString *name;//姓+名字

@end
