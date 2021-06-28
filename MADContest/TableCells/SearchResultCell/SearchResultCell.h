//
//  SearchResultCell.h
//  MADContest
//
//  Created by JingFeng Ma on 2020/4/9.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) CLRegion *region;

@end

NS_ASSUME_NONNULL_END
