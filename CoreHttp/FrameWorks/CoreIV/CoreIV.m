//
//  CoreIV.m
//  CoreIV
//
//  Created by 冯成林 on 15/11/28.
//  Copyright © 2015年 冯成林. All rights reserved.
//

#import "CoreIV.h"
#import "DGActivityIndicatorView.h"


@implementation UIView (layout)

-(void)autoLayoutFillSuperView {
    
    if(self.superview == nil) {return;}
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{@"v":self};
    
    NSArray *v_ver = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[v]-0-|" options:0 metrics:nil views:views];
    NSArray *v_hor = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[v]-0-|" options:0 metrics:nil views:views];
    [self.superview addConstraints:v_ver];[self.superview addConstraints:v_hor];
}

@end



@interface CoreIV ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (nonatomic,assign) IVType type;

@property (nonatomic,weak) DGActivityIndicatorView *di;

@property (nonatomic,copy) void (^FailBlock)();

@end




@implementation CoreIV



/** 展示 */
+(void)showWithType:(IVType)type view:(UIView *)view msg:(NSString *)msg failClickBlock:(void(^)())failClickBlock{
    
    [CoreIV dismissFromView:view animated:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        //创建view
        CoreIV *iv = [CoreIV iv];
        
        //设置
        iv.type = type;
        iv.msgLabel.text = msg;
        iv.FailBlock = failClickBlock;
        
        [view addSubview:iv];
        
        [iv autoLayoutFillSuperView];
    });
}

/** 消失 */
+(void)dismissFromView:(UIView *)view animated:(BOOL)animated{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *subView in view.subviews) {
            
            if(![subView isKindOfClass:[CoreIV class]]) continue;
            
            if(animated){
                [UIView animateWithDuration:0.3 animations:^{
                    subView.alpha=0;
                } completion:^(BOOL finished) {
                    [(CoreIV *)subView dismiss];return;
                }];
            }else{
                [(CoreIV *)subView dismiss];break;
            }
            
        }
    });
}


/** 内部处理 */
+(instancetype)iv{
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

-(void)setType:(IVType)type {
    
    UIColor *tintColor = [UIColor grayColor];
    CGFloat size = 50;
    
    DGActivityIndicatorView *di = nil;
    if(type == IVTypeLoad) {
        
        di = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallTrianglePath tintColor:tintColor size:size];
        
    }else {
        
        di = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeCookieTerminator tintColor:tintColor size:size];
    }
    
    //记录
    self.di = di;
    
    [self.contentView addSubview:di];
    
    di.bounds = CGRectMake(0, 0, 100, 100);
    [di autoLayoutFillSuperView];
    
    
    //执行动画
    [di startAnimating];
}

-(void)dismiss {
    
    [self.di stopAnimating];
    [self.di removeFromSuperview];
    [self removeFromSuperview];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if(self.FailBlock != nil) self.FailBlock();
}

@end




