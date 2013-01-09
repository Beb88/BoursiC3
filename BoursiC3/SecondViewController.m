//
//  SecondViewController.m
//  BoursiC3
//
//  Created by bertrand louis on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "AFNetworking.h"
#import "Detail_ActionViewController.h"


@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize TableListVAL ,listVal = _listVal;
@synthesize dataForPlot, hostingView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Setting Up Table View
    
    self.TableListVAL.dataSource = self;
    self.TableListVAL.delegate = self;
 
    
    // Setting Up Activity Indicator View
    //self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //self.activityIndicatorView.hidesWhenStopped = YES;
    //self.activityIndicatorView.center = self.view.center;
    //[self.view addSubview:self.activityIndicatorView];
    //[self.activityIndicatorView startAnimating];
    
    // Initializing Data Source
    self.listVal = [[NSArray alloc] init];
    NSLog(@"COIN");
    
    
    //FLO 192.168.0.14
    //BEB 192.168.1.46
    // FROM TGV BOXTGV 10.164.10.149
    //192.168.1.46
    
    
    
    //VERSION UTILISATEUR FLO  Parametre passé : idPtf =1
    NSURL *url = [NSURL URLWithString:@"http://192.168.0.14:8888/wsgetValeurs.php"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"1", @"idPtf",
                            nil];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://192.168.0.14:8888/wsgetValeurs.php"parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
      
        NSLog(@"REQUEST OK JSON");
        //NSLog(@"json count: %i, key: %@, value: %@", [JSON count], [JSON allKeys], [JSON allValues]);
        NSLog(@"json: %@", JSON);
        
        self.listVal = [JSON objectForKey:@"VALEURS"];
        
        // [self.activityIndicatorView stopAnimating];
        [self.TableListVAL setHidden:NO];
        [self.TableListVAL reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    
    [operation start];
    
    
    
    // Données de test
	NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:30];
	NSUInteger i;
	for ( i = 0; i < 30; i++ ) {
        id x = [NSNumber numberWithFloat:i];
        id y = [NSNumber numberWithFloat:1.2*rand()/(float)RAND_MAX + 2.2];
        [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
    }
    self.dataForPlot = contentArray;
    
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
    // Theme du graphique
	CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    
      
    CPTGraphHostingView *graphHostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    
    
    graphHostingView.collapsesLayers = NO;
    
    graphHostingView.hostedGraph = graph;
    [hostingView addSubview:graphHostingView];
    
    
    
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.8) length:CPTDecimalFromFloat(30.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.8) length:CPTDecimalFromInt(10)];
    
    // Axe X
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPTDecimalFromString(@"5");
    x.minorTicksPerInterval = 4;
    
    // Axe Y
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromString(@"5");
    y.minorTicksPerInterval = 4;
    
    
    
    // Ligne du graphique
    CPTScatterPlot *boundLinePlot = [[CPTScatterPlot alloc] init ];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 4.0f;
    lineStyle.lineColor = [CPTColor blueColor];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier = @"Blue Plot";
    boundLinePlot.dataSource = self;
	[graph addPlot:boundLinePlot];
    
    
  

}

- (void)viewDidUnload
{
    [self setTableListVAL:nil];
    [self setHostingView:nil];
    [self setTextdetailcell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


// Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.listVal && self.listVal.count) {
        return self.listVal.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSDictionary *listVal = [self.listVal objectAtIndex:indexPath.row];
    
    
    
    //On place dans la cellule le 3e object de la requete ( 0 etant le premier, le 3e contient le nomValeur)
    cell.textLabel.text = [listVal objectForKey:@"2"];
    cell.detailTextLabel.text = [listVal objectForKey:@"4"];
    
    // cell.detailTextLabel.text = [movie objectForKey:@"artistName"];
    
    // NSURL *url = [[NSURL alloc] initWithString:[movie objectForKey:@"artworkUrl100"]];
    // [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"On clique sur une ligne");
    //Detail_ActionViewController *detailValeur = [[Detail_ActionViewController alloc] initWithNibName:nil bundle:nil];
    //[self.navigationController pushViewController:detailValeur animated:YES];
    static NSString *cellID = @"Cell Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSLog(@"On envoit la cellule: %@", cell);
    
    Valeurs *valeurs = [self.listVal objectAtIndex:indexPath.row];
    
    
  //  [self performSegueWithIdentifier:@"showDetailValeur" sender:cell.detailTextLabel];
      [self performSegueWithIdentifier:@"showDetailValeur" sender:valeurs];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     NSLog(@"prepareForSegue");
    
    NSLog(@"Source Controller = %@", [segue sourceViewController]);
    NSLog(@"Destination Controller = %@", [segue destinationViewController]);
    NSLog(@"Segue Identifier = %@", [segue identifier]);

    
    if ([segue.identifier isEqualToString:@"showDetailValeur"]) {
        //UINavigationController *navigationController = segue.destinationViewController;
        Detail_ActionViewController *controller = segue.destinationViewController;
        
        
        //controller.checklistToEdit = nil;
    }
}


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index  {
    return [[dataForPlot objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y")];
}
/*

-(NSUInteger)numberOfRecords {
    return 51;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum
               recordIndex:(NSUInteger)index
{
    double val = (index/5.0)-5;
    if(fieldEnum == CPTScatterPlotFieldX)
    { return [NSNumber numberWithDouble:val]; }
    else
    {
        if(plot.identifier == @"X Squared Plot")
        { return [NSNumber numberWithDouble:val*val]; }
        else
        { return [NSNumber numberWithDouble:1/val]; }
    }
}
*/


@end
