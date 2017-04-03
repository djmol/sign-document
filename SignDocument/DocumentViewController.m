//
//  DocumentViewController.m
//  SignDocument
//
//  Created by Dan on 3/21/17.
//  Copyright © 2017 Passaic County Technical Institute. All rights reserved.
//

#import "DocumentViewController.h"
#import "FacultyMobileDeviceAgreementViewController.h"

@interface DocumentViewController ()

@end

@implementation DocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set navigation bar title
    self.navigationItem.title = self.document.documentName;
    
    // Load PDF
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.document.readFileName ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:filePath];      
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)signBarButtonItemClicked:(id)sender {
    // TODO: Handle this better
    if ([self.document.documentName isEqualToString:@"Faculty Mobile Device Agreement"]) {
        [self performSegueWithIdentifier:@"signFacultyMobileDeviceAgreementSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"signFacultyMobileDeviceAgreementSegue"]) {
        FacultyMobileDeviceAgreementViewController *fmdaViewController = (FacultyMobileDeviceAgreementViewController *) segue.destinationViewController;
        fmdaViewController.document = [[Document alloc] init];
        fmdaViewController.document = self.document;
    }
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
