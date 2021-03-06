//
//  DateFormatterManager.h
//  Water App
//
//  Created by Immanuel Kannan on 14/08/2016.
//  Copyright © 2016 Immanuel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatterManager : NSObject

+ (instancetype)sharedManager;
- (NSDateFormatter *)shortDate;
- (NSDateFormatter *)formatWithMediumStyle;
- (NSDateFormatter *)formatForEntryDate;

- (NSString *)todayString;

- (NSString *)convertEntryDateToStylishDate: (NSString *)entryDate;
- (NSString *)convertStylishDateToEntryDate: (NSString *)stylishDate;

@end
