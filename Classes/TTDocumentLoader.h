//
//  TTDocumentLoader.h
//  Time Tracker
//
//  The TTDocumentLoader is responsible for loading the correct version of the data model
//  and if necessary migrating it to the current data model version.
//
//  Created by Aaron VonderHaar on 2/16/09.
//  Copyright 2009 Aaron VonderHaar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../TTDocumentV1.h"

@interface TTDocumentLoader : NSObject {

}

- (TTDocumentV1 *)loadDocument;
- (TTDocumentV1 *)loadDocumentFromFile:(NSString *)filename;
- (TTDocumentV1 *)loadDocumentFromData:(NSData *)data;

- (void)saveDocument:(TTDocumentV1 *)document;
- (void)saveDocument:(TTDocumentV1 *)document toFile:(NSString *)filename;

@end
