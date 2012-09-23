//
//  LOGINViewController.m
//  BoursiC3
//
//  Created by bertrand louis on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LOGINViewController.h"
#import "AFNetworking.h"
#import "SecondViewController.h"

@interface LOGINViewController ()

@end

@implementation LOGINViewController
@synthesize TextLOG;
@synthesize TextPWD;
@synthesize TextID, LOGID;

- (IBAction)Action_Connect:(id)sender {
    
    NSLog(@"CONNECT");
    
      NSLog(@"LOG=%@",TextLOG.text);
      NSLog(@"PWD=%@",TextPWD.text);
    
  
    //NSURL *url = [NSURL URLWithString:@"http://192.168.1.46:8888/wsLogin.php"];
    // CHEZ FLO 192.168.0.14
    // CHEZ WAM 192.168.1.46
    //NSURL *url = [NSURL URLWithString:@"http://192.168.0.14:8888/wsLogin.php"];
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.46:8888/wslogin.php"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

       
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            TextLOG.text, @"nom",
                            TextPWD.text, @"mdp",
                            nil];

    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://192.168.1.46:8888/wslogin.php"parameters:params];
    //[httpClient release];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //  self.movies = [JSON objectForKey:@"NOMVALEUR"];
        NSLog(@"REQUEST OK JSON");
        NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"json: %@", JSON);
        LOGID = [JSON objectForKey:@"LOGID"];
        
        // [self.activityIndicatorView stopAnimating];
        // [self.tableView setHidden:NO];
        // [self.tableView reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    
    
    [operation start];
    
    

    
    ////
  /*  NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.1.46:8888/webservicelog.php"];
    
    //http://192.168.1.46:8888/login_GET.Php?nom=beb&mdp=beb"
    
    //http://itunes.apple.com/search?term=harry&country=us&entity=movie
    
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //[AFJSONRequestOperation addAcceptableContentTypes:@"text/plain"];
    
    // AFJSONParameterEncoding
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
      //  self.movies = [JSON objectForKey:@"NOMVALEUR"];
        NSLog(@"REQUEST OK JSON");
        
       // [self.activityIndicatorView stopAnimating];
       // [self.tableView setHidden:NO];
       // [self.tableView reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    [operation start];
*/
    
    
  }


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTextLOG:nil];
    [self setTextPWD:nil];
   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
