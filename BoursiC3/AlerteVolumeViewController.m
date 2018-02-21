//
//  AlerteVolumeViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 18/02/13.
//
//

#import "AlerteVolumeViewController.h"
#import "Valeurs_Alertes.h"
#import "Indicateurs.h"
#import "Valeurs.h"

@interface AlerteVolumeViewController ()

@end

@implementation AlerteVolumeViewController

@synthesize delegateAlertVolume,AlertToEdit,textFranchissementHausse,textNomAlerte,Indicateur_infos,Valeur_recue_ByListIndic,CodeYF,textDescIndic,textIndicAlerte,textVolumMoy,switchIsActive;

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
    
    NSLog(@"Valeur_recue = %@   ",self.Valeur_recue_ByListIndic.codeBourso);
    
    
    // SI MODIFICATION D UNE ALERTE
    if (self.AlertToEdit != nil) {
        
        // [ButtonAjoutAlert setTitle:@"Modif Alerte" forState:UIControlStateNormal];
        
        CodeYF = self.AlertToEdit.id_Valeur;
        //self.textCoursActuel.text = self.AlertToEdit.
        self.textNomAlerte.text= self.AlertToEdit.nom_alerte ;
        //self.textVolumMoy.text = self.AlertToEdit
        self.textFranchissementHausse.text =self.AlertToEdit.param1 ;
        
        if ( [self.AlertToEdit.isActive isEqual: @"1"] ) {
                       //ON RESTITUE L ETAT ON
            [self.switchIsActive setOn:YES ];
             }
        
        
        //self.AlertToEdit.isActive
        
    }
    else{ //NEW ALERT
        CodeYF = self.Valeur_recue_ByListIndic.codeBourso;
        self.textVolumMoy.text =self.Valeur_recue_ByListIndic.volumeMoy;
        self.textDescIndic.text = Indicateur_infos.descIndic;
    }

    
    
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"retour clavier");
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)RetourListeAlertes
{
    [self.delegateAlertVolume alertViewControllerDidCancel:self];
    
}


-(IBAction)AjoutAlertVolumetrie
{
    
    if (self.AlertToEdit == nil) {
        
        Valeurs_Alertes *alerte = [[Valeurs_Alertes alloc] init];
       
        alerte.id_indic=@"1"; 
        alerte.id_Valeur =CodeYF;
        
        alerte.nom_alerte = self.textNomAlerte.text;
        alerte.param1 = self.textFranchissementHausse.text;
        
        
        NSLog(@"TEST SEUIL");
        NSLog(@"ON VA ENVOYER LA NOUVELLE ALERTE A L ECRAN DETAIL VALEUR LIST INDIC : %@",alerte);
        
        [self.delegateAlertVolume alertvolumeViewController:self didFinishAddingAlertlist:(Valeurs_Alertes *)alerte];
    } else {
         self.AlertToEdit.nom_alerte = self.textNomAlerte.text;
         self.AlertToEdit.param1 = self.textFranchissementHausse.text;
        
        [self.delegateAlertVolume alertVolumeViewController:self didFinishEditingAlertlist:self.AlertToEdit];
    }
    
    
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alerte volume"
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
