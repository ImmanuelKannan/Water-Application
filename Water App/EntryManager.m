//
//  EntryManager.m
//  Water App
//
//  Created by Immanuel Kannan on 12/08/2016.
//  Copyright © 2016 Immanuel. All rights reserved.
//

#import "EntryManager.h"
#import "Entry.h"
#import "DateFormatterManager.h"
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
        if (_context) {
            NSLog(@"NSManagedObjectContext is initialized");
        } else {
            NSLog(@"!! - NSManagedObjectContext IS NOT initialized - !!");
        }
    }
    
    return self;
}

#pragma mark - Entry and entry manipulation methods

- (Entry *)entryForToday {
    return [self entryWithDate:[[[DateFormatterManager sharedManager] mediumDate] stringFromDate:[NSDate date]]];
}

-(Entry *)entryWithDate: (NSString *)date {
    NSArray *fetchedObjects = [[NSArray alloc] init];
    NSManagedObjectContext *context = [self getContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@", date];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    if ((fetchedObjects = [context executeFetchRequest:fetchRequest error:&error]).count == 1) {
        NSLog(@"Object found");
        return [fetchedObjects objectAtIndex:0];
    } else {
        NSLog(@"Making a new object");
        Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:context];
        entry.date = date;
        entry.numberOfGlasses = 0;
        return entry;
    }
}

- (void)addOneGlassToEntry {
    
}


#pragma mark - Core Data Methods

//Returns UIApplication's NSManagedObjectContext
- (NSManagedObjectContext *)getContext {
    NSManagedObjectContext *managedObjectContext = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    return managedObjectContext;
}

@end
