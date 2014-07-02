//
//  PPProfileViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/8/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPMainViewController.h"
#import "PPMessageTableViewCell.h"
#import "PPDataShare.h"
#import "PPDatabaseManager.h"
#import "PPMessageLocation.h"

#define METERS_PER_MILE 1609.344

@implementation PPMainViewController
@synthesize toolbarTitle, quotes, table, mapView;

#pragma mark -
#pragma mark view methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.toolbarTitle.title = [[PPDataShare sharedSingleton]currentUser];
    
    allQuotes = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"quotes" ofType:@"plist"]];
    self.quotes.text = [allQuotes objectAtIndex:languageIndex];
    languageIndex = 1;
    [self animateText];
    
    self.table.allowsMultipleSelectionDuringEditing = NO;
    
    [[PPDatabaseManager sharedDatabaseManager]getUnreadReceivedMessages:^(NSMutableArray *results) {
        messages = results;
        [self.table reloadData];
        [self plotMessagesPositions];
    }];
    
    messageContentView = [[PPMessagePopupView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    messageContentView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark Messages Popup View delegate methods

-(void)shouldDeleteMessageWithID:(int)theID
{
    [[PPDatabaseManager sharedDatabaseManager]deleteMessage:theID finish:^(bool success) {
        
        NSMutableDictionary *messageToDelete = nil;
        
        for(NSMutableDictionary *message in messages)
        {
            if([[message objectForKey:@"id"]intValue] == theID)
            {
                messageToDelete = message;
            }
        }
        
        if(messageToDelete)
        {
            [messages removeObject:messageToDelete];
            [self.table reloadData];
            [self plotMessagesPositions];
        }
        
    }];
}

#pragma mark -
#pragma mark table view cell delegate methods

-(void)shouldDeleteMessage:(id)sender
{
    PPMessageTableViewCell *messageCell = (PPMessageTableViewCell *)sender;
    
    NSMutableDictionary *messageToDelete = nil;
    
    for(NSMutableDictionary *message in messages)
    {
        if([[message objectForKey:@"id"]intValue] == messageCell.messageID)
        {
            messageToDelete = message;
        }
    }
    
    [[PPDatabaseManager sharedDatabaseManager]deleteMessage:messageCell.messageID finish:^(bool success) {
        
        if(messageToDelete)
        {
            [messages removeObject:messageToDelete];
            [self.table reloadData];
            [self plotMessagesPositions];
        }
    }];
}

#pragma mark -
#pragma mark Quotes Animation Methods

-(void)animateText
{
    self.quotes.alpha = 0.0;
    [self beginFadeInTextLabel:self.quotes];
}

-(void)beginFadeInTextLabel:(UILabel *)label
{
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        label.alpha = 1.0;
    } completion:^(BOOL finished){[self fadeOutTextLabel:label];}];
}

-(void)fadeOutTextLabel:(UILabel *)label
{
    [UIView animateWithDuration:2.0 delay:6.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        label.alpha = 0.0;
    } completion:^(BOOL finished){
        [self beginFadeInTextLabel:label];
        languageIndex = languageIndex + 1 > allQuotes.count -1 ? 0 : languageIndex + 1;
        label.text = [allQuotes objectAtIndex:languageIndex];
    }];
}

#pragma mark -
#pragma mark table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Message";
    
    PPMessageTableViewCell *cell = (PPMessageTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PPMessageTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (PPMessageTableViewCell *)currentObject;
                cell.fromLabel.text = [[messages objectAtIndex:indexPath.row]objectForKey:@"from"];
                cell.messageLabel.text = [[messages objectAtIndex:indexPath.row]objectForKey:@"subject"];
                cell.dateLabel.text = [[messages objectAtIndex:indexPath.row]objectForKey:@"created"];
                cell.messageID = [[[messages objectAtIndex:indexPath.row]objectForKey:@"id"]intValue];
                break;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *messageID = [[messages objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    [[PPDatabaseManager sharedDatabaseManager]getMessageContentForID:[messageID intValue] andFinish:^(NSMutableDictionary *results) {
        messageContentView.content.text = [results objectForKey:@"content"];
        messageContentView.fromLabel.text = [[messages objectAtIndex:indexPath.row] objectForKey:@"from"];
        messageContentView.toLabel.text = [[messages objectAtIndex:indexPath.row] objectForKey:@"to"];
        messageContentView.subjectLabel.text = [[messages objectAtIndex:indexPath.row] objectForKey:@"subject"];
        messageContentView.messageID = [messageID intValue];
        
        
        [[PPDatabaseManager sharedDatabaseManager]markMessageAsRead:[messageID intValue] finish:^(bool success) {
            [messages removeObjectAtIndex:indexPath.row];
            [self.table reloadData];
            [self plotMessagesPositions];
        }];
        
    }];
    
    [self.view addSubview:messageContentView];
    [messageContentView show];
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [[PPDatabaseManager sharedDatabaseManager]deleteMessage:[[[messages objectAtIndex:indexPath.row]objectForKey:@"id"]intValue] finish:^(bool success) {
            [messages removeObjectAtIndex:indexPath.row];
            [self.table reloadData];
            [self plotMessagesPositions];
        }];
    }
}

#pragma mark -
#pragma mark Map View Methods

-(void)plotMessagesPositions
{
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }

    for(NSDictionary *message in messages)
    {
        if([[message objectForKey:@"lat"]doubleValue] != 0 && [[message objectForKey:@"lat"]doubleValue] != 0)
        {
            NSString * name = [message objectForKey:@"from"];
            NSString * subject = [message objectForKey:@"subject"];
    
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [[message objectForKey:@"lat"]doubleValue];
            coordinate.longitude = [[message objectForKey:@"lon"]doubleValue];
            PPMessageLocation *annotation = [[PPMessageLocation alloc] initWithName:name subject:subject coordinate:coordinate] ;
            [mapView addAnnotation:annotation];
        }
    }
    
    [self setMapRegion];
}

/*Note that when you dequeue a reusable annotation, you give it an identifier. If you have multiple styles of annotations, be sure to have a unique identifier for each one, otherwise you might mistakenly dequeue an identifier of a different type, and have unexpected behavior in your app. It’s basically the same idea behind a cell identifier in tableView:cellForRowAtIndexPath.*/

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"PPMessageLocation";
    if ([annotation isKindOfClass:[PPMessageLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"mapPin.png"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

-(void)setMapRegion
{
    if([messages count] > 0)
    {
        //calculate new region to show on map
        NSDictionary *firstMessage = [messages objectAtIndex:0];
        double max_long = [[firstMessage objectForKey:@"lon"] doubleValue];
        double min_long = [[firstMessage objectForKey:@"lon"] doubleValue];
        double max_lat = [[firstMessage objectForKey:@"lat"] doubleValue];
        double min_lat = [[firstMessage objectForKey:@"lat"] doubleValue];
        
        //find min and max values
        for (NSDictionary *message in messages) {
            if ([[message objectForKey:@"lat"] doubleValue] > max_lat) {max_lat = [[message objectForKey:@"lat"] doubleValue];}
            if ([[message objectForKey:@"lat"] doubleValue] < min_lat) {min_lat = [[message objectForKey:@"lat"] doubleValue];}
            if ([[message objectForKey:@"lon"]doubleValue] > max_long) {max_long = [[message objectForKey:@"lon"] doubleValue];}
            if ([[message objectForKey:@"lon"]doubleValue] < min_long) {min_long = [[message objectForKey:@"lon"]doubleValue];}
        }
        
        //calculate center of map
        double center_long = (max_long + min_long) / 2;
        double center_lat = (max_lat + min_lat) / 2;
        
        //calculate deltas
        double deltaLat = abs(max_lat - min_lat);
        double deltaLong = abs(max_long - min_long);
        
        //set minimal delta
        if (deltaLat < .028) {deltaLat = .028;}
        if (deltaLong < .028) {deltaLong = .028;}
        
        MKCoordinateRegion region;
        region.center.latitude = center_lat;
        region.center.longitude = center_long;
        region.span.latitudeDelta = deltaLat;
        region.span.longitudeDelta = deltaLong;
        [mapView setRegion:region];
    }
}
#pragma mark -
#pragma mark segue methods

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"logout"])
    {        
        return YES;
    }
    
    return YES;
}

- (IBAction)unwindMainMenuViewController:(UIStoryboardSegue *)unwindSegue
{

}

@end
