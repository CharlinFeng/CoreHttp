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

@interface ViewController ()

@property (nonatomic,strong) NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self beginAction:nil];
    
    self.view.backgroundColor = [UIColor redColor];
}


- (IBAction)beginAction:(id)sender {
<<<<<<< HEAD
    [APPHttp postUrl:@"http://www.baidu.com/" params:nil target:nil type:APPHttpTypeStatusView success:^(id obj) {
        NSLog(@"请求成功");
    } errorBlock:^(CoreHttpErrorType errorType) {
        NSLog(@"请求失败");
=======
    
    CoreSVPLoading(@"加载中", NO)
    
    [APPHttp postUrl:nil params:nil target:nil type:APPHttpTypeNone success:^(id obj) {
        
    } errorBlock:^(CoreHttpErrorType errorType, NSString *errorMsg) {
        NSLog(@"%@",errorMsg);
>>>>>>> origin/master
    }];
}


- (IBAction)endAction:(id)sender {

    
}






@end
