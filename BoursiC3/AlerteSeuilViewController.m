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

#import "Indicateurs.h"
#import "Valeurs.h"
@interface AlerteSeuilViewController ()

@end

@implementation AlerteSeuilViewController

@synthesize textFranchissementBaisse,textFranchissementHausse,textProchede,ButtonAjoutAlert,delegateAlertSeuil,AlertToEdit,labelValeur, SwitchFranchissementHausse, SwithFranchissementBaisse,textBaisse,textHausse,textNomAlerte,textDescIndic,CodeYF,Indicateur_infos,Valeur_recue_ByListIndic;



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
        
        
       // ButtonAjoutAlert.titleLabel.text = @"Modif Alerte";
        [ButtonAjoutAlert setTitle:@"Modif Alerte" forState:UIControlStateNormal];
        
        //self.ButtonAjoutAlert.titleLabel = @"Modif Alerte";
        CodeYF = AlertToEdit.id_Valeur;
        //ButtonAjoutAlert.titleLabel = @"ded";
        NSLog(@"ALERTE EDITEE : %@", self.AlertToEdit.id_alerte );
        if ([AlertToEdit.sens isEqualToString: @"H"]) {
               textFranchissementHausse.text = AlertToEdit.param1;
        }
        else if ([AlertToEdit.sens isEqualToString: @"B"])
        {textFranchissementBaisse.text = AlertToEdit.param1;
        }
     
       // textFranchissementBaisse.text = AlertToEdit.param3;
        textNomAlerte.text= AlertToEdit.nom_alerte;
        //ALERTE ACTIVE
        if ( [self.AlertToEdit.etat_alerte  isEqual: @"ON"] ) {
            //SI ALERTE HAUSSE ACTIVE
            if ( [self.AlertToEdit.sens  isEqual: @"H"] ) {
                //ON DESACTIVE L ALERTE BAISSE
                [self.SwithFranchissementBaisse setHidden:YES];
                [self.textFranchissementBaisse setHidden:YES];
                [self.textBaisse setHidden:YES];
                AlertToEdit.param3=@"";
                AlertToEdit.param4=@"OFF";
              
                //ON RESTITUE L ETAT ON/OFF DE L ALERTE HAUSSE ET BASSE
                [self.SwitchFranchissementHausse setOn:YES ];
                [self.SwithFranchissementBaisse setOn:NO ];
                
            }
            //SI ALERTE BASSE ACTIVE
            if ( [self.AlertToEdit.sens isEqual: @"B"] ) {
                 //ON DESACTIVE L ALERTE HAUSSE
                [self.SwitchFranchissementHausse setHidden:YES];
                [self.textFranchissementHausse setHidden:YES];
                [self.textHausse setHidden:YES];
                //ON RESTITUE L ETAT ON
                [self.SwithFranchissementBaisse setOn:YES ];
                [self.SwitchFranchissementHausse setOn:NO ];
                
                
            }
            else [self.SwithFranchissementBaisse setOn:NO ];
            
            
            textFranchissementHausse.text = AlertToEdit.param1;
            textFranchissementBaisse.text = AlertToEdit.param3;

        }
        
        
    }
    else{
    
        CodeYF = self.Valeur_recue_ByListIndic.codeBourso;
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
    [self.delegateAlertSeuil alertViewControllerDidCancel:self];
   
}



-(IBAction)AjoutAlertSeuil
{
    
    //ON RECUPERE LES DONNEES DE L ECRAN
    
    // SI AJOUT D UNE ALERTE SEUIL
    if (self.AlertToEdit == nil) {
        
        Valeurs_Alertes *alerte = [[Valeurs_Alertes alloc] init];
        alerte.id_indic=@"2";
        
        //self.AlertToEdit.nom_alerte = @"Seuil";
        alerte.nom_alerte = self.textNomAlerte.text;
        alerte.param1 = self.textFranchissementHausse.text;
        if ( [self.SwitchFranchissementHausse isOn]) {
            alerte.param2 = @"ON";
            alerte.sens = @"H";
        }
        else alerte.param2 = @"OFF";
        alerte.param3 = self.textFranchissementBaisse.text;
        if ([self.SwithFranchissementBaisse isOn]){
           alerte.param4 = @"ON";
             alerte.sens = @"B";
        }
        else alerte.param4 = @"OFF";
      
        NSLog(@"TEST SEUIL");
        NSLog(@"ON VA ENVOYER LA NOUVELLE ALERTE A L ECRAN DETAIL VALEUR LIST INDIC : %@",alerte);
     
        [self.delegateAlertSeuil alertSeuilViewController:self didFinishAddingAlertlist:(Valeurs_Alertes *)alerte];
        
        
        // [self.delegateAlertSeuil alertSeuilViewController:self didFinishAddingAlertlist:(Valeurs_Alertes *)alerte];
    }
    // SI MODIF D UNE ALERT SEUIL
    else
    
    {
        
        //GESTION MONO ALERTE QD EDITION  D UNE ALERTE
        self.AlertToEdit.param1 = self.textFranchissementHausse.text;
        self.AlertToEdit.param3 = self.textFranchissementBaisse.text;
        self.AlertToEdit.nom_alerte = self.textNomAlerte.text;
        //self.ButtonAjoutAlert.titleLabel = @"Modification Alerte";
        
        if ( [self.SwitchFranchissementHausse isOn]) {
            self.AlertToEdit.param2 = @"ON";
            self.AlertToEdit.sens=@"H";
            
        }
        else {
           self.AlertToEdit.param2 = @"OFF";
            
        }
        
       
        if ([self.SwithFranchissementBaisse isOn]){
            self.AlertToEdit.param4 = @"ON";
              self.AlertToEdit.sens=@"B";
            
        }
        else {
             self.AlertToEdit.param4 = @"OFF";
            
        }
        
           NSLog(@"ON VA ENVOYER LA NOUVELLE ALERTE MODIFIE A L ECRAN LISTESALERTES : P1 =%@ , P2 =%@, P3 =%@  , P4 = %@ ",self.AlertToEdit.param1,self.AlertToEdit.param2,self.AlertToEdit.param3,self.AlertToEdit.param4);
       

        [self.delegateAlertSeuil alertSeuilViewController:self didFinishEditingAlertlist:self.AlertToEdit];
    }

    
    
   
    
    
   }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
