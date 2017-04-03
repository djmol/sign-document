//
//  DataInput.h
//  SignDocument
//
//  Created by Dan on 3/23/17.
//  Copyright © 2017 Passaic County Technical Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DataInput : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSObject *value;
@property (nonatomic) CGRect drawLocation;
@property (nonatomic) NSInteger page; //TODO: Change this to NSArray<NSNumber *> * so that dataInputs can belong to multiple pages

-(id)initWithName:(NSString *)name drawLocation:(CGRect)drawLocation page:(NSInteger)page;

@end
