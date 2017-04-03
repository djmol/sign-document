//
//  Document.h
//  SignDocument
//
//  Created by Dan on 3/23/17.
//  Copyright © 2017 Passaic County Technical Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataInput.h"

@interface Document : NSObject

@property (strong, nonatomic) NSString *readFileName; // The name of the file to first be presented to the user
@property (strong, nonatomic) NSString *signFileName; // The name of the file on which we will print the data (and then present to the user)
@property (strong, nonatomic) NSString *documentName; // The title of the document (e.g. Travel Authorization Form, License Agreement, etc.)
@property (strong, nonatomic) NSMutableDictionary<NSString *, DataInput *> *dataInputs; // The data input by the user that will be printed onto the document
@property (strong, nonatomic) NSMutableArray<NSString *> *baseRecipientEmails; // The standard emails that will always receive the filled-out document
@property (strong, nonatomic) NSMutableArray<NSString *> *recipientEmails; // The full list of emails to receive the document (presumably, the user adds at least one email to which to send the document)

-(id)initWithReadFileName:(NSString *)readFileName signFileName:(NSString *)signFileName documentName:(NSString *)docName;
-(NSMutableArray<NSNumber *> *) getInputPages; // Get which pages have dataInputs to be printed to them

@end
