//
//  NSData+MD5.h
//  HelloWorld
//
//  Created by Junichi Motohisa on 2016/12/15.
//  Copyright © 2016年 Hokkaido University. All rights reserved.
//

// Create MD5 Hash from NSString, NSData or a File
// taken from http://iosdevelopertips.com/core-services/create-md5-hash-from-nsstring-nsdata-or-file.html

#import <Foundation/Foundation.h>

@interface NSData(MD5)

- (NSString *)MD5;

@end
