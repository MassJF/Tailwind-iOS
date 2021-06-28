//
//  CKStockListTableView.h
//  CaiKuMobile
//
//  Created by ma on 12-9-12.
//  Copyright (c) 2012年 wolf. All rights reserved.
//

#import "DragUpRefreshBottomView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

//@interface DragUpRefreshBottomView (Private)
//- (void)setState:(CKPullRefreshState)aState;
//@end

@implementation DragUpRefreshBottomView

//@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString* )arrow /*textColor:(UIColor* )textColor*/ backGroundColor:(UIColor* )backGroundColor {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        if(backGroundColor)
            self.backgroundColor = backGroundColor;
        else
            self.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
        
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
        
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
        
		CALayer* layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, 0.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@""].CGImage;
		
        
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView* view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(45.0f, 12, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;		
		
		[self setState:CKPullRefreshNormal];
		
    }
    return self;
	
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	if ([self.delegate respondsToSelector:@selector(pullUpUpdateViewRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate* date = [self.delegate pullUpUpdateViewRefreshTableHeaderDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"数据更新于: %@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
    
}

- (void)setState:(CKPullRefreshState)aState{
	switch (aState) {
		case CKPullRefreshPulling:
            _statusLabel.text = NSLocalizedString(@"松开后加载更多...", @"Release to load status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0)*  180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case CKPullRefreshNormal:
			if (_state == CKPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
            _statusLabel.text = NSLocalizedString(@"上拉加载更多...", @"Pull down to load status");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case CKPullRefreshLoading:
            _statusLabel.text = NSLocalizedString(@"正在加载...", @"Loading Status");;
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView* )scrollView {
	if (_state == CKPullRefreshLoading) {
		
//		CGFloat offset = MAX(scrollView.contentOffset.y , 0);
//		offset = MIN(offset, 55 );
//		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, offset, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([self.delegate respondsToSelector:@selector(pullUpUpdateViewRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [self.delegate pullUpUpdateViewRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == CKPullRefreshPulling && scrollView.contentOffset.y < self.frame.origin.y - scrollView.frame.size.height + 45 && scrollView.contentOffset.y > 0.0f && !_loading) {//从阈值主动拖回
			[self setState:CKPullRefreshNormal];
		} else if (_state == CKPullRefreshNormal && scrollView.contentOffset.y > self.frame.origin.y - scrollView.frame.size.height + 45 && !_loading) {//拖到阈值以上 仅设置状态
			[self setState:CKPullRefreshPulling];
		}
	}
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView* )scrollView {
	BOOL _loading = NO;
	if ([self.delegate respondsToSelector:@selector(pullUpUpdateViewRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [self.delegate pullUpUpdateViewRefreshTableHeaderDataSourceIsLoading:self];
	}
	if (scrollView.contentOffset.y > self.frame.origin.y - scrollView.frame.size.height + 45 && !_loading) {//在阈值以下  则更新
		
		if ([self.delegate respondsToSelector:@selector(pullUpUpdateViewRefreshTableHeaderDidTriggerRefresh:)]) {
			[self.delegate pullUpUpdateViewRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        float bottom = 45.0f;
        if(scrollView.contentSize.height < scrollView.frame.size.height){
            bottom = scrollView.frame.size.height - scrollView.contentSize.height + 98;
        }
		scrollView.contentInset = UIEdgeInsetsMake(0.0f , 0.0f, bottom, 0.0f); //更新时停在阈值处 但向上偏移5像素
		[UIView commitAnimations];
		
        [self setState:CKPullRefreshLoading];
	}
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView* )scrollView privateMessage:(BOOL)priveteMessagebool{
    [self.delegate pullUpUpdateViewRefreshTableHeaderDidTriggerRefresh:self];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    float bottom = 45.0f;
    if(scrollView.contentSize.height < scrollView.frame.size.height){
        bottom = scrollView.frame.size.height - scrollView.contentSize.height + 98;
    }
    scrollView.contentInset = UIEdgeInsetsMake(0.0f , 0.0f, bottom, 0.0f); //更新时停在阈值处 但向上偏移5像素
    [UIView commitAnimations];
    
    [self setState:CKPullRefreshLoading];
}

- (void)dataSourceDidFinishedLoading:(UIScrollView* )scrollView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];  //归位
	[UIView commitAnimations];
	
	[self setState:CKPullRefreshNormal];
    
}

@end
