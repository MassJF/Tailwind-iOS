//
//  PageWidgetVC.m
//  ScrollPageView
//
//  Created by superMa on 15/10/16.
//  Copyright © 2015年 superMa. All rights reserved.
//

#import "PageWidget.h"

#define TIMEINTERVAL 4.0f

@interface PageWidget () <UIScrollViewDelegate>

@property (nonatomic) BOOL shouldLoop;
@property (nonatomic) BOOL pageControlUsed;
@property (nonatomic) BOOL hidePageControl;
@property (nonatomic) BOOL shouldAotuScroll;
@property (nonatomic) NSInteger currentPageReal;
@property (strong, nonatomic) NSTimer* timer;
@property (strong, nonatomic) NSMutableArray* pageList;

@end

@implementation PageWidget

-(instancetype)initWithScrollView:(UIScrollView *)scrollView pageControll:(UIPageControl *)pageControl pagingEnabled:(BOOL)pagingEnabled{
    self = [super init];
    
    if(self){
        self.pageList = [NSMutableArray arrayWithCapacity:0];
        self.currentPageReal = 0;
        self.shouldLoop = NO;
        self.shouldAotuScroll = NO;
        
        self.scrollView = scrollView;
        self.scrollView.delegate = self;
        self.pageControl = pageControl;
        self.scrollView.pagingEnabled = pagingEnabled;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.scrollsToTop = NO;
        self.scrollView.contentSize = self.scrollView.frame.size;
        
        //pageControl设定
        [self.pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.pageControl.hidden = self.hidePageControl;
        
    }
    return self;
}

-(void)shouldAotuScroll:(BOOL)shouldAotuScroll{
    self.shouldAotuScroll = shouldAotuScroll;
    
    if(self.shouldAotuScroll){
        [self startAutoScroll];
    }else{
        [self stopAutoScroll];
    }
}

-(void)setPageing:(BOOL)paging{
    [self.scrollView setPagingEnabled:paging];
}

-(void)setPageControlVisible:(BOOL)visible{
    self.hidePageControl = !visible;
    self.pageControl.hidden = self.hidePageControl;
}

-(void)startAutoScroll
{
    if(![self.timer isValid]){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMEINTERVAL target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    }
}

-(void)stopAutoScroll
{
    [self.timer invalidate];
}

-(void)setViewsFromArray:(NSArray<PageWidgetCell *>* )viewsList shouldLoop:(BOOL)loop
{
    if(!viewsList || [viewsList count] == 0) return;
    
    for(UIViewController* page in self.pageList){
        [page.view removeFromSuperview];
    }
    [self.pageList removeAllObjects];
    
    for(id obj in viewsList){
        if([obj isKindOfClass:[PageWidgetCell class]]){
            [self.pageList addObject:obj];
        }else{
            [self.pageList removeAllObjects];
            return;
        }
    }
    
    self.shouldLoop = loop;
    if(self.shouldLoop){
        PageWidgetCell* firstPage = [viewsList objectAtIndex:0];
        PageWidgetCell* lastPage = [viewsList objectAtIndex:[self.pageList count] - 1];
        
        PageWidgetCell* beforeFirstPage = [lastPage copy];
        PageWidgetCell* afterLastPage = [firstPage copy];

        beforeFirstPage.view.frame = lastPage.view.frame;
        afterLastPage.view.frame = firstPage.view.frame;
        
        //加上头尾两个缓存page
        [self.pageList insertObject:beforeFirstPage atIndex:0];
        [self.pageList addObject:afterLastPage];
    }
    
    [self setViews];
}

-(void)setViews{
    @try {
        if(self.shouldLoop){
            self.currentPageReal = 1;
        }else{
            self.currentPageReal = 0;
        }
        int localX = 0;
        
        CGRect dFrame;
        CGSize contentSize = CGSizeZero;
        
        for(id obj in self.pageList){
            if([obj isKindOfClass:[PageWidgetCell class]]){
                PageWidgetCell* page = obj;
                dFrame = page.view.frame;
                dFrame.origin.x = localX;
                page.view.frame = dFrame;
                
                localX += dFrame.size.width;
                contentSize = CGSizeMake(contentSize.width + dFrame.size.width, dFrame.size.height);
                [self.scrollView addSubview:page.view];
            }
        }
        
        //scrollView所包含所有subview size之和
        CGSize scrollViewFrame = self.scrollView.frame.size;
        self.scrollView.contentSize = CGSizeMake(MAX(contentSize.width, scrollViewFrame.width),
                                                 MAX(contentSize.height, scrollViewFrame.height));
//    self.pageControl.numberOfPages = self.pageList.count;
        
        if(self.shouldLoop){
            self.pageControl.currentPage = 0;
            [self scrollToPage:1 animated:NO];
        }

    }
    @catch (NSException* exception) {
        NSLog(@"%@, %@", exception.name, exception.reason);
    }
    @finally {
        
    }
    
}

-(void)numberOfPages:(NSInteger)number{
    self.pageControl.numberOfPages = number;
}

-(void)pageControlChanged:(id)sender{
    [self scrollToPage:self.pageControl.currentPage animated:YES];
}

-(void)autoScroll
{
    @try {
        NSInteger numberOfPages = [self.pageList count];

        NSInteger toPage = self.currentPageReal + 1;
        NSInteger page = toPage % (numberOfPages == 0 ? 1 : numberOfPages);
        [self scrollToPage:page animated:YES];
    }
    @catch (NSException* exception) {
        NSLog(@"PageWidgetVC exception, autoScroll exception");
    }
    
}

-(void)scrollToPage:(NSInteger)page animated:(BOOL)animate
{
//    NSLog(@"page=%ld",(long)page);
    
    if(self.pageList){
        id obj = [self.pageList objectAtIndex:page];
        PageWidgetCell* pageCell = obj;
        UIView* view = pageCell.view;
        CGRect frame = view.frame;
        [self.scrollView scrollRectToVisible:frame animated:animate];
        self.pageControlUsed = YES; //用户通过点击Page Control换页时将其设置为YES
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView* )scrollView{
    if(self.shouldAotuScroll){
        [self stopAutoScroll];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView* )scrollView willDecelerate:(BOOL)decelerate{
    if(self.shouldAotuScroll){
        [self startAutoScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView* )scrollView{
    [self scrollViewStopScroll];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView* )scrollView{
    [self scrollViewStopScroll];
}

-(void)scrollViewStopScroll{
    self.pageControlUsed = NO;//滚动结束后将pageControlUsed重置为NO
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self setPageControlCurrentPage:page];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(scrolledToPage:numberOfPages:)]){
        [self.delegate scrolledToPage:page numberOfPages:self.pageControl.numberOfPages];
    }

}

-(void)setPageControlCurrentPage:(NSInteger)page{
    self.scrollView.userInteractionEnabled = NO;
    
    if(self.shouldLoop){
        if(page == 0){
            page = [self.pageList count] - 2;
            [self scrollToPage:page animated:NO];
        }
        if(page == [self.pageList count] - 1){
            page = 1;
            [self scrollToPage:page animated:NO];
        }
        self.pageControl.currentPage = page - 1;
    }else{
        self.pageControl.currentPage = page;
    }
    self.currentPageReal = page;
    
    self.scrollView.userInteractionEnabled = YES;
}

@end
