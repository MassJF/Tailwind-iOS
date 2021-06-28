//
//  BaseTimePickerViewController.h
//  MADContest
//
//  Created by JingFeng Ma on 2020/4/2.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BaseDatePickerViewProtocol <NSObject>
//-(void)finishWithDate:(NSDate *)date;
-(void)canceled;
@end

@interface BaseTimePickerViewController : UIViewController

@property (retain, nonatomic) id<BaseDatePickerViewProtocol> delegate;
@property (strong, nonatomic) NSString *message;
@property (nonatomic) BOOL isShow;

-(void)showWithMessage:(NSString *)message withCompletion:(void(^)(NSDate *))completionBlock;
-(void)hide;

@end

NS_ASSUME_NONNULL_END
