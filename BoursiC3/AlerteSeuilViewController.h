//
//  AlerteSeuilViewController.h
//  BoursiC3
//
//  Created by Bertrand louis on 09/02/13.
//
//

#import <UIKit/UIKit.h>

@class AlerteSeuilViewController;
@class Valeurs;
@class Valeurs_Alertes;


@protocol AlerteSeuilViewControllerDelegate <NSObject>
- (void)alertSeuilViewControllerDidCancel:(AlerteSeuilViewController *)controller;
- (void)alertSeuilViewController:(AlerteSeuilViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert;
- (void)alertSeuilViewController:(AlerteSeuilViewController *)controller didFinishEditingAlertlist:(Valeurs_Alertes *)newAlert;
@end



@interface AlerteSeuilViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelValeur;

@property (nonatomic, strong) IBOutlet UITextField *textFranchissementHausse;
@property (nonatomic, strong) IBOutlet UITextField *textFranchissementBaisse;
@property (nonatomic, strong) IBOutlet UITextField *textProchede;


//PREVOIR 
@property (weak, nonatomic) IBOutlet UISwitch *SwitchFranchissementHausse;
@property (weak, nonatomic) IBOutlet UISwitch *SwithFranchissementBaisse;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *ButtonAjoutAlert;
@property (nonatomic, weak) id <AlerteSeuilViewControllerDelegate> delegateAlertSeuil;
@property (nonatomic, strong) Valeurs_Alertes *AlertToEdit;




-(IBAction)AjoutAlertSeuil;

@end
