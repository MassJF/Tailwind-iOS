//
//  OrderDetailsTableCell.m
//  MADContest
//
//  Created by JingFeng Ma on 2020/4/15.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import "OrderDetailsTableCell.h"

@implementation OrderDetailsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.stampButton.transform = CGAffineTransformMakeRotation (-M_PI_2 * 1 / 3);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
