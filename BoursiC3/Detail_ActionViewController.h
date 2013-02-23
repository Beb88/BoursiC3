//
//  Detail_ActionViewController.h
//  BoursiC3
//
//  Created by Bertrand louis on 27/09/12.
//
//

#import <UIKit/UIKit.h>
#import "Valeurs.h"
#import "Valeurs_Alertes.h"
#import "IndicateursViewController.h" //pour delegate
#import "AlerteSeuilViewController.h"//pour delegate
#import "ListeIndicTableViewController.h"

@class Valeurs;
@class Valeurs_Alertes;
@class ListValViewController;

@interface Detail_ActionViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,IndicateursViewControllerDelegate, AlerteSeuilViewControllerDelegate, AlerteVolumeViewControllerDelegate, ListeIndicTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *te;

@property (weak, nonatomic) IBOutlet UITextField *TextValo;
@property (weak, nonatomic) IBOutlet UITextField *TextVolumeEnc;
@property (weak, nonatomic) IBOutlet UITextField *TextEvo;
@property (weak, nonatomic) IBOutlet UITextField *TextNomValeur;

@property (weak, nonatomic) IBOutlet UITableView *TableListAlert;
@property (weak, nonatomic) IBOutlet UITextField *TextNomAlert;

@property (nonatomic, strong) Valeurs *valeurRecue;

@property (nonatomic, strong) Valeurs_Alertes *alertes_valeur;

@end
