//
//  ScheduleDetailsWidget.m
//  MADContest
//
//  Created by JingFeng Ma on 2020/4/4.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import "ScheduleDetailsWidget.h"
#import "BaseTableView.h"
#import "ScheduleDetailsTableCellMenu.h"
#import "ScheduleDetailsTableCell.h"
#import "SearchResultCell.h"
#import "OrderDetailsTableCell.h"
#import "TableCellButton.h"
#import "Utils.h"

#define TABLE_CELL_MENU @"ScheduleDetailsTableCellMenu"
#define TABLE_CELL_SCHEDULE @"ScheduleDetailsTableCell"
#define TABLE_CELL_BUTTON @"TableCellButton"
#define TABLE_CELL_RESULT @"SearchResultCell"
#define TABLE_CELL_ORDER @"OrderDetailsTableCell"

#define MENU_EDIT_SCHEDULE 0
#define MENU_MY_SCHEDULE 1
#define MENU_AVAILABLE_SCHEDULES 2
#define MENU_MY_ORDER 3
#define MENU_QR_SCANNING 4
#define MENU_QR_CODE 5
#define MENU_OTHERS 6


@interface ScheduleDetailsWidget () <BaseTableViewProtocol, ScheduleDetailsTableCellProtocol, UISearchBarDelegate, ScheduleDetailsTableCellMenuProtocol>
@property (strong, nonatomic) IBOutlet BaseTableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *dragIndicatorLabel;
@property (nonatomic) NSInteger menuIndex;
@property (nonatomic) NSInteger menuIndexBackup;
@property (strong, nonatomic) NSArray<NSArray <NSString *> *> *schedulingTableData;
@property (strong, nonatomic) NSArray<NSArray <NSString *> *> *mySchedulesTableData;
@property (strong, nonatomic) NSMutableArray<NSArray <NSString *> *> *availableTableData;
@property (strong, nonatomic) NSMutableArray<NSArray <NSString *> *> *myOrdersTableData;
@property (strong, nonatomic) NSArray<NSArray <NSString *> *> *searchingTableData;
//@property (strong, nonatomic) NSArray<NSArray <NSString *> *> *tableDataBackup;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) NSArray<NSDictionary *> *locationResults;

@end

@implementation ScheduleDetailsWidget

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.clipsToBounds = YES;
    self.dragIndicatorLabel.clipsToBounds = YES;
    self.dragIndicatorLabel.layer.cornerRadius = 3.0f;
    self.view.layer.cornerRadius = 10.0f;
    self.locationResults = nil;
    self.menuIndex = 0;
    self.menuIndexBackup = -1;
    
    self.searchBar.delegate = self;
    self.schedule = [[Schedule alloc] init];
    self.mySchedules = [NSMutableArray arrayWithCapacity:0];
    self.availableSchedule = [NSMutableArray arrayWithCapacity:0];
    self.schedulingTableData = @[@[TABLE_CELL_MENU]];
    self.mySchedulesTableData = @[@[TABLE_CELL_MENU]];
    self.myOrdersTableData = [NSMutableArray arrayWithArray:@[@[TABLE_CELL_MENU]/*, @[TABLE_CELL_ORDER]*/]];
    self.availableTableData = [NSMutableArray arrayWithArray:@[@[TABLE_CELL_MENU]/*, @[TABLE_CELL_SCHEDULE, TABLE_CELL_SCHEDULE, TABLE_CELL_BUTTON]*/]];
//    self.tableDataBackup = nil;
    
    /** style参数，blur效果，可选:
     *  UIBlurEffectStyleExtraLight,
     *  UIBlurEffectStyleLight,
     *  UIBlurEffectStyleDark,
     *  UIBlurEffectStyleExtraDark   ios10之后
     *  UIBlurEffectStyleRegular     ios10之后
     *  UIBlurEffectStyleProminent   ios10之后
     */
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *HUDView = [[UIVisualEffectView alloc] initWithEffect:blur];
    HUDView.alpha = 0.98f;
    HUDView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:HUDView];
    [self.view sendSubviewToBack:HUDView];
    
    //移动的手势
    UIPanGestureRecognizer *panRcognize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRcognize.delegate = self;
    [panRcognize setEnabled:YES];
    [panRcognize delaysTouchesEnded];
    [panRcognize cancelsTouchesInView];
    [self.view addGestureRecognizer:panRcognize];
    
    //init base tableview
    [self.tableView setupTableViewDelegate:self];
    [self.tableView registerCellForNibName:TABLE_CELL_MENU forIdentifier:TABLE_CELL_MENU];
    [self.tableView registerCellForNibName:TABLE_CELL_SCHEDULE forIdentifier:TABLE_CELL_SCHEDULE];
    [self.tableView registerCellForNibName:TABLE_CELL_BUTTON forIdentifier:TABLE_CELL_BUTTON];
    [self.tableView registerCellForNibName:TABLE_CELL_RESULT forIdentifier:TABLE_CELL_RESULT];
    [self.tableView registerCellForNibName:TABLE_CELL_ORDER forIdentifier:TABLE_CELL_ORDER];
}

-(void)refreshTableView{
    [self.tableView reloadData];
}

-(NSArray<NSArray *> *)pichTableData{
    switch (self.menuIndex) {
        case MENU_EDIT_SCHEDULE:
            return self.schedulingTableData;
            break;
        case MENU_MY_SCHEDULE:{
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.mySchedules.count * 2];
            
            for(int i = 0; i < self.mySchedules.count; i++){
                [array addObjectsFromArray:@[TABLE_CELL_SCHEDULE, TABLE_CELL_SCHEDULE]];
            }
            self.mySchedulesTableData = @[@[TABLE_CELL_MENU], array];
            return self.mySchedulesTableData;
        }
            break;
        case MENU_AVAILABLE_SCHEDULES:
            [self.availableTableData removeAllObjects];
            [self.availableTableData addObject:@[TABLE_CELL_MENU]];
            
            if([self.availableSchedule count] > 0){
                
                for(int i = 0; i < self.availableSchedule.count; i++){
                    if([self.availableSchedule objectAtIndex:i].confirmed >= 2){
                        [self.availableTableData addObject:@[TABLE_CELL_SCHEDULE, TABLE_CELL_SCHEDULE]];
                    }else{
                        [self.availableTableData addObject:@[TABLE_CELL_SCHEDULE, TABLE_CELL_SCHEDULE, TABLE_CELL_BUTTON]];
                    }
                }
                
            }
            return self.availableTableData;
            break;
        case MENU_MY_ORDER:
            [self.myOrdersTableData removeAllObjects];
            [self.myOrdersTableData addObject:@[TABLE_CELL_MENU]];
            
            if([self.availableSchedule count] > 0){
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
                
                for(int i = 0; i < self.availableSchedule.count; i++){
                    if([self.availableSchedule objectAtIndex:i].confirmed >= 2)
                        [array addObject:TABLE_CELL_ORDER];
                }
                [self.myOrdersTableData addObject:array];
            }
            return self.myOrdersTableData;
            break;
        case MENU_QR_SCANNING:
            
            break;
        case MENU_QR_CODE:
            
            break;
        case MENU_OTHERS:
            
            break;
        case 99://搜索模式
            return self.searchingTableData;
            break;
        default:
            break;
    }
    return nil;
}

//set number of sections
-(NSInteger)numberOfSectionsInTableView:(UITableView* )tableView{
//    return [self.tableData count];
    return [[self pichTableData] count];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self showScheduleWidget:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([searchText length] > 0){
        [self.delegate searchLocationsWithString:searchText];
    }else{
//        self.tableData = [NSArray arrayWithArray:self.tableDataBackup];
//        self.tableDataBackup = nil;
        if(self.menuIndexBackup >= 0)
            self.menuIndex = self.menuIndexBackup;
        self.menuIndexBackup = -1;
        [self.tableView reloadData];
    }
}

-(void)showLocationSearchingResults:(NSArray<NSDictionary *> *)results withSourceString:(NSString *)source{
    if(![source isEqualToString:self.searchBar.text] || !results || results.count == 0){
        return;
    }
//    if(results && results.count > 0){
        self.locationResults = results;
        NSMutableArray *r = [NSMutableArray arrayWithCapacity:results.count];
        
        for (int i = 0; i < results.count; i++) {
            [r addObject:TABLE_CELL_RESULT];
        }
        
        if(self.menuIndexBackup < 0)
            self.menuIndexBackup = self.menuIndex;
//            self.tableDataBackup = [NSArray arrayWithArray:self.tableData];
        
        self.menuIndex = 99;
        self.searchingTableData = @[r];
//    }else{
//        self.tableData = [NSArray arrayWithArray:self.tableDataBackup];
//    }
    [self.tableView reloadData];
}

//return custom view for header. will be adjusted to default or specified header height
-(UIView* )tableView:(BaseTableView* )tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    
    if(!header){
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
        header.backgroundView.alpha = 0.0f;
        header.contentView.alpha = 0.0f;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, 20)];
        label.tag = 999;
        [label setFont:[UIFont systemFontOfSize:15.0f]];
        [label setTextColor:[UIColor grayColor]];
        [header addSubview:label];
    }
    UILabel *label = [header viewWithTag:999];
    if(section == 0 && [[[self pichTableData] objectAtIndex:0] containsObject:TABLE_CELL_MENU]){
        [label setText:@"Menus:"];
        return header;
    }
    if(section == 1 && [[[self pichTableData] objectAtIndex:1] containsObject:TABLE_CELL_SCHEDULE]){
        if(self.menuIndex == MENU_EDIT_SCHEDULE)
            [label setText:@"Editing Schedule:"];
        if(self.menuIndex == MENU_MY_SCHEDULE)
            [label setText:@"My Schedules:"];
        if(self.menuIndex == MENU_AVAILABLE_SCHEDULES)
            [label setText:@"Available Schedule for You:"];
        return header;
    }
    if(section == 1 && [[[self pichTableData] objectAtIndex:1] containsObject:TABLE_CELL_ORDER]){
        if(self.menuIndex == MENU_MY_ORDER)
            [label setText:@"My Orders:"];
        return header;
    }
    if(section == 0 && [[[self pichTableData] objectAtIndex:0] containsObject:TABLE_CELL_RESULT])
        return nil;
    
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor clearColor];
}

//return height custom view for header
-(CGFloat)tableView:(BaseTableView* )tableView heightForHeaderInSection:(NSInteger)section{
    return 16.0f;
}

-(CGFloat)tableView:(BaseTableView* )tableView heightForFooterInSection:(NSInteger)section{
    return 30.0f;
}

-(void)addScheduleStartAt:(CLLocationCoordinate2D)coordinate onTime:(int64_t)time location:(NSString *)location{
    self.schedule.startCoordinate = coordinate;
    self.schedule.startTime = time;
    self.schedule.startLocation = location;
    self.schedulingTableData = @[@[TABLE_CELL_MENU], @[TABLE_CELL_SCHEDULE]];
//    NSIndexSet *set = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, self.tableData.count - 1)];
//    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

-(void)addScheduleEndAt:(CLLocationCoordinate2D)coordinate onTime:(int64_t)time location:(NSString *)location{
    self.schedule.endCoordinate = coordinate;
    self.schedule.endTime = time;
    self.schedule.endLocation = location;
    self.schedulingTableData = @[@[TABLE_CELL_MENU], @[TABLE_CELL_SCHEDULE, TABLE_CELL_SCHEDULE, TABLE_CELL_BUTTON]];
//    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:1];
//    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

-(void)showLocationDetailsOnSearchBar:(NSString *)location{
    self.searchBar.text = location;
}

-(void)removeScheduleStarting{
    self.schedulingTableData = @[@[TABLE_CELL_MENU]];
    [self.tableView reloadData];
}

-(void)removeScheduleEnding{
    self.schedulingTableData = @[@[TABLE_CELL_MENU], @[TABLE_CELL_SCHEDULE]];
    [self.tableView reloadData];
}

//return a array of table view cell identifiers
//table view will order cells by model-array you returned
-(NSArray *)dataModelForTableView:(UITableView *)tableView forSection:(NSInteger)section{
//    if(section == 0)
//        return @[TABLE_CELL_MENU];
//    if(section == 1)
//        return @[];
    return [[self pichTableData] objectAtIndex:section];
}

//set height of cell
-(CGFloat)tableView:(BaseTableView* )tableView cellForIdentifier:(NSString *)identifier heightForRowAtIndexPath:(NSIndexPath* )indexPath{
    if([identifier isEqualToString:TABLE_CELL_MENU]){
        return 120.0f;
    }
    if([identifier isEqualToString:TABLE_CELL_SCHEDULE]){
        return 80.0f;
    }
    if([identifier isEqualToString:TABLE_CELL_BUTTON]){
        return 70.0f;
    }
    if([identifier isEqualToString:TABLE_CELL_RESULT]){
        return 70.0f;
    }
    if([identifier isEqualToString:TABLE_CELL_ORDER]){
        return 106.0f;
    }
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell cellForIdentifier:(NSString *)identifier forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([identifier isEqualToString:TABLE_CELL_MENU]){
        ScheduleDetailsTableCellMenu *c = (ScheduleDetailsTableCellMenu *)cell;
        [c prepareation];
    }
}

//return custom cell
-(UITableViewCell *)cellForTableView:(UITableView* )tableView cellForIdentifier:(NSString *)identifier cellForIndexPath:(NSIndexPath *)indexPath{
    
    id c = [tableView dequeueReusableCellWithIdentifier:identifier];
    [c setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if([identifier isEqualToString:TABLE_CELL_MENU]){
        ScheduleDetailsTableCellMenu *cell = c;
        cell.delegate = self;
        return cell;
    }
    if([identifier isEqualToString:TABLE_CELL_SCHEDULE]){
        ScheduleDetailsTableCell *cell = c;
        cell.delegate = self;
        cell.row = indexPath.row;
        
        Schedule *schedule = nil;
        switch (self.menuIndex) {
            case MENU_EDIT_SCHEDULE:
                schedule = self.schedule;
                cell.rightButton.hidden = NO;
                cell.rightButtonWidth.constant = 32.0f;
                break;
            case MENU_MY_SCHEDULE:
                schedule = [self.mySchedules objectAtIndex:indexPath.row / 2];
                cell.rightButton.hidden = YES;
                cell.rightButtonWidth.constant = 0.0f;
                break;
            case MENU_AVAILABLE_SCHEDULES:
                if(self.availableSchedule && [self.availableSchedule count] > 0 && indexPath.section > 0)
                    schedule = [self.availableSchedule objectAtIndex:indexPath.section - 1];
                cell.rightButton.hidden = YES;
                cell.rightButtonWidth.constant = 0.0f;
                break;
            default:
                break;
        }
        [cell layoutIfNeeded];
        cell.topSeperator.hidden = YES;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy HH:mm"];
        
        if(schedule){
            if(indexPath.row % 2 == 0){
                if(indexPath.row / 2 > 0){
                    cell.topSeperator.hidden = NO;
                }
                cell.bottomSeperator.hidden = NO;
                [cell.leftLabel setText:@"Start"];
                [cell.leftLabel setTextColor:[UIColor systemPurpleColor]];
                [cell.topLabel setText:[NSString stringWithFormat:@" at: %@", schedule.startLocation]];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:schedule.startTime];
                [cell.bottomLabel setText:[NSString stringWithFormat:@"on: %@", [formatter stringFromDate:date]]];
                
                if(self.menuIndex == MENU_AVAILABLE_SCHEDULES && schedule.confirmed >= 2){
                    cell.checkMarkImage.hidden = NO;
                }else{
                    cell.checkMarkImage.hidden = YES;
                }
            }else if(indexPath.row % 2 == 1){
                cell.bottomSeperator.hidden = YES;
                cell.checkMarkImage.hidden = YES;
                [cell.leftLabel setText:@"End"];
                [cell.leftLabel setTextColor:[UIColor systemTealColor]];
                [cell.topLabel setText:[NSString stringWithFormat:@" at: %@", schedule.endLocation]];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:schedule.endTime];
                [cell.bottomLabel setText:[NSString stringWithFormat:@"on: %@", [formatter stringFromDate:date]]];
            }
        }
        
        return cell;
    }
    if([identifier isEqualToString:TABLE_CELL_ORDER]){
        OrderDetailsTableCell *cell = c;
        Schedule *schedule = [self.availableSchedule objectAtIndex:indexPath.row];
        
        if(schedule.orderStatus >= 1){
            if(schedule.scheduleStatus >= 2){
                
                [cell.startLabel setText:schedule.startLocation];
                [cell.endLabel setText:schedule.endLocation];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd/MM/yyyy HH:mm"];
                
                NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:schedule.startTime];
                NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:schedule.endTime];
                [cell.timeLabel setText:[NSString stringWithFormat:@"%@ - %@",
                                         [formatter stringFromDate:startDate], [formatter stringFromDate:endDate]]];
                cell.stampButton.hidden = NO;
                
                switch (schedule.scheduleStatus) {
                    case 2:
                        [cell.stampButton setTitleColor:[UIColor systemRedColor] forState:UIControlStateNormal];
                        [cell.stampButton setTintColor:[UIColor systemRedColor]];
                        [cell.stampButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Not\nStarted"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [cell.stampButton setTitleColor:[UIColor systemOrangeColor] forState:UIControlStateNormal];
                        [cell.stampButton setTintColor:[UIColor systemOrangeColor]];
                        [cell.stampButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Delivering"] forState:UIControlStateNormal];
                        break;
                    case 4:
                        [cell.stampButton setTitleColor:[UIColor systemGreenColor] forState:UIControlStateNormal];
                        [cell.stampButton setTintColor:[UIColor systemGreenColor]];
                        [cell.stampButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Finished"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
            }
        }
        
        
        return cell;
    }
    if([identifier isEqualToString:TABLE_CELL_BUTTON]){
        TableCellButton *cell = c;
        
        if(self.menuIndex == MENU_EDIT_SCHEDULE){
            [cell.buttonLabel setText:@"Confirm to upload"];
            [cell.buttonLabel setBackgroundColor:[UIColor systemIndigoColor]];
        }
        if(self.menuIndex == MENU_AVAILABLE_SCHEDULES){
            [cell.buttonLabel setText:@"Confirm to start delivery!"];
            [cell.buttonLabel setBackgroundColor:[UIColor systemGreenColor]];
        }
        return cell;
    }
    if([identifier isEqualToString:TABLE_CELL_RESULT]){
        SearchResultCell *cell = c;
        
        NSDictionary *location = [self.locationResults objectAtIndex:indexPath.row];
        [cell.nameLabel setText:[location valueForKey:@"name"]];
        [cell.addressLabel setText:[location valueForKey:@"address"]];
        cell.location = [location objectForKey:@"location"];
        cell.region = [location objectForKey:@"region"];
        
        return cell;
    }
    return nil;
}

-(void)tableView:(BaseTableView* )tableView didSelectRowWithIdentifier:(NSString *)identifier atIndexPath:(NSIndexPath *)indexPath{
    
    if([identifier isEqualToString:TABLE_CELL_BUTTON]){
        
        if(self.menuIndex == MENU_EDIT_SCHEDULE){
            [self.delegate uploadSchedule:self.schedule];
        }
        if(self.menuIndex == MENU_AVAILABLE_SCHEDULES){
            [self.delegate confirmSchedule:[self.availableSchedule objectAtIndex:indexPath.section - 1]];
        }
    }
    if([identifier isEqualToString:TABLE_CELL_RESULT]){
        [self.searchBar setText:@""];
        [self searchBar:self.searchBar textDidChange:@""];
        
        CLLocation *location = [[self.locationResults objectAtIndex:indexPath.row] objectForKey:@"location"];
        CLRegion *region = [[self.locationResults objectAtIndex:indexPath.row] objectForKey:@"region"];
        if([self.searchBar isFirstResponder]){
            [self.searchBar resignFirstResponder];
        }
        [self showScheduleWidget:NO];
        [self.delegate searchResultDidClicked:location withRegion:region];
    }
    if([identifier isEqualToString:TABLE_CELL_SCHEDULE]){

        if(self.menuIndex == MENU_AVAILABLE_SCHEDULES){
            self.selectedSchedule = [self.availableSchedule objectAtIndex:indexPath.row];
        }
    }
}

-(void)pageWidgetCellBeenTapped:(NSInteger)index{
    
    
    switch (index) {
        case MENU_EDIT_SCHEDULE:
            self.menuIndex = index;
            [self.tableView reloadData];
            break;
        case MENU_MY_SCHEDULE:
            self.menuIndex = index;
            [self.tableView reloadData];
            break;
        case MENU_AVAILABLE_SCHEDULES:
            self.menuIndex = index;
            [self.tableView reloadData];
            break;
        case MENU_MY_ORDER:
            self.menuIndex = index;
            [self.tableView reloadData];
            break;
        case MENU_QR_SCANNING:
            [self.delegate showQRScanningView];
            break;
        case MENU_QR_CODE:
            [self.delegate showQRCode];
            break;
        default:
            break;
    }
}

-(void)scheduleDetailsTableCellCanceled:(NSInteger)row{
    if(row == 0){
        [self.delegate cancelStartAnnotation];
    }
    if(row == 1){
        [self.delegate cancelEndAnnotation];
    }
}

- (IBAction)backButtonClicked:(id)sender {
    [self.delegate backButtonClicked];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer{
    CGRect superBounds = self.view.superview.bounds;
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self.view];
        
        
        CGRect frame = CGRectMake(0,
                                  selfFrame.origin.y + translation.y,
                                  selfSize.width,
                                  superBounds.size.height - SCHEDULEDETAILSWIDGET_TOP_MARGIN);
        frame.origin.y = MAX(SCHEDULEDETAILSWIDGET_TOP_MARGIN, frame.origin.y);
        frame.origin.y = MIN(superBounds.size.height - SCHEDULEDETAILSWIDGET_BOTTOM_MARGIN, frame.origin.y);
        self.view.frame = frame;
        
        //关键，不设为零会不断递增，视图会突然不见
        [recognizer setTranslation:CGPointZero inView:self.view];
    }
    if(recognizer.state == UIGestureRecognizerStateEnded){
        CGPoint velocity = [recognizer velocityInView:self.view];
        NSLog(@"ending Y speed:%f", velocity.y);
        
        [self dragWidgetWithVelocity:velocity.y / 10];
    }
}

-(void)showScheduleWidget:(BOOL)show{
    CGRect superBounds = self.view.superview.bounds;
    
    float y;
    if(show){
        y = SCHEDULEDETAILSWIDGET_TOP_MARGIN;
    }else{
        y = superBounds.size.height - SCHEDULEDETAILSWIDGET_BOTTOM_MARGIN;
    }
    CGRect frame = CGRectMake(0,
                              y,
                              selfSize.width,
                              superBounds.size.height - SCHEDULEDETAILSWIDGET_TOP_MARGIN);
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:1.5f
          initialSpringVelocity:1.5f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.view.frame = frame;
    }
                     completion:^(BOOL finished) {
        
    }];
}

-(void)dragWidgetWithVelocity:(float)velocity{
    CGRect superBounds = self.view.superview.bounds;
    
    CGRect frame = CGRectMake(0,
                              selfFrame.origin.y + velocity,
                              selfSize.width,
                              superBounds.size.height - SCHEDULEDETAILSWIDGET_TOP_MARGIN);
    frame.origin.y = MAX(SCHEDULEDETAILSWIDGET_TOP_MARGIN, frame.origin.y);
    frame.origin.y = MIN(superBounds.size.height - SCHEDULEDETAILSWIDGET_BOTTOM_MARGIN, frame.origin.y);
    
    [UIView animateWithDuration:0.6f
                          delay:0.0f
         usingSpringWithDamping:0.4f
          initialSpringVelocity:1.5f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.view.frame = frame;
    }
                     completion:^(BOOL finished) {
        
    }];
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
