//
//  FirstViewController.m
//  BoursiC3
//
//  Created by bertrand louis on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "AFNetworking.h"
@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize ListPTF,ArraylistPTF = _ArraylistPTF;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
     // Setting Up Table View
    self.ListPTF.dataSource = self;
    self.ListPTF.delegate = self;
    
    // Initializing Data Source
    self.ArraylistPTF = [[NSArray alloc] init];
    
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.1.46:8888/webservicelog.php"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.ArraylistPTF = [JSON objectForKey:@"VALEURS"];
        NSLog(@"REQUEST OK JSON");
        NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        //NSLog(@"json: %@", JSON);
        
        
        // [self.activityIndicatorView stopAnimating];
        [self.ListPTF setHidden:NO];
        [self.ListPTF reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    
    
   // [operation start];

    
    
}

- (void)viewDidUnload
{
    [self setListPTF:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


// Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.ArraylistPTF && self.ArraylistPTF.count) {
        return self.ArraylistPTF.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSDictionary *ArraylistPTF = [self.ArraylistPTF objectAtIndex:indexPath.row];
    cell.textLabel.text = [ArraylistPTF objectForKey:@"nomValeur"];
    
    // cell.detailTextLabel.text = [movie objectForKey:@"artistName"];
    
    // NSURL *url = [[NSURL alloc] initWithString:[movie objectForKey:@"artworkUrl100"]];
    // [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}


@end
