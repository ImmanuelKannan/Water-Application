//
//  CalendarViewController.h
//  Water App
//
//  Created by Immanuel Kannan on 13/08/2016.
//  Copyright © 2016 Immanuel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>

@interface CalendarViewController : UIViewController <JTCalendarDelegate>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

- (void)loadTrackerViewWithDate: (NSDate *)date animated: (BOOL)animated;

@end
