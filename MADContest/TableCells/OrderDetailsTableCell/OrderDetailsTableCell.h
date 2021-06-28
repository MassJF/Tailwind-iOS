//
//  OrderDetailsTableCell.h
//  MADContest
//
//  Created by JingFeng Ma on 2020/4/15.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailsTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *startLabel;
@property (strong, nonatomic) IBOutlet UILabel *endLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *stampButton;

@end

NS_ASSUME_NONNULL_END
