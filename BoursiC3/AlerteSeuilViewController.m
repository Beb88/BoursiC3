//
//  AlerteSeuilViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 09/02/13.
//
//

#import "AlerteSeuilViewController.h"
#import "Valeurs_Alertes.h"
#import "AFNetworking.h"
#import "SBJson.h"
@interface AlerteSeuilViewController ()

@end

@implementation AlerteSeuilViewController

@synthesize textFranchissementBaisse,textFranchissementHausse,textProchede,ButtonAjoutAlert,delegateAlertSeuil,AlertToEdit,labelValeur;

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

-(void)Inscription_Alerte_Serveur:(Valeurs_Alertes *)new_alert
{
    //1&1
/*    NSURL *url = [NSURL URLWithString:@"http://s454555776.onlinehome.fr/boursicoincoin/jsonConnect.php"];
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    
   // new_alert.id_Valeur
    //new_alert.id_alerte
   // new_alert.param1
   // new_alert.nom_alerte
   // NSLog(@"Valeur passé pour creation d alerte : %@", new_alert.cod );
    //LES PARAM PASSES EN POST
    
    
    NSLog(@"LA NOUVELLE ALERTE CONTIENT : %i,  %i,   %@, %@ ", new_alert.id_Valeur, new_alert.id_alerte, new_alert.nom_alerte, new_alert.param1);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"beb", @"user",
                            @"beb", @"password",
                            @"setNewAlert",@"action",
                            @"UBI.PA", @"codeyf",
                            @"2", @"idindic", //1 ou 2(seuil)
                            @"notif", @"typealert", //notif ou mail
                            @"THEFIRSTNAMEALERT", @"namealert",
                            @"10", @"seuil", //
                            @"H", @"sens", // H ou B
                            @"0", @"volume",///
                            nil];// Autre param a envoyer
    
    
    
    
    // user, passwd, action, ticker, typealert, typenotif, tableauparam
    
    // user, pwd, action, codeyf, idalert(2 = Seuil) , typealert(mail ,sms ou phone), seuil(numerique), sens(h ou b)
    
    
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://s454555776.onlinehome.fr/boursicoincoin/jsonConnect.php"parameters:params];
    
    
    
    //MISE EN COMMENTAIRE EN VUE DE SUPPRESSION DE LECRAN et DU LOG
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //  self.movies = [JSON objectForKey:@"NOMVALEUR"];
        NSLog(@"INSCRIPTION ALERTE OK SUR  SERVEUR");
        NSLog(@"REQUEST OK JSON");
        NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"json: %@", JSON);
        
        
        NSString *bidule =   [JSON objectForKey:@"result"];
        NSLog(@"BADOUM=%@",bidule);
        AlertToEdit.id_alerte=bidule;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alerte Seuil"
                                                            message:@"Alerte Crée"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
       
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
        NSLog(@"ERREUR INSCRIPTION ALERTE SUR SERVEUR");
        NSLog(@"BAD REQUEST JSON");
        NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"json: %@", JSON);
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Réseau non disponible"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
    
    
    
    [operation start];
    
  */  


}


-(IBAction)AjoutAlertSeuil
{
    
    if (self.AlertToEdit == nil) {
        
        Valeurs_Alertes *alerte = [[Valeurs_Alertes alloc] init];
        
        alerte.nom_alerte = @"Seuil";
        alerte.param1 = self.textFranchissementHausse.text;
        
      
        NSLog(@"TEST SEUIL");
        NSLog(@"ON VA ENVOYER LA NOUVELLE ALERTE A L ECRAN DETAIL VALEUR LIST INDIC : %@",alerte);
     
        //[self Inscription_Alerte_Serveur:alerte];
   
    
    //FONCTION DE CREATION D ALERTE  ( A VIRER , CAR PRESENTE DANS ECRAN 3)
   /*
        NSURL *url = [NSURL URLWithString:@"http://s454555776.onlinehome.fr/boursicoincoin/jsonConnect.php"];
        
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        
        
        // new_alert.id_Valeur
        //new_alert.id_alerte
        // new_alert.param1
        // new_alert.nom_alerte
        // NSLog(@"Valeur passé pour creation d alerte : %@", new_alert.cod );
        //LES PARAM PASSES EN POST
        
    
        
        NSLog(@"ENVOIE AU SERVEUR INCRIPTION ALERTE : ID_VAL =%i,  ID_ALERTE=%@,   NOM_ALERTE =%@, PARAM1 =%@ ", alerte.id_Valeur, alerte.id_alerte, alerte.nom_alerte, alerte.param1);
        
     /*  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"beb", @"user",
                                @"beb", @"password",
                                @"setNewAlert",@"action",
                                @"UBI.PA", @"codeyf",
                                @"2", @"idindic", //1 ou 2(seuil)
                                @"notif", @"typealert", //notif ou mail
                                @"THEFIRSTNAMEALERT", @"namealert",
                                @"10", @"seuil", //
                                @"H", @"sens", // H ou B
                                @"0", @"volume",///
                                nil];// Autre param a envoyer
        
        */
        //FONCTION TEST JSON
       /* NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"beb", @"user",
                                @"beb", @"password",
                                @"settest",@"action",
                                nil];// Autre param a envoyer
*/
        
        // user, passwd, action, ticker, typealert, typenotif, tableauparam
        
        // user, pwd, action, codeyf, idalert(2 = Seuil) , typealert(mail ,sms ou phone), seuil(numerique), sens(h ou b)
        
        
     /*
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://s454555776.onlinehome.fr/boursicoincoin/jsonConnect.php"parameters:params];
        
        
        
        //MISE EN COMMENTAIRE EN VUE DE SUPPRESSION DE LECRAN et DU LOG
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            //  self.movies = [JSON objectForKey:@"NOMVALEUR"];
            NSLog(@"INSCRIPTION ALERTE FROM SCREEN 6 OK SUR  SERVEUR");
            NSLog(@"REQUEST OK JSON");
            NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
            NSLog(@"json: %@", JSON);
            
            
            NSString *id_alert_recup =   [JSON objectForKey:@"result"];
          
            alerte.id_alerte=id_alert_recup;
            
             NSLog(@"alerte.id_alerte=%@",alerte.id_alerte);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alerte Seui Crée"
                                                                message:alerte.id_alerte
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
            NSLog(@"ERREUR INSCRIPTION FROM SCREEN6 ALERTE SUR SERVEUR");
            NSLog(@"BAD REQUEST JSON");
            NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
            NSLog(@"json: %@", JSON);
            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Réseau non disponible"
                                                                message:@""
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            
        }];
        
        
        
        [operation start];
        
*/
        
        
        [self.delegateAlertSeuil alertSeuilViewController:self didFinishAddingAlertlist:(Valeurs_Alertes *)alerte];
    } else {
        
           NSLog(@"ON VA ENVOYER LA NOUVELLE ALERTE MODIFIE A L ECRAN DETAIL VALEUR LIST INDIC : %@",self.AlertToEdit.param1);
         self.AlertToEdit.param1 = self.textFranchissementHausse.text;

        [self.delegateAlertSeuil alertSeuilViewController:self didFinishEditingAlertlist:self.AlertToEdit];
    }

    
    
   
    
    
   }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
