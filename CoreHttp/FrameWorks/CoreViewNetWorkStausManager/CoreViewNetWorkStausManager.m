//
//  CoreViewNetWorkStausManager.m
//  CoreViewNetWorkStausManager
//
//  Created by muxi on 15/3/12.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreViewNetWorkStausManager.h"
#import "CMView.h"

@implementation CoreViewNetWorkStausManager


+(void)show:(UIView *)view type:(CMType)type msg:(NSString *)msg subMsg:(NSString *)subMsg offsetY:(CGFloat)offsetY failClickBlock:(void(^)())failClickBlock{

    //先移除一次
    [self dismiss:view animated:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //创建CMView
        CMView *myCmView=[CMView cmViewWithType:type msg:msg subMsg:subMsg offsetY:offsetY failClickBlock:failClickBlock];
        
        myCmView.backgroundColor = [UIColor whiteColor];
        
        [view addSubview:myCmView];
        
//        myCmView.alpha=0;
//        [UIView animateWithDuration:.25f animations:^{
//            myCmView.alpha=1.0f;
//        }];
    });
    
}



+(void)dismiss:(UIView *)view animated:(BOOL)animated;{
    
    NSArray *subViews=view.subviews;
    
    if(subViews==nil || subViews.count==0) return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //遍历
        for (UIView *subView in subViews) {
            
            if(![subView isKindOfClass:[CMView class]]) continue;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(animated){
                    
                    [UIView animateWithDuration:.5f animations:^{
                        
                        subView.alpha = 0;
                        
                    } completion:^(BOOL finished) {
                        
                        [subView removeFromSuperview];
                        
                    }];
                    
                }else{
                    [subView removeFromSuperview];
                }
            });
        }
    });
}


@end
