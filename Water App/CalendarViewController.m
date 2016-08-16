//
//  CalendarViewController.m
//  Water App
//
//  Created by Immanuel Kannan on 13/08/2016.
//  Copyright © 2016 Immanuel. All rights reserved.
//

#import "CalendarViewController.h"
#import "MainTrackerViewController.h"
#import "DateFormatterManager.h"

@interface CalendarViewController ()

@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    self.navigationItem.title = @"Calendar";
    
    
    /*if ([[[[DateFormatterManager sharedManager] mediumDate] stringFromDate:self.date] isEqualToString:[[[DateFormatterManager sharedManager] mediumDate] stringFromDate:[NSDate date]]]) {
        self.navigationItem.title = @"Today";
    } else {
        self.navigationItem.title = [[[DateFormatterManager sharedManager] mediumDate] stringFromDate:self.date];
    }*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Calendar Methods
- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(UIView<JTCalendarDay> *)dayView {
    NSLog(@"%@", dayView.date);
    
    [self loadTrackerViewWithDate:dayView.date animated:YES];
}

#pragma mark - Other Methods
-(void)loadTrackerViewWithDate: (NSDate *)date animated:(BOOL)animated {
    MainTrackerViewController *mtvc = [[MainTrackerViewController alloc] initWithDate:date];
    [self.navigationController pushViewController:mtvc animated:animated];
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
