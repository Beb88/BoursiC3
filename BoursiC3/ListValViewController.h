//
//  SecondViewController.h
//  BoursiC3
//
//  Created by bertrand louis on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "AjoutValeurViewController.h"
#import "Detail_ActionViewController.h"

@class Valeurs;

@interface ListValViewController : UIViewController <AjoutValeurViewControllerDelegate, Detail_ActionViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, CPTPlotDataSource >
{
NSMutableArray *_listValJSON;
//COREPLOT
NSMutableArray *dataForPlot;

    CPTXYGraph *graph;
}
@property (nonatomic, strong) Valeurs *valeur;

@property (weak, nonatomic) IBOutlet UITableView *TableListVAL;
@property (nonatomic, retain) NSMutableArray *listValJSON;
@property (weak, nonatomic) IBOutlet UILabel *textdetailcell;

@property(readwrite, retain, nonatomic) NSMutableArray *dataForPlot;
@property(weak, nonatomic) IBOutlet UIView *hostingView;
@property  UIRefreshControl *refreshControl;



- (IBAction)ajoutValeur;

@end
