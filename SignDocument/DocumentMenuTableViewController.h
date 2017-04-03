//
//  DocumentMenuTableViewController.h
//  SignDocument
//
//  Created by Dan on 3/23/17.
//  Copyright © 2017 Passaic County Technical Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document.h"

@interface DocumentMenuTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray<Document *> *documents;
@property (strong, nonatomic) Document *selectedDocument;

@end
