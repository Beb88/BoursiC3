//
//  IndicateursViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 09/01/13.
//
//

#import "IndicateursViewController.h"

#import "Valeurs_Alertes.h"

@interface IndicateursViewController ()

@end

@implementation IndicateursViewController

@synthesize textSeuil,ButtonAjoutAlert,delegateIG,AlertToEdit,labelValeur;

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
    
    if (self.AlertToEdit != nil) {
        self.title = @"Modification Alerte";
       // self.labelValeur.text = self.AlertToEdit.nom_alerte;
        //self.textSeuil.text.floatValue = self.AlertToEdit.param1;
        //self.ButtonAjoutAlert.enabled = YES;
    }
    else{
        
        self.title = @"Nouvelle Alerte";
       // self.labelValeur.text = @"Y";
        
    
    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"retour clavier");
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)AjoutAlert
{
   
    
    if (self.AlertToEdit == nil) {
        
        Valeurs_Alertes *alerte = [[Valeurs_Alertes alloc] init];
        
        alerte.nom_alerte = @"Seuil";
        alerte.param1 = self.textSeuil.text;
        
        
        NSLog(@"TEST SEUIL");
        NSLog(@"ON VA ENVOYER LA NOUVELLE ALERTE A L ECRAN DETAIL VALEUR LIST INDIC : %@",alerte);
        
        [self.delegateIG indicateursViewController:self didFinishAddingAlertlist:(Valeurs_Alertes *)alerte];
    } else {
       // self.AlertToEdit.name = self.textField.text;
       //[self.delegateIG indicateursViewController:self didFinishEditingChecklist:self.AlertToEdit];
    }
    
    
    
    NSLog(@"AJOUT ALERTE EN COURS");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ajout Alerte"
    message:@"Alerte Crée"
    delegate:nil
    cancelButtonTitle:@"OK"
    otherButtonTitles:nil];                   
         [alertView show];                     
    
    
    /*NSDate *alertTime = [[NSDate date] dateByAddingTimeInterval:10];
    UIApplication* app = [UIApplication sharedApplication];
    UILocalNotification* notifyAlarm = [UILocalNotification new];
    if (notifyAlarm)
    {
        notifyAlarm.fireDate = alertTime;
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        notifyAlarm.repeatInterval = 0;
       // notifyAlarm.soundName = @"Glass.aiff";
        notifyAlarm.alertBody = @"Ajout Alerte OK !";
        
        [app scheduleLocalNotification:notifyAlarm];
    }
     */   
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [self setTextSeuil:nil];
    [self setButtonAjoutAlert:nil];
    
    
    [self setLabelValeur:nil];
    [super viewDidUnload];
}
@end
