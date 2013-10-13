//
//  AlerteMACDViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 13/10/13.
//
//

#import "AlerteMACDViewController.h"
#import "Valeurs_Alertes.h"
@interface AlerteMACDViewController ()

@end

@implementation AlerteMACDViewController


@synthesize AlertToEdit,delegateAlertMACD;

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




-(IBAction)AjoutAlertMACD
{
    
    //ON RECUPERE LES DONNEES DE L ECRAN
    
    // SI AJOUT D UNE ALERTE MM
    if (self.AlertToEdit == nil) {
        
        Valeurs_Alertes *alerte = [[Valeurs_Alertes alloc] init];
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
