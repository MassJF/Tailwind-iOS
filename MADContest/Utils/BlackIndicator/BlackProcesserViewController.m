//
//  BlackProcesserViewController.m
//  CaiKuMobile
//
//  Created by ma on 13-9-30.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "BlackProcesserViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BlackProcesserViewController ()

@property (nonatomic) BOOL isLoading;
@property (nonatomic) BlackProcesserViewStyle style;
@property (strong, nonatomic) IBOutlet UILabel* messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *largeMessageLabel;

@end

@implementation BlackProcesserViewController

- (id)initWithNibName:(NSString* )nibNameOrNil bundle:(NSBundle* )nibBundleOrNil style:(BlackProcesserViewStyle)style
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.style = style;
        self.isLoading = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.cornerRadius = 12;
    // Do any additional setup after loading the view from its nib.
    
    [self.smallWhiteIndicator setHidden:YES];
    [self.largeWhiteIndecator setHidden:YES];
    [self.messageLabel setHidden:YES];
    [self.largeMessageLabel setHidden:YES];
}

-(void)showMessage:(NSString* )message forTime:(double)time{
    self.isLoading = NO;
    [self.largeWhiteIndecator setHidden:YES];
    [self.largeWhiteIndecator stopAnimating];
    [self.messageLabel setHidden:YES];
    
//    if(!self.isLoading){
        self.isLoading = YES;
        [self.view.superview bringSubviewToFront:self.view];
        self.view.hidden = NO;
        
        [self.largeMessageLabel setText:message];
        [self.largeMessageLabel setHidden:NO];
        
        [UIView animateWithDuration:0.2f animations:^{
            self.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f delay:time options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.view.alpha = 0.0f;
            } completion:^(BOOL finished) {
                self.isLoading = NO;
                [self.largeMessageLabel setHidden:YES];
                self.view.hidden = YES;
                
                [self stopAnimating];
            }];
        }];
//    }
}

-(void)startAnimating
{
    if(!self.isLoading){
        self.isLoading = YES;
        [self.view.superview bringSubviewToFront:self.view];
//        self.view.superview.userInteractionEnabled = NO;
        self.view.hidden = NO;
        [self.messageLabel setHidden:NO];
        [self.largeWhiteIndecator setHidden:NO];
        [self.largeMessageLabel setHidden:YES];
        
        [UIView animateWithDuration:0.2f animations:^{
            self.view.alpha = 1.0f;
        }];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self.largeWhiteIndecator startAnimating];
    }
}

-(void)stopAnimating
{
//    self.view.superview.userInteractionEnabled = YES;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [UIView animateWithDuration:0.6f animations:^{
        self.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.isLoading = NO;
        self.view.hidden = YES;
        [self.messageLabel setHidden:YES];
        [self.largeWhiteIndecator setHidden:YES];
        [self.largeWhiteIndecator stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setLargeWhiteIndecator:nil];
    [self setSmallWhiteIndicator:nil];
    [super viewDidUnload];
}
@end
