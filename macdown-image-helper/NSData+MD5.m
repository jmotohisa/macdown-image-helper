//
//  NSData+MD5.m
//  HelloWorld
//
//  Created by Junichi Motohisa on 2016/12/15.
//  Copyright © 2016年 Hokkaido University. All rights reserved.
//

// Create MD5 Hash from NSString, NSData or a File
// taken from http://iosdevelopertips.com/core-services/create-md5-hash-from-nsstring-nsdata-or-file.html

#import "NSData+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData(MD5)

- (NSString*)MD5
{
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(self.bytes, (CC_LONG) self.length, md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

@end