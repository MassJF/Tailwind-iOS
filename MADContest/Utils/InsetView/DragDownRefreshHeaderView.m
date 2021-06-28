//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "DragDownRefreshHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

@implementation DragDownRefreshHeaderView

@synthesize delegate;


- (id)initWithArrowImageName:(NSString* )arrow backGroundColor:(UIColor* )backGroundColor {
    if((self = [super init])) {
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        if(backGroundColor)
            self.backgroundColor = backGroundColor;
        else
            self.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
        
		UILabel* label = [[UILabel alloc] init];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		
		label = [[UILabel alloc] init];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
        
		CALayer* layer = [CALayer layer];
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
        
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView* view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:view];
		_activityView = view;
		
		[self setState:DragDownRefreshNormal];
		
    }
	
    return self;
	
}

-(void)layoutSubviews{
    _lastUpdatedLabel.frame = CGRectMake(10.0f, self.frame.size.height - 30.0f, self.frame.size.width, 20.0f);
    _statusLabel.frame = CGRectMake(10.0f, self.frame.size.height - 48.0f, self.frame.size.width, 20.0f);
    _arrowImage.frame = CGRectMake(40.0f, self.frame.size.height - 65.0f, 30.0f, 55.0f);
    _activityView.frame = CGRectMake(40.0f, self.frame.size.height - 38.0f, 20.0f, 20.0f);
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	if ([delegate respondsToSelector:@selector(DragDownUpdateHeaderViewDataSourceLastUpdated:)]) {
		
		NSDate* date = [delegate DragDownUpdateHeaderViewDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后刷新时间: %@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
    
}

- (void)setState:(DragDownRefreshState)aState{
	switch (aState) {
		case DragDownRefreshDragging:
            _statusLabel.text = NSLocalizedString(@"松开后开始刷新...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0)*  180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case DragDownRefreshNormal:
			if (_state == DragDownRefreshDragging) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
            _statusLabel.text = NSLocalizedString(@"下拉刷新...", @"Pull down to refresh status");
			
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case DragDownRefreshLoading:
            _statusLabel.text = NSLocalizedString(@"正在刷新...", @"Loading Status");
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

- (void)DragDownUpdateHeaderViewDidScroll:(UIScrollView* )scrollView {
    
	if (_state == DragDownRefreshLoading) {
        //自身高度＋个别定制的y轴偏移量
        CGFloat top = self.frame.size.height;
        if([self.delegate respondsToSelector:@selector(resetEdgeInsetsWhenFinishLoad)]){
            top += [self.delegate resetEdgeInsetsWhenFinishLoad].top;
        }
        
        CGFloat offset = MAX(-scrollView.contentOffset.y, 0);
        offset = MIN(offset, top);
        
        [UIView animateWithDuration:0.3 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
        }];
        
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([delegate respondsToSelector:@selector(DragDownUpdateHeaderViewDataSourceIsLoading:)]) {
			_loading = [delegate DragDownUpdateHeaderViewDataSourceIsLoading:self];
		}
		
		if (_state == DragDownRefreshDragging && scrollView.contentOffset.y > -self.frame.size.height - 20 && scrollView.contentOffset.y < 0.0f && !_loading) {//从阈值主动拖回
			[self setState:DragDownRefreshNormal];
		} else if (_state == DragDownRefreshNormal && scrollView.contentOffset.y < -self.frame.size.height - 20 && !_loading) {//拖到阈值以下 仅设置状态
            
			[self setState:DragDownRefreshDragging];
		}
	}
}



- (void)DragDownUpdateHeaderViewDidEndDragging:(UIScrollView* )scrollView {
	BOOL _loading = NO;
    
	if ([delegate respondsToSelector:@selector(DragDownUpdateHeaderViewDataSourceIsLoading:)]) {
		_loading = [delegate DragDownUpdateHeaderViewDataSourceIsLoading:self];
	}

	if (scrollView.contentOffset.y < -self.frame.size.height - 20 && !_loading) {//在阈值以下  则更新
        
		if ([delegate respondsToSelector:@selector(DragDownUpdateHeaderViewDidTriggerRefresh:)]) {
			[delegate DragDownUpdateHeaderViewDidTriggerRefresh:self];
		}
        
        [self setState:DragDownRefreshLoading];
        
	}
}

- (void)dataSourceDidFinishedLoading:(UIScrollView* )scrollView
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    
    if([self.delegate respondsToSelector:@selector(resetEdgeInsetsWhenFinishLoad)]){
        //代理定制y轴偏移量
        insets = [self.delegate resetEdgeInsetsWhenFinishLoad];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [scrollView setContentInset:insets];  //归位
    }];
    
	[self setState:DragDownRefreshNormal];
    
}

@end
