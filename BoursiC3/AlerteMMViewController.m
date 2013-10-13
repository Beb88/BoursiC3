//
//  AlerteMMViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 12/10/13.
//
//

#import "AlerteMMViewController.h"
#import "Valeurs_Alertes.h"
@interface AlerteMMViewController ()

@end



@implementation AlerteMMViewController

@synthesize delegateAlertMM,AlertToEdit;

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

    
    }
    
    
}



-(IBAction)AjoutAlertMM
{
    
    //ON RECUPERE LES DONNEES DE L ECRAN
    
    // SI AJOUT D UNE ALERTE MM
    if (self.AlertToEdit == nil) {
        
        Valeurs_Alertes *alerte = [[Valeurs_Alertes alloc] init];
        alerte.id_indic=@"6";
        
        //self.AlertToEdit.nom_alerte = @"Seuil";
        alerte.nom_alerte = @"MM";
        alerte.param1 = self.textTypeMM.text;
        alerte.param2 = self.textMM1.text;
        alerte.param3 = self.textMM2.text;
        
        
        
        NSLog(@"TEST SEUIL");
        NSLog(@"ON VA ENVOYER LA NOUVELLE ALERTE A L ECRAN DETAIL VALEUR LIST INDIC : %@",alerte);
        
        [self.delegateAlertMM alertMMViewController:self didFinishAddingAlertlist:(Valeurs_Alertes *)alerte];
        
           }
    // SI MODIF D UNE ALERT SEUIL
    else
        
    {
       
        self.AlertToEdit.param1 = self.textTypeMM.text;
        self.AlertToEdit.param2 = self.textMM1.text;
        self.AlertToEdit.param3 = self.textMM2.text;
        
        NSLog(@"ON VA ENVOYER LA NOUVELLE ALERTE MODIFIE A L ECRAN LISTESALERTES : P1 =%@ , P2 =%@, P3 =%@  , P4 = %@ ",self.AlertToEdit.param1,self.AlertToEdit.param2,self.AlertToEdit.param3,self.AlertToEdit.param4);
        
        [self.delegateAlertMM alertMMViewController:self didFinishEditingAlertlist:self.AlertToEdit];
    }
    
    
    
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
