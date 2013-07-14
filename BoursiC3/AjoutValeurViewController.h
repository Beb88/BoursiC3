//
//  AjoutValeurViewController.h
//  BoursiC3
//
//  Created by Bertrand louis on 12/01/13.
//
//

#import <UIKit/UIKit.h>
#import "Valeurs.h"
// DELEGATE ETAPE1
@class AjoutValeurViewController;
@class Valeurs;


//DECLARATION D UN PROTOCOLE POUR LE DELEGATE (APELLANT)
@protocol AjoutValeurViewControllerDelegate <NSObject>
- (void)AjoutValeurViewControllerDidCancel:(AjoutValeurViewController *)controller;
- (void)AjoutValeurViewController:(AjoutValeurViewController *)controller ajoutNouvelleValeur:(Valeurs *)valeur;
@end


@interface AjoutValeurViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
NSMutableArray *_listValJSON;
}


@property (weak, nonatomic) IBOutlet UISearchBar *SearchBarValeurs;

//@property (weak, nonatomic) IBOutlet UISearchBar *IBSearchBarValeur;
@property (weak, nonatomic) IBOutlet UITableView *TableListVAL;
@property (nonatomic, retain) NSMutableArray *listValJSON;

//PROPRIETE DELEGATE 
@property (nonatomic, weak) id <AjoutValeurViewControllerDelegate> delegate;

- (IBAction)cancel;
- (IBAction)done;

@end
