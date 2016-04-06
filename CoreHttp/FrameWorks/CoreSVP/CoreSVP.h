//
//  CoreSVP.h
//
//  Created by muxi on 14/10/22.
//  Copyright (c) 2014年 muxi. All rights reserved.
//  提示工具类



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

#define isNightMode NO

#define CoreSVPSuccess(msg, CompleteBlock) [CoreSVP showSVPWithType:CoreSVPTypeSuccess Msg:msg duration:1.5 allowEdit:NO beginBlock:nil completeBlock:CompleteBlock];
#define CoreSVPError(msg, CompleteBlock) [CoreSVP showSVPWithType:CoreSVPTypeError Msg:msg duration:2.0 allowEdit:NO beginBlock:nil completeBlock:CompleteBlock];
#define CoreSVPWarning(msg, CompleteBlock) [CoreSVP showSVPWithType:CoreSVPTypeInfo Msg:msg duration:2.0 allowEdit:NO beginBlock:nil completeBlock:CompleteBlock];
#define CoreSVPLoading(msg, URL) [CoreSVP showSVPLoadingWithMsg:msg url:URL];
#define CoreSVPBottomMsg(msg, CompleteBlock) [CoreSVP showSVPWithType:CoreSVPTypeBottomMsg Msg:msg duration:2 allowEdit:NO beginBlock:nil completeBlock:CompleteBlock];
#define CoreSVPDismiss [CoreSVP dismiss];
#define CoreSVPDismissDelay(delay) [CoreSVP dismiss:delay];


typedef enum {
    
    /** 默认无状态 */
    CoreSVPTypeNone = 0,
    
    /** 无图片普通提示，显示在屏幕正中间 */
    CoreSVPTypeCenterMsg,
    
    /** 无图片普通提示，显示在屏幕下方，tabbar之上 */
    CoreSVPTypeBottomMsg,
    
    /** Info */
    CoreSVPTypeInfo,
    
    /** Progress */
    CoreSVPTypeLoadingInterface,
    
    /** error */
    CoreSVPTypeError,
    
    /** success */
    CoreSVPTypeSuccess

}CoreSVPType;





@interface CoreSVP : NSObject




/**
*  展示提示框
*
*  @param type          类型
*  @param msg           文字
*  @param duration      时间（当type=CoreSVPTypeLoadingInterface时无效）
*  @param allowEdit     否允许编辑
*  @param beginBlock    提示开始时的回调
*  @param completeBlock 提示结束时的回调
*/
+(void)showSVPWithType:(CoreSVPType)type Msg:(NSString *)msg duration:(CGFloat)duration allowEdit:(BOOL)allowEdit beginBlock:(void(^)())beginBlock completeBlock:(void(^)())completeBlock;




/*
 *  进度
 */
+(void)showProgess:(CGFloat)progress Msg:(NSString *)msg maskType:(SVProgressHUDMaskType)maskType;


/*
 *  加载中
 */
+(void)showSVPLoadingWithMsg:(NSString *)msg url:(NSString *)url;



/**
 *  隐藏提示框
 */
+(void)dismiss;
+(void)dismiss:(NSTimeInterval)delay;


@end







