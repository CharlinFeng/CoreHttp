//
//  APPHttpType.h
//  CoreHttp
//
//  Created by 成林 on 15/6/7.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#ifndef CoreHttp_APPHttpType_h
#define CoreHttp_APPHttpType_h

/** 指示器类型 */
typedef enum{
    
    //None
    APPHttpTypeNone = 0,
    
    //StatusView
    APPHttpTypeStatusView,
    
    //SVP
    APPHttpTypeSVP,
    
    //Btn
    APPHttpTypeBtn,
    
}APPHttpType;



/** 请求方式 */
typedef enum{
    
    //GET
    APPHttpMethodGET = 0,
    
    //POST
    APPHttpMethodPOST,
    
}APPHttpMethod;














#endif
