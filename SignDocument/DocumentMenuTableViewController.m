//
//  DocumentMenuTableViewController.m
//  SignDocument
//
//  Created by Dan on 3/23/17.
//  Copyright © 2017 Passaic County Technical Institute. All rights reserved.
//

#import "DocumentMenuTableViewController.h"
#import "DocumentViewController.h"

@interface DocumentMenuTableViewController ()

@end

@implementation DocumentMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Initialize documents
    self.documents = [[NSMutableArray<Document *> alloc] init];
    
    // Read in document information from JSON
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"documents" ofType:@"json"];
    NSData *fileJson = [[NSData alloc] initWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:fileJson options:0 error:nil];
    for (NSDictionary *jsonDict in json) {
        Document *newDoc;
        // TODO: Check if all key names exist, I guess?
        if ([jsonDict objectForKey:@"readFileName"] && [jsonDict objectForKey:@"signFileName"] && [jsonDict objectForKey:@"documentName"]) {
            newDoc = [[Document alloc] initWithReadFileName:[jsonDict valueForKey:@"readFileName"]
                                               signFileName:[jsonDict valueForKey:@"signFileName"]
                                               documentName:[jsonDict valueForKey:@"documentName"]];
            // Not a fan of the complexity, but we have to grab the dataInputs as well.
            if ([jsonDict objectForKey:@"dataInputs"]) {
                for (NSDictionary *dataJsonDict in [jsonDict objectForKey:@"dataInputs"]) {
                    NSDictionary *sizeDict = [dataJsonDict valueForKey:@"drawLocation"];
                    // TODO: Parse drawLocation info so that we can do relative sizes (...like 1/6 of the image size)
                    DataInput *newDataInput = [[DataInput alloc] initWithName:[dataJsonDict valueForKey:@"name"]
                                                                 drawLocation:CGRectMake([[sizeDict valueForKey:@"x"] floatValue], [[sizeDict valueForKey:@"y"] floatValue],
                                                                                         [[sizeDict valueForKey:@"width"] floatValue], [[sizeDict valueForKey:@"height"] floatValue])
                                                                         page:[[dataJsonDict valueForKey:@"page"] intValue]];
                    [newDoc.dataInputs setObject:newDataInput forKey:[dataJsonDict valueForKey:@"name"]];
                }
            }
            if ([jsonDict objectForKey:@"baseRecipientEmails"]) {
                // TODO: Check if it actually is an array before doing this.
                NSArray<NSString *> *recipientEmails = [jsonDict objectForKey:@"baseRecipientEmails"];
                [newDoc.baseRecipientEmails addObjectsFromArray:recipientEmails];
                [newDoc.recipientEmails addObjectsFromArray:recipientEmails];
            }
            [self.documents addObject:newDoc];
        }
        
    }
    
    // Set navigation bar title
    self.navigationItem.title = @"Documents";    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.documents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"documentCell" forIndexPath:indexPath];
    
    Document *doc = [self.documents objectAtIndex:indexPath.row];
    cell.textLabel.text = doc.documentName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Send our selected blank document along
    self.selectedDocument = [self.documents objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"selectDocumentSegue" sender:self];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"selectDocumentSegue"]) {
        DocumentViewController *documentViewController = (DocumentViewController *) segue.destinationViewController;
        documentViewController.document = [[Document alloc] init];
        documentViewController.document = self.selectedDocument;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
