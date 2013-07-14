//
//  ListeIndicTableViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 09/02/13.
//
//

#import "ListeIndicTableViewController.h"

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
    
    [self TransfertJSON_Vers_Objet_ListIndic];
    // [self.activityIndicatorView stopAnimating];
    [self.TableListIndic setHidden:NO];
    [self.TableListIndic reloadData];

    
    
}
-(void) TransfertJSON_Vers_Objet_ListIndic
{
    
        
    listIndic = [[NSMutableArray alloc] initWithCapacity:20];
    
    for ( int i=0; i< 1; i=i+1)
    {
        
        Indicateurs *indic =  [Indicateurs new];
        
        indic.nom_indic=@"Seuil";
        [listIndic addObject:indic];
        NSLog(@"On ajoute %@ A listIndic",indic.nom_indic);
       
        Indicateurs *indic2 =  [Indicateurs new];
        
        indic2.nom_indic=@"Volumetrie";
        [listIndic addObject:indic2];
        NSLog(@"On ajoute %@ A listIndic",indic2.nom_indic);
        
    }
    
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
   
    
    if ([indic.nom_indic isEqualToString:@"Seuil" ]) {
        
   
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"AS"];
        
        AlerteSeuilViewController *controller = (AlerteSeuilViewController *)navigationController;
        controller.delegateAlertSeuil = self;
        
        //Checklist *checklist = [lists objectAtIndex:indexPath.row];
        //controller.checklistToEdit = checklist;
        
        [self presentViewController:navigationController animated:YES completion:nil];
    
   }
    
    
    if ([indic.nom_indic isEqualToString:@"Volumetrie"])
    {
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"AV"];
        
        AlerteVolumeViewController *controller = (AlerteVolumeViewController *)navigationController;
        
        controller.delegateAlertVolume = self;
        
        //Checklist *checklist = [lists objectAtIndex:indexPath.row];
        //controller.checklistToEdit = checklist;
        
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

//  METHODES DELEGATE VENANT DU PROTOCOLE DE L ECRAN ALERTE VOLUMETRIE  IMPLEMENTEES ICI

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////



- (void)alertvolumeViewController:(AlerteSeuilViewController *)controller didFinishAddingAlertlist:(Valeurs_Alertes *)newAlert
{
    
    
    NSLog(@"LISTE INDIC :ON RECOIT LA NOUVELLE ALERTE  VOLUME: %@",newAlert);
    
    [self.delegateListeIndic listeIndicTableView:self didFinishAddingAlertlist:newAlert];
    
       
    
}


@end
