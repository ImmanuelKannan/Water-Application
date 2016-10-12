//
//  DateFormatterManager.m
//  Water App
//
//  Created by Immanuel Kannan on 14/08/2016.
//  Copyright © 2016 Immanuel. All rights reserved.
//

#import "DateFormatterManager.h"

@interface DateFormatterManager ()

@property (nonatomic, strong) NSDateFormatter *shortDateFormatter;
@property (nonatomic, strong) NSDateFormatter *formatWithMediumStyle;
@property (nonatomic, strong) NSDateFormatter *formatForEntryDate;

@property (nonatomic, strong) NSDateFormatter *format;
@property (nonatomic, strong) NSDateFormatter *stylishFormat;
@property (nonatomic, strong) NSDateFormatter *entryFormat;

@end

@implementation DateFormatterManager

#pragma mark - Constructors & Initializers

+ (instancetype)sharedManager {
    static DateFormatterManager *formatterManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        formatterManager = [[self alloc] init];
    });
    
    return formatterManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _shortDateFormatter = [[NSDateFormatter alloc] init];
        _formatWithMediumStyle = [[NSDateFormatter alloc] init];
        _formatForEntryDate = [[NSDateFormatter alloc] init];
        
        _stylishFormat = [[NSDateFormatter alloc] init];
        _stylishFormat.dateFormat = @"dd MMM, yyyy";
        
        _entryFormat = [[NSDateFormatter alloc] init];
        _entryFormat.dateFormat = @"yyyy-MM-dd";
    }
    
    return self;
}

#pragma mark - Other Methods

- (NSDateFormatter *)shortDate {
    _shortDateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    return _shortDateFormatter;
}

- (NSDateFormatter *)formatWithMediumStyle {
    _formatWithMediumStyle.dateStyle = NSDateFormatterMediumStyle;
    
    return _formatWithMediumStyle;
}

- (NSDateFormatter *)formatForEntryDate {
    _formatForEntryDate.dateFormat = @"yyyy-MM-dd";
    
    return _formatForEntryDate;
}

- (NSString *)todayString {
    
    NSString *todayDateString = [[[DateFormatterManager sharedManager] formatForEntryDate] stringFromDate:[NSDate date]];
    
    return todayDateString;
}

- (NSString *)convertEntryDateToStylishDate: (NSString *)entryDate {
    
    /*
        Converts a dateString from one with an entry
        format (e.g. 2016-08-24) to one with a more 
        readable, stylish format (e.g. 24 August, 2016)
    */
    
    NSDate *tempDate = [_entryFormat dateFromString:entryDate];
    
    NSString *stylishDate = [_stylishFormat stringFromDate:tempDate];
    
    return stylishDate;
}

- (NSString *)convertStylishDateToEntryDate: (NSString *)stylishDate {
    
    /*
        Converts a dateString from one with a more
        readable, stylish format (e.g. 24 August, 2016)
        to an entry format (e.g. 2016-08-24)
    */
    
    NSDate *tempDate = [_stylishFormat dateFromString:stylishDate];
    
    NSString *entryDate = [_entryFormat stringFromDate:tempDate];
    
    return entryDate;
}

@end
