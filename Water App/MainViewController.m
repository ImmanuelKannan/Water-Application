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
    _dateLabel.text = [[[DateFormatterManager sharedManager] formatWithMediumStyle] stringFromDate:[NSDate date]];
    _numberOfGlassesLabel.text = [NSString stringWithFormat:@"%@", [[EntryManager sharedManager] entryForToday].numberOfGlasses];
    
    _swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    _swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    
    _swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    _swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:_swipeUpRecognizer];
    [self.view addGestureRecognizer:_swipeDownRecognizer];
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
    
    NSLog(@"Currently Selected: %@", dayView.date);
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView {
    
    dayView.hidden = NO;
    
    if ([dayView isFromAnotherMonth]) {
        dayView.hidden = YES;
    } else if ([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]) {
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithRed:0. green:231. blue:255. alpha:1];
    } else {
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = [UIColor blackColor];
        
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

#pragma mark - Gesture Recognizer Methods

- (void)didChangeMode: (UISwipeGestureRecognizer *)sender {
    
    /*
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
   
    
    
    [_calendarManager reload];
    
    CGFloat newHeight = 300;
    if (_calendarManager.settings.weekModeEnabled) {
        newHeight = 80;
    }
    
    self.calendarContentViewHeight.constant = newHeight;
    [self.view layoutIfNeeded];
     
     */
    
    /*
    [_calendarManager reload];

    CGFloat fullSizeHeight = 300;
    CGFloat weekSizeHeight = 80;
    
    if (sender.direction == UISwipeGestureRecognizerDirectionUp && _calendarManager.settings.weekModeEnabled == NO) {
        _calendarManager.settings.weekModeEnabled = YES;
        
        self.calendarContentViewHeight.constant = weekSizeHeight;
        [self.view layoutIfNeeded];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionDown && _calendarManager.settings.weekModeEnabled == YES) {
        _calendarManager.settings.weekModeEnabled = NO;
        
        self.calendarContentViewHeight.constant = fullSizeHeight;
        [self.view layoutIfNeeded];
    }
    */
}

- (void)swipeUp: (UISwipeGestureRecognizer *)sender {
    
    if (_calendarManager.settings.weekModeEnabled == NO) {
        _calendarManager.settings.weekModeEnabled = YES;
        [_calendarManager reload];
    }
    
    self.calendarContentViewHeight.constant = 80;
}

- (void)swipeDown: (UISwipeGestureRecognizer *)sender {
    if (_calendarManager.settings.weekModeEnabled == YES) {
        _calendarManager.settings.weekModeEnabled = NO;
        [_calendarManager reload];
    }
    
    self.calendarContentViewHeight.constant = 300;
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
