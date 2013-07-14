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
//@synthesize appDelegate;


static NSString *URLServeurString = @"http://s454555776.onlinehome.fr/boursicoincoin/jsonConnect.php";



- (IBAction)Action_Connect:(id)sender {
    
    NSLog(@"CONNECT");
    
      NSLog(@"LOG=%@",TextLOG.text);
      NSLog(@"PWD=%@",TextPWD.text);
    
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSLog(@"deviceToken=%@",deviceToken);

      
    
    NSURL *url = [NSURL URLWithString: URLServeurString ];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    //On construit les parametres qui vont etre passes en POST de la requete
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            TextLOG.text, @"user",
                            TextPWD.text, @"password",
                            deviceToken, @"token",
                            @"getLogin", @"action",
                            nil];
    
    //On interroge le serveur avec la requete
  
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:URLServeurString parameters:params];
    
    
    //On recupere la reponse du serveur
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"ENVOI LOG  OK");
        NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"RESULT DU json DU LOG: %@", JSON);
        
        if ([JSON count]==1)
        {
            [[NSUserDefaults standardUserDefaults] setObject:TextLOG.text forKey:@"USER"];
            [[NSUserDefaults standardUserDefaults] setObject:TextPWD.text forKey:@"PASSWORD"];
            
            [self performSegueWithIdentifier:@"ShowScreen1" sender:nil];
            /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection OK"
                                                                message:@"Bienvenue"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];*/
            
        }
        else
        {
            //[self performSegueWithIdentifier:@"ShowScreen1" sender:nil];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Pb Connection"
                                                                message:@"Veuillez recommencer"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            

        }
        // self.listValJSON = JSON;
        //NSLog(@"listVal (OBJET VALEURS EST MERE : %@", self.listValJSON);
        
        // [self TransfertJSON_Vers_Objet_ListVal];
        
        // [self.activityIndicatorView stopAnimating];
        // [self.TableListVAL setHidden:NO];
        // [self.TableListVAL reloadData];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request ENVOI LOG Failed with Error: %@, %@", error, error.userInfo);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Pb Connection"
                                                            message:@"Veuillez recommencer"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
         [alertView show];
        
    }];
    
    
    [operation start];
    
  
    
  }



- (IBAction)Action_Create_Compte:(id)sender {
    
    NSLog(@"CONNECT");
    
    NSLog(@"LOG=%@",TextLOG.text);
    NSLog(@"PWD=%@",TextPWD.text);
    
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSLog(@"deviceToken=%@",deviceToken);
    
    
    
    NSURL *url = [NSURL URLWithString: URLServeurString ];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    //On construit les parametres qui vont etre passes en POST de la requete
   
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            TextLOG.text, @"user",
                            TextPWD.text, @"password",
                            deviceToken, @"token",
                            @"setNewUserWithToken", @"action",
                            nil];
    
    //On interroge le serveur avec la requete
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:URLServeurString parameters:params];
    
    
    //On recupere la reponse du serveur
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"ENVOI LOG  OK");
        NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"RESULT DU json DU LOG: %@", JSON);
        if ([JSON count]==1)
        {
            [self performSegueWithIdentifier:@"ShowScreen1" sender:nil];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Inscription OK"
                                                                message:@"Bienvenue sur Boursicoincoin"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            
        }
        // self.listValJSON = JSON;
        //NSLog(@"listVal (OBJET VALEURS EST MERE : %@", self.listValJSON);
        
        // [self TransfertJSON_Vers_Objet_ListVal];
        
        // [self.activityIndicatorView stopAnimating];
        // [self.TableListVAL setHidden:NO];
        // [self.TableListVAL reloadData];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request ENVOI LOG Failed with Error: %@, %@", error, error.userInfo);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Pb Inscription"
                                                            message:@"Veuillez recommencer"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    
    [operation start];
    
   // [self performSegueWithIdentifier:@"ShowScreen1" sender:nil];
    
}





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
         //  [self setAppDelegate:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self performSegueWithIdentifier:@"ShowScreen1" sender:nil];
    NSLog(@"vue chargee");
    //[self Action_Connect:(this) ];
    
    
    NSString *USER = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER"];
     NSString *PASSWORD = [[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"];
    
    NSLog(@"USER RECUPERE = %@",USER);
    NSLog(@"PASSWORD RECUPERE = %@",PASSWORD);
    
    
    if (USER.length>0) {
        
       /* UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bienvenue sur boursicoincoin"
                                                            message:USER
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        */
        TextLOG.text=USER;
        TextPWD.text=PASSWORD;
        
        [self Action_Connect:nil];
        
        

    }
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
    
    // on passe directement a l ecran ACTIONS
    // [self performSegueWithIdentifier:@"ShowScreen1" sender:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
