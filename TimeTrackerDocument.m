//
//  TimeTrackerDocument.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 2007-11-26.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "TimeTrackerDocument.h"


@implementation TimeTrackerDocument

- (NSString *)windowNibName {
    // Implement this to return a nib to load OR implement -makeWindowControllers to manually create your controllers.
    return @"TimeTrackerDocument";
}

- (NSData *)dataRepresentationOfType:(NSString *)type {
    // Implement to provide a persistent data representation of your document OR remove this and implement the file-wrapper or file path based save methods.
    return nil;
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)type {
    // Implement to load a persistent data representation of your document OR remove this and implement the file-wrapper or file path based load methods.
    return YES;
}

@end
