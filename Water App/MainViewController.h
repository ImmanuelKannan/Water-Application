//
//  MainViewController.h
//  Water App
//
//  Created by Immanuel Kannan on 15/08/2016.
//  Copyright © 2016 Immanuel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>

@interface MainViewController : UIViewController <JTCalendarDelegate>

//JTCalendar properties
@property (nonatomic, weak) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (nonatomic, weak) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (nonatomic, strong) JTCalendarManager *calendarManager;

//XIB properties
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberOfGlassesLabel;

@end
