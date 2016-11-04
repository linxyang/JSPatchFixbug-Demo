//
//  NSData+Des.m
//  timeLineCellList
//
//  Created by fuchun on 16/10/12.
//  Copyright © 2016年 yanglinxia. All rights reserved.
//

#import "NSData+Des.h"

@implementation NSData (Des)

- (NSData *)decryptWithKey:(NSString *)key iv:(NSString *)iv
{
    return [self crypto:kCCDecrypt key:key.UTF8String iv:iv.UTF8String];
}

- (NSData *)encryptWithKey:(NSString *)key iv:(NSString *)iv
{
    return [self crypto:kCCEncrypt key:key.UTF8String iv:iv.UTF8String];
}

- (NSData *)crypto:(CCOperation)operation  key:(const char *)key iv:(const char *)iv
{
    if(!self.length)
    {
        return nil;
    }
    
    //密文长度
    size_t size = self.length + kCCKeySizeDES;
    
    Byte *buffer = (Byte *)malloc(size * sizeof(Byte));
    
    //结果的长度
    size_t numBytes = 0;
    
    //CCCrypt函数 加密/解密
    CCCryptorStatus cryptStatus = CCCrypt(
                                          operation,//  加密/解密
                                          kCCAlgorithmDES,//  加密根据哪标准（des3desaes）
                                          kCCOptionPKCS7Padding,//  选项组密码算(des:每块组加密  3DES：每块组加三同密)
                                          key,//密钥    加密解密密钥必须致
                                          kCCKeySizeDES,//  DES 密钥（kCCKeySizeDES=8）
                                          iv,//  选初始矢量
                                          self.bytes,// 数据存储单元
                                          self.length,// 数据
                                          buffer,// 用于返数据
                                          size,
                                          &numBytes
                                          );
    
    
    NSData *result = nil;
    
    if(cryptStatus == kCCSuccess)
    {
        result = [NSData dataWithBytes:buffer length:numBytes];
    }
    
    //释放指针
    free(buffer);
    
    return result;
}



@end
