//
//  FacultyMobileDeviceAgreementViewController.h
//  SignDocument
//
//  Created by Dan on 3/21/17.
//  Copyright © 2017 Passaic County Technical Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document.h"

@interface FacultyMobileDeviceAgreementViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *assetTagNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *teacherNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *teacherPhoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *teacherEmailAddressTextField;
@property (weak, nonatomic) IBOutlet UIImageView *teacherDrawImageView;
@property (weak, nonatomic) IBOutlet UIImageView *teacherDisplayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *teacherBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *teacherClearButton;
@property (weak, nonatomic) IBOutlet UIImageView *technicianDrawImageView;
@property (weak, nonatomic) IBOutlet UIImageView *technicianDisplayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *technicianBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *technicianClearButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (strong, nonatomic) Document *document;

@end
