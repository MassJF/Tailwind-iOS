//
//  BlackProcesserViewController.h
//  CaiKuMobile
//
//  Created by ma on 13-9-30.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LargeStyle,
    SmallStyle
} BlackProcesserViewStyle;

@interface BlackProcesserViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* smallWhiteIndicator;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView* largeWhiteIndecator;

- (id)initWithNibName:(NSString* )nibNameOrNil bundle:(NSBundle* )nibBundleOrNil style:(BlackProcesserViewStyle)style;
-(void)startAnimating;
-(void)stopAnimating;
-(void)showMessage:(NSString* )message forTime:(double)time;

@end
