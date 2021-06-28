//
//  LogingViewController.m
//  MADContest
//
//  Created by JingFeng Ma on 2020/3/10.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import "LogingViewController.h"
#import <POP.h>
#import "StartupViewController.h"
#import "Utils.h"
#import "HTTPModelUseCompletionBlok.h"
#import "RoleViewController.h"
#import "AFNetworkConfig.h"

@interface LogingViewController () <CAAnimationDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *appLogoLabelYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginButtonWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginButtonHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *startButtonHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *startButtonWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *startButtonYConstraint;
@property (strong, nonatomic) UIView *loginLoadingAnimView;
//@property (strong, nonatomic) StartupViewController *startUpVC;
@property (strong, nonatomic) RoleViewController *startUpVC;

@end

@implementation LogingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.startUpVC = [GET_STORYBOARD(@"Main") instantiateViewControllerWithIdentifier:@"startUpViewControllerSID"];
    self.startUpVC = [GET_STORYBOARD(@"Main") instantiateViewControllerWithIdentifier:@"3DStartUpViewControllerSID"];
    
    self.loginLoadingAnimView = nil;
    self.usernameTextField.layer.cornerRadius = 4.0f;
    self.passwordTextField.layer.cornerRadius = 4.0f;
    self.startButton.layer.cornerRadius = 10.0f;
    self.loginButton.layer.cornerRadius = 4.0f;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewDidAppear:(BOOL)animated{
//    [UIView animateWithDuration:1.0f delay:0.3f usingSpringWithDamping:0.5f initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
//        [self.view layoutIfNeeded];
//    } completion:^(BOOL finished) {
//
//    }];
}

- (IBAction)startClicked:(id)sender {
    [sender setUserInteractionEnabled:NO];
    
    //get背景颜色
    CABasicAnimation *changeColor1 = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    changeColor1.delegate = self;
    changeColor1.fromValue = (__bridge id)self.startButton.backgroundColor.CGColor;
    changeColor1.toValue = (__bridge id)[UIColor systemTealColor].CGColor;
    changeColor1.duration = 1.0f;
    changeColor1.beginTime = CACurrentMediaTime();
    
    changeColor1.fillMode = kCAFillModeForwards;
    changeColor1.removedOnCompletion = false;
    changeColor1.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [self.startButton.layer addAnimation:changeColor1 forKey:changeColor1.keyPath];
    
    
    self.startButtonWidthConstraint.constant = self.loginWidgetContainer.bounds.size.width;
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.startButton layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    self.startButtonHeightConstraint.constant = self.loginWidgetContainer.bounds.size.height * 0.7;
    [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.startButton layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    self.startButtonYConstraint.constant -= self.loginWidgetContainer.bounds.size.height * 0.2f;
    [UIView animateWithDuration:1.4f delay:0.35f usingSpringWithDamping:0.4f initialSpringVelocity:5.5f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.loginWidgetContainer layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
    
    //get按钮变宽
    /*CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    anim1.delegate = self;
    anim1.fromValue = @(CGRectGetWidth(self.startButton.bounds));
    anim1.toValue = @(self.loginWidgetContainer.bounds.size.width);
    anim1.duration = 0.3;
    anim1.beginTime = CACurrentMediaTime();
    anim1.fillMode = kCAFillModeForwards;
    anim1.removedOnCompletion = false;
    anim1.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [self.startButton.layer addAnimation:anim1 forKey:anim1.keyPath];
    //get按钮变高
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
    anim2.delegate = self;
    anim2.fromValue = @(CGRectGetHeight(self.startButton.bounds));
    anim2.toValue = @(self.loginWidgetContainer.bounds.size.height * 0.7);
    anim2.duration = 0.3;
    anim2.beginTime = CACurrentMediaTime() + 0.1;
    anim2.fillMode = kCAFillModeForwards;
    anim2.removedOnCompletion = false;
    anim2.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [self.startButton.layer addAnimation:anim2 forKey:anim2.keyPath];
    
    //start按钮上移
    //start shake
    POPSpringAnimation *anim3 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim3.fromValue = [NSValue valueWithCGPoint:self.startButton.layer.position];;
    anim3.toValue = [NSValue valueWithCGPoint:CGPointMake(self.startButton.layer.position.x, self.startButton.layer.position.y * 0.6)];
    anim3.beginTime = CACurrentMediaTime() + 0.2;
    anim3.springBounciness = 16;
    anim3.springSpeed = 12;
    anim3.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        self.startButton.userInteractionEnabled = NO;
    };
    [self.startButton pop_addAnimation:anim3 forKey:nil];
    */
    
    //login button scale up animation
    self.loginButtonWidthConstraint.constant *= 40.0f;
    self.loginButtonHeightConstraint.constant *= 40.0f;
    self.loginButton.hidden = NO;
    [UIView animateWithDuration:0.8f delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.loginButton.alpha = 1.0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    }];
    
    //Tailwind spring animation
    self.appLogoLabelYConstraint.constant = 32.0f;
    [UIView animateWithDuration:1.2f delay:0.55f usingSpringWithDamping:0.4f initialSpringVelocity:5.5f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
    
//    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    CGPoint point = self.startButton.layer.position;
//    keyFrame.values = @[
//        [NSValue valueWithCGPoint:CGPointMake(point.x, point.y - 4)],
//        [NSValue valueWithCGPoint:CGPointMake(point.x, point.y + 4)],
//        [NSValue valueWithCGPoint:CGPointMake(point.x, point.y )]
//    ];
//    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    keyFrame.duration = 0.45f;
//    keyFrame.beginTime = CACurrentMediaTime() + 0.4;
//    [self.startButton.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
    
    //出现输入框
    self.usernameTextField.alpha = 0.0;
    self.passwordTextField.alpha = 0.0;
    self.usernameTextField.hidden = NO;
    self.passwordTextField.hidden = NO;
    [UIView animateWithDuration:0.8 delay:1.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.usernameTextField.alpha = 1.0;
        self.passwordTextField.alpha = 1.0;
    } completion:^(BOOL finished) {
         
    }];
}

- (void)animationDidStart:(CAAnimation *)theAnimation
{
    if([[self.startButton.layer animationForKey:@"backgroundColor"] isEqual:theAnimation]){
        [self.startButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.startButton setTitle:@"" forState:UIControlStateNormal];
    }
}
 
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
//    if([[self.startButton.layer animationForKey:@"popanimation"] isEqual:theAnimation]){
//        self.startButton.userInteractionEnabled = NO;
//    }
}

- (IBAction)loginClicked:(id)sender {
    return [self.navigationController pushViewController:self.startUpVC animated:YES];
    
    [self startLoginLoadingAnimation];
    
    self.view.userInteractionEnabled = NO;
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjects:@[[self.usernameTextField text], [self.passwordTextField text]]
                                                         forKeys:@[@"userName", @"password"]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AFNetworkConfig *config = [AFNetworkConfig shareAFNetWorkConfig];
    [config.requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
    
    [HTTPModelUseCompletionBlok HTTPModelWithBaseUrl:SERVER_IP
                                            WithPath:@"/api/authentication/login"
                                               param:params
                                           getOrPost:@"POST"
                                           withCache:NO
                                            maxTimes:1
                                     completionBlock:^(id responseData, NSError *error) {
        NSLog(@"---->http: response:%@", responseData);
        self.view.userInteractionEnabled = YES;
        
        if(error == nil && responseData != nil){
            
            if([[responseData valueForKey:@"status"] isEqual:@"1"]){
                
                NSString *token = [responseData valueForKey:@"token"];
                
                if(token.length > 5){
                    [config.requestSerializer setValue:token forHTTPHeaderField:@"token"];
                    
                    [defaults setObject:token forKey:@"token"];
                    [defaults synchronize];
                    
                    return [self.navigationController pushViewController:self.startUpVC animated:YES];
                }
            }
        }
        return [self loginFailedShakingAnimation];
        
    }];
    
//    NSDictionary *params = [[NSDictionary alloc] initWithObjects:@[[self.usernameTextField text], [self.passwordTextField text], @"13511111111"]
//                                                         forKeys:@[@"userName", @"password", @"phone"]];
//    [HTTPModelUseCompletionBlok HTTPModelWithBaseUrl:@"http://10.103.1.94:8080"
//                                            WithPath:@"/add"
//                                               param:params
//                                           getOrPost:@"POST"
//                                           withCache:NO
//                                            maxTimes:1
//                                     completionBlock:^(id responseData, NSError *error) {
//        NSLog(@"---->http: response:%@", responseData);
//        if(error == nil){
//            [self.navigationController pushViewController:self.startUpVC animated:YES];
//        }else{
//            [self loginFailedShakingAnimation];
//        }
//    }];
}

-(void)loginFailedShakingAnimation{
    
    if(self.loginLoadingAnimView){
        [self.loginLoadingAnimView removeFromSuperview];
        self.loginLoadingAnimView = nil;
    }
    self.loginButton.hidden = NO;
    
    //关键帧动画
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint point = self.loginButton.layer.position;
    keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        [NSValue valueWithCGPoint:point]];
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    keyFrame.duration = 0.5f;
    [self.loginButton.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
}

-(void)startLoginLoadingAnimation{
    if(!self.loginLoadingAnimView){
        self.loginLoadingAnimView = [[UIView alloc] init];
        [self.loginWidgetContainer addSubview:self.loginLoadingAnimView];
    }
    
    self.loginLoadingAnimView.layer.cornerRadius = 10;
    self.loginLoadingAnimView.layer.masksToBounds = YES;
    self.loginLoadingAnimView.frame = self.loginButton.frame;
    self.loginLoadingAnimView.backgroundColor = self.loginButton.backgroundColor;
    self.loginButton.hidden = YES;
    
    CGPoint centerPoint = self.loginLoadingAnimView.center;
    CGFloat radius = MIN(self.loginButton.frame.size.width, self.loginButton.frame.size.height);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
         
        self.loginLoadingAnimView.frame = CGRectMake(0, 0, radius, radius);
        self.loginLoadingAnimView.center = centerPoint;
        self.loginLoadingAnimView.layer.cornerRadius = radius/2;
        self.loginLoadingAnimView.layer.masksToBounds = YES;
         
    }completion:^(BOOL finished) {
         
        //给圆加一条不封闭的白色曲线
        UIBezierPath* path = [[UIBezierPath alloc] init];
        [path addArcWithCenter:CGPointMake(radius/2, radius/2)
                        radius:(radius/2 - 5)
                    startAngle:0
                      endAngle:M_PI_2 * 2
                     clockwise:YES];
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.lineWidth = 1.5;
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        shapeLayer.fillColor = self.loginButton.backgroundColor.CGColor;
        shapeLayer.frame = CGRectMake(0, 0, radius, radius);
        shapeLayer.path = path.CGPath;
        [self.loginLoadingAnimView.layer addSublayer:shapeLayer];
        //circling
        CABasicAnimation* baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        baseAnimation.duration = 0.4;
        baseAnimation.fromValue = @(0);
        baseAnimation.toValue = @(2 * M_PI);
        baseAnimation.repeatCount = MAXFLOAT;
        [self.loginLoadingAnimView.layer addAnimation:baseAnimation forKey:nil];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
