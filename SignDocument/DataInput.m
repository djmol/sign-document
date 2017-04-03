//
//  DataInput.m
//  SignDocument
//
//  Created by Dan on 3/23/17.
//  Copyright © 2017 Passaic County Technical Institute. All rights reserved.
//

#import "DataInput.h"

@implementation DataInput

-(id)init {
    // TODO: Set better default values.
    return [self initWithName:nil drawLocation:CGRectMake(0, 0, 0, 0) page:0];
}

-(id)initWithName:(NSString *)name drawLocation:(CGRect)drawLocation page:(NSInteger)page {
    self.name = name;
    self.drawLocation = drawLocation;
    self.page = page;
    
    return self;
}

@end
