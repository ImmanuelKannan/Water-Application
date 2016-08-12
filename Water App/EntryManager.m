//
//  EntryManager.m
//  Water App
//
//  Created by Immanuel Kannan on 12/08/2016.
//  Copyright © 2016 Immanuel. All rights reserved.
//

#import "EntryManager.h"

@implementation EntryManager

+ (instancetype)sharedManager {
    static EntryManager *entryManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        entryManager = [[self alloc] init];
    });
    
    return entryManager;
}

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"Entry Manager initialized");
    }
    
    return self;
}

@end
