//
//  BaseTimePickerViewController.m
//  MADContest
//
//  Created by JingFeng Ma on 2020/4/2.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import "BaseTimePickerViewController.h"
#import "Utils.h"

@interface BaseTimePickerViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (copy, nonatomic) void (^completionBlock)(NSDate *);
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation BaseTimePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isShow = NO;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.hidden = YES;
    self.view.layer.borderWidth = 0.5f;
    self.view.layer.borderColor = [RGB(0xd3, 0xd3, 0xd3) CGColor];
    
}

- (IBAction)okClicked:(id)sender {
//    [self.delegate finishWithDate:self.datePicker.date];
    self.completionBlock(self.datePicker.date);
    [self hide];
}

- (IBAction)cancelClicked:(id)sender {
    [self.delegate canceled];
    [self hide];
}

-(void)showWithMessage:(NSString *)message withCompletion:(void(^)(NSDate *date))completionBlock{
    self.view.hidden = NO;
    [self.view.superview bringSubviewToFront:self.view];
    CGRect superBounds = self.view.superview.bounds;
    self.completionBlock = completionBlock;
    [self.messageLabel setText:message];
    
    [UIView animateWithDuration:0.3f animations:^{
    
        self.view.frame = CGRectMake(superBounds.origin.x,
                                     superBounds.size.height - self.view.frame.size.height,
                                     superBounds.size.width,
                                     self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        self.isShow = YES;
    }];
}

-(void)hide{
    CGRect superBounds = self.view.superview.bounds;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.view.frame = CGRectMake(superBounds.origin.x,
                                     superBounds.size.height,
                                     superBounds.size.width,
                                     self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        self.isShow = NO;
        self.view.hidden = YES;
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
