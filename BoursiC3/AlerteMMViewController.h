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


@protocol AlerteMMViewControllerDelegate <NSObject>
- (void)alertMMViewControllerDidCancel:(AlerteMMViewController *)controller;
- (void)alertMMViewController:(AlerteMMViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert;
- (void)alertMMViewController:(AlerteMMViewController *)controller didFinishEditingAlertlist:(Valeurs_Alertes *)newAlert;
@end


@interface AlerteMMViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textTypeMM;
@property (weak, nonatomic) IBOutlet UITextField *textMM1;
@property (weak, nonatomic) IBOutlet UITextField *textMM2;
@property (nonatomic, weak) id <AlerteMMViewControllerDelegate> delegateAlertMM;
@property (nonatomic, strong) Valeurs_Alertes *AlertToEdit;
@end
