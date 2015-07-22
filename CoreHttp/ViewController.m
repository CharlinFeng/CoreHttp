//
//  ViewController.m
//  CoreHttp
//
//  Created by muxi on 15/3/2.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "ViewController.h"
#import "APPHttp.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self requestBegin];
    });
}






- (void)requestBegin{
    
    NSString *url = @"http://211.149.151.92/lailai/MyApi/slide";

    NSDictionary *params = nil;
    
    [APPHttp getUrl:url params:params target:nil type:APPHttpTypeSVP success:^(id obj) {
        
        NSLog(@"请求成功");
        
    } errorBlock:^(CoreHttpErrorType errorType) {
        
        NSLog(@"请求失败");
        
    }];

}







@end
