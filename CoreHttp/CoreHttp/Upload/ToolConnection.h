//
//  ToolConnection.h
//
//  Created by muxi on 14/10/22.
//  Copyright (c) 2014年 muxi. All rights reserved.
//  全新的网络请求工具类：2.0版本（更新于2015.01.28）

#import <Foundation/Foundation.h>
#import "UploadFile.h"

typedef enum{
    
    ToolErrorTypeNull=0,                                                                            //请求正常，无错误
    
    ToolErrorTypeURLConnectionError,                                                                //请求时出错，可能是URL不正确
    
    ToolErrorTypeStatusCodeError,                                                                   //请求时出错，服务器未返回正常的状态码：200
    
    ToolErrorTypeDataNilError,                                                                      //请求回的Data在解析前就是nil，导致请求无效，无法后续JSON反序列化。
    
    ToolErrorTypeDataSerializationError,                                                            //data在JSON反序列化时出错
    
    ToolErrorTypeNoNetWork,                                                                         //无网络连接
    
    
    /**
     *  以下是文件上传中的错误类型
     */
    ToolErrorTypeUploadDataNil,                                                                     //什么都没有上传
    
    
}ToolErrorType;                                                                                     //错误类型定义





typedef void(^SuccessBlock)(id obj);

typedef void(^ErrorBlock)(ToolErrorType errorType);



@interface ToolConnection : NSObject


/**
 *  GET:
 *  params中可指明参数类型
 */
+(void)getUrl:(NSString *)urlString params:(NSDictionary *)params success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock;


/**
 *  POST:
 */
+(void)postUrl:(NSString *)urlString params:(NSDictionary *)params success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock;



/**
 *  文件上传
 *  @params: 普通参数
 *  @files : 文件数据，里面装的都是UploadFile对象
 */
+(void)uploadUrl:(NSString *)uploadUrl params:(NSDictionary *)params files:(NSArray *)files success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock;



@end
