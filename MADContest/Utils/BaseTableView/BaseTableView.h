//
//  CentGroupedTableView.h
//  CaiKuMobile
//
//  Created by ma on 13-9-5.
//  Copyright (c) 2013年 wolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragDownRefreshHeaderView.h"
#import "DragUpRefreshBottomView.h"

@class BaseTableView;

@protocol BaseTableViewProtocol <NSObject>

@required

//set number of sections
-(NSInteger)numberOfSectionsInTableView:(BaseTableView* )tableView;

//return a array of table view cell identifiers
//table view will order cells by model-array you returned
-(NSArray<NSString *> *)dataModelForTableView:(BaseTableView *)tableView forSection:(NSInteger)section;

//return custom cell
-(UITableViewCell *)cellForTableView:(BaseTableView* )tableView cellForIdentifier:(NSString *)identifier cellForIndexPath:(NSIndexPath *)indexPath;

@optional

//set height of cell
//-(CGFloat)tableView:(BaseTableView* )tableView heightForRowAtIndexPath:(NSIndexPath* )indexPath;

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section;

//can be used for layout cell contenview for final display
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell cellForIdentifier:(NSString *)identifier forRowAtIndexPath:(NSIndexPath *)indexPath;

//set height of cell
-(CGFloat)tableView:(BaseTableView* )tableView cellForIdentifier:(NSString *)identifier heightForRowAtIndexPath:(NSIndexPath* )indexPath;

//-(CGFloat)tableView:(BaseTableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;

//do some initialize for cell
-(void)initializeForDefualtStyleCell:(UITableViewCell *)cell forIdentifier:(NSString *)identifier forTableView:(BaseTableView *)tablevView;

//return custom view for header. will be adjusted to default or specified header height
-(UIView* )tableView:(BaseTableView* )tableView viewForHeaderInSection:(NSInteger)section;

//return height custom view for header
-(CGFloat)tableView:(BaseTableView* )tableView heightForHeaderInSection:(NSInteger)section;

//return custom view for footer. will be adjusted to default or specified footer height
-(UIView* )tableView:(BaseTableView* )tableView viewForFooterInSection:(NSInteger)section;

//return height custom view for footer
-(CGFloat)tableView:(BaseTableView* )tableView heightForFooterInSection:(NSInteger)section;

//cause of drag down motion, tableView begins update
-(void)doUpdating;

//tells the tableview whether the delegate is updating, (ex.when drag off the tableview, but the delegate is still networking)
-(BOOL)delegateIsUpdating;

//cause of drag up motion, tableView begins load more
-(void)doLoadMore;

//tells the tableview whether the delegate is loading more, (ex.when drag up the tableview, but the delegate is still networking)
-(BOOL)delegateIsLoadingMore;

//register cells for nibs if need
//system default styles should not use this method for registration
//-(NSArray* )nibNamesNeedRegisterToTableView;

//do something when cell has been selected
-(void)tableView:(BaseTableView* )tableView didSelectRowWithIdentifier:(NSString *)identifier atIndexPath:(NSIndexPath* )indexPath;

//do something when cell has been unSelected
- (void)tableView:(BaseTableView* )tableView didDeselectRowAtIndexPath:(NSIndexPath* )indexPath;

//whether highlight the row
- (BOOL)tableView:(BaseTableView* )tableView shouldHighlightRowAtIndexPath:(NSIndexPath* )indexPath;

//set tableview cell whether can be edit
-(BOOL)setTableView:(BaseTableView* )tableView canEditRowAtIndexPath:(NSIndexPath* )indexPath;

//tableview has been edited
-(void)setTableView:(BaseTableView* )tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath* )indexPath;

//cell has been moved
-(void)setTableView:(BaseTableView* )tableView moveRowAtIndexPath:(NSIndexPath* )fromIndexPath toIndexPath:(NSIndexPath* )toIndexPath;

 //set tableview cell whether can be moved
-(BOOL)setTableView:(BaseTableView* )tableView canMoveRowAtIndexPath:(NSIndexPath* )indexPath;

-(void)scrollViewDidScroll:(UIScrollView* )scrollView;
-(void)scrollViewDidEndDragging:(UIScrollView* )scrollView willDecelerate:(BOOL)decelerate;

@end


@interface BaseTableView : UITableView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, DragDownRefreshHeaderViewProtocol, DragUpRefreshBottomViewProtocol>{
    BOOL supportDragDownRefresh;
    BOOL supportDragUpRefresh;
}

@property (strong, nonatomic) DragDownRefreshHeaderView* pullDownUpdateHeaderView;
@property (strong, nonatomic) DragUpRefreshBottomView* pullUpUpdateBottomView;

-(void)registerCellForDefaultStyle:(UITableViewCellStyle)style forIdentifier:(NSString *)identifier;
-(void)registerCellForNibName:(NSString *)nibName forIdentifier:(NSString *)identifier;
-(void)registerHeaderFooterForNibName:(NSString *)nibName forIdentifier:(NSString *)identifier;
-(void)setupTableViewDelegate:(id<BaseTableViewProtocol>)delegate;
-(void)doneUpdate;
-(void)doneLoadMore;
-(void)supportDragDownUpdate:(BOOL)supportDragDownUpdate supportDragUpLoadMore:(BOOL)supportDragUpLoadMore;
-(void)dragDownToReloadData;

@end
