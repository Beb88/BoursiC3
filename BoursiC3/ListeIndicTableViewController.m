//
//  ListeIndicTableViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 09/02/13.
//
//

#import "ListeIndicTableViewController.h"
#import "AFNetworking.h"
#import "SBJson.h"
@interface ListeIndicTableViewController ()

@end

@implementation ListeIndicTableViewController{
    NSMutableArray *listIndic;
}

@synthesize TableListIndic, listIndicJSON,delegateListeIndic;


@synthesize  valeurInEcranListeindic;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"ECRAN LISTE INDIC : ON a RECU LA VALEUR (nom)%@",self.valeurInEcranListeindic.nom);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.TableListIndic.dataSource = self;
    self.TableListIndic.delegate = self;
   //  [self.TableListIndic setHidden:YES];
    
    [self TransfertJSON_Vers_Objet_ListIndic];
    // [self.activityIndicatorView stopAnimating];
    [self.TableListIndic setHidden:NO];
    [self.TableListIndic reloadData];

    
    
}
-(void) TransfertJSON_Vers_Objet_ListIndic
{
    
        
    listIndic = [[NSMutableArray alloc] initWithCapacity:20];
    
    //1&1
    NSURL *url = [NSURL URLWithString:@"http://s454555776.onlinehome.fr/boursicoincoin/jsonConnect.php"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    //LES PARAM PASSES EN POST
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"beblouis@gmail.com", @"user",
                            @"beb", @"password",
                            @"getAllIndicateurs",@"action",
                            nil];// Autre param a envoyer
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://s454555776.onlinehome.fr/boursicoincoin/jsonConnect.php"parameters:params];
    
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"RECUPERATION ALERTE OK SUR  SERVEUR");
        NSLog(@"REQUEST OK JSON");
        NSLog(@"json: %@", JSON);
        NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        
        
        self.listIndicJSON = [JSON objectForKey:@"result"];
    
        for ( int i=0; i< [self.listIndicJSON count]; i=i+1)
        {
            
            Indicateurs *indic =  [Indicateurs new];
           
            NSDictionary *listIndicDict = [self.listIndicJSON objectAtIndex:i];
            indic.nom_indic=[listIndicDict objectForKey:@"nameIndic"];
            indic.idIndic =[listIndicDict objectForKey:@"idIndic"];
            
            [listIndic addObject:indic];
            NSLog(@"On ajoute %@ A slistIndic",indic.nom_indic);
            
        }
        
        NSLog(@"listIndic globale = %@ ",listIndic);

        
        [self.TableListIndic setHidden:NO];
        [self.TableListIndic reloadData];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Synchro serveur OK"
                                                            message:@"Récupation des indicateurs"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
        NSLog(@"ERREUR RECUPERATION DES indicateurs SUR SERVEUR");
        NSLog(@"BAD REQUEST JSON");
        NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"json: %@", JSON);
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Réseau non disponible"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
    
    [operation start];
    NSLog(@"listIndic globale = %@ ",listIndic);
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel
{
    
    //   Valeurs *valeur = [Valeurs new];
    //= @"NV";//self.textField.text;
    //valeur.checked = NO;
    
    //[self.delegate AjoutValeurViewControllerDidCancel:self];
    
    //Retour sur ecran precedent
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source


/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (listIndic && listIndic.count) {
        return listIndic.count;
    } else {
        return 0;
    }}



//REMPLISSAGE DE LA TABLEVIEW
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //ListofIndics est l identifieur défini dans le storyboard sur la tableviewCell
    static NSString *cellID = @"ListofIndics";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSLog(@"IN TABLEVIEW LISTE INDIC");
    NSLog(@"CONTENU listIndic = %@",listIndic );
    
    Indicateurs *indic = [listIndic objectAtIndex:indexPath.row];
    UILabel *labelIndic = (UILabel *)[cell viewWithTag:1000];
    labelIndic.text =  indic.nom_indic;
   // cell.textLabel.text = indic.nom_indic;
        NSLog(@"CONTENU INDIC  = %@",indic.nom_indic );
    NSLog(@"OUT TABLEVIEW AJOUT VALEUR");
    return cell;

 
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    // Navigation logic may go here. Create and push another view controller.
    
   /*  AlerteSeuilViewController *detailViewController = [[AlerteSeuilViewController alloc] initWithNibName:nil bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
    */
    //ListofIndics est l identifieur défini dans le storyboard sur la tableviewCell
    static NSString *cellID = @"ListofIndics";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    Indicateurs *indic = [listIndic objectAtIndex:indexPath.row];
    //UILabel *labelIndic = (UILabel *)[cell viewWithTag:1000];
   
    
    if ([indic.idIndic isEqualToString:@"2" ]) { //SEUIL
        
   
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"AS"];
        AlerteSeuilViewController *controller = (AlerteSeuilViewController *)navigationController;
        controller.delegateAlertSeuil = self;
        [self presentViewController:navigationController animated:YES completion:nil];
    
   }
    
    
    if ([indic.idIndic isEqualToString:@"1"]) //VOLUMETRIE
    {
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"AV"];
        AlerteVolumeViewController *controller = (AlerteVolumeViewController *)navigationController;
        controller.delegateAlertVolume = self;
        [self presentViewController:navigationController animated:YES completion:nil];
      

    }
    
    if ([indic.idIndic isEqualToString:@"6"]) //MM
    {
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"AMM"];
        AlerteMMViewController *controller = (AlerteMMViewController *)navigationController;
        controller.delegateAlertMM = self;
        [self presentViewController:navigationController animated:YES completion:nil];
        
        
    }
    
    if ([indic.idIndic isEqualToString:@"7"]) //MACD
    {
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"AMACD"];
        AlerteMACDViewController *controller = (AlerteMACDViewController *)navigationController;
        controller.delegateAlertMACD = self;
        [self presentViewController:navigationController animated:YES completion:nil];
        
        
    }
    
    if ([indic.idIndic isEqualToString:@"8"]) //RSI
    {
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ARSI"];
        AlerteRSIViewController *controller = (AlerteRSIViewController *)navigationController;
        controller.delegateAlertRSI = self;
        [self presentViewController:navigationController animated:YES completion:nil];
        
        
    }


    
    
        
    
    NSLog(@"performeSegue");
if (1==1)
    {
       // [self performSegueWithIdentifier:@"VersAddAlertesSeuil" sender:nil];
    }
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    NSLog(@"prepareForSegue");
    
    NSLog(@"Source Controller = %@", [segue sourceViewController]);
    NSLog(@"Destination Controller = %@", [segue destinationViewController]);
    NSLog(@"Segue Identifier = %@", [segue identifier]);
    
   
    
    
   /*
    
    if ([segue.identifier isEqualToString:@"VersAddAlertesSeuil"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AlerteSeuilViewController *controller = (AlerteSeuilViewController *)navigationController;//WARNING on a viré le topviewcontroller qui suivait navigationController
        //Warning: Attempt to dismiss from view controller <UITabBarController: 0x72537f0> while a presentation or dismiss is in progress!

        controller.delegateAlertSeuil = self;
        //controller.AlertToEdit = nil;
        //controller.labelValeur.text = self.valeurRecue.nom;
    }
    
    */
}




///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

//  METHODES DELEGATE VENANT DU PROTOCOLE DE L ECRAN ALERTE SEUIL  IMPLEMENTEES ICI

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////



- (void)alertSeuilViewController:(AlerteSeuilViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert
{
    
    
      NSLog(@"LISTE INDIC :ON RECOIT LA NOUVELLE ALERTE : %@",newAlert);
   
    [self.delegateListeIndic listeIndicTableView:self didFinishAddingAlertlist:newAlert];
    
       
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

//  METHODES DELEGATE VENANT DU PROTOCOLE DE L ECRAN ALERTE MM  IMPLEMENTEES ICI

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)alertMMViewController:(AlerteMMViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert
{
    NSLog(@"LISTE INDIC :ON RECOIT LA NOUVELLE ALERTE MM : %@",newAlert);
    
    [self.delegateListeIndic listeIndicTableView:self didFinishAddingAlertlist:newAlert];


}




/////////////////////////////////////////////////////////////////////////////////////////////////////////

//  METHODES DELEGATE VENANT DU PROTOCOLE DE L ECRAN ALERTE MACD  IMPLEMENTEES ICI

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)alertMACDViewController:(AlerteMACDViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert
{
    NSLog(@"LISTE INDIC :ON RECOIT LA NOUVELLE ALERTE MACD : %@",newAlert);
    
    [self.delegateListeIndic listeIndicTableView:self didFinishAddingAlertlist:newAlert];
    
    
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////

//  METHODES DELEGATE VENANT DU PROTOCOLE DE L ECRAN ALERTE RSI  IMPLEMENTEES ICI

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)alertRSIViewController:(AlerteRSIViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert
{
    NSLog(@"LISTE INDIC :ON RECOIT LA NOUVELLE ALERTE RSI : %@",newAlert);
    
    [self.delegateListeIndic listeIndicTableView:self didFinishAddingAlertlist:newAlert];
    
    
}






///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

//  METHODES DELEGATE VENANT DU PROTOCOLE DE L ECRAN ALERTE VOLUME  IMPLEMENTEES ICI

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////



- (void)alertvolumeViewController:(AlerteSeuilViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert
{
    
    
    NSLog(@"LISTE INDIC :ON RECOIT LA NOUVELLE ALERTE  VOLUME: %@",newAlert);
    
    [self.delegateListeIndic listeIndicTableView:self didFinishAddingAlertlist:newAlert];
    
       
    
}


@end
