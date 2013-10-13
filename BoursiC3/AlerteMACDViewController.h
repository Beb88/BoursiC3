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



@protocol AlerteMACDViewControllerDelegate <NSObject>
- (void)alertMACDViewControllerDidCancel:(AlerteMACDViewController *)controller;
- (void)alertMACDViewController:(AlerteMACDViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert;
- (void)alertMACDViewController:(AlerteMACDViewController *)controller didFinishEditingAlertlist:(Valeurs_Alertes *)newAlert;
@end



@interface AlerteMACDViewController : UIViewController




@property (nonatomic, weak) id <AlerteMACDViewControllerDelegate> delegateAlertMACD;
@property (nonatomic, strong) Valeurs_Alertes *AlertToEdit;
@property (weak, nonatomic) IBOutlet UISwitch *SwitchHausse;
@property (weak, nonatomic) IBOutlet UISwitch *SwitchBaisse;



@end
