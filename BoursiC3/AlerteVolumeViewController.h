//
//  AlerteVolumeViewController.h
//  BoursiC3
//
//  Created by Bertrand louis on 18/02/13.
//
//

#import <UIKit/UIKit.h>

@class AlerteVolumeViewController;
@class Valeurs;
@class Valeurs_Alertes;


@protocol AlerteVolumeViewControllerDelegate <NSObject>
- (void)alertvolumeViewControllerDidCancel:(AlerteVolumeViewController *)controller;
- (void)alertvolumeViewController:(AlerteVolumeViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert;
- (void)alertVolumeViewController:(AlerteVolumeViewController *)controller didFinishEditingAlertlist:(Valeurs_Alertes *)newAlert;
@end



@interface AlerteVolumeViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelValeur;

@property (nonatomic, strong) IBOutlet UITextField *textFranchissementHausse;
@property (nonatomic, strong) IBOutlet UITextField *textFranchissementBaisse;
@property (nonatomic, strong) IBOutlet UITextField *textProchede;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *ButtonAjoutAlert;


-(IBAction)AjoutAlertSeuil;


@property (nonatomic, weak) id <AlerteVolumeViewControllerDelegate> delegateAlertVolume;
@property (nonatomic, strong) Valeurs_Alertes *AlertToEdit;
@end
