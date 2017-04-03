//
//  DocumentViewController.h
//  SignDocument
//
//  Created by Dan on 3/21/17.
//  Copyright © 2017 Passaic County Technical Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document.h"

@interface DocumentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *signBarButtonItem;
@property (strong, nonatomic) Document *document;

@end
