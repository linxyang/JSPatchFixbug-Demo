//
//  NSData+Des.h
//  timeLineCellList
//
//  Created by fuchun on 16/10/12.
//  Copyright © 2016年 yanglinxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (Des)

/** des加密 */
- (NSData *)encryptWithKey:(NSString *)key iv:(NSString *)iv;
/** des解密 */
- (NSData *)decryptWithKey:(NSString *)key iv:(NSString *)iv;

@end
