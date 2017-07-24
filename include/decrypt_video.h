#ifndef decrypt_video_h
#define decrypt_video_h
//int Encryption(char *srcfilepath, char *keyfilepath,int extract_Nalu,double Nalu_percent,int extract_Islice,double Islice_percent,int FrameInterval,int unitInterval);
//int Decryption_video(char* srcfilepath, char* key_path);

int EncryptedThenAddInfo(char *srcfilepath, char *keyfilepath, int extract_Nalu, double Nalu_percent, int extract_Islice, double Islice_percent, int FrameInterval, int unitInterval, char* file_id, char* usercode, char* version);
int AgreedThenDecryption(char* srcfilepath, char* key_path);
int GetUserInfo(char* srcfilepath, char* pUserInfo);
#endif /* decrypt_video_h */
