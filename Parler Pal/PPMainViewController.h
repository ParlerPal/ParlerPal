//
//  PPProfileViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/8/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPMessagePopupView.h"
#import "PPMessageTableViewCell.h"
#import <MapKit/MapKit.h>

@interface PPMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PPMessagesPopupViewDelegate, PPMessagesTableViewCellDelegate, MKMapViewDelegate>
{
    int languageIndex;
    NSArray *allQuotes;
    NSMutableArray *messages;
    PPMessagePopupView *messageContentView;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *toolbarTitle;
@property (weak, nonatomic) IBOutlet UILabel *quotes;
@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

-(IBAction)unwindMainMenuViewController:(UIStoryboardSegue *)unwindSegue;
-(void)plotMessagesPositions;

@end
