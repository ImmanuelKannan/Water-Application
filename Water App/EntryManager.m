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
@property (nonatomic, strong) NSFetchRequest *fetchRequest;

@end


@implementation EntryManager

#pragma mark - Initializer Methods

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
        self.context = [EntryManager getContext];
        if (_context) {
            NSLog(@"NSManagedObjectContext is initialized");
        } else {
            NSLog(@"!! - NSManagedObjectContext IS NOT initialized - !!");
        }
        
        _fetchedObjects = [[NSArray alloc] init];
        _entityDescription = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.context];
        _fetchRequest = [[NSFetchRequest alloc] init];
        _fetchRequest.entity = _entityDescription;
        _fetchRequest.fetchLimit = 1;
        
        [EntryManager populateEntryCache];
    }
    
    return self;
}

#pragma mark - Entry and entry manipulation methods

- (Entry *)entryForToday {
    /*
        Checks if an entry exists for today. 
        If an entry does exist, set it as the currentEntry, and return it. Otherwise, create a new entry,
        set it as the currentEntry, and return it.
     */
    
    Entry *entry;
    if ((entry = [self entryWithDate:[[DateFormatterManager sharedManager] todayString]])) {
        [EntryManager setCurrentEntry:[[DateFormatterManager sharedManager] todayString]];
        return entry;
    } else {
        entry = [self createEntryForDate:[[DateFormatterManager sharedManager] todayString]];
        [EntryManager setCurrentEntry:[[DateFormatterManager sharedManager] todayString]];
        return entry;
    }
}

- (Entry *)entryWithDate: (NSString *)date {
    /*
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@", date];
    [_fetchRequest setPredicate:predicate];
    
    Entry *entry;
    
    NSError *error = nil;
    if ((self.fetchedObjects = [self.context executeFetchRequest:_fetchRequest error:&error]).count == 1) {
        NSLog(@"Entry Manager: Entry with date: %@ found", date);
        entry = [self.fetchedObjects objectAtIndex:0];
        return entry;
    } else {
        NSLog(@"Entry Manager: Entry with date: %@ not found", date);
        return nil;
    }
     */
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"date == %@", date];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Entry"];
    fetch.predicate = pred;
    
    NSArray *arr;
    
    NSError *err = nil;
    if ((arr = [self.context executeFetchRequest:fetch error:&err]).count == 1) {
        NSLog(@"Entry Manager, (-entryWithDate): Entry with date %@ found", date);
        Entry *entry = [arr firstObject];
        return entry;
    } else {
        NSLog(@"Entry Manager, (-entryWithDate): Entry with date %@ NOT found", date);
        return nil;
    }
}

- (Entry *)createEntryForDate: (NSString *)date {
    Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:self.context];
    [entry setValue:date forKey:@"date"];
    [entry setValue:[NSNumber numberWithInt:0] forKey:@"numberOfGlasses"];
    
    return entry;
}


- (BOOL)entryWithDateDoesExist: (NSString *)date {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@", date];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:self.entityDescription];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    
    NSError *error = nil;
    NSUInteger count = [self.context countForFetchRequest:fetchRequest error:&error];
    
    if (count == 0) {
        NSLog(@"Error: %@", error);
        return NO;
    } else {
        return YES;
    }
    
}

- (void)addOneGlassToCurrentEntry {
    //_currentlySelectedEntry.numberOfGlasses = [NSNumber numberWithInt:[_currentlySelectedEntry.numberOfGlasses intValue] + 1];
    currentEntry.numberOfGlasses = [NSNumber numberWithInt:[currentEntry.numberOfGlasses intValue] + 1];
}

- (void)subtractOneGlassFromCurrentEntry {
   //_currentlySelectedEntry.numberOfGlasses = [NSNumber numberWithInt:[_currentlySelectedEntry.numberOfGlasses intValue] - 1];
    currentEntry.numberOfGlasses = [NSNumber numberWithInt:[currentEntry.numberOfGlasses intValue] - 1];
}


#pragma mark - Core Data Methods

//Returns UIApplication's NSManagedObjectContext
+ (NSManagedObjectContext *)getContext {
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

static Entry *currentEntry = nil;

+ (Entry *)currentEntry {
    return currentEntry;
}

+ (void)setCurrentEntry: (NSString *)date {
    
    if ((currentEntry = [[EntryManager sharedManager] entryWithDate:date])) {
        NSLog(@"Cureent Entry: %@", currentEntry);
    }
    
    else {
        currentEntry.date = date;
        currentEntry.numberOfGlasses = 0;
    }
    
}

static NSMutableDictionary *entryCache = nil;

+ (NSMutableDictionary *)entryCache {
    if (entryCache == nil) {
        [EntryManager populateEntryCache];
        return entryCache;
    } else {
        return entryCache;
    }
}

+ (void)populateEntryCache {
    entryCache = [[NSMutableDictionary alloc] init];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Entry"];
    
    NSError *err = nil;
    NSArray *array = [[self getContext] executeFetchRequest:fetch error:&err];
    
    if (err != nil) {
        
        NSLog(@"ENTRY MANAGER, (- cache): FETCH FAILED");
        
    }
    else {
        
        for (NSManagedObject *entry in array) {
            [entryCache setObject:entry forKey:[NSString stringWithFormat:@"%@", ((Entry *) entry).date]];
        }
        
    }
    
}

/*
- (NSMutableDictionary *)cache {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Entry"];
    
    NSError *err = nil;
    NSArray *array = [_context executeFetchRequest:fetch error:&err];
    
    if (err != nil) {
        
        NSLog(@"ENTRY MANAGER, (- cache): FETCH FAILED");
        
    }
    else {
        
        for (NSManagedObject *entry in array) {
            [dictionary setObject:entry forKey:[NSString stringWithFormat:@"%@", ((Entry *) entry).date]];
        }
        
    }
    
    for (NSString *key in [dictionary allKeys]) {
        NSLog(@"CACHE THIS: %@", [dictionary objectForKey:key]);
    }
    
    return dictionary;
}
 */

@end
