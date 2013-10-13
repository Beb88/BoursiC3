//
//  AlerteVolumeViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 18/02/13.
//
//

#import "AlerteVolumeViewController.h"
#import "Valeurs_Alertes.h"
@interface AlerteVolumeViewController ()

@end

@implementation AlerteVolumeViewController

@synthesize delegateAlertVolume,AlertToEdit;

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
    // Do any additional setup after loading the view from its nib.
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
        
        alerte.nom_alerte = @"Volumetrie";
        alerte.param1 = self.textFranchissementHausse.text;
        
        
        NSLog(@"TEST SEUIL");
        NSLog(@"ON VA ENVOYER LA NOUVELLE ALERTE A L ECRAN DETAIL VALEUR LIST INDIC : %@",alerte);
        
        [self.delegateAlertVolume alertvolumeViewController:self didFinishAddingAlertlist:(Valeurs_Alertes *)alerte];
    } else {
        // self.AlertToEdit.name = self.textField.text;
        //[self.delegateIG indicateursViewController:self didFinishEditingChecklist:self.AlertToEdit];
    }
    
    
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alerte Seuil"
                                                        message:@"Alerte Crée"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
