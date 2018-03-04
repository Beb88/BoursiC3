//
//  AlerteMMViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 12/10/13.
//
//

#import "AlerteMMViewController.h"
#import "Valeurs_Alertes.h"
#import "Indicateurs.h"
#import "Valeurs.h"

#import "AFNetworking.h"
#import "SBJson.h"

@interface AlerteMMViewController ()

@end


@implementation AlerteMMViewController

@synthesize delegateAlertMM,AlertToEdit,Indicateur_infos ,textMM1,textMM1Live,textMM2,textMM2Live,textTypeMM,Valeur_recue_ByListIndic,CodeYF,textDescIndicateur,pickerTypeMM,arrayNo;

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
    
    if(textField == textTypeMM)
    {
        NSLog(@"PICKER TYPEMM ");//pickerTypeMM.tag = PICKERADDRESS;
    }
    
    
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"Valeur_recue = %@   ",self.Valeur_recue_ByListIndic.codeBourso);
    arrayNo = [[NSMutableArray alloc] init];
    [arrayNo addObject:@" MM "];
    [arrayNo addObject:@" COURS "];
   
    
    [pickerTypeMM selectRow:1 inComponent:0 animated:NO];
    
    //self.textTypeMM.inputView = pickerTypeMM;
    
    // SI MODIFICATION D UNE ALERTE
    if (self.AlertToEdit != nil) {
        
        // [ButtonAjoutAlert setTitle:@"Modif Alerte" forState:UIControlStateNormal];

        CodeYF = self.AlertToEdit.id_Valeur;
        
        //self.textCoursActuel.text = self.AlertToEdit.
        self.textNomAlerte.text= self.AlertToEdit.nom_alerte ;
        self.textTypeMM.text =self.AlertToEdit.param1 ;
        self.textMM1.text =self.AlertToEdit.param2 ;
        self.textMM2.text =self.AlertToEdit.param3 ;
        self.textDescIndicateur.text = self.AlertToEdit.param5 ;
       
    }
    else{
        CodeYF = self.Valeur_recue_ByListIndic.codeBourso;
        self.textCoursActuel.text = self.Valeur_recue_ByListIndic.cotation;
        self.textDescIndicateur.text = Indicateur_infos.descIndic;
    }
    
   
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    textTypeMM.text=    [arrayNo objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [arrayNo count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [arrayNo objectAtIndex:row];
}



- (IBAction)RetourListeAlertes
{
    
    //   Valeurs *valeur = [Valeurs new];
    //= @"NV";//self.textField.text;
    //valeur.checked = NO;
    
    [self.delegateAlertMM alertViewControllerDidCancel:self];
    
    //Retour sur ecran precedent
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}



-(IBAction)AjoutAlertMM
{
    
    //ON RECUPERE LES DONNEES DE L ECRAN
    
    // SI AJOUT D UNE ALERTE MM
    if (self.AlertToEdit == nil) {
        
        Valeurs_Alertes *alerte = [[Valeurs_Alertes alloc] init];
        alerte.id_indic=@"6"; //MM
        alerte.id_Valeur =CodeYF;
        //alerte.id_Valeur =self.AlertToEdit.id_Valeur;
        
        //self.AlertToEdit.nom_alerte = @"Seuil";
        alerte.nom_alerte = self.textNomAlerte.text;
        alerte.param1 = self.textTypeMM.text;
        alerte.param2 = self.textMM1.text;
        alerte.param3 = self.textMM2.text;
        
        alerte.param5 = self.Indicateur_infos.descIndic;
        
        
        NSLog(@"TEST MM");
        NSLog(@"ON VA ENVOYER LA NOUVELLE ALERTE A L ECRAN DETAIL VALEUR LIST INDIC : %@",alerte);
        
        [self.delegateAlertMM alertMMViewController:self didFinishAddingAlertlist:(Valeurs_Alertes *)alerte];
        
           }
    // SI MODIF D UNE ALERT SEUIL
    else
        
    {
        self.AlertToEdit.nom_alerte = self.textNomAlerte.text;
        self.AlertToEdit.param1 = self.textTypeMM.text;
        self.AlertToEdit.param2 = self.textMM1.text;
        self.AlertToEdit.param3 = self.textMM2.text;
        
        NSLog(@"ON VA ENVOYER LA NOUVELLE ALERTE MODIFIE A L ECRAN LISTESALERTES : P1 =%@ , P2 =%@, P3 =%@  , P4 = %@ ",self.AlertToEdit.param1,self.AlertToEdit.param2,self.AlertToEdit.param3,self.AlertToEdit.param4);
        
        [self.delegateAlertMM alertMMViewController:self didFinishEditingAlertlist:self.AlertToEdit];
    }
    
    
    
    
    
    
}


-(IBAction)MM1HasChanged
{
    
        //1&1
        NSURL *url = [NSURL URLWithString:@"http://88.191.209.98:80BCC/BCC/jsonConnect.php"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
   // Moyenne mobile
   // Action : getMM
   // POST en entrée : 'codeyf' (String), 'mm' (Long)
   // JSON : {"result":10.867619047619}
  
        //LES PARAM PASSES EN POST
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"beblouis@gmail.com", @"user",
                                @"beb", @"password",
                                @"getMM",@"action",
                                CodeYF,@"codeyf",
                                textMM1.text,@"mm",
                                nil];// Autre param a envoyer
        
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://88.191.209.98:80/BCC/BCC/jsonConnect.php"parameters:params];
    
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSLog(@"RECUPERATION MM1 OK SUR  SERVEUR");
            NSLog(@"REQUEST OK JSON");
            NSLog(@"json: %@", JSON);
          //  NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
            //
            NSString *MM1 = [NSString stringWithFormat:@"%@",[JSON objectForKey:@"result"]];
            textMM1Live.text = MM1;
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RECUP MM1 du serveur OK"
                                                                message:@""
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
            NSLog(@"ERREUR RECUPERATION DES indicateurs SUR SERVEUR");
          //  NSLog(@"BAD REQUEST JSON");
           // NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
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

-(IBAction)MM2HasChanged
{
    
    //1&1
    NSURL *url = [NSURL URLWithString:@"http://88.191.209.98:80/BCC/BCC/jsonConnect.php"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    // Moyenne mobile
    // Action : getMM
    // POST en entrée : 'codeyf' (String), 'mm' (Long)
    // JSON : {"result":10.867619047619}
    
    //LES PARAM PASSES EN POST
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"beblouis@gmail.com", @"user",
                            @"beb", @"password",
                            @"getMM",@"action",
                            CodeYF,@"codeyf",
                            textMM2.text,@"mm",
                            nil];// Autre param a envoyer
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://88.191.209.98:80BCC/BCC/jsonConnect.php"parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"RECUPERATION MM1 OK SUR  SERVEUR");
        NSLog(@"REQUEST OK JSON");
        NSLog(@"json: %@", JSON);
     //   NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        
        NSString *MM2 = [NSString stringWithFormat:@"%@",[JSON objectForKey:@"result"]];
        
        //NSString *MM1= [[NSString alloc] init];
        //MM1 = [JSON objectForKey:@"result"];
        
        textMM2Live.text = MM2;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RECUP MM2 du serveur OK"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
        NSLog(@"ERREUR RECUPERATION DES indicateurs SUR SERVEUR");
        NSLog(@"BAD REQUEST JSON");
      ///  NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
