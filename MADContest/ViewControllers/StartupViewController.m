//
//  StartupViewController.m
//  MADContest
//
//  Created by JingFeng Ma on 2020/2/25.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import "StartupViewController.h"
#import "MapViewController.h"
#import "../Utils/Utils.h"

@interface StartupViewController ()
@property(strong, nonatomic) MapViewController *mapviewController;

@end

@implementation StartupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mapviewController = [GET_STORYBOARD(@"Main") instantiateViewControllerWithIdentifier:@"mapViewControllerSID"];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (IBAction)deliverymanClicked:(id)sender {
    [self.navigationController pushViewController:_mapviewController animated:YES];
}

- (IBAction)senderClicked:(id)sender {
    [self.navigationController pushViewController:_mapviewController animated:YES];
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
