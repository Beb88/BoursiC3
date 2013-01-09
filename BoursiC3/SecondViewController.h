//
//  SecondViewController.h
//  BoursiC3
//
//  Created by bertrand louis on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@class Valeurs;

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CPTPlotDataSource >
{
NSArray *_listVal;
//COREPLOT
NSMutableArray *dataForPlot;

    CPTXYGraph *graph;
}
@property (nonatomic, strong) Valeurs *valeurs;
@property (weak, nonatomic) IBOutlet UITableView *TableListVAL;
@property (nonatomic, retain) NSArray *listVal;
@property (weak, nonatomic) IBOutlet UILabel *textdetailcell;

@property(readwrite, retain, nonatomic) NSMutableArray *dataForPlot;
@property(weak, nonatomic) IBOutlet UIView *hostingView;
@end
