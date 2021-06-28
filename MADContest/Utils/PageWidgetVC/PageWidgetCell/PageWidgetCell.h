//
//  PageWidgetCell.h
//  ScrollPageView
//
//  Created by superMa on 15/10/18.
//  Copyright © 2015年 superMa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol PageWidgetCellProtocol <NSObject>

-(void)pageWidgetCellBeenTapped:(NSInteger)atIndex;

@end

@interface PageWidgetCell : BaseViewController <NSCopying>

@property (weak, nonatomic) id<PageWidgetCellProtocol>delegate;

-(instancetype)initWithNibName:(NSString* )nibNameOrNil bundle:(NSBundle* )nibBundleOrNil withIndex:(NSInteger)index;

@end
