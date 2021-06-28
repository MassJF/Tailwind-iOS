//
//  CKStockListTableView.h
//  CaiKuMobile
//
//  Created by ma on 12-9-12.
//  Copyright (c) 2012年 wolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	CKPullRefreshPulling = 0,
	CKPullRefreshNormal,
	CKPullRefreshLoading,
} CKPullRefreshState;

@protocol DragUpRefreshBottomViewProtocol;

@interface DragUpRefreshBottomView : UIView {
	
//	id _delegate;
	CKPullRefreshState _state;
    
	UILabel* _lastUpdatedLabel;
	UILabel* _statusLabel;
	CALayer* _arrowImage;
	UIActivityIndicatorView* _activityView;
	NSInteger typeOffset;
    
}

@property(nonatomic,assign) id<DragUpRefreshBottomViewProtocol> delegate;


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString* )arrow /*textColor:(UIColor* )textColor*/ backGroundColor:(UIColor* )backGroundColor;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView* )scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView* )scrollView;
- (void)dataSourceDidFinishedLoading:(UIScrollView* )scrollView;

@end

@protocol DragUpRefreshBottomViewProtocol <NSObject>

- (void)pullUpUpdateViewRefreshTableHeaderDidTriggerRefresh:(DragUpRefreshBottomView*)view;
- (BOOL)pullUpUpdateViewRefreshTableHeaderDataSourceIsLoading:(DragUpRefreshBottomView*)view;

@optional
- (NSDate*)pullUpUpdateViewRefreshTableHeaderDataSourceLastUpdated:(DragUpRefreshBottomView*)view;

@end
