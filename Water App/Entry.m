//
//  Entry.m
//  Water App
//
//  Created by Immanuel Kannan on 12/08/2016.
//  Copyright © 2016 Immanuel. All rights reserved.
//

#import "Entry.h"

@implementation Entry

// Insert code here to add functionality to your managed object subclass

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"Date: %@, Number of Glasses: %@", self.date, self.numberOfGlasses];
    
    return description;
}

@end
