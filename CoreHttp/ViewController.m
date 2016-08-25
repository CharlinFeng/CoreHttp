//
//  ViewController.m
//  CoreHttp
//
//  Created by muxi on 15/3/2.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "ViewController.h"
#import "APPHttp.h"
#import "CoreSVP.h"

@interface ViewController ()<NSURLSessionTaskDelegate>

@property (nonatomic,strong) NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self beginAction:nil];
    
    self.view.backgroundColor = [UIColor redColor];
}


- (IBAction)beginAction:(id)sender {

    UIImage *img = [UIImage imageNamed:@"cut"];
    
    NSData *data = UIImageJPEGRepresentation(img, 1) ;
    
    NSDictionary *params = @{@"token":@"8888",@"attach_id":@"1"};
    
    NSMutableArray *arr = [NSMutableArray array];
//    4226524

    for (NSUInteger i = 0; i< 1; i++) {
        
        UploadFile *file = [UploadFile fileWithKey:@"icon" data:data name:[NSString stringWithFormat:@"%i.jpg",i]];
        
        [arr addObject:file];
    }
    
    NSString *url = @"http://112.74.125.78/yeah/index.php/Home/User/delete_attach";
    
    [APPHttp uploadUrl:url params:params files:arr target:self.view type:APPHttpTypeStatusView progressBlock:^(CGFloat p) {
        NSLog(@"上传中%f",p);
    } success:^(id obj) {
        NSLog(@"成功");
    } errorBlock:^(CoreHttpErrorType errorType, NSString *errorMsg) {
        NSLog(@"失败");
    }];

}


- (IBAction)endAction:(id)sender {

    
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
    CGFloat p = totalBytesSent/(CGFloat)totalBytesExpectedToSend;

    NSLog(@"didSendBodyData:%f,%@,%@",p,@(totalBytesSent),@(totalBytesExpectedToSend));
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{

    NSLog(@"上传完成:%@",error);
}


@end
