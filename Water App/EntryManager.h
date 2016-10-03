//
//  EntryManager.h
//  Water App
//
//  Created by Immanuel Kannan on 12/08/2016.
//  Copyright © 2016 Immanuel. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@class Entry;

@interface EntryManager : NSObject

+ (instancetype)sharedManager;

- (Entry *)entryForToday;
- (Entry *)entryWithDate: (NSString *)date;

+ (Entry *)currentEntry;
+ (void)setCurrentEntry: (NSString *)date;

- (void)addOneGlassToCurrentEntry;
- (void)subtractOneGlassFromCurrentEntry;

+ (void)populateEntryCache;
+ (NSMutableDictionary *)entryCache;

+ (NSManagedObjectContext *)getContext;
- (void)saveData;

@end
