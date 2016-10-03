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

#pragma mark - Constants

static const CGFloat kCalendarContentViewHeightInWeekView = 80;
static const CGFloat kCalendarContentViewHeightInMonthView = 280;

static const CGFloat kWeekViewComponents = 76; 

#pragma mark - Class Extension

@interface MainViewController ()

//JTCalendar properties
@property (nonatomic, weak) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (nonatomic, weak) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (nonatomic, strong) JTCalendarManager *calendarManager;

//XIB properties
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberOfGlassesLabel;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;


//XIB constraints
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *minusButtonYPosition;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *plusButtonYPosition;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *numberOfGlassesLabelYPosition;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *navigationBarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuYPosition;

//Gesture Recognizers
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeUpRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeDownRecognizer;

@end


#pragma mark - Class Implementation

@implementation MainViewController


#pragma mark - Initializers

- (instancetype)init {
    if (self = [super init]) {
    }
    
    return self;
}


#pragma mark - View Controller Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationBar.topItem.title = @"Progress";
    
    [self setupCalendar];
    
    [EntryManager setCurrentEntry:[[DateFormatterManager sharedManager] todayString]];
    
    _dateLabel.text = [NSString stringWithFormat:@"%@", [EntryManager currentEntry].date];
    _numberOfGlassesLabel.text = [self setNumberOfGlassesLabelText:[EntryManager currentEntry]];
    
    
    //Sets up the gesture recognizers and adds them to the view
    [self setupGestureRecognizers];
    
}


#pragma mark - JTCalendar Methods 

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView {
    NSString *dateString = [[[DateFormatterManager sharedManager] formatForEntryDate] stringFromDate:dayView.date];
    Entry *entry = [[EntryManager entryCache] objectForKey:dateString];
    
    if (entry) {
        [EntryManager setCurrentEntry:dateString];
        
        _dateLabel.text = [[EntryManager currentEntry] date];
        _numberOfGlassesLabel.text = [NSString stringWithFormat:@"%@", [[EntryManager currentEntry] numberOfGlasses]];
    }
    
    else {
        [EntryManager setCurrentEntry:dateString];
        _dateLabel.text = dateString;
        _numberOfGlassesLabel.text = @"No Entry";
    }
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView {
    
    NSString *dateString = [[[DateFormatterManager sharedManager] formatForEntryDate] stringFromDate:dayView.date];
    Entry *entry = [[EntryManager entryCache] objectForKey:dateString];
    
    dayView.hidden = NO;
    dayView.circleView.hidden = YES;
    
    //Tests if dayView.date is the same day as today
    if ([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]) {
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor orangeColor];
    }
    
    //Tests if an entry exists for dayView.date and if it's today's date
    else if (entry && ([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date] == NO)) {
        dayView.circleView.hidden = NO;
        dayView.textLabel.textColor = [UIColor whiteColor];
        
        switch ([entry.numberOfGlasses intValue]) {
            case 1:
                dayView.circleView.backgroundColor = [UIColor colorWithRed:133.0f/255.0f
                                                                     green:149.0f/255.0f
                                                                      blue:255.0f/255.0f
                                                                     alpha:1.0f];
                break;
            case 2:
                dayView.circleView.backgroundColor = [UIColor colorWithRed:74.0f/255.0f
                                                                     green:98.0f/255.0f
                                                                      blue:255.0f/255.0f
                                                                     alpha:1.0f];
                break;
            case 3:
                dayView.circleView.backgroundColor = [UIColor colorWithRed:23.0f/255.0f
                                                                     green:53.0f/255.0f
                                                                      blue:252.0f/255.0f
                                                                     alpha:1.0f];
                break;
            default:
                dayView.circleView.backgroundColor = [UIColor greenColor];
                break;
        }
    }
    
    //Tests if dayView.date is from another month and if an entry exists
    else if ([dayView isFromAnotherMonth] && (entry == NO)) {
        dayView.textLabel.textColor = [UIColor grayColor];
    }
    
    //Sets default appearance for every other dayView
    else {
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
}
-(UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar {
    JTCalendarDayView *view = [JTCalendarDayView new];
    view.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:13];
    
    return view;
}


-(UIView *)calendarBuildMenuItemView:(JTCalendarManager *)calendar {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 300, 100)];
    
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}


#pragma mark - UI Methods

- (IBAction)addOneToNumberOfGlassesButtonWasPressed {
    [[EntryManager sharedManager] addOneGlassToCurrentEntry];
    //self.numberOfGlassesLabel.text = [NSString stringWithFormat:@"%@", [EntryManager sharedManager].currentlySelectedEntry.numberOfGlasses];
    
    self.numberOfGlassesLabel.text = [NSString stringWithFormat:@"%@", [EntryManager currentEntry].numberOfGlasses];
    [_calendarManager reload];
}

- (IBAction)subtractOneFromNumberOfGlassesButtonWasPressed {
    [[EntryManager sharedManager] subtractOneGlassFromCurrentEntry];
    self.numberOfGlassesLabel.text = [NSString stringWithFormat:@"%@", [EntryManager currentEntry].numberOfGlasses];
    [_calendarManager reload];
}

- (NSString *)setNumberOfGlassesLabelText: (Entry *)entry {
    NSString *numberOfGlassesText;
    
    if (entry) {
        numberOfGlassesText = [NSString stringWithFormat:@"%@", entry.numberOfGlasses];
        return numberOfGlassesText;
    }
    
    else {
        numberOfGlassesText = @"No Entry Found";
        return numberOfGlassesText;
    }
}


#pragma mark - Gesture Recognizer Methods

- (void)swipeUp: (UISwipeGestureRecognizer *)sender {
    
    if (_calendarManager.settings.weekModeEnabled == NO) {
        _calendarManager.settings.weekModeEnabled = YES;
        [_calendarManager reload];
    }
    
    self.calendarContentViewHeight.constant = kCalendarContentViewHeightInWeekView;
    
    if (_calendarContentViewHeight.constant == kCalendarContentViewHeightInWeekView) {
        [UIView animateWithDuration:.5f animations:^void {
            _minusButtonYPosition.constant = 76.;
            _numberOfGlassesLabelYPosition.constant = 76.;
            _plusButtonYPosition.constant = 76.;
            _navigationBarHeight.constant = -64;
            _menuYPosition.constant = 70;
            
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)swipeDown: (UISwipeGestureRecognizer *)sender {
    if (_calendarManager.settings.weekModeEnabled == YES) {
        _calendarManager.settings.weekModeEnabled = NO;
        [_calendarManager reload];
    }
    
    self.calendarContentViewHeight.constant = kCalendarContentViewHeightInMonthView;
    
    if (_calendarContentViewHeight.constant == kCalendarContentViewHeightInMonthView) {
        
        [UIView animateWithDuration:.5f animations:^void {
            
            _numberOfGlassesLabelYPosition.constant = -100.;
            _navigationBarHeight.constant = 0;
            _plusButtonYPosition.constant = -100.;
            _minusButtonYPosition.constant = -100.;
            _menuYPosition.constant = 110;
            

            [self.view layoutIfNeeded];
        }];
    }
}

- (void)setupCalendar {
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
}

- (void)setupGestureRecognizers {
    _swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    _swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    
    _swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    _swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:_swipeUpRecognizer];
    [self.view addGestureRecognizer:_swipeDownRecognizer];
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
