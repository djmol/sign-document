//
//  SendViewController.m
//  SignDocument
//
//  Created by Dan on 3/21/17.
//  Copyright © 2017 Passaic County Technical Institute. All rights reserved.
//

#import "SendViewController.h"
@import CoreText;

@interface SendViewController ()

@property (strong, nonatomic) NSURL *documentURL;
@property (strong, nonatomic) NSArray *messageBody;

@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set navigation bar title
    self.navigationItem.title = [@"Your " stringByAppendingString:self.document.documentName];
    
    // Initialize document body
    // TODO: Create this using JSON (this was a literal last minute addition)
    self.messageBody = [[NSArray alloc] initWithObjects:@"", self.document.documentName, @" is attached. Please keep a copy of this email for your records.", nil];
    
    // Assemble unique document name using time
    NSMutableString *documentName = [[NSMutableString alloc] initWithString:self.document.signFileName];
    [documentName appendString:[NSString stringWithFormat:@"%lf", CFAbsoluteTimeGetCurrent()]];
    [documentName appendString:@".pdf"];
    
    // Create copy of PDF
    NSString *docPath = [[NSBundle mainBundle] pathForResource:self.document.signFileName ofType:@"pdf"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:documentName];
    [fileManager copyItemAtPath:docPath toPath:documentDirectoryPath error:&error];
    self.documentURL = [NSURL fileURLWithPath:documentDirectoryPath];
    CFURLRef url = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:documentDirectoryPath]);
    CGPDFDocumentRef documentCopy = CGPDFDocumentCreateWithURL(url);

    CGContextRef pdfContext = CGPDFContextCreateWithURL(url, NULL, NULL);
    int totalPages = (int)CGPDFDocumentGetNumberOfPages(documentCopy);
    
    // Build PDF copy, page by page
    for (int pageNum = 1; pageNum <= totalPages; pageNum++) {
        CGPDFContextBeginPage(pdfContext, NULL);
        UIGraphicsPushContext(pdfContext);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawPDFPage(context,CGPDFDocumentGetPage(documentCopy,pageNum));
        
        // Get input pages
        NSArray<NSNumber *> *inputPages = [self.document getInputPages];
        
        // On the last page, fill out the form
        if ([inputPages containsObject:[NSNumber numberWithInteger:pageNum]]) {
            
            // Retrieve signature from storage
            //NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"signature.png"];// image is the e-sign saved in doc. directory
            //self.signatureImage = [[UIImage alloc] initWithContentsOfFile:filePath];
            
            // Draw inputs to form
            for (id key in self.document.dataInputs) {
                // TODO: Handle more than strings and images.
                DataInput *input = [self.document.dataInputs valueForKey:key];
                if (input.value && input.page == pageNum) {
                    if ([input.value isKindOfClass:[NSString class]]) {
                        [self drawString:(NSString *)input.value inFrame:input.drawLocation withContext:context];
                    } else if ([input.value isKindOfClass:[UIImage class]]) {
                        UIImage *drawImage = (UIImage *)input.value;
                        CGContextDrawImage(context, input.drawLocation, drawImage.CGImage);
                    }
                }
            }
        }
        
        // Clean up
        UIGraphicsPopContext();
        CGPDFContextEndPage(pdfContext);
    }
    // Finish PDF
    CGPDFContextClose(pdfContext);

    // Load PDF into view
    NSURLRequest *request = [NSURLRequest requestWithURL:self.documentURL];
    [self.webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Reset recipient emails to base recipients
    [self.document.recipientEmails removeAllObjects];
    [self.document.recipientEmails addObjectsFromArray:self.document.baseRecipientEmails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Drawing

- (void)drawString:(NSString *)stringToDraw inFrame:(CGRect)drawFrame withContext:(CGContextRef)context {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawFrame);
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:stringToDraw];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    CTFrameDraw(frame, context);
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

#pragma mark - Actions

- (IBAction)sendButtonClicked:(id)sender {
    // Send our email to the assigned recipients
    NSString *emailTitle =  [@"Your " stringByAppendingString:self.document.documentName];
    NSString *messageBody = [self.messageBody componentsJoinedByString:@""];
    NSData *fileData = [NSData dataWithContentsOfURL:self.documentURL];
    NSString *fileName = [[self.document.documentName stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingString:@".pdf"];
        
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc addAttachmentData:fileData mimeType:@"application/pdf" fileName:fileName];
        [mc setToRecipients:self.document.recipientEmails];
    
        [self presentViewController:mc animated:YES completion:nil];
    }
}

- (IBAction)newButtonClicked:(id)sender {
    // Pop back to the document menu
    // Create alert view controller and assign our actions and popover presenter
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Discard" message:@"Return to document menu?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    // The cancel action is technically unncessary since this is an iPad app, but whatever.
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self.navigationController popToRootViewControllerAnimated:true];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) { }];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    UIPopoverPresentationController *popoverController = [alertController popoverPresentationController];
    popoverController.barButtonItem = self.docNewBarButtonItem;
    popoverController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    
    [self presentViewController:alertController animated:true completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)mailer didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self becomeFirstResponder];
    [mailer dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
