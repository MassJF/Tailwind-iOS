//
//  CentPickerView.h
//  PushApp
//
//  Created by ma on 14/11/13.
//  Copyright (c) 2014年 Centillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperPickerViewData.h"

@protocol SuperPickerViewProtocol <NSObject>

//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
//-(CentPickerViewData *)pickerView:(UIPickerView *)pickerView forComponent:(NSInteger)component;
-(void)finishWithData:(SuperPickerViewData *)data withIndex:(NSInteger)index;

@end

@interface SuperPickerView : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (retain, nonatomic) id<SuperPickerViewProtocol> delegate;
@property (nonatomic) BOOL isShow;

-(void)reloadData:(SuperPickerViewData *)data;
-(void)show;
-(void)hide;

@end
