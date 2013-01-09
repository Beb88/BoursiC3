//
//  Detail_ActionViewController.m
//  BoursiC3
//
//  Created by Bertrand louis on 27/09/12.
//
//

#import "Detail_ActionViewController.h"
#import "AFNetworking.h"
#import "SBJson.h"



@interface Detail_ActionViewController ()

@end

@implementation Detail_ActionViewController

@synthesize TextValo,valeurs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"%@",self.valeurs.codeBourso);
    NSLog(@"%@",self.valeurs.nom);
    NSLog(@"%@",self.valeurs.devise);
    NSLog(@"%@",self.valeurs.cotation);
    
    //On execute la requete URL
    NSURLRequest* requestB = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bourse.lesechos.fr/bourse/streaming/fiches/getHeader.jsp?code=FR0000054470&place=XPAR&codif=ISIN"]];
    // On récupère le résultat de la requête JSON ( avec 6 lignes vides avt)
    NSData* responseB = [NSURLConnection sendSynchronousRequest:requestB returningResponse:nil error:nil];
  
    // On transforme le résultat en String de type NSASCII pour source leschos
    NSString* jsonStringB = [[NSString alloc] initWithData:responseB encoding:NSASCIIStringEncoding];
    
    //Suppression des lignes vides
    NSString *trimmedText = [jsonStringB stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // On met le resultat en string et purgé des lignes vides dans un NSdictionnaire JSON
    NSDictionary *jsonResults= [trimmedText JSONValue];
    NSLog(@"jsonResults : %@", jsonResults);
    //1er niveau du JSON
    NSDictionary *cotation = [ jsonResults objectForKey:@"cotation" ];
    //second niveau du JSON on recupere les données de l'action
    NSLog(@"Valo : %@", [ cotation objectForKey:@"valorisationEnc" ]);
	NSLog(@"heure : %@", [ cotation objectForKey:@"heure" ]);
   
    //On met à jour l'affichage
    TextValo.text = [ cotation objectForKey:@"valorisationEnc" ];
    
    
    
    /* pour gerer des listes (pour plus tard
     
     // Check if there is an error
     if (jsonResults == nil) {
     
     NSLog(@"Erreur lors de la lecture du code JSON (%@).", [ jsonError localizedDescription ]);
     
     } else {
     
     NSArray *candiesList;
     NSDictionary *bakery = [ jsonResults objectForKey:@"bakery" ];
     NSLog(@"Nom : %@", [ bakery objectForKey:@"name" ]);
     NSLog(@"Adresse : %@", [ bakery objectForKey:@"adress" ]);
     NSLog(@"Bonbons :");
     candiesList = [ [ bakery objectForKey:@"candies" ] objectForKey:@"candy" ];
     for (NSDictionary *candy in candiesList) {
     
     NSLog(@"\tNom=%@ et Prix=%@", [ candy objectForKey:@"name" ],
     [ candy objectForKey:@"price" ]);
     
     }
     
     }
     
     */
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextValo:nil];
    [super viewDidUnload];
}
@end
