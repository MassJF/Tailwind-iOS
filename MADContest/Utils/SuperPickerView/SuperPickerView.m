//
//  CentPickerView.m
//  PushApp
//
//  Created by ma on 14/11/13.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import "SuperPickerView.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>

@interface SuperPickerView ()

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (retain, nonatomic) SuperPickerViewData *pickerData;

- (IBAction)finishButtonClicked:(id)sender;
- (IBAction)cancleButtonClicked:(id)sender;

@end

@implementation SuperPickerView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isShow = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.hidden = YES;
    self.view.layer.borderWidth = 0.5f;
    self.view.layer.borderColor = [RGB(0xd3, 0xd3, 0xd3) CGColor];
}

-(void)reloadData:(SuperPickerViewData *)data{
    self.pickerData = data;
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:self.pickerData.selectedIndex inComponent:0 animated:NO];
}

-(void)show{
    self.view.hidden = NO;
    CGRect superBounds = self.view.superview.bounds;
    
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerData getCount];
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    if([self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]){
//        CentPickerViewData *data = [self.delegate pickerView:pickerView forComponent:component];
//        return [data getObjectAtIndex:row];
//    }
//    return nil;
    return [self.pickerData getObjectAtIndex:row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishButtonClicked:(id)sender {
    [self.delegate finishWithData:self.pickerData withIndex:[self.pickerView selectedRowInComponent:0]];
    [self hide];
}

- (IBAction)cancleButtonClicked:(id)sender {
    [self hide];
}

@end
