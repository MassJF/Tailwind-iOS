//
//  MenuPageCell.h
//  MADContest
//
//  Created by JingFeng Ma on 2020/4/5.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import "PageWidgetCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MenuPageCell : PageWidgetCell
@property (strong, nonatomic) IBOutlet UILabel *iconLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *highlightMark;
@end

NS_ASSUME_NONNULL_END
