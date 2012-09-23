//
//  SecondViewController.m
//  BoursiC3
//
//  Created by bertrand louis on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "AFNetworking.h"
@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize TableListVAL ,listVal = _listVal;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Setting Up Table View
    
    self.TableListVAL.dataSource = self;
    self.TableListVAL.delegate = self;
 
    
    // Setting Up Activity Indicator View
    //self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //self.activityIndicatorView.hidesWhenStopped = YES;
    //self.activityIndicatorView.center = self.view.center;
    //[self.view addSubview:self.activityIndicatorView];
    //[self.activityIndicatorView startAnimating];
    
    // Initializing Data Source
    self.listVal = [[NSArray alloc] init];
    NSLog(@"COIN");
    
    
    //FLO 192.168.0.14
    //BEB 192.168.1.46
    
    
    
    //NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.0.14:8888/webservicelog.php"];
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.46:8888/wsgetValeurs.php"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"1", @"idPtf",
                            nil];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://192.168.1.46:8888/wsgetValeurs.php"parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
      
        NSLog(@"REQUEST OK JSON");
        //NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"json: %@", JSON);
        
        self.listVal = [JSON objectForKey:@"VALEURS"];
        
        // [self.activityIndicatorView stopAnimating];
        [self.TableListVAL setHidden:NO];
        [self.TableListVAL reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    
    [operation start];
    

}

- (void)viewDidUnload
{
    [self setTableListVAL:nil];
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
    if (self.listVal && self.listVal.count) {
        return self.listVal.count;
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
    
    NSDictionary *listVal = [self.listVal objectAtIndex:indexPath.row];
    cell.textLabel.text = [listVal objectForKey:@"2"];
    
    // cell.detailTextLabel.text = [movie objectForKey:@"artistName"];
    
    // NSURL *url = [[NSURL alloc] initWithString:[movie objectForKey:@"artworkUrl100"]];
    // [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}


@end
