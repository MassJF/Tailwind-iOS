//
//  ScheduleDetailsTableCell.m
//  MADContest
//
//  Created by JingFeng Ma on 2020/4/6.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import "ScheduleDetailsTableCell.h"

@implementation ScheduleDetailsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (IBAction)cancelClicked:(id)sender {
    [self.delegate scheduleDetailsTableCellCanceled:self.row];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
