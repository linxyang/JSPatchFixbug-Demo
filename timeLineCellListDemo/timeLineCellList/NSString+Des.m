//
//  NSString+Extension.m
//  timeLineCellList
//
//  Created by fuchun on 16/10/12.
//  Copyright © 2016年 yanglinxia. All rights reserved.
//

#import "NSString+Des.h"

@implementation NSString (Des)
- (NSString *)stringOfHexString
{
    return [[NSString alloc] initWithData:[self dataUsingHexEncoding] encoding:NSASCIIStringEncoding];
}

- (NSData *)dataUsingHexEncoding
{
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i = 0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    return [stringData copy];
}


@end
