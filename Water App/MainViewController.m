//
//  MainViewController.m
//  Water App
//
//  Created by Immanuel Kannan on 15/08/2016.
//  Copyright © 2016 Immanuel. All rights reserved.
//

#import "MainViewController.h"
#import "DateFormatterManager.h"
#import "EntryManager.h"
#import "Entry.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (instancetype)init {
    if (self = [super init]) {
    }
    
    return self;
}

#pragma mark - View Controller Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    //Sets initial values for _dateLabel and _numberOfGlassesLabel
    _dateLabel.text = [[EntryManager sharedManager] entryForToday].date;
    _numberOfGlassesLabel.text = [NSString stringWithFormat:@"%@", [[EntryManager sharedManager] entryForToday].numberOfGlasses];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - JTCalendar Methods 

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView {
    NSString *dateString = [[[DateFormatterManager sharedManager] formatForEntryDate] stringFromDate:dayView.date];
    Entry *entry = [[EntryManager sharedManager] entryWithDate:dateString];
    
    _dateLabel.text = [[[DateFormatterManager sharedManager] formatWithMediumStyle] stringFromDate:dayView.date];
    _numberOfGlassesLabel.text = [NSString stringWithFormat:@"%@", entry.numberOfGlasses];
    
    NSLog(@"Currently Selected: %@", entry.date);
}

-(void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView {
    
    //Makes dates from another month a light gray color
    if ([dayView isFromAnotherMonth]) {
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    //Gives todays date a red circular background
    if ([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]) {
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    
    
}

#pragma mark - UI Methods

- (IBAction)incrementNumberOfGlasses {
    [[EntryManager sharedManager] addOneGlassToCurrentEntry];
    self.numberOfGlassesLabel.text = [NSString stringWithFormat:@"%@", [EntryManager sharedManager].currentlySelectedEntry.numberOfGlasses];
}

- (IBAction)decrementNumberOfGlasses {
    [[EntryManager sharedManager] subtractOneGlassFromCurrentEntry];
    self.numberOfGlassesLabel.text = [NSString stringWithFormat:@"%@", [EntryManager sharedManager].currentlySelectedEntry.numberOfGlasses];
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
