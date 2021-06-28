//
//  PageWidgetVC.h
//  ScrollPageView
//
//  Created by superMa on 15/10/16.
//  Copyright © 2015年 superMa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PageWidgetCell.h"

@protocol PageWidgetProtocol <NSObject>

@optional
-(void)scrolledToPage:(NSInteger)pageIndex numberOfPages:(NSInteger)numberOfPages;

@end

@interface PageWidget : NSObject

@property (retain, nonatomic) id<PageWidgetProtocol> delegate;
@property (retain, nonatomic) UIScrollView* scrollView;
@property (retain, nonatomic) UIPageControl* pageControl;

-(instancetype)initWithScrollView:(UIScrollView *)scrollView pageControll:(UIPageControl *)pageControl pagingEnabled:(BOOL)pagingEnabled;
-(void)setPageControlVisible:(BOOL)visible;
-(void)setViewsFromArray:(NSArray<PageWidgetCell *>* )viewsList shouldLoop:(BOOL)loop;
-(void)numberOfPages:(NSInteger)number;
-(void)shouldAotuScroll:(BOOL)shouldAotuScroll;
-(void)setViews;

@end
