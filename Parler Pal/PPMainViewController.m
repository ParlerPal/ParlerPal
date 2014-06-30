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

@implementation PPMainViewController
@synthesize toolbarTitle, quotes, table;

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
        }];
    }
}

#pragma mark -
#pragma mark segue methods

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"logout"])
    {
        //[PFUser logOut];
        return YES;
    }
    
    return YES;
}

- (IBAction)unwindMainMenuViewController:(UIStoryboardSegue *)unwindSegue
{

}

@end
