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
#import "PPMessage.h"
#import "PPMessageLocation.h"
#import "JMImageCache.h"

@interface PPMainViewController(PrivateMethods)

-(void)plotMessagesPositions;

@end

@implementation PPMainViewController
@synthesize toolbarTitle, table, mapView;//quotes

#pragma mark - view methods

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.toolbarTitle.title = [[PPDataShare sharedSingleton]currentUser];
    
   // allQuotes = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"quotes" ofType:@"plist"]];
   // self.quotes.text = [allQuotes objectAtIndex:languageIndex];
   // languageIndex = 1;
   // [self animateText];
    
    self.table.allowsMultipleSelectionDuringEditing = NO;
    
    [[PPDatabaseManager sharedDatabaseManager]getUnreadReceivedMessagesCompletionHandler:^(NSMutableArray *results) {
        messages = results;
        [self.table reloadData];
        [self plotMessagesPositions];
    }];
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    messageContentView = [[PPMessagePopupView alloc]initWithFrame:screenSize];
    messageContentView.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:refreshControl];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    [[PPDatabaseManager sharedDatabaseManager]getUnreadReceivedMessagesCompletionHandler:^(NSMutableArray *results) {
        messages = results;
        [self.table reloadData];
        [self plotMessagesPositions];
    }];
}

-(void)refresh:(UIRefreshControl *)refreshControl
{
    [refreshControl endRefreshing];
    [[PPDatabaseManager sharedDatabaseManager]getUnreadReceivedMessagesCompletionHandler:^(NSMutableArray *results) {
        messages = results;
        [self.table reloadData];
        [self plotMessagesPositions];
    }];
}

#pragma mark - Messages Popup View delegate methods

-(void)shouldDeleteMessageWithID:(int)theID
{
    [[PPDatabaseManager sharedDatabaseManager]deleteMessage:theID completionHandler:^(bool success) {
        
        PPMessage *messageToDelete = nil;
        
        for(PPMessage *message in messages)
        {
            if(message.dbID == theID)
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

#pragma mark - table view cell delegate methods

-(void)shouldDeleteMessage:(id)sender
{
    PPMessageTableViewCell *messageCell = (PPMessageTableViewCell *)sender;
    
    PPMessage *messageToDelete = nil;
    
    for(PPMessage *message in messages)
    {
        if(message.dbID == messageCell.messageID)
        {
            messageToDelete = message;
        }
    }
    
    [[PPDatabaseManager sharedDatabaseManager]deleteMessage:messageCell.messageID completionHandler:^(bool success) {
        
        if(messageToDelete)
        {
            [messages removeObject:messageToDelete];
            [self.table reloadData];
            [self plotMessagesPositions];
        }
    }];
}

#pragma mark - Quotes Animation Methods
/*
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
}*/

#pragma mark - table view delegate methods

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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Message";
    
    PPMessageTableViewCell *cell = (PPMessageTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PPMessageTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                PPMessage *message = [messages objectAtIndex:indexPath.row];
                
                cell = (PPMessageTableViewCell *)currentObject;
                cell.fromLabel.text = message.from;
                cell.messageLabel.text = message.subject;
                cell.toLabel.text = message.to;
                [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@files/uploadedProfilePhotos/%@.png", WEB_SERVICES, message.from]] key:nil
                                    placeholder:[UIImage imageNamed:@"profile.png"]
                                completionBlock:nil
                                   failureBlock:nil];
                
                NSDateFormatter *df = [[NSDateFormatter alloc]init];
                df.dateFormat = @"yyyy-MM-dd hh:mm a";
                df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                cell.dateLabel.text = [df stringFromDate: message.created];
        
                cell.messageID = message.dbID;
                break;
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPMessage *message = [messages objectAtIndex:indexPath.row];
    
    [[PPDatabaseManager sharedDatabaseManager]getMessageContentForID:message.dbID completionHandler:^(NSMutableDictionary *results) {
        messageContentView.content.text = [results objectForKey:@"content"];
        
        messageContentView.fromLabel.text = message.from;
        messageContentView.toLabel.text = message.to;
        messageContentView.subjectLabel.text = message.subject;
        messageContentView.messageID = message.dbID;
        messageContentView.memoAttached = message.memoAttached;
        
        [[PPDatabaseManager sharedDatabaseManager]markMessageAsRead:message.dbID completionHandler:^(bool success) {
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
        PPMessage *message = [messages objectAtIndex:indexPath.row];
        
        [[PPDatabaseManager sharedDatabaseManager]deleteMessage:message.dbID completionHandler:^(bool success) {
            [messages removeObjectAtIndex:indexPath.row];
            [self.table reloadData];
            [self plotMessagesPositions];
        }];
    }
}

#pragma mark - Map View Methods

-(void)plotMessagesPositions
{
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }

    NSMutableArray *messagesToPin = [self getMessagesThatCanBePinned];

    for(PPMessage *message in messagesToPin)
    {
        NSString * name = message.from;
        NSString * subject = message.subject;

        CLLocationCoordinate2D coordinate;
        coordinate.latitude = message.lat;
        coordinate.longitude = message.lon;
        PPMessageLocation *annotation = [[PPMessageLocation alloc] initWithName:name subject:subject coordinate:coordinate] ;
        annotation.index = (int)[messages indexOfObject:message];
        [mapView addAnnotation:annotation];
    }
    
    [self setMapRegion];
}

/*Note that when you dequeue a reusable annotation, you give it an identifier. If you have multiple styles of annotations, be sure to have a unique identifier for each one, otherwise you might mistakenly dequeue an identifier of a different type, and have unexpected behavior in your app. It’s basically the same idea behind a cell identifier in tableView:cellForRowAtIndexPath.*/

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"PPMessageLocation";
    if ([annotation isKindOfClass:[PPMessageLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [button setTintColor:[UIColor blackColor]];
            annotationView.rightCalloutAccessoryView = button;
            annotationView.image = [UIImage imageNamed:@"mapPin.png"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    PPMessageLocation *annotation = (PPMessageLocation *)view.annotation;
    PPMessage *message = [messages objectAtIndex:annotation.index];

    [[PPDatabaseManager sharedDatabaseManager]getMessageContentForID:message.dbID completionHandler:^(NSMutableDictionary *results) {
        messageContentView.content.text = [results objectForKey:@"content"];
        
        messageContentView.fromLabel.text = message.from;
        messageContentView.toLabel.text = message.to;
        messageContentView.subjectLabel.text = message.subject;
        messageContentView.messageID = message.dbID;
        messageContentView.memoAttached = message.memoAttached;
        
        [[PPDatabaseManager sharedDatabaseManager]markMessageAsRead:message.dbID completionHandler:^(bool success) {
            [messages removeObjectAtIndex:annotation.index];
            [self.table reloadData];
            [self plotMessagesPositions];
        }];
    }];
    
    [self.view addSubview:messageContentView];
    [messageContentView show];
}

-(void)setMapRegion
{
    NSMutableArray *messagesToPin = [self getMessagesThatCanBePinned];
    
    if([messagesToPin count] > 0)
    {
        //calculate new region to show on map
        PPMessage *firstMessage = [messagesToPin objectAtIndex:0];
        double max_long = firstMessage.lon;
        double min_long = firstMessage.lon;
        double max_lat = firstMessage.lat;
        double min_lat = firstMessage.lat;
        
        //find min and max values
        for (PPMessage *message in messagesToPin)
        {
            if (message.lat > max_lat) {max_lat = message.lat;}
            if (message.lat < min_lat) {min_lat = message.lat;}
            if (message.lon > max_long) {max_long = message.lon;}
            if (message.lon < min_long) {min_long = message.lon;}
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
        region.span.latitudeDelta = deltaLat + .9;
        region.span.longitudeDelta = deltaLong + .9;
        [mapView setRegion:region];
    }
}

-(NSMutableArray *)getMessagesThatCanBePinned
{
    NSMutableArray *validMessages = [[NSMutableArray alloc]init];
    
    for(PPMessage *message in messages)
    {
        if(message.lat != 0 && message.lon != 0)
        {
            [validMessages addObject:message];
        }
    }
    
    return validMessages;
}

#pragma mark - segue methods

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"logout"])
    {        
        return YES;
    }
    
    return YES;
}

-(IBAction)unwindMainMenuViewController:(UIStoryboardSegue *)unwindSegue
{

}

@end
