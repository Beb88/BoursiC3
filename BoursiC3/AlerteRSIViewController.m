//
//  AlerteRSIViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 13/10/13.
//
//

#import "AlerteRSIViewController.h"
#import "Valeurs_Alertes.h"
#import "Indicateurs.h"
#import "Valeurs.h"
#import "AFNetworking.h"
#import "SBJson.h"

@interface AlerteRSIViewController ()

@end

@implementation AlerteRSIViewController



@synthesize AlertToEdit,delegateAlertRSI,TextRSICible,SwitchHausse,SwitchBaisse,TextNomAlerte,textDescIndic,textRSIEnCours,CodeYF,Indicateur_infos,Valeur_recue_ByListIndic;

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
    
   
    
    // SI MODIFICATION D UNE ALERTE
    if (self.AlertToEdit != nil) {
        
        //[ButtonAjoutAlert setTitle:@"Modif Alerte" forState:UIControlStateNormal];
        
        CodeYF = self.AlertToEdit.id_Valeur;
        self.TextNomAlerte.text= self.AlertToEdit.nom_alerte ;
        self.TextRSICible.text = self.AlertToEdit.param2;
        self.textDescIndic.text = self.AlertToEdit.param5 ;
        
        if ( [self.AlertToEdit.param1  isEqualToString:@"H"]) {
            
            [self.SwitchHausse setOn:YES];
        }
        else {
            [self.SwitchBaisse setOn:YES];
            
        }
        
    }
    else{
        CodeYF = self.Valeur_recue_ByListIndic.codeBourso;
        self.textDescIndic.text = Indicateur_infos.descIndic;
    }
     [self getRSI];
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"retour clavier");
    [textField resignFirstResponder];
    return YES;
}


-(void)getRSI
{
    
    //1&1
    NSURL *url = [NSURL URLWithString:@"http://78.192.193.7:8888/BCC/BCC/jsonConnect.php"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    // Moyenne mobile
    // Action : getMM
    // POST en entrée : 'codeyf' (String), 'mm' (Long)
    // JSON : {"result":10.867619047619}
    
    //LES PARAM PASSES EN POST
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"beblouis@gmail.com", @"user",
                            @"beb", @"password",
                            @"getRsi",@"action",
                            CodeYF,@"codeyf",
                            
                            nil];// Autre param a envoyer
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://78.192.193.7:8888/BCC/BCC/jsonConnect.php" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"RECUPERATION MM1 OK SUR  SERVEUR");
        NSLog(@"REQUEST OK JSON");
        NSLog(@"json: %@", JSON);
      //  NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        
        NSString *RSILIVE = [NSString stringWithFormat:@"%@",[JSON objectForKey:@"result"]];
        
        // NSString *MM1 = [NSString stringWithFormat:@"%@",[JSON objectForKey:@"result"]];
       // textMM1Live.text = MM1;

        
       // NSDictionary *listMACD = [MACDLIVE objectAtIndex:0];
        // alerte.nom_alerte = [listValDict3 objectForKey:@"nameAlert"];
        //alerte.id_alerte = [listValDict3 objectForKey:@"idAlert"];
        //alerte.id_indic =[listValDict3 objectForKey:@"idIndic"];
        //NSString *MM1= [[NSString alloc] init];
        //MM1 = [JSON objectForKey:@"result"];
        
        textRSIEnCours.text = RSILIVE;
        //signal
        //diff
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RECUP RSI du serveur OK"
                                                            message:@"Récupation RSI"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
        NSLog(@"ERREUR RECUPERATION DES indicateurs SUR SERVEUR");
        NSLog(@"BAD REQUEST JSON");
        NSLog(@"json count: %lu, key: %@, value: %@", (unsigned long)[JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"json: %@", JSON);
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Réseau non disponible"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
    
    [operation start];
    // NSLog(@"listIndic globale = %@ ",listIndic);
    
    
    
    
    
    
}

- (IBAction)RetourListeAlertes
{
    [self.delegateAlertRSI alertViewControllerDidCancel:self];
    
}


-(IBAction)Ajout_Update_AlertRSI
{
    
    //ON RECUPERE LES DONNEES DE L ECRAN
    
    // SI AJOUT D UNE ALERTE MACD
    if (self.AlertToEdit == nil) {
        
        Valeurs_Alertes *alerte = [[Valeurs_Alertes alloc] init];
        alerte.id_indic=@"8";
        
        //self.AlertToEdit.nom_alerte = @"Seuil";
        alerte.nom_alerte = self.TextNomAlerte.text;
        
        if ( [self.SwitchBaisse isOn]) {
            alerte.param1 = @"B";
        }
        else if ( [self.SwitchHausse isOn]) {
            alerte.param1 = @"H";
        }
        
        alerte.param2 = self.TextRSICible.text;
        
        
        NSLog(@"TEST MACD");
        NSLog(@"ON VA ENVOYER LA NOUVELLE ALERTE A L ECRAN DETAIL VALEUR LIST INDIC : %@",alerte);
        
        [self.delegateAlertRSI alertRSIViewController:self didFinishAddingAlertlist: alerte];
        
        
    }
    // SI MODIF D UNE ALERT MACD
    else
        
    {
        
        self.AlertToEdit.nom_alerte = self.TextNomAlerte.text;
        
        if ( [self.SwitchBaisse isOn]) {
            self.AlertToEdit.param1 = @"B";
        }
        else if ( [self.SwitchHausse isOn]) {
            self.AlertToEdit.param1 = @"H";
        }
        
        self.AlertToEdit.param2 = self.TextRSICible.text;

        
        [self.delegateAlertRSI alertRSIViewController:self didFinishEditingAlertlist:self.AlertToEdit];
    }
    
    
    
    
    
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
