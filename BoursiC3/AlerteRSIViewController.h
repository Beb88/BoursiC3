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

@protocol AlerteRSIViewControllerDelegate <NSObject>
- (void)alertRSIViewControllerDidCancel:(AlerteRSIViewController *)controller;
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

@end
