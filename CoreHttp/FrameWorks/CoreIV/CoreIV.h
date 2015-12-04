//
//  CoreIV.h
//  CoreIV
//
//  Created by 冯成林 on 15/11/28.
//  Copyright © 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    IVTypeLoad,
    
    IVTypeError
    
} IVType;

@interface CoreIV : UIView

/** 展示 */
+(void)showWithType:(IVType)type view:(UIView *)view msg:(NSString *)msg failClickBlock:(void(^)())failClickBlock;

/** 消失 */
+(void)dismissFromView:(UIView *)view animated:(BOOL)animated;




@end
