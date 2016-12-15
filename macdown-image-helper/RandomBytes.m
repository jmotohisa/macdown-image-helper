//
//  RandomBytes.m
//  macdown-image-helper
//
//  Created by Junichi Motohisa on 2016/12/10.
//  Copyright © 2016年 Hokkaido University. All rights reserved.
//

#import "RandomBytes.h"

@implementation RandomBytes

-(NSData *)getRandomBytes:(NSUInteger)length {
    return [[NSFileHandle fileHandleForReadingAtPath:@"/dev/random"] readDataOfLength:length];
}

@end
