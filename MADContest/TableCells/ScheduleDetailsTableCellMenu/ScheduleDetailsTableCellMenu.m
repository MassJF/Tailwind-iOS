//
//  ScheduleDetailsTableCellMenuTableViewCell.m
//  MADContest
//
//  Created by JingFeng Ma on 2020/4/5.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import "ScheduleDetailsTableCellMenu.h"
#import "PageWidget.h"
#import "MenuPageCell.h"
#import "Utils.h"

@interface ScheduleDetailsTableCellMenu () <PageWidgetCellProtocol>

@property (strong, nonatomic) PageWidget *pageWidget;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray<MenuPageCell *> *cellsArray;

@end

@implementation ScheduleDetailsTableCellMenu

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.pageWidget = [[PageWidget alloc] initWithScrollView:self.scrollView pageControll:nil pagingEnabled:NO];
    self.cellsArray = [[NSMutableArray alloc] init];
    [self.scrollView setContentInset:UIEdgeInsetsMake(0, 15.0f, 0, 15.0f)];
    self.selectedIndex = 0;
    
    for(int i = 0; i < 7; i++){
        MenuPageCell *p = [[MenuPageCell alloc] initWithNibName:@"MenuPageCell" bundle:nil withIndex:i];
        p.delegate = self;
        [self.cellsArray addObject:p];
    }
}

-(void)highlightCellAtIndex:(NSInteger)index{
    for(int i = 0; i < self.cellsArray.count; i++){
        [self.cellsArray objectAtIndex:i].highlightMark.hidden = (i != index);
    }
}

-(void)pageWidgetCellBeenTapped:(NSInteger)atIndex{
    self.selectedIndex = atIndex;
    
    [self highlightCellAtIndex:atIndex];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageWidgetCellBeenTapped:)]){
        [self.delegate pageWidgetCellBeenTapped:atIndex];
    }
}

-(void)prepareation{
    CGFloat width = self.contentView.bounds.size.height - 6;
    self.scrollView.frame = self.contentView.bounds;
    CGRect cellFrame = CGRectMake(0, 0, width - 25, width);
    
    for(MenuPageCell *c in self.cellsArray){
        c.view.frame = cellFrame;
        
        [c.highlightMark.layer removeAllAnimations];
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
        rotationAnimation.duration = 30;
        rotationAnimation.repeatCount = HUGE_VALF;
        [c.highlightMark.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
    }
    [self.cellsArray objectAtIndex:self.selectedIndex].highlightMark.hidden = NO;
    
    [[self.cellsArray objectAtIndex:0].iconLabel setText:@"AS"];
    [[self.cellsArray objectAtIndex:0].iconLabel setBackgroundColor:[UIColor systemIndigoColor]];
    [[self.cellsArray objectAtIndex:0].highlightMark setTintColor:[UIColor systemIndigoColor]];
    [[self.cellsArray objectAtIndex:0].titleLabel setText:@"Adding Schedules"];
    
    [[self.cellsArray objectAtIndex:1].iconLabel setText:@"MS"];
    [[self.cellsArray objectAtIndex:1].iconLabel setBackgroundColor:[UIColor systemPinkColor]];
    [[self.cellsArray objectAtIndex:1].highlightMark setTintColor:[UIColor systemPinkColor]];
    [[self.cellsArray objectAtIndex:1].titleLabel setText:@"My Schedules"];
    
    [[self.cellsArray objectAtIndex:2].iconLabel setText:@"AS"];
    [[self.cellsArray objectAtIndex:2].iconLabel setBackgroundColor:[UIColor systemGreenColor]];
    [[self.cellsArray objectAtIndex:2].highlightMark setTintColor:[UIColor systemGreenColor]];
    [[self.cellsArray objectAtIndex:2].titleLabel setText:@"Available Service"];
    
    [[self.cellsArray objectAtIndex:3].iconLabel setText:@"MO"];
    [[self.cellsArray objectAtIndex:3].iconLabel setBackgroundColor:[UIColor systemYellowColor]];
    [[self.cellsArray objectAtIndex:3].highlightMark setTintColor:[UIColor systemYellowColor]];
    [[self.cellsArray objectAtIndex:3].titleLabel setText:@"My Order"];
    
    [[self.cellsArray objectAtIndex:4].iconLabel setText:@"QS"];
    [[self.cellsArray objectAtIndex:4].iconLabel setBackgroundColor:[UIColor systemRedColor]];
    [[self.cellsArray objectAtIndex:4].highlightMark setTintColor:[UIColor systemRedColor]];
    [[self.cellsArray objectAtIndex:4].titleLabel setText:@"QR Scanning"];
    
    [[self.cellsArray objectAtIndex:5].iconLabel setText:@"MQ"];
    [[self.cellsArray objectAtIndex:5].iconLabel setBackgroundColor:[UIColor systemTealColor]];
    [[self.cellsArray objectAtIndex:5].highlightMark setTintColor:[UIColor systemTealColor]];
    [[self.cellsArray objectAtIndex:5].titleLabel setText:@"My QR Code"];
    
    [[self.cellsArray objectAtIndex:6].iconLabel setText:@"O"];
    [[self.cellsArray objectAtIndex:6].iconLabel setBackgroundColor:[UIColor systemOrangeColor]];
    [[self.cellsArray objectAtIndex:6].highlightMark setTintColor:[UIColor systemOrangeColor]];
    [[self.cellsArray objectAtIndex:6].titleLabel setText:@"Others.."];
    
    [self.pageWidget setViewsFromArray:self.cellsArray shouldLoop:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
