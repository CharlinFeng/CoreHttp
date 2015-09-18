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
    
    NSString *url = @"http://211.149.151.92/mytest/Test/test2";
    
    [APPHttp postUrl:url params:nil target:self.view type:APPHttpTypeStatusView success:^(id obj) {
        
        NSLog(@"请求成功:%@",obj);
        
    } errorBlock:nil];

}


- (IBAction)endAction:(id)sender {

    
}






@end
