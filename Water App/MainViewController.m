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

static const float goal = 8.0;

#pragma mark - Class Extension

@interface MainViewController ()

//FSCalendar Properties
@property (nonatomic, strong) IBOutlet FSCalendar *calendar;

// UAProgressView Properties
@property (nonatomic, strong) IBOutlet UAProgressView *progressView;
@property (nonatomic, strong) UILabel *progressViewTextLabel;

//XIB properties
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *calendarHeightConstraint;

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
    [self setupProgressView];
    [self setupNavigationBar];
    [[EntryManager sharedManager] entryForToday];
    
    _dateLabel.text = [[DateFormatterManager sharedManager] convertEntryDateToStylishDate:[[EntryManager currentEntry] date]];
    _progressViewTextLabel.text = [NSString stringWithFormat:@"%@", [EntryManager currentEntry].numberOfGlasses];
    
}


#pragma mark - FSCalendar methods

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    
    NSLog(@"%f", calendar.frame.size.height);
}

-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date {
    NSString *dateString = [[[DateFormatterManager sharedManager] formatForEntryDate] stringFromDate:date];
    Entry *entry = [[EntryManager entryCache] objectForKey:dateString];
    
    if ([entry.numberOfGlasses isEqualToNumber:[NSNumber numberWithInt:0]]) {
        return [UIColor greenColor];
    } else {
        return [UIColor clearColor];
    }
}

-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    NSString *dateString = [[[DateFormatterManager sharedManager] formatForEntryDate] stringFromDate:date];
    
    [EntryManager setCurrentEntry:dateString];
    self.progressViewTextLabel.text = [NSString stringWithFormat:@"%@", [[EntryManager currentEntry] numberOfGlasses]];
    
    if ([EntryManager currentEntry]) {
        self.dateLabel.text = [[DateFormatterManager sharedManager] convertEntryDateToStylishDate:dateString];
    } else {
        self.progressViewTextLabel.text = @"0";
        self.dateLabel.text = [[DateFormatterManager sharedManager] convertEntryDateToStylishDate:dateString];
    }
    
    [self.progressView setProgress:([[EntryManager currentEntry].numberOfGlasses floatValue] / goal) animated:YES];
    NSLog(@"%@", self.progressViewTextLabel.text);
    
    [_calendar reloadData];
}

// Sets the color of the circle that displays the number of glasses the user has drunk
-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date{
    NSString *dateString = [[[DateFormatterManager sharedManager] formatForEntryDate] stringFromDate:date];
    Entry *entry = [[EntryManager entryCache] objectForKey:dateString];
    
    if (entry) {
        if ([entry.numberOfGlasses isEqualToNumber:[NSNumber numberWithInteger:1]]) {
            return [UIColor colorWithRed:34./255. green:167./255. blue:240./255. alpha:1];
        }
        else if ([entry.numberOfGlasses isEqualToNumber:[NSNumber numberWithInteger:2]]) {
            return  [UIColor colorWithRed:65./255. green:131./255. blue:215./255. alpha:1];
        }
        else if ([entry.numberOfGlasses isEqualToNumber:[NSNumber numberWithInteger:3]]) {
            return  [UIColor colorWithRed:31./255. green:58./255. blue:147./255. alpha:1];
        }
        else {
            return [UIColor clearColor];
        }
    }
    
    else {
        return [UIColor clearColor];
    }

}

// Sets the color of the text that displays the date on the calendar
-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
    NSString *dateString = [[[DateFormatterManager sharedManager] formatForEntryDate] stringFromDate:date];
    Entry *entry = [[EntryManager entryCache] objectForKey:dateString];
    
    if (entry && (entry.numberOfGlasses > [NSNumber numberWithInteger:0])) {
        return [UIColor whiteColor];
    } else {
        return [UIColor blackColor];
    }
}

// Sets the color of the selection circle.
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date {
    return  [UIColor colorWithRed:155./255. green:89./255. blue:182./255. alpha:1];
}


#pragma mark - Setup methods

- (void) setupCalendar {
    _calendar.scopeGesture.enabled = YES;
    _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    [_calendar selectDate:[NSDate date]];
    
    self.calendar.appearance.headerTitleFont = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self.calendar.appearance.headerTitleColor = [UIColor blackColor];
    self.calendar.appearance.weekdayFont = [UIFont fontWithName:@"HelveticaNeue" size:5];
    self.calendar.appearance.weekdayTextColor = [UIColor blackColor];
}

- (void)setupProgressView {
    self.progressView.fillOnTouch = NO;
    self.progressView.tintColor = [UIColor colorWithRed:47./255. green:112./255. blue:224./255. alpha:1.];
    self.progressView.borderWidth = 0.0;
    self.progressView.lineWidth = 5.5;
    
    self.progressViewTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 32.0)];
    self.progressViewTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    self.progressViewTextLabel.textAlignment = NSTextAlignmentCenter;
    self.progressViewTextLabel.textColor = self.progressView.tintColor;
    self.progressViewTextLabel.backgroundColor = [UIColor clearColor];
    self.progressView.centralView = _progressViewTextLabel;
}

- (void)setupNavigationBar {
    self.navigationBar.barTintColor = [UIColor colorWithRed:47./255. green:112./255. blue:224./255. alpha:1.];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                               NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:20]};
}


#pragma mark - UI Methods

- (IBAction)addOneToNumberOfGlassesButtonWasPressed {
    NSString *dateString = self.dateLabel.text;
    
    /*
        If the current entry doesn't exist, create an entry and
        set it as the current entry. Increment the numberOfGlasses
        and then set the progressViewTextLabel text.
    */
    if ([EntryManager currentEntry] == nil) {
        [[EntryManager sharedManager] createEntryForDate:[[DateFormatterManager sharedManager] convertStylishDateToEntryDate:dateString]];
        [EntryManager setCurrentEntry:[[DateFormatterManager sharedManager] convertStylishDateToEntryDate:dateString]];
        
        [[EntryManager sharedManager] addOneGlassToCurrentEntry];
        self.progressViewTextLabel.text = [NSString stringWithFormat:@"%@", [EntryManager currentEntry].numberOfGlasses];
        
    }
    
    /*
        If a current entry does exist, increment the numberOfGlasses
        and set the progressViewTextLabel text
    */
    else {
        [[EntryManager sharedManager] addOneGlassToCurrentEntry];
        self.progressViewTextLabel.text = [NSString stringWithFormat:@"%@", [EntryManager currentEntry].numberOfGlasses];
    }
    
    //  Set the progress of the progressView
    [self.progressView setProgress:([[EntryManager currentEntry].numberOfGlasses floatValue] / goal) animated:YES];
    
}

- (IBAction)subtractOneFromNumberOfGlassesButtonWasPressed {
    [[EntryManager sharedManager] subtractOneGlassFromCurrentEntry];
    self.progressViewTextLabel.text = [NSString stringWithFormat:@"%@", [EntryManager currentEntry].numberOfGlasses];
    
    if ([[EntryManager currentEntry].numberOfGlasses isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [[EntryManager entryCache] removeObjectForKey:[EntryManager currentEntry].date];
        [[EntryManager getContext] deleteObject:[EntryManager currentEntry]];
        [EntryManager setCurrentEntry:nil];
        
    }
    
    [self.progressView setProgress:([[EntryManager currentEntry].numberOfGlasses floatValue] / goal) animated:YES];
    
}

@end
