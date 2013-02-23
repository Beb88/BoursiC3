//
//  AlerteSeuilViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 09/02/13.
//
//

#import "AlerteSeuilViewController.h"
#import "Valeurs_Alertes.h"
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

-(IBAction)AjoutAlertSeuil
{
    
    
    
    if (self.AlertToEdit == nil) {
        
        Valeurs_Alertes *alerte = [[Valeurs_Alertes alloc] init];
        
        alerte.nom_alerte = @"Seuil";
        alerte.param1 = self.textFranchissementHausse.text;
        
        
        NSLog(@"TEST SEUIL");
        NSLog(@"ON VA ENVOYER LA NOUVELLE ALERTE A L ECRAN DETAIL VALEUR LIST INDIC : %@",alerte);
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alerte Seuil"
                                                            message:@"Alerte Crée"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
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
