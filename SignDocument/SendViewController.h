//
//  SendViewController.h
//  SignDocument
//
//  Created by Dan on 3/21/17.
//  Copyright © 2017 Passaic County Technical Institute. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import <UIKit/UIKit.h>
#import "Document.h"

@interface SendViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *docNewBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendBarButtonItem;
@property (strong, nonatomic) Document *document;

@end
