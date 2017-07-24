#ifndef BS_H
#define BS_H

#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#define KEY_BIT_LEN_1 8

#define KEY_BIT_LEN_3 3
#define KEY_BIT_LEN_4 8
#define KEY_UNIT_CNT 1024*1024*20 //20M
#define MAX_BUFFER_LEN 1024*1024// 1M

typedef struct
{
	uint8_t* start;
	uint8_t* p;
	uint8_t* end;
	int bits_left;
} bs_t;

typedef struct
{
    int byte_offset;
    int bit_offset;
    int key_data_len;
    int is_Islice;
}KeyUnit;



typedef enum
{
    False = 0,
    True = 1,
    
}Bool;

typedef struct
{
    FILE *srcfp;
    
    /*read file to buffer*/
    uint8_t *data;
    long read_pos;
    long write_pos;
    size_t buf_size;
	Bool isfirst_buf;
    int buf_no;
    int buf_offset;
    Bool bufmodifed;
    Bool read_next_buf;
    size_t read_byte_count;
    //todo
    int file_content_start;
    int file_content_end;
    
}SrcFileInfo;

typedef struct
{
    int unitlen1; /*use 6 bits stands for relative byteoff,which decides the length of unit2*/
    int unitlen2;
    int unitlen3;/*this unit use 3 bits to decide bitoffset*/
    int unitlen4;/*this unit use 8 bits to decide the changed data length*/
    int unitlen5;
    
}Keyformat;

typedef struct
{
    FILE *keyfp;
    
    /*read file to buffer*/
    uint8_t *data;
    size_t filesize;
    
    bs_t *b_key;
    Bool bufmodifed;
    Bool read_next_buf;
    
}Keyfile;

typedef struct
{
    //int key_fd;
    FILE *keyfp;
    
    uint8_t *keydata;
    int byteoff;
    int relative_byteoff;
    int bitoff;
    int datalen;
    int change_byte_cnt;
    int keyunit_bytelen;
    Keyformat *keyformat;
    int unitInterval;
}Key;



int bs_eof(bs_t* b);
bs_t* bs_init(bs_t* b, uint8_t* buf, size_t size);
bs_t* bs_new(uint8_t* buf, size_t size);
void bs_skip_u1(bs_t* b);
void bs_skip_u(bs_t* b, int n);
void bs_free(bs_t* b);
uint32_t bs_read_u1(bs_t* b);
uint32_t bs_read_u(bs_t* b, int n);
void bs_write_u1(bs_t* b, uint32_t v);
void bs_write_u(bs_t* b, int n, uint32_t v);

#define BITLEN_A_BYTE 8

//decrypt.h
/*********************** FUNCTION DECLARATIONS **********************/
void init_srcfile(SrcFileInfo *srcfile,char* srcfilepath);
void init_keyfile(Keyfile *keyfile,char *key_path);
void deinit_keyfile(Keyfile *keyfile);
void deinit_srcfile(SrcFileInfo *srcfile);

int get_key_encryptpos(Key *key,Keyfile *keyfile);
int write_keydata_tosrcfile(SrcFileInfo * file,Key * key);
int goto_byte_start(Key *key,Keyfile *keyfile);
int get_keydata(Key *key,Keyfile *keyfile);
int Decryption_video(char* srcfilepath, char* key_path);

//encrypt.h
//#define BITLEN_A_BYTE 8

//int extract_encrypt(char *srcfilepath,char *keypath);
int extract_encrypt(char *srcfilepath,char *keypath,int unitInterval);
int read_srcfile(SrcFileInfo *file,Key *key);
int get_one_key(Key *key,SrcFileInfo *srcfile);
void init_key(int index, Key *key, SrcFileInfo *srcfile);
void deinit_key(Key *key);
int write_keyfile(Key *key);
int encrypt_one_unit(int index,SrcFileInfo *srcfile,Key *key);
int write_srcfile(SrcFileInfo *file);

//keycommon.h
int getbitcnt(unsigned int Number,int *BitCount );
int get_keybytelen(Key *key , int *key_all_data_bytelen);
int bs_write_data(bs_t *b, int bitlen,uint8_t *s_Keydata);
int bs_Read_KeyData(bs_t *b, int BitLength,uint8_t *s_Keydata);
int get_changed_byte_cnt(int BitLength,int BitOffset,int *ChangedByteNum);
int bs_read_data(bs_t *b, int bitlen,uint8_t *s_Keydata);
int file_size2(char* filename);  
#endif