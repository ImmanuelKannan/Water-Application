//
//  MainTrackerViewController.h
//  Water App
//
//  Created by Immanuel Kannan on 12/08/2016.
//  Copyright © 2016 Immanuel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTrackerViewController : UIViewController

@property (nonatomic, strong) NSDate *date;

- (instancetype)initWithDate: (NSDate *)date;

@end
