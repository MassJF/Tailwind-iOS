//
//  ScheduleDetailsTableCell.h
//  MADContest
//
//  Created by JingFeng Ma on 2020/4/6.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ScheduleDetailsTableCellProtocol <NSObject>

-(void)scheduleDetailsTableCellCanceled:(NSInteger)row;

@end

@interface ScheduleDetailsTableCell : UITableViewCell
@property (weak, nonatomic) id<ScheduleDetailsTableCellProtocol>delegate;
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UILabel *bottomLabel;
@property (strong, nonatomic) IBOutlet UILabel *topSeperator;
@property (strong, nonatomic) IBOutlet UILabel *bottomSeperator;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIImageView *checkMarkImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightButtonWidth;
@property (nonatomic) NSInteger row;
@end

NS_ASSUME_NONNULL_END
