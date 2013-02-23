//
//  IndicateursViewController.h
//  BoursiC3
//
//  Created by Bertrand louis on 09/01/13.
//
//

#import <UIKit/UIKit.h>

@class IndicateursViewController;
@class Valeurs;
@class Valeurs_Alertes;


@protocol IndicateursViewControllerDelegate <NSObject>
- (void)indicateursViewControllerDidCancel:(IndicateursViewController *)controller;
- (void)indicateursViewController:(IndicateursViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert;
- (void)indicateursViewController:(IndicateursViewController *)controller didFinishEditingAlertlist:(Valeurs_Alertes *)newAlert;
@end



@interface IndicateursViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelValeur;
@property (nonatomic, strong) IBOutlet UITextField *textSeuil;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *ButtonAjoutAlert;
@property (nonatomic, weak) id <IndicateursViewControllerDelegate> delegateIG;
@property (nonatomic, strong) Valeurs_Alertes *AlertToEdit;





-(IBAction)AjoutAlert;

@end
