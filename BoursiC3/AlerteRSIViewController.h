//
//  AlerteRSIViewController.h
//  BoursiC3
//
//  Created by Bertrand louis on 13/10/13.
//
//

#import <UIKit/UIKit.h>


@class AlerteRSIViewController;
@class Valeurs;
@class Valeurs_Alertes;
@class Indicateurs;

@protocol AlerteRSIViewControllerDelegate <NSObject>
- (void)alertViewControllerDidCancel:(AlerteRSIViewController *)controller;
- (void)alertRSIViewController:(AlerteRSIViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert;
- (void)alertRSIViewController:(AlerteRSIViewController *)controller didFinishEditingAlertlist:(Valeurs_Alertes *)newAlert;
@end


@interface AlerteRSIViewController : UIViewController<UITextFieldDelegate>


@property (nonatomic, weak) id <AlerteRSIViewControllerDelegate> delegateAlertRSI;
@property (weak, nonatomic) IBOutlet UISwitch *SwitchBaisse;
@property (weak, nonatomic) IBOutlet UITextField *TextNomAlerte;
@property (nonatomic, strong) Valeurs_Alertes *AlertToEdit;
@property (weak, nonatomic) IBOutlet UISwitch *SwitchHausse;
@property (weak, nonatomic) IBOutlet UITextField *TextRSICible;
@property (weak, nonatomic) IBOutlet UITextField *textRSIEnCours;
@property (weak, nonatomic) IBOutlet UITextView *textDescIndic;
@property (nonatomic, strong) Indicateurs *Indicateur_infos;
@property (nonatomic, strong) Valeurs *Valeur_recue_ByListIndic;

@property (nonatomic,strong)  NSString *CodeYF;
@end
