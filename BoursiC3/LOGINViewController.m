//
//  LOGINViewController.m
//  BoursiC3
//
//  Created by bertrand louis on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LOGINViewController.h"
#import "AFNetworking.h"
#import "ListValViewController.h"

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
    // FROM TGV 10.164.10.149
    //NSURL *url = [NSURL URLWithString:@"http://192.168.1.46:8888/wsLogin.php"];
    //CHE WAM
    //NSURL *url = [NSURL URLWithString:@"http://192.168.1.46:8888/wslogin.php"];
  
    
    
   // VERSION LOCALE MAMP
    //FLO
    //NSURL *url = [NSURL URLWithString:@"http://192.168.0.12:8888/wslogin.php"];
    
    //WAM
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.146:8888/wslogin.php"];
    
    //ARKKOX
    //NSURL *url = [NSURL URLWithString:@"http://arkkox.free.fr/Boursicoincoin/wslogin.php"];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    //LES PARAM PASSES EN POST
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            TextLOG.text, @"nom",
                            TextPWD.text, @"mdp",
                            nil];

    //CHEWAM
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://192.168.1.46:8888/wslogin.php"parameters:params];
    
    //FLO
   //NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://192.168.0.12:8888/wslogin.php"parameters:params];
    
    //ARKKOX
   // NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://arkkox.free.fr/Boursicoincoin/wslogin.php"parameters:params];
   
    
    
    
    
    
    //VERSION SERVEUR YANNICK
   
    //FLO
  /*  NSURL *url = [NSURL URLWithString:@"http://92.161.60.212:8080/jsonConnect.php"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    //LES PARAM PASSES EN POST
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            
                            TextLOG.text, @"nom",
                            TextPWD.text, @"mdp",
                            nil];
    
    
    //FLO
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://92.161.60.212:8080/jsonConnect.php"parameters:params];

    */
    ////////////////////////////////////////
    ///FIN VERSION SERVEUR YANNICK
    
    
    
    
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
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Réseau non disponible"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];                   
        [alertView show];
        
    }];
    
    
    
    [operation start];
    
    [self performSegueWithIdentifier:@"ShowScreen1" sender:nil];
    
      
    
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"retour clavier");
    [textField resignFirstResponder];
    return YES;
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
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
