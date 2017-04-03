//
//  Document.m
//  SignDocument
//
//  Created by Dan on 3/23/17.
//  Copyright © 2017 Passaic County Technical Institute. All rights reserved.
//

#import "Document.h"

@interface Document()

@property (strong, nonatomic) NSMutableArray<NSNumber *> *inputPages;

@end

@implementation Document

-(id)init {
    return [self initWithReadFileName:nil signFileName:nil documentName:nil];
}

-(id)initWithReadFileName:(NSString *)readFileName signFileName:(NSString *)signFileName documentName:(NSString *)docName {
    self.readFileName = readFileName;
    self.signFileName = signFileName;
    self.documentName = docName;
    self.dataInputs = [[NSMutableDictionary<NSString *, DataInput *> alloc] init];
    self.inputPages = [[NSMutableArray<NSNumber *> alloc] init];
    self.baseRecipientEmails = [[NSMutableArray<NSString *> alloc] init];
    self.recipientEmails = [[NSMutableArray<NSString *> alloc] init];
    
    return self;
}

-(NSMutableArray<NSNumber *> *)getInputPages {
    // Iterate over our dataInputs and return the pages that has at least one input on it
    for (id key in self.dataInputs) {
        DataInput *input = [self.dataInputs valueForKey:key];
        if (![self.inputPages containsObject:[NSNumber numberWithInteger:input.page]])
           [self.inputPages addObject:[NSNumber numberWithInteger:input.page]];
    }
    
    return self.inputPages;
}

@end
