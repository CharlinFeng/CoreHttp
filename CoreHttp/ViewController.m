//
//  ViewController.m
//  CoreHttp
//
//  Created by muxi on 15/3/2.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "ViewController.h"
#import "CoreHttp.h"
#import "NSString+CoreHttp.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str= @"fdfsfffds\r fdsfsa \n     {}fdaf fewaf";
    
    NSLog(@"%@，%@",str,str.deleteSpecialCode);
    
}






- (IBAction)request:(id)sender {
    
    NSString *url=@"http://localhost/test.php";
    
    NSDictionary *params = @{@"arr":@[@(1),@(2),@(3)]};
    [CoreHttp postUrl:url params:params success:^(id obj) {
        
        NSLog(@"正确");
        
    } errorBlock:^(CoreHttpErrorType errorType) {
        
        NSLog(@"出错");
    }];

}

- (IBAction)upload:(id)sender {

    UIImage *img=[UIImage imageNamed:@"charlin.jpg"];
    
    //转data
    NSData *data=UIImageJPEGRepresentation(img, .8f);

    
}





@end
