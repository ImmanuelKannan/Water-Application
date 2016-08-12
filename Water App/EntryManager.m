//
//  EntryManager.m
//  Water App
//
//  Created by Immanuel Kannan on 12/08/2016.
//  Copyright © 2016 Immanuel. All rights reserved.
//

#import "EntryManager.h"
#import "UIKit/UIKit.h"


@interface EntryManager ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end


@implementation EntryManager

#pragma mark - Constructor & Initializer Methods

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
        self.context = [self getContext];
        NSLog(@"Entry Manager initialized");
    }
    
    return self;
}


#pragma mark - Core Data Methods

//Returns the UIApplication's NSManagedObjectContext
- (NSManagedObjectContext *)getContext {
    NSManagedObjectContext *managedObjectContext = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    return managedObjectContext;
}

@end
