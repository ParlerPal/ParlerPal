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

@implementation PPMainViewController
@synthesize toolbarTitle, quotes;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
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
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Message";
    
    PPMessageTableViewCell *cell = (PPMessageTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PPMessageTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (PPMessageTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    // Configure the cell.
    //User *user = [items objectAtIndex:indexPath.row];
    //cell.profilePicture.image = [UIImage imageNamed:user.avatarFname];
    //cell.name.text = user.name;
    //cell.status.text = user.status;
    //cell.datePosted.text = user.datePosted;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
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


@end