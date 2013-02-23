//
//  ListeIndicTableViewController.h
//  BoursiC3
//
//  Created by Bertrand louis on 09/02/13.
//
//

#import <UIKit/UIKit.h>
#import "Indicateurs.h"
#import "Valeurs.h"
#import "AlerteSeuilViewController.h"
#import "AlerteVolumeViewController.h"

@class ListeIndicTableViewController;
@class Valeurs;
@class Valeurs_Alertes;


@protocol ListeIndicTableViewControllerDelegate <NSObject>
//- (void)listeIndicTableViewDidCancel:(ListeIndicTableViewController *)controller;
- (void)listeIndicTableView:(ListeIndicTableViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert;
//- (void)listeIndicTableView:(ListeIndicTableViewController *)controller didFinishEditingAlertlist:(Valeurs_Alertes *)newAlert;
@end


@interface ListeIndicTableViewController : UITableViewController<AlerteSeuilViewControllerDelegate  ,AlerteVolumeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
NSMutableArray *_listIndicJSON;
}

@property (weak, nonatomic) IBOutlet UITableView *TableListIndic;
@property (nonatomic, retain) NSMutableArray *listIndicJSON;

@property (nonatomic, strong) Valeurs *valeurInEcranListeindic;

@property (nonatomic, weak) id <ListeIndicTableViewControllerDelegate> delegateListeIndic;




- (IBAction)cancel;

@end
