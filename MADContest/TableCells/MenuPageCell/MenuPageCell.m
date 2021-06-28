//
//  MenuPageCell.m
//  MADContest
//
//  Created by JingFeng Ma on 2020/4/5.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import "MenuPageCell.h"

@interface MenuPageCell ()

@end

@implementation MenuPageCell

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.iconLabel.layer.cornerRadius = self.iconLabel.bounds.size.width / 2;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
