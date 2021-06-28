//
//  ScheduleDetailsTableCellMenuTableViewCell.h
//  MADContest
//
//  Created by JingFeng Ma on 2020/4/5.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ScheduleDetailsTableCellMenuProtocol <NSObject>

-(void)pageWidgetCellBeenTapped:(NSInteger)index;

@end

@interface ScheduleDetailsTableCellMenu : UITableViewCell

@property (weak, nonatomic) id<ScheduleDetailsTableCellMenuProtocol>delegate;
@property (nonatomic) NSInteger selectedIndex;

-(void)prepareation;
-(void)highlightCellAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
