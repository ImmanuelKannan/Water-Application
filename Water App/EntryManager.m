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

@property (nonatomic, strong) NSArray *fetchedObjects;
@property (nonatomic, strong) NSEntityDescription *entityDescription;

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
        
        _fetchedObjects = [[NSArray alloc] init];
        _entityDescription = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.context];
        _currentlySelectedEntry = [self entryWithDate:[[[DateFormatterManager sharedManager] formatForEntryDate] stringFromDate:[NSDate date]]];
        if (_currentlySelectedEntry) {
            NSLog(@"There is an entry selected");
        }
    }
    
    return self;
}

#pragma mark - Entry and entry manipulation methods

- (Entry *)entryForToday {
    return [self entryWithDate:[[[DateFormatterManager sharedManager] formatForEntryDate] stringFromDate:[NSDate date]]];
}

- (Entry *)entryWithDate: (NSString *)date {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@", date];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:self.entityDescription];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    if ((self.fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error]).count == 1) {
        NSLog(@"Entry with date: %@ found", date);
        _currentlySelectedEntry = [self.fetchedObjects objectAtIndex:0];
        return _currentlySelectedEntry;
    } else {
        NSLog(@"Creating new entry with date: %@", date);
        _currentlySelectedEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:self.context];
        _currentlySelectedEntry.date = date;
        _currentlySelectedEntry.numberOfGlasses = [NSNumber numberWithInt:0];
        return _currentlySelectedEntry;
    }
}

- (void)addOneGlassToCurrentEntry {
    _currentlySelectedEntry.numberOfGlasses = [NSNumber numberWithInt:[_currentlySelectedEntry.numberOfGlasses intValue] + 1];
}

- (void)subtractOneGlassFromCurrentEntry {
   _currentlySelectedEntry.numberOfGlasses = [NSNumber numberWithInt:[_currentlySelectedEntry.numberOfGlasses intValue] - 1];
}


#pragma mark - Core Data Methods

//Returns UIApplication's NSManagedObjectContext
- (NSManagedObjectContext *)getContext {
    NSManagedObjectContext *managedObjectContext = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    return managedObjectContext;
}

- (void)saveData {
    NSError *error = nil;
    if ([self.context save:&error] == NO)
        NSLog(@"There has been an error");
    else
        NSLog(@"NSManagedObjectContext has been saved");
    
}

@end
