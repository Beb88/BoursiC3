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
@class Indicateurs;

@protocol AlerteVolumeViewControllerDelegate <NSObject>
- (void)alertViewControllerDidCancel:(AlerteVolumeViewController *)controller;
- (void)alertvolumeViewController:(AlerteVolumeViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert;
- (void)alertVolumeViewController:(AlerteVolumeViewController *)controller didFinishEditingAlertlist:(Valeurs_Alertes *)newAlert;
@end



@interface AlerteVolumeViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelValeur;

@property (nonatomic, strong) IBOutlet UITextField *textFranchissementHausse;
@property (weak, nonatomic) IBOutlet UISwitch *switchIsActive;

@property (weak, nonatomic) IBOutlet UITextField *textVolumMoy;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *ButtonAjoutAlert;
@property (weak, nonatomic) IBOutlet UITextField *textNomAlerte;
@property (weak, nonatomic) IBOutlet UITextView *textIndicAlerte;
@property (weak, nonatomic) IBOutlet UITextView *textDescIndic;
@property (nonatomic, strong) Indicateurs *Indicateur_infos;
@property (nonatomic, strong) Valeurs *Valeur_recue_ByListIndic;
@property (nonatomic,strong)  NSString *CodeYF;

-(IBAction)AjoutAlertSeuil;


@property (nonatomic, weak) id <AlerteVolumeViewControllerDelegate> delegateAlertVolume;
@property (nonatomic, strong) Valeurs_Alertes *AlertToEdit;
@end
