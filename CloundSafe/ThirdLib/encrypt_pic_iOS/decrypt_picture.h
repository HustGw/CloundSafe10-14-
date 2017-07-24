//
//  Header.h
//  图片拆分测试程序
//
//  Created by Messiah_S on 6/12/16.
//  Copyright © 2016 ZJ-Jie. All rights reserved.
//

#ifndef Header_h
#define Header_h
int EncryptedThenAddInfo_pic(char* pic_path, int extraction_percent, char* key_path, char* content_path, char* file_id, char* usercode, char* version);
int AgreedThenDecryption_pic(char* srcfilepath, char* key_path);
int GetUserInfo_pic(char* srcfilepath, char *pUserInfo);


#endif /* Header_h */
