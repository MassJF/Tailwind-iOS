//
//  CentGroupedTableView.m
//  CaiKuMobile
//
//  Created by ma on 13-9-5.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import "BaseTableView.h"

@interface BaseTableView()

@property (retain, nonatomic) id<BaseTableViewProtocol> tableViewDelegate;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSMutableDictionary *styleIdentifierMap;

@end

@implementation BaseTableView

-(id)initWithCoder:(NSCoder* )aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self prepare];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        [self prepare];
    }
    return self;
}

-(void)setupTableViewDelegate:(id<BaseTableViewProtocol>)delegate{
    self.tableViewDelegate = delegate;
    
}

-(void)registerCellForNibName:(NSString *)nibName forIdentifier:(NSString *)identifier{
    UINib* nib = [UINib nibWithNibName:nibName bundle:nil];
    [super registerNib:nib forCellReuseIdentifier:identifier];
}

-(void)registerHeaderFooterForNibName:(NSString *)nibName forIdentifier:(NSString *)identifier{
    UINib* nib = [UINib nibWithNibName:nibName bundle:nil];
    [super registerNib:nib forHeaderFooterViewReuseIdentifier:identifier];
}

-(void)registerCellForDefaultStyle:(UITableViewCellStyle)style forIdentifier:(NSString *)identifier{
    if(identifier){
        [self.styleIdentifierMap setObject:[NSNumber numberWithInteger:style] forKey:identifier];
    }
}

-(__kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    UITableViewCell *cell = [super dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        NSNumber *style = [self.styleIdentifierMap objectForKey:identifier];
        
        if(style)
            cell = [[UITableViewCell alloc] initWithStyle:[style integerValue] reuseIdentifier:identifier];
        
        if(cell && [self.tableViewDelegate respondsToSelector:@selector(initializeForDefualtStyleCell:forIdentifier:forTableView:)]){
            [self.tableViewDelegate initializeForDefualtStyleCell:cell forIdentifier:identifier forTableView:self];
        }
    }
    return cell;
}

//-(void)doSomeInitializeForCell

-(void)prepare
{
    self.sections = [NSMutableArray arrayWithCapacity:0];
    self.styleIdentifierMap = [NSMutableDictionary dictionaryWithCapacity:0];
    
    self->supportDragDownRefresh = NO;
    self->supportDragDownRefresh = NO;
    
    self.delegate = self;
    self.dataSource = self;
    
    CGSize bounds = self.bounds.size;
    CGSize frame = self.frame.size;
    
    self.estimatedRowHeight = self.frame.size.height;
    
    self.pullDownUpdateHeaderView = [[DragDownRefreshHeaderView alloc]
                                     initWithArrowImageName:@"blueArrow.png"
                                     backGroundColor:[UIColor clearColor]];
    self.pullDownUpdateHeaderView.delegate = self;
    
    self.pullUpUpdateBottomView = [[DragUpRefreshBottomView alloc]
                                   initWithFrame:CGRectMake(0.0f, bounds.height * 2, frame.width, bounds.height)
                                   arrowImageName:@"blueArrow.png"
                                   backGroundColor:[UIColor clearColor]];
    self.pullUpUpdateBottomView.delegate = self;
    
    [self.pullDownUpdateHeaderView refreshLastUpdatedDate];
    [self.pullUpUpdateBottomView refreshLastUpdatedDate];
    
}

-(void)dragDownToReloadData
{
    [self setContentOffset:CGPointMake(0.0f, 0.0f)];
    [UIView animateWithDuration:0.2 animations:^{
        [self setContentOffset:CGPointMake(0.0f, -66.0/*下拉阈值*/)];
    } completion:^(BOOL finished){
        [self.pullDownUpdateHeaderView DragDownUpdateHeaderViewDidEndDragging:self];
    }];

}

-(void)supportDragDownUpdate:(BOOL)supportDragDownUpdate supportDragUpLoadMore:(BOOL)supportDragUpLoadMore
{
    self->supportDragDownRefresh = supportDragDownUpdate;
    self->supportDragUpRefresh = supportDragUpLoadMore;
    
    if(self->supportDragDownRefresh){
        //打开下拉更新
        [self addSubview:self.pullDownUpdateHeaderView];
    }else{
        [self.pullDownUpdateHeaderView removeFromSuperview];
    }
    
    if(self->supportDragUpRefresh){
        //打开上拉加载
        [self addSubview:self.pullUpUpdateBottomView];
    }else{
        [self.pullUpUpdateBottomView removeFromSuperview];
    }
}

-(void)doneUpdate
{
//    [self.pullDownUpdateHeaderView dataSourceDidFinishedLoading:self];
    [self.pullDownUpdateHeaderView performSelector:@selector(dataSourceDidFinishedLoading:) withObject:self afterDelay:0.5f];
}

-(void)doneLoadMore
{
//    [self.pullUpUpdateBottomView dataSourceDidFinishedLoading:self];
    [self.pullUpUpdateBottomView performSelector:@selector(dataSourceDidFinishedLoading:) withObject:self afterDelay:0.5f];
}

//---------tableView protocol--------

-(NSArray<NSString *> *)dataModelForTableView:(BaseTableView *)tableView forSection:(NSInteger)section{
    
    if([self.delegate respondsToSelector:@selector(dataModelForTableView:forSection:)]){
        id dataModel = [self.tableViewDelegate dataModelForTableView:tableView forSection:section];
        
        if([dataModel isKindOfClass:[NSArray class]]){
            return dataModel;
        }else{
            NSLog(@"BaseTableView Exception: dataModelForTableView:forSection: didn't return an array object.");
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(BaseTableView* )tableView
{
    CGSize content = self.contentSize;
    CGRect frame = self.frame;
    
    self.pullUpUpdateBottomView.frame = CGRectMake(0,
                                                   (content.height > frame.size.height ? content.height : frame.size.height),
                                                   frame.size.width,
                                                   frame.size.height);
    
    
    NSInteger numberOfSections = [self.tableViewDelegate numberOfSectionsInTableView:tableView];
    
    for(NSInteger i = 0; i < numberOfSections; i++){
        NSMutableArray *identifiersArray = [NSMutableArray arrayWithCapacity:0];
        [self.sections addObject:identifiersArray];
    }
    
    return numberOfSections;
}

- (NSInteger)tableView:(BaseTableView* )tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *identifiersInSection = [self dataModelForTableView:tableView forSection:section];
    
    if(identifiersInSection){
//        NSLog(@"---->add identifiers array.");
        NSMutableArray *identifiersArray = [self.sections objectAtIndex:section];
        [identifiersArray removeAllObjects];
        [identifiersArray addObjectsFromArray:identifiersInSection];
//        NSLog(@"---->sections.count=%lu", (unsigned long)[self.sections count]);
        
        return [identifiersInSection count];
    }else{
        return 0;
    }
}

-(UIView* )tableView:(BaseTableView* )tableView viewForHeaderInSection:(NSInteger)section
{
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]){
        return [self.tableViewDelegate tableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}

-(CGFloat)tableView:(BaseTableView* )tableView heightForHeaderInSection:(NSInteger)section
{
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]){
        return [self.tableViewDelegate tableView:tableView heightForHeaderInSection:section];
    }
    
    return 0.0f;
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if([self.tableViewDelegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)]){
//        return [self.tableViewDelegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
//    }
//    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
//    //如果无需实现本方法 则再次调用tableView:heightForRowAtIndexPath:保证和原来高度一致
//}

-(UIView* )tableView:(BaseTableView* )tableView viewForFooterInSection:(NSInteger)section{
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]){
        return [self.tableViewDelegate tableView:tableView viewForFooterInSection:section];
    }
    return nil;
}

-(CGFloat)tableView:(BaseTableView* )tableView heightForFooterInSection:(NSInteger)section{
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]){
        return [self.tableViewDelegate tableView:tableView heightForFooterInSection:section];
    }
    return 0.0f;
}

- (UITableViewCell* )tableView:(BaseTableView* )tableView cellForRowAtIndexPath:(NSIndexPath* )indexPath
{
    NSString *identifier = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    UITableViewCell* cell = [self.tableViewDelegate cellForTableView:tableView cellForIdentifier:identifier cellForIndexPath:indexPath];
    return cell;
}

-(void)tableView:(BaseTableView* )tableView didSelectRowAtIndexPath:(NSIndexPath* )indexPath
{
//    if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
//        [self.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
//    }
    NSString *identifier = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectRowWithIdentifier:atIndexPath:)]){
        [self.tableViewDelegate tableView:tableView didSelectRowWithIdentifier:identifier atIndexPath:indexPath];
    }
}

- (void)tableView:(BaseTableView* )tableView didDeselectRowAtIndexPath:(NSIndexPath* )indexPath{
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]){
        [self.tableViewDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(BaseTableView* )tableView shouldHighlightRowAtIndexPath:(NSIndexPath* )indexPath{
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)]){
        return [self.tableViewDelegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    }
    return YES;
}

-(CGFloat)tableView:(BaseTableView* )tableView heightForRowAtIndexPath:(NSIndexPath* )indexPath
{
//    if([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
//        return [self.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:cellForIdentifier:heightForRowAtIndexPath:)]){
        
        NSString *identifier = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        return [self.tableViewDelegate tableView:tableView cellForIdentifier:identifier heightForRowAtIndexPath:indexPath];
    }
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:willDisplayCell:cellForIdentifier:forRowAtIndexPath:)]){
        [self.tableViewDelegate tableView:tableView willDisplayCell:cell cellForIdentifier:identifier forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]){
        [self.tableViewDelegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

-(BOOL)tableView:(BaseTableView* )tableView canEditRowAtIndexPath:(NSIndexPath* )indexPath
{
    if([self.tableViewDelegate respondsToSelector:@selector(setTableView:canEditRowAtIndexPath:)]){
        return [self.tableViewDelegate setTableView:tableView canEditRowAtIndexPath:indexPath];
    }else
        return NO;
}

-(void)tableView:(BaseTableView* )tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath* )indexPath
{
    if([self.tableViewDelegate respondsToSelector:@selector(setTableView:commitEditingStyle:forRowAtIndexPath:)]){
        [self.tableViewDelegate setTableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}


// Override to support rearranging the table view.
- (void)tableView:(BaseTableView* )tableView moveRowAtIndexPath:(NSIndexPath* )fromIndexPath toIndexPath:(NSIndexPath* )toIndexPath
{
    if([self.tableViewDelegate respondsToSelector:@selector(setTableView:moveRowAtIndexPath:toIndexPath:)]){
        [self.tableViewDelegate setTableView:tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    }
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(BaseTableView* )tableView canMoveRowAtIndexPath:(NSIndexPath* )indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    if([self.tableViewDelegate respondsToSelector:@selector(setTableView:canMoveRowAtIndexPath:)]){
        return [self.tableViewDelegate setTableView:tableView canMoveRowAtIndexPath:indexPath];
    }else
        return NO;
}


//-------end--------//

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView* )scrollView
{
    if([self.tableViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.tableViewDelegate scrollViewDidScroll:scrollView];
    }
    
    if(self->supportDragDownRefresh)
        [self.pullDownUpdateHeaderView DragDownUpdateHeaderViewDidScroll:scrollView];
    
    if(self->supportDragUpRefresh)
        [self.pullUpUpdateBottomView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView* )scrollView willDecelerate:(BOOL)decelerate
{
    if([self.tableViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]){
        [self.tableViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
    if(self->supportDragDownRefresh)
        [self.pullDownUpdateHeaderView DragDownUpdateHeaderViewDidEndDragging:scrollView];
    
    if(self->supportDragUpRefresh)
        [self.pullUpUpdateBottomView egoRefreshScrollViewDidEndDragging:scrollView];
}


//--------dragDownUpdate protocol--------

- (NSDate*)DragDownUpdateHeaderViewDataSourceLastUpdated:(DragDownRefreshHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

- (void)DragDownUpdateHeaderViewDidTriggerRefresh:(DragDownRefreshHeaderView*)view
{
    if([self.tableViewDelegate respondsToSelector:@selector(doUpdating)]){
        [self.tableViewDelegate doUpdating];
    }
}

- (BOOL)DragDownUpdateHeaderViewDataSourceIsLoading:(DragDownRefreshHeaderView*)view
{
    if([self.tableViewDelegate respondsToSelector:@selector(delegateIsUpdating)]){
        return [self.tableViewDelegate delegateIsUpdating];
    }
    return NO;
}

//--------end--------//

//--------dragUpLoadMore protocol--------

- (NSDate*)pullUpUpdateViewRefreshTableHeaderDataSourceLastUpdated:(DragUpRefreshBottomView*)view
{
    return [NSDate date];
}


- (void)pullUpUpdateViewRefreshTableHeaderDidTriggerRefresh:(DragUpRefreshBottomView*)view
{
    if([self.tableViewDelegate respondsToSelector:@selector(doLoadMore)]){
        [self.tableViewDelegate doLoadMore];
    }
    
}

- (BOOL)pullUpUpdateViewRefreshTableHeaderDataSourceIsLoading:(DragUpRefreshBottomView*)view
{
    if([self.tableViewDelegate respondsToSelector:@selector(delegateIsLoadingMore)]){
        return [self.tableViewDelegate delegateIsLoadingMore];
    }
    return NO;
}

//--------end--------//

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
