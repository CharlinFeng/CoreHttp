//
//  NSString+CoreHttp.m
//  CoreHttp
//
//  Created by muxi on 15/3/2.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSString+CoreHttp.h"

@implementation NSString (CoreHttp)




/** 处理json格式的字符串中的换行符、回车符 */
-(NSString *)deleteSpecialCode {
    
    NSArray *deleteStrArray = @[@"\r",@"\n",@"\t",@"{",@"}",@" "];
    
    __block NSString *str = self;
    
    [deleteStrArray enumerateObjectsUsingBlock:^(NSString *deleteStr, NSUInteger idx, BOOL *stop) {
        
        str = [str stringByReplacingOccurrencesOfString:deleteStr withString:@""];
    }];

    return str;
}

@end
