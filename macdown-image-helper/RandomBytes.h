//
//  RandomBytes.h
//  macdown-image-helper
//
//  Created by Junichi Motohisa on 2016/12/10.
//  Copyright © 2016年 Hokkaido University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomBytes : NSData

-(NSData *)getRandomBytes :(NSUInteger)length;

@end
