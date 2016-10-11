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


@interface APPHttp ()<NSURLSessionTaskDelegate>

@property (nonatomic,strong) NSMutableDictionary *taskDict;

@property (nonatomic,assign) BOOL isCancel;

@property (nonatomic,copy) void (^ProgressBlock)(CGFloat p);

@property (nonatomic,assign) APPHttpType type;

@end


@implementation APPHttp
HMSingletonM(APPHttp)

+(void)initialize {
    
    APPHttp *ah = [APPHttp sharedAPPHttp];

    [[NSNotificationCenter defaultCenter] addObserver:ah selector:@selector(svpNoti:) name:SVProgressHUDURLNoti object:nil];
    [self sharedAPPHttp];
}


-(void)svpNoti:(NSNotification *)noti{
    
    NSString *url = noti.userInfo[SVProgressHUDURLNoti];
    
    if (url == nil){return;}
    
    //取出task
    NSURLSessionDataTask *task = self.taskDict[url];
    
    self.isCancel = YES;
    
    [task cancel];
}



/** 请求开始，展示指示器 */
+(void)requestBeginWithUrl:(NSString *)urlString params:(id)params target:(id)target type:(APPHttpType)type success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock{

    //重置
    APPHttp *ah = [self sharedAPPHttp];
    ah.isCancel = NO;
    
    if(APPHttpTypeStatusView == type){ //显示指示视图
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [CoreIV showWithType:IVTypeLoad view:target msg:nil failClickBlock:^{
                
                [self getUrl:urlString params:params target:target type:type success:successBlock errorBlock:errorBlock];
            }];
        });
    }else if (APPHttpTypeBtn == type){ //状态按钮
        
        CoreStatusBtn *statusBtn = (CoreStatusBtn *)target;
        
        statusBtn.status = CoreStatusBtnStatusProgress;
        
    }else if (APPHttpTypeSVP == type){ //SVP
        
        CoreSVPLoading(@"正在加载", urlString)
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
    
    NSURLSessionDataTask *dataTask = [CoreHttp getUrl:urlString params:params success:^(id obj) {
        
        [self success:obj url:urlString params:params target:target type:type method:APPHttpMethodGET successBlock:successBlock errorBlock:errorBlock];
        
        //移除task
        [[APPHttp sharedAPPHttp].taskDict removeObjectForKey:urlString];
        
    } errorBlock:^(CoreHttpErrorType errorType, NSString *errorMsg) {

        [self error:errorType errorMsg:errorMsg method:APPHttpMethodGET url:urlString params:params target:target type:type success:successBlock errorBlock:errorBlock];
        
        //移除task
        [[APPHttp sharedAPPHttp].taskDict removeObjectForKey:urlString];
        
    }];
    
    //记录
    [APPHttp sharedAPPHttp].taskDict[urlString] = dataTask;
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
    
    NSURLSessionDataTask *dataTask = [CoreHttp postUrl:urlString params:params success:^(id obj) {
    
        [self success:obj url:urlString params:params target:target type:type method:APPHttpMethodPOST successBlock:successBlock errorBlock:errorBlock];
        
        //移除task
        [[APPHttp sharedAPPHttp].taskDict removeObjectForKey:urlString];
        
    } errorBlock:^(CoreHttpErrorType errorType, NSString *errorMsg) {
        
        [self error:errorType errorMsg:errorMsg method:APPHttpMethodPOST url:urlString params:params target:target type:type success:successBlock errorBlock:errorBlock];
        
        //移除task
        [[APPHttp sharedAPPHttp].taskDict removeObjectForKey:urlString];
        
    }];
    
    //记录
    [APPHttp sharedAPPHttp].taskDict[urlString] = dataTask;
}


/**
 *  UPLOAD:
 *   APPHttpTypeStatusView  ：view
 *   APPHttpTypeSVP         ：nil
 *   APPHttpTypeBtn         ：btn
 */
+(void)uploadUrl:(NSString *)uploadUrl params:(id)params files:(NSArray *)files target:(id)target type:(APPHttpType)type progressBlock:(void(^)(CGFloat p))progressBlock success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock{
    
    //实例
    APPHttp *ap = [APPHttp sharedAPPHttp];
    
    //记录
    ap.ProgressBlock = progressBlock;
    ap.type = type;

    //请求开始指示器
    [self requestBeginWithUrl:uploadUrl params:params target:target type:type success:successBlock errorBlock:errorBlock];
    
    [CoreHttp uploadUrl:uploadUrl params:params files:files success:^(id obj) {
        
        //清空
        ap.ProgressBlock = nil;
        
        [self success:obj url:uploadUrl params:params target:target type:type method:APPHttpMethodPOST successBlock:successBlock errorBlock:errorBlock];
        
    } errorBlock:^(CoreHttpErrorType errorType, NSString *errorMsg) {
        
        //清空
        ap.ProgressBlock = nil;
        [self error:errorType errorMsg:errorMsg method:APPHttpMethodPOST url:uploadUrl params:params target:target type:type success:successBlock errorBlock:errorBlock];
        
    } delegate:ap];

}





/**
 *  错误处理
 */
+(void)error:(CoreHttpErrorType)errorType errorMsg:(NSString *)errorMsg method:(APPHttpMethod)method url:(NSString *)urlString params:(NSDictionary *)params target:(id)target type:(APPHttpType)type success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock{
    
    //执行回调
    if(errorBlock != nil) errorBlock(errorType,errorMsg);
    
    APPHttp *ah = [APPHttp sharedAPPHttp];
    
    if (ah.isCancel) {ah.isCancel = NO;return;}
    
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
        
        CoreSVPError(errorMsg, nil)
        
    }else if (APPHttpTypeSVP == type){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CoreSVP showSVPWithType:CoreSVPTypeError Msg:errorMsg duration:2.0f allowEdit:NO beginBlock:nil completeBlock:nil];
        });
    }
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
        
        if(status.integerValue == 900){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:AppHttpTokenDeprecatedNoti object:nil userInfo:nil];
            });
            
            NSLog(@"错误：Token过期");
            
            errorMsg = @"请重新登陆";
        }
        
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
















/** 取出task */
+(NSURLSessionDataTask *)taskWithUrl:(NSString *)url{

    return [APPHttp sharedAPPHttp].taskDict[url];
}








/** lazy */
-(NSMutableDictionary *)taskDict{

    if(_taskDict == nil){
    
        _taskDict = [NSMutableDictionary dictionary];
    }

    return _taskDict;
}



-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
    CGFloat p = totalBytesSent/(CGFloat)totalBytesExpectedToSend;
    
    if(self.ProgressBlock != nil) self.ProgressBlock(p);
    
    if (self.type == APPHttpTypeSVP){
        
        [CoreSVP showProgess:p Msg:@"上传中" maskType:SVProgressHUDMaskTypeClear];
    }
}



@end
