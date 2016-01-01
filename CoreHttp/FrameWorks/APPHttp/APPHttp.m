//
//  APPHttp.m
//  4s
//
//  Created by muxi on 15/3/10.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "APPHttp.h"
#import "CoreIV.h"
#import "CoreSVP.h"









@implementation APPHttp


/** 请求开始，展示指示器 */
+(void)requestBeginWithUrl:(NSString *)urlString params:(id)params target:(id)target type:(APPHttpType)type success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock{

    if(APPHttpTypeStatusView == type){ //显示指示视图
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [CoreIV showWithType:IVTypeLoad view:target msg:@"努力加载中" failClickBlock:^{
                
                [self getUrl:urlString params:params target:target type:type success:successBlock errorBlock:errorBlock];
            }];
        });
    }else if (APPHttpTypeBtn == type){ //状态按钮
        
        CoreStatusBtn *statusBtn = (CoreStatusBtn *)target;
        
        statusBtn.status = CoreStatusBtnStatusProgress;
        
    }else if (APPHttpTypeSVP == type){ //SVP
        
        [CoreSVP showSVPWithType:CoreSVPTypeLoadingInterface Msg:@"加载中" duration:0 allowEdit:NO beginBlock:nil completeBlock:nil];
    }

    
}





/**
 *  GET:
 *  params中可指明参数类型
 *  target:
 *   APPHttpTypeStatusView  ：view
 *   APPHttpTypeSVP         ：nil
 *   APPHttpTypeBtn         ：btn
 */
+(void)getUrl:(NSString *)urlString params:(id)params target:(id)target type:(APPHttpType)type success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock{
    
    //请求开始指示器
    [self requestBeginWithUrl:urlString params:params target:target type:type success:successBlock errorBlock:errorBlock];
    
    [CoreHttp getUrl:urlString params:params success:^(id obj) {
        
        [self success:obj url:urlString params:params target:target type:type method:APPHttpMethodGET successBlock:successBlock errorBlock:errorBlock];
        
    } errorBlock:^(CoreHttpErrorType errorType) {

        [self error:errorType errorMsg:nil method:APPHttpMethodGET url:urlString params:params target:target type:type success:successBlock errorBlock:errorBlock];
        
    }];
}


/**
 *  POST:
 *   APPHttpTypeStatusView  ：view
 *   APPHttpTypeSVP         ：nil
 *   APPHttpTypeBtn         ：btn
 */
+(void)postUrl:(NSString *)urlString params:(id)params target:(id)target type:(APPHttpType)type success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock{
    
    //请求开始指示器
    [self requestBeginWithUrl:urlString params:params target:target type:type success:successBlock errorBlock:errorBlock];
    
    [CoreHttp postUrl:urlString params:params success:^(id obj) {
    
        [self success:obj url:urlString params:params target:target type:type method:APPHttpMethodPOST successBlock:successBlock errorBlock:errorBlock];
        
    } errorBlock:^(CoreHttpErrorType errorType) {
        
        [self error:errorType errorMsg:nil method:APPHttpMethodPOST url:urlString params:params target:target type:type success:successBlock errorBlock:errorBlock];
    }];
}


/**
 *  UPLOAD:
 *   APPHttpTypeStatusView  ：view
 *   APPHttpTypeSVP         ：nil
 *   APPHttpTypeBtn         ：btn
 */
+(void)uploadUrl:(NSString *)uploadUrl params:(id)params files:(NSArray *)files target:(id)target type:(APPHttpType)type success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock{

    //请求开始指示器
    [self requestBeginWithUrl:uploadUrl params:params target:target type:type success:successBlock errorBlock:errorBlock];
    
    [CoreHttp uploadUrl:uploadUrl params:params files:files success:^(id obj) {
        
        [self success:obj url:uploadUrl params:params target:target type:type method:APPHttpMethodPOST successBlock:successBlock errorBlock:errorBlock];
        
    } errorBlock:^(CoreHttpErrorType errorType) {
        
        [self error:errorType errorMsg:nil method:APPHttpMethodPOST url:uploadUrl params:params target:target type:type success:successBlock errorBlock:errorBlock];
        
    }];

}





/**
 *  错误处理
 */
+(void)error:(CoreHttpErrorType)errorType errorMsg:(NSString *)errorMsg method:(APPHttpMethod)method url:(NSString *)urlString params:(NSDictionary *)params target:(id)target type:(APPHttpType)type success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock{
    
    if(errorMsg == nil || errorMsg.length ==0) errorMsg = @"请求失败";
    
    if(APPHttpTypeStatusView == type){ // 视图指示器
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(APPHttpMethodGET == method){ //GET
                [CoreIV showWithType:IVTypeError view:target msg:errorMsg failClickBlock:^{
                    
                    [self getUrl:urlString params:params target:target type:type success:successBlock errorBlock:errorBlock];
                }];
                
            }else{ //POST
                
                [CoreIV showWithType:IVTypeError view:target msg:errorMsg failClickBlock:^{
                    [self postUrl:urlString params:params target:target type:type success:successBlock errorBlock:errorBlock];
                }];
                
            }

        });
    }else if (APPHttpTypeBtn == type){ //状态按钮
        
        CoreStatusBtn *btn = (CoreStatusBtn *)target;
        
        //设置状态
        btn.status = CoreSVPTypeError;
        
    }else if (APPHttpTypeSVP == type){
        
        [CoreSVP showSVPWithType:CoreSVPTypeError Msg:errorMsg duration:2.0f allowEdit:NO beginBlock:nil completeBlock:nil];
    }
  
    //执行回调
    if(errorBlock != nil) errorBlock(errorType);
    
}


/**
 *  数据处理
 */
+(void)success:(id)obj url:(NSString *)urlString params:(id)params target:(id)target type:(APPHttpType)type method:(APPHttpMethod)method successBlock:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock{
    
    if(![obj isKindOfClass:[NSDictionary class]]){
        NSLog(@"数据异常，服务器返回的数据不是字典！");return;
    }
    
    //项目数据处理
    //1.取出状态码
    NSString *status=obj[@"status"];
    
    if(!(status.integerValue == 200)){
        
        //服务器抛出错误
        //取出错误信息
        NSString *errorMsg=@"服务器抛出错误";
        id msgObj=obj[@"msg"];
        if([msgObj isKindOfClass:[NSString class]]) errorMsg=msgObj;
        [self error:CoreHttpErrorTypeServiceRetrunErrorStatus errorMsg:errorMsg method:method url:urlString params:params target:target type:type success:successBlock errorBlock:errorBlock];
        return;
    }else{
        
        //剥离数据
        NSDictionary *dataDict=obj[@"res"];
        //1.取出状态码
        NSString *dataStatus=dataDict[@"res_status"];
        
        if(!(dataStatus.integerValue == 200)){
            
            //服务器抛出错误
            //取出错误信息
            NSString *errorMsg=@"服务器抛出错误";
            id msgObj=dataDict[@"res_msg"];
            if([msgObj isKindOfClass:[NSString class]]) errorMsg=msgObj;
            
            [self error:CoreHttpErrorTypeServiceRetrunErrorStatus errorMsg:errorMsg method:method url:urlString params:params target:target type:type success:successBlock errorBlock:errorBlock];
            return;
        }else{
            
            //这里才是真正成功的地方
            //状态指示
            if(APPHttpTypeStatusView == type){ //视图指示器
                
                //隐藏
                [CoreIV dismissFromView:target animated:YES];
                
            }else if (APPHttpTypeBtn == type){ //状态按钮
                
                CoreStatusBtn *btn = (CoreStatusBtn *)target;
                
                btn.status = CoreStatusBtnStatusSuccess;
                
            }else if (APPHttpTypeSVP == type){ //SVP
                
                [CoreSVP dismiss];
            }
            
            //剥离数据
            id appObj=dataDict[@"res_data"];
            
            successBlock(appObj);
            
        }
        
    }
}

@end
