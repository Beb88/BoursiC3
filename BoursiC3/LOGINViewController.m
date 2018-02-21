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
@synthesize TextID, LOGID, ActivityIndicatorLog;
//@synthesize appDelegate;


//static NSString *URLServeurString = @"http://s454555776.onlinehome.fr/boursicoincoin/jsonConnect.php";
//http://78.192.193.7:8888/BCC/BCC/
static NSString *URLServeurString = @"http://88.191.209.98:80/BCC/BCC/jsonConnect.php";

-(void) viewDidAppear:(BOOL)animated
{
    NSString *USER = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER"];
    NSString *PASSWORD = [[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"];
    
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSLog(@"deviceToken recupere=%@",deviceToken);
    NSLog(@"USER RECUPERE = %@",USER);
    NSLog(@"PASSWORD RECUPERE = %@",PASSWORD);
    
    
    // MODE LOGIN SAUVEGARDE
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
        
        //[self performSegueWithIdentifier:@"ShowScreen1" sender:nil];
        [self Action_Connect:nil];
        
    }

}

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
      [self.ActivityIndicatorLog startAnimating];
    
    //On recupere la reponse du serveur
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"ENVOI LOG  OK");
        NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"RESULT DU json DU LOG: %@", JSON);
          [self.ActivityIndicatorLog stopAnimating];
        if ([JSON count]==1)
        {
            [[NSUserDefaults standardUserDefaults] setObject:TextLOG.text forKey:@"USER"];
            [[NSUserDefaults standardUserDefaults] setObject:TextPWD.text forKey:@"PASSWORD"];
            
            [self performSegueWithIdentifier:@"ShowScreen1" sender:nil];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection SERVER OK"
                                                                message:@"Bienvenue"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            
        }
        else
        {
            //[self performSegueWithIdentifier:@"ShowScreen1" sender:nil];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SERVER OFF"
                                                                message:@""
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            [self performSegueWithIdentifier:@"ShowScreen1" sender:nil];

            

        }
        // self.listValJSON = JSON;
        //NSLog(@"listVal (OBJET VALEURS EST MERE : %@", self.listValJSON);
        
        // [self TransfertJSON_Vers_Objet_ListVal];
        
        // [self.activityIndicatorView stopAnimating];
        // [self.TableListVAL setHidden:NO];
        // [self.TableListVAL reloadData];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request ENVOI LOG Failed with Error: %@, %@", error, error.userInfo);
         [self.ActivityIndicatorLog stopAnimating];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Mode Offline"
                                                            message:@"Pas de connexion internet"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
         [alertView show];
        [self performSegueWithIdentifier:@"ShowScreen1" sender:nil];

        
    }];
    
    
    [operation start];
    
  
    
  }



- (IBAction)Action_Create_Compte:(id)sender {
    
    NSLog(@"CONNECT");
    NSLog(@"LOG=%@",TextLOG.text);
    NSLog(@"PWD=%@",TextPWD.text);
    
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSLog(@"deviceToken=%@",deviceToken);
    
    
     /* [[NSUserDefaults standardUserDefaults] setObject:@"6ec0a1b1528e07c0dce6ef9a14a65d804d514aa3137fc5072c863d2bad4d5a23" forKey:@"deviceToken"];
    */
    
    NSURL *url = [NSURL URLWithString: URLServeurString ];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    //On construit les parametres qui vont etre passes en POST de la requete
   
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            TextLOG.text, @"user",
                            TextPWD.text, @"password",
                            deviceToken, @"token",
                           // @"6ec0a1b1528e07c0dce6ef9a14a65d804d514aa3137fc5072c863d2bad4d5a23",@"token"
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
           /* UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Inscription OK"
                                                                message:@"Bienvenue sur Boursicoincoin"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            */
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

/*
-(void) viewDidAppear:(BOOL)animated

{
    NSLog(@"VIEWDIDAPPEAR");
    
    NSString *USER = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER"];
    NSString *PASSWORD = [[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"];
    
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSLog(@"deviceToken recupere=%@",deviceToken);
    NSLog(@"USER RECUPERE = %@",USER);
    NSLog(@"PASSWORD RECUPERE = %@",PASSWORD);
    
    
    if (USER.length>0) {
        
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bienvenue sur boursicoincoin"
         message:USER
         delegate:nil
         cancelButtonTitle:@"OK"
         otherButtonTitles:nil];
         [alertView show];
         
        TextLOG.text=USER;
        TextPWD.text=PASSWORD;
        
        [self performSegueWithIdentifier:@"ShowScreen1" sender:nil];
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self performSegueWithIdentifier:@"ShowScreen1" sender:nil];
    NSLog(@"vue chargee");
    
    
     NSLog(@"viewDidLoad");
    
  /*  NSString *USER = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER"];
    NSString *PASSWORD = [[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"];
    
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSLog(@"deviceToken recupere=%@",deviceToken);
    NSLog(@"USER RECUPERE = %@",USER);
    NSLog(@"PASSWORD RECUPERE = %@",PASSWORD);
    
    
    if (USER.length>0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bienvenue sur boursicoincoin"
                                                            message:USER
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        TextLOG.text=USER;
        TextPWD.text=PASSWORD;
        
        [self performSegueWithIdentifier:@"ShowScreen1" sender:nil];
        //[self Action_Connect:nil];
  
    }
   
   */
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
