//
//  BaseViewController.m
//  zgxt
//
//  Created by superMa on 15/10/20.
//  Copyright © 2015年 htqh. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@property (strong, nonatomic) BlackProcesserViewController* blackIndicator;
//@property (nonatomic) CGRect viewFrame;

@end

@implementation BaseViewController

/*-(instancetype)initWithFrame:(CGRect)frame{
    self = [super init];
    if(self){
        self.viewFrame = frame;
    }
    return self;
}*/

-(instancetype)initWithNibName:(NSString* )nibNameOrNil bundle:(NSBundle* )nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
//        self.viewFrame = frame;
    }
    return self;
}

-(void)setNavigationBarTranslucent{
    UIView *view = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.frame];
    view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setValue:view forKey:@"backgroundView"];
    self.edgesForExtendedLayout = UIRectEdgeTop;
}

-(void)startLoading{
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    [self.blackIndicator startAnimating];
}

-(void)stopLoading{
    [self.blackIndicator stopAnimating];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}

-(void)showMessage:(NSString* )message forTime:(double)time{
    [self.blackIndicator showMessage:message forTime:time];
}

-(void)refreshData{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.frame = self.viewFrame;
    self.blackIndicator = [[BlackProcesserViewController alloc] initWithNibName:@"BlackProcesserViewController" bundle:nil style:LargeStyle];
    
    [self.view addSubview:self.blackIndicator.view];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resignKeyboardNotification];
}

-(void)viewDidLayoutSubviews{
    self.blackIndicator.view.center = self.view.center;
}

-(void)shouldListenKeyboardNotification{
    //重要：强烈建议子类在viewDidAppear:中调用此方法
    //注册键盘消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification //UIKeyboardWillHideNotification ?
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

-(void)resignKeyboardNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

-(void)keyboardWillShown:(NSNotification* )notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    self.keyboardSize = [value CGRectValue].size;
//    NSLog(@"width=%f, height=%f", self.keyboardSize.width, self.keyboardSize.height);
//    [self mesureViewFrameWhenKeyboardChanged];
    [self keyBoardWillShow:YES withSize:self.keyboardSize];
}

- (void)textFieldDidGetFocus:(UITextField* )textField{
    self.textFieldOnFocus = textField;
    
    //有问题吗？
    [self mesureViewFrameWhenKeyboardChanged];
    
}

-(void)mesureViewFrameWhenKeyboardChanged{
    
    CGRect windowFrame = [UIScreen mainScreen].bounds;
    windowFrame.size.height -= self.keyboardSize.height;
    
    CGRect textFieldFrame = [self.textFieldOnFocus.superview convertRect:self.textFieldOnFocus.frame toView:nil];
    
    CGFloat offset = CGRectGetMaxY(textFieldFrame) - (CGRectGetMaxY(windowFrame) - 60.0f);
    CGFloat newY = self.view.frame.origin.y - offset;
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        CGFloat minY = 0.0f;
        
        if(self.edgesForExtendedLayout == UIRectEdgeAll || self.edgesForExtendedLayout == UIRectEdgeTop){
            CGFloat heightForStatusBar = [[UIApplication sharedApplication] statusBarFrame].size.height;
            CGFloat heightForNavigationBar = self.navigationController.navigationBar.frame.size.height;
            minY += heightForNavigationBar + heightForStatusBar;
        }
        
        frame.origin.y = MIN(minY, newY);
        self.view.frame = frame;
    }];
}

-(void)keyboardDidHide:(NSNotification* )notification{
    [self keyBoardWillShow:NO withSize:self.keyboardSize];
    
    /*
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.bounds;

        if(self.edgesForExtendedLayout == UIRectEdgeAll || self.edgesForExtendedLayout == UIRectEdgeTop){
            CGFloat heightForStatusBar = [[UIApplication sharedApplication] statusBarFrame].size.height;
            CGFloat heightForNavigationBar = self.navigationController.navigationBar.frame.size.height;
            frame.origin.y += heightForStatusBar + heightForNavigationBar;
        }
        self.view.frame = frame;
    }];
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue* )segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
