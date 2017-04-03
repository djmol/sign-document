//
//  FacultyMobileDeviceAgreementViewController.m
//  SignDocument
//
//  Created by Dan on 3/21/17.
//  Copyright © 2017 Passaic County Technical Institute. All rights reserved.
//

#import "FacultyMobileDeviceAgreementViewController.h"
#import "SendViewController.h"

@interface FacultyMobileDeviceAgreementViewController ()

@property CGPoint currentPoint;
@property CGPoint lastPoint;
@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;
@property CGFloat brush;
@property CGFloat opacity;
@property BOOL mouseSwiped;
@property (strong, nonatomic) UIImageView *drawImageView;
@property (strong, nonatomic) UIImageView *displayImageView;

@end

@implementation FacultyMobileDeviceAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set drawing defaults
    self.red = 0.0/255.0;
    self.green = 0.0/255.0;
    self.blue = 0.0/255.0;
    self.brush = 5.0;
    self.opacity = 1.0;
    self.drawImageView = [[UIImageView alloc] init];
    self.displayImageView = [[UIImageView alloc] init];
    
    // Initialize layout
    self.errorLabel.text = nil;
    [self.errorLabel setNumberOfLines:0];
    [self.errorLabel sizeToFit];
    
    // Set navigation bar title
    self.navigationItem.title = @"Sign";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Drawing

// Drawing methods modified from https://www.raywenderlich.com/18840/how-to-make-a-simple-drawing-app-with-uikit
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    
    // Set our drawing views to the correct set of imageViews
    if (touch.view == self.teacherDrawImageView) {
        self.drawImageView = self.teacherDrawImageView;
        self.displayImageView = self.teacherDisplayImageView;
    } else if (touch.view == self.technicianDrawImageView) {
        self.drawImageView = self.technicianDrawImageView;
        self.displayImageView = self.technicianDisplayImageView;
    }
    
    self.lastPoint = [touch locationInView:self.drawImageView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // Draw a line segment between each move
    self.mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    self.currentPoint = [touch locationInView:self.drawImageView];
    
    UIGraphicsBeginImageContext(self.displayImageView.frame.size);
    [self.drawImageView.image drawInRect:CGRectMake(0, 0, self.drawImageView.frame.size.width, self.drawImageView.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.currentPoint.x, self.currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.drawImageView setAlpha:self.opacity];
    UIGraphicsEndImageContext();
    
    self.lastPoint = self.currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Complete the line segment or draw a dot.
    if(!self.mouseSwiped) {
        UIGraphicsBeginImageContext(self.displayImageView.frame.size);
        [self.drawImageView.image drawInRect:CGRectMake(0, 0, self.drawImageView.frame.size.width, self.drawImageView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, self.opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.displayImageView.frame.size);
    [self.drawImageView.image drawInRect:CGRectMake(0, 0, self.drawImageView.frame.size.width, self.drawImageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.displayImageView.image drawInRect:CGRectMake(0, 0, self.displayImageView.frame.size.width, self.displayImageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:self.opacity];
    self.displayImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    self.drawImageView.image = nil;
    UIGraphicsEndImageContext();
    
    self.drawImageView = nil;
    self.displayImageView = nil;
}

#pragma mark - Action

- (IBAction)submitBarButtonItemClicked:(id)sender {
    // Validate input
    if ([self validateInput]) {
        // Save response information
        // TODO: Handle these names in a better way. String enum or something.
        // The image sizes were originally image.size.width/height / 6
        [[self.document.dataInputs objectForKey:@"teacherSignatureImage"] setValue:self.teacherDisplayImageView.image forKey:@"value"];
        [[self.document.dataInputs objectForKey:@"technicianSignatureImage"] setValue:self.technicianDisplayImageView.image forKey:@"value"];
        [[self.document.dataInputs objectForKey:@"signDate"] setValue:[self getDate] forKey:@"value"];
        [[self.document.dataInputs objectForKey:@"assetTagNumber"] setValue:self.assetTagNumberTextField.text forKey:@"value"];
        [[self.document.dataInputs objectForKey:@"serialNumber"] setValue:self.serialNumberTextField.text forKey:@"value"];
        [[self.document.dataInputs objectForKey:@"teacherName"] setValue:self.teacherNameTextField.text forKey:@"value"];
        [[self.document.dataInputs objectForKey:@"teacherPhoneNumber"] setValue:self.teacherPhoneNumberTextField.text forKey:@"value"];
        [[self.document.dataInputs objectForKey:@"teacherEmail"] setValue:self.teacherEmailAddressTextField.text forKey:@"value"];
        
        // Add our teacher email to the list of recipients
        [self.document.recipientEmails addObject:self.teacherEmailAddressTextField.text];
        
        [self performSegueWithIdentifier:@"submitInfoSegue" sender:self];
    }
}

- (IBAction)clearButtonClicked:(id)sender {
    // Clear the appropriate signature imageView
    if (sender == self.teacherClearButton) {
        self.teacherDisplayImageView.image = nil;
    } else if (sender == self.technicianClearButton) {
        self.technicianDisplayImageView.image = nil;
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Send information to be written to document
    if ([segue.identifier isEqualToString:@"submitInfoSegue"]) {
        SendViewController *sendViewController = (SendViewController *) segue.destinationViewController;
        sendViewController.document = [[Document alloc] init];
        sendViewController.document = self.document;
    }
}

#pragma mark - Helpers

- (bool)validateInput {
    bool validity = true;
    
    NSMutableString *errorString = [[NSMutableString alloc] init];
    
    // Check input lengths (is there a more graceful way of doing this?)
    if (self.assetTagNumberTextField.text.length <= 0
        || self.serialNumberTextField.text.length <= 0
        || self.teacherNameTextField.text.length <= 0
        || self.teacherPhoneNumberTextField.text.length <= 0
        || self.teacherEmailAddressTextField.text.length <= 0) {
        validity = false;
        
        [errorString appendString:@"All fields are required."];
    }
    
    if ([self.teacherEmailAddressTextField.text containsString:@"@"]) {
        // If teacher email input is a full address, check validity
        if (![self NSStringIsValidEmail:self.teacherEmailAddressTextField.text]) {
            validity = false;
            
            if (errorString.length > 0)
                [errorString appendString:@"\n"];
            [errorString appendString:@"Please enter a valid email address."];
        }
    } else if ([self.teacherEmailAddressTextField.text length] != 0) {
        // Otherwise, append PCTI domain
        self.teacherEmailAddressTextField.text = [self.teacherEmailAddressTextField.text stringByAppendingString:@"@pcti.tec.nj.us"];
    }
    
    // BUG: Error label text moves around sometimes.
    self.errorLabel.text = errorString;
    [self.errorLabel sizeToFit];

    return validity;
}

// Thanks to http://stackoverflow.com/questions/3139619/check-that-an-email-address-is-valid-on-ios
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (NSString *)getDate {
    NSString *dateString;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM d, yyyy"];
    NSDate *now = [[NSDate alloc] init];
    dateString = [format stringFromDate:now];
    
    return dateString;
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
