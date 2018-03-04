//
//  AlerteMACDViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 13/10/13.
//
//

#import "AlerteMACDViewController.h"
#import "Valeurs_Alertes.h"
#import "Indicateurs.h"
#import "Valeurs.h"
#import "AFNetworking.h"
#import "SBJson.h"

@interface AlerteMACDViewController ()

@end

@implementation AlerteMACDViewController


@synthesize AlertToEdit,delegateAlertMACD,SwitchBaisse,SwitchHausse,textMACDEnCours,textNomAlerte,Indicateur_infos,textDescIndic,CodeYF,textDiffEnCours,textSignalEncours;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"retour clavier");
    [textField resignFirstResponder];
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   

    // SI MODIFICATION D UNE ALERTE
    if (self.AlertToEdit != nil) {
        
        // [ButtonAjoutAlert setTitle:@"Modif Alerte" forState:UIControlStateNormal];
        CodeYF = self.AlertToEdit.id_Valeur;
        self.textNomAlerte.text= self.AlertToEdit.nom_alerte ;
       
        self.textDescIndic.text = self.AlertToEdit.param5 ;
        //GEstion des switch ( à rajouter)
        
        
        
    }
    else{
        CodeYF = self.Valeur_recue_ByListIndic.codeBourso;
        self.textDescIndic.text = Indicateur_infos.descIndic;
    }
 [self getMACD];

}

-(void)getMACD
{
    
    //1&1
    NSURL *url = [NSURL URLWithString:@"http://88.191.209.98:80:BCC/BCC/jsonConnect.php"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    // Moyenne mobile
    // Action : getMM
    // POST en entrée : 'codeyf' (String), 'mm' (Long)
    // JSON : {"result":10.867619047619}
    
    //LES PARAM PASSES EN POST
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"beblouis@gmail.com", @"user",
                            @"beb", @"password",
                            @"getMacd",@"action",
                            CodeYF,@"codeyf",
                         
                            nil];// Autre param a envoyer
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://88.191.209.98:80/BCC/BCC//jsonConnect.php" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"RECUPERATION MM1 OK SUR  SERVEUR");
        NSLog(@"REQUEST OK JSON");
        NSLog(@"json: %@", JSON);
        NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        
       // NSMutableArray *MACDLIVE = [JSON objectForKey:@"result"];
        
        //NSDictionary *listMACD = [MACDLIVE objectAtIndex:0];
        
      //  NSString *bidule =[NSString stringWithFormat:@"%@",[listMACD objectForKey:@"macd"]];
       // alerte.nom_alerte = [listValDict3 objectForKey:@"nameAlert"];
        //alerte.id_alerte = [listValDict3 objectForKey:@"idAlert"];
        //alerte.id_indic =[listValDict3 objectForKey:@"idIndic"];
        //NSString *MM1= [[NSString alloc] init];
        //MM1 = [JSON objectForKey:@"result"];
       
        
        
        
         NSString *MACD = [NSString stringWithFormat:@"%@",[[JSON objectForKey:@"result"] objectForKey:@"macd"]];
        NSString *DIFF = [NSString stringWithFormat:@"%@",[[JSON objectForKey:@"result"] objectForKey:@"diff"]];
        NSString *signal = [NSString stringWithFormat:@"%@",[[JSON objectForKey:@"result"] objectForKey:@"signal"]];
        
        textMACDEnCours.text = MACD;
        textSignalEncours.text = signal;
        textDiffEnCours.text = DIFF;
        
       // textMACDEnCours.text = bidule;
        //signal
        //diff
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RECUP MACD du serveur OK"
                                                            message:@"Récupation MACD"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
        NSLog(@"ERREUR RECUPERATION DES MACD SUR SERVEUR");
        NSLog(@"BAD REQUEST JSON");
        NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"json: %@", JSON);
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Serveur non disponible"
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
    [self.delegateAlertMACD alertViewControllerDidCancel:self];
    
}

-(IBAction)AjoutAlertMACD
{
    
    //ON RECUPERE LES DONNEES DE L ECRAN
    
    // SI AJOUT D UNE ALERTE MM
    if (self.AlertToEdit == nil) {
        
        Valeurs_Alertes *alerte = [[Valeurs_Alertes alloc] init];
        alerte.nom_alerte = textNomAlerte.text;
        alerte.id_indic=@"7";
        
        //self.AlertToEdit.nom_alerte = @"Seuil";
        alerte.nom_alerte = @"MACD";
        
        if ( [self.SwitchBaisse isOn]) {
            alerte.param1 = @"B";
        }
        else if ( [self.SwitchHausse isOn]) {
            alerte.param1 = @"H";
        }
    
        
        NSLog(@"TEST MACD");
        NSLog(@"ON VA ENVOYER LA NOUVELLE ALERTE A L ECRAN DETAIL VALEUR LIST INDIC : %@",alerte);
        
        [self.delegateAlertMACD alertMACDViewController:self didFinishAddingAlertlist: alerte];
        
        
    }
    // SI MODIF D UNE ALERT SEUIL
    else
        
    {
        
       
        
        [self.delegateAlertMACD alertMACDViewController:self didFinishEditingAlertlist:self.AlertToEdit];
    }
    
    
    
    
    
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
