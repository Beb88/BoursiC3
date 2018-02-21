//
//  AlerteMMViewController.h
//  BoursiC3
//
//  Created by Bertrand louis on 12/10/13.
//
//

#import <UIKit/UIKit.h>



@class AlerteMMViewController;
@class Valeurs;
@class Valeurs_Alertes;
@class Indicateurs;

@protocol AlerteMMViewControllerDelegate <NSObject>
- (void)alertViewControllerDidCancel:(AlerteMMViewController *)controller;
- (void)alertMMViewController:(AlerteMMViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert;
- (void)alertMMViewController:(AlerteMMViewController *)controller didFinishEditingAlertlist:(Valeurs_Alertes *)newAlert;
@end


@interface AlerteMMViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>


@property (weak, nonatomic) IBOutlet UIPickerView *pickerTypeMM;
@property NSMutableArray *arrayNo;

@property (weak, nonatomic) IBOutlet UILabel *textTitreEcran;
@property (weak, nonatomic) IBOutlet UITextView *textDescIndicateur;
@property (weak, nonatomic) IBOutlet UITextField *textNomAlerte;
@property (weak, nonatomic) IBOutlet UITextField *textCoursActuel;

@property (weak, nonatomic) IBOutlet UITextField *textTypeMM;
@property (weak, nonatomic) IBOutlet UITextField *textMM1;
@property (weak, nonatomic) IBOutlet UILabel *textMM1Live;
@property (weak, nonatomic) IBOutlet UILabel *textMM2Live;
@property (weak, nonatomic) IBOutlet UITextField *textMM2;
@property (nonatomic, weak) id <AlerteMMViewControllerDelegate> delegateAlertMM;
@property (nonatomic, strong) Valeurs_Alertes *AlertToEdit;
@property (nonatomic, strong) Indicateurs *Indicateur_infos;
@property (nonatomic, strong) Valeurs *Valeur_recue_ByListIndic;

@property (nonatomic,strong)  NSString *CodeYF;
@end
