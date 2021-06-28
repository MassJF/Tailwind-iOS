//
//  TableCellButton.m
//  MADContest
//
//  Created by JingFeng Ma on 2020/4/7.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import "TableCellButton.h"

@implementation TableCellButton

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.buttonLabel.layer.cornerRadius = 5.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
