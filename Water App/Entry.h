//
//  Entry.h
//  Water App
//
//  Created by Immanuel Kannan on 12/08/2016.
//  Copyright © 2016 Immanuel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Entry : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (NSString *)description;

@end

NS_ASSUME_NONNULL_END

#import "Entry+CoreDataProperties.h"
