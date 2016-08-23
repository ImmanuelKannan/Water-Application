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

@end
