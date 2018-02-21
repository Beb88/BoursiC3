//
//  AlerteMACDViewController.h
//  BoursiC3
//
//  Created by Bertrand louis on 13/10/13.
//
//

#import <UIKit/UIKit.h>


@class AlerteMACDViewController;
@class Valeurs;
@class Valeurs_Alertes;
@class Indicateurs;



@protocol AlerteMACDViewControllerDelegate <NSObject>
- (void)alertViewControllerDidCancel:(AlerteMACDViewController *)controller;
- (void)alertMACDViewController:(AlerteMACDViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert;
- (void)alertMACDViewController:(AlerteMACDViewController *)controller didFinishEditingAlertlist:(Valeurs_Alertes *)newAlert;
@end



@interface AlerteMACDViewController : UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *textSignalEncours;
@property (weak, nonatomic) IBOutlet UITextField *textDiffEnCours;


@property (nonatomic, weak) id <AlerteMACDViewControllerDelegate> delegateAlertMACD;
@property (nonatomic, strong) Valeurs_Alertes *AlertToEdit;
@property (weak, nonatomic) IBOutlet UISwitch *SwitchHausse;
@property (weak, nonatomic) IBOutlet UISwitch *SwitchBaisse;
@property (weak, nonatomic) IBOutlet UITextField *textMACDEnCours;
@property (weak, nonatomic) IBOutlet UITextField *textNomAlerte;
@property (weak, nonatomic) IBOutlet UITextView *textDescIndic;
@property (nonatomic, strong) Indicateurs *Indicateur_infos;
@property (nonatomic, strong) Valeurs *Valeur_recue_ByListIndic;
@property (nonatomic,strong)  NSString *CodeYF;
@end
