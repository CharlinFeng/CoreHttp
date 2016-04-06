////
////  CoreSVP+Swift.swift
////  CoreSVP
////
////  Created by 冯成林 on 15/9/18.
////  Copyright (c) 2015年 muxi. All rights reserved.
////
//
//import Foundation
//
//
///** 成功 */
//func CoreSVPSuccess(msg: String,completeClosure:(()->())!){
//    
//    CoreSVP.showSVPWithType(CoreSVPTypeSuccess, msg: msg, duration: 1.6, allowEdit: false, beginBlock: nil) { () -> Void in
//        completeClosure?()
//    }
//}
//
///** 失败 */
//func CoreSVPError(msg: String,completeClosure:(()->())!){
//    
//    CoreSVP.showSVPWithType(CoreSVPTypeError, msg: msg, duration: 2, allowEdit: false, beginBlock: nil) { () -> Void in
//        completeClosure?()
//    }
//}
//
///** 注意 */
//func CoreSVPWarning(msg: String,completeClosure:(()->())!){
//    
//    CoreSVP.showSVPWithType(CoreSVPTypeInfo, msg: msg, duration: 2, allowEdit: false, beginBlock: nil) { () -> Void in
//        completeClosure?()
//    }
//}
//
//
///** 底部消息 */
//func CoreSVPBottomMsg(msg: String,completeClosure:(()->())!){
//    
//    CoreSVP.showSVPWithType(CoreSVPTypeBottomMsg, msg: msg, duration: 1.6, allowEdit: false, beginBlock: nil) { () -> Void in
//        completeClosure?()
//    }
//}
//
///** 进度 */
//func CoreSVPLoading(msg: String, url: String){
//    
//    CoreSVP.showSVPLoadingWithMsg(msg, url: url)
//}
//
//
//
///**  消失  */
//func CoreSVPDismiss(){ CoreSVP.dismiss() }
//func CoreSVPDismissDelay(delay: NSTimeInterval){CoreSVP.dismiss(delay)}
