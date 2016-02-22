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

@property (nonatomic,strong) NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self beginAction:nil];
}


- (IBAction)beginAction:(id)sender {
    [APPHttp postUrl:@"http://www.baidu.com/" params:nil target:nil type:APPHttpTypeStatusView success:^(id obj) {
        NSLog(@"请求成功");
    } errorBlock:^(CoreHttpErrorType errorType) {
        NSLog(@"请求失败");
    }];
}


- (IBAction)endAction:(id)sender {

    
}






@end
