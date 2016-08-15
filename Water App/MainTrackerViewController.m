//
//  MainTrackerViewController.m
//  Water App
//
//  Created by Immanuel Kannan on 12/08/2016.
//  Copyright © 2016 Immanuel. All rights reserved.
//

#import "MainTrackerViewController.h"
#import "DateFormatterManager.h"

@interface MainTrackerViewController ()

@end

@implementation MainTrackerViewController

- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (instancetype)initWithDate: (NSDate *)date {
    if (self = [super init]) {
        self.date = date;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Old way of setting the date in the MainTrackerViewController
    /*
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    if ([[formatter stringFromDate:self.date] isEqualToString:[formatter stringFromDate:[NSDate date]]]) {
        self.navigationItem.title = @"Today";
    } else {
        self.navigationItem.title = [formatter stringFromDate:self.date];
    }
    */
    
    if ([[[[DateFormatterManager sharedManager] mediumDate] stringFromDate:self.date] isEqualToString:[[[DateFormatterManager sharedManager] mediumDate] stringFromDate:[NSDate date]]]) {
        self.navigationItem.title = @"Today";
    } else {
        self.navigationItem.title = [[[DateFormatterManager sharedManager] mediumDate] stringFromDate:self.date];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
