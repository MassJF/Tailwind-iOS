//
//  BaseViewController.h
//  zgxt
//
//  Created by superMa on 15/10/20.
//  Copyright © 2015年 htqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlackProcesserViewController.h"

@interface BaseViewController : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) UITextField* textFieldOnFocus;
@property (nonatomic) CGSize keyboardSize;

//-(instancetype)initWithFrame:(CGRect)frame;
-(instancetype)initWithNibName:(NSString* )nibNameOrNil bundle:(NSBundle* )nibBundleOrNil;
- (void)textFieldDidGetFocus:(UITextField* )textField;
-(void)shouldListenKeyboardNotification;
-(void)startLoading;
-(void)stopLoading;
-(void)refreshData;
-(void)showMessage:(NSString* )message forTime:(double)time;
-(void)keyBoardWillShow:(BOOL)show withSize:(CGSize)size;
-(void)setNavigationBarTranslucent;

@end
