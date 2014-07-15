//
//  PPProfileViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/18/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPProfileViewController.h"
#import "PPDatabaseManager.h"
#import "PPDataShare.h"
#import "PPUser.h"
#import "UIImage+Resize.h"

@implementation PPProfileViewController
@synthesize passwordField, confirmPasswordField, privateEmailField, countryField, profile, scrollView, contentView, age, gender, imageView, palRating;

#pragma mark - view methods

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapRec.delegate = self;
    [self.view addGestureRecognizer:tapRec];
    
    listOfCountries = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"plist"]];
    
    [[PPDatabaseManager sharedDatabaseManager]getUserProfileCompletionHandler:^(PPUser *results)
    {
        privateEmailField.text = results.email;
        countryField.text = results.country;
        profile.text = results.profile;
        age.text = [NSString stringWithFormat:@"%i",results.age];
        palRating.text = [NSString stringWithFormat:@"Pal Rating: %@",results.recommendationScore];
        [gender setSelectedSegmentIndex:results.gender];
        
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = dirPaths[0];
        imageView.image = [UIImage imageWithContentsOfFile:[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[[PPDataShare sharedSingleton]currentUser]]]];
        if(!imageView.image)self.imageView.image = [UIImage imageNamed:@"profile.png"];
    }];
    
    [self registerForKeyboardNotifications];
    
    self.imageView.layer.cornerRadius = 5.0;
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    self.countryField.inputView = picker;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

#pragma mark - textfield delegate methods

// Call this method somewhere in your view controller setup code.
-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
-(void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+10, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark - text view delegate methods

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y/2.2);
    [scrollView setContentOffset:scrollPoint animated:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [scrollView setContentOffset:CGPointZero animated:YES];
    [textView resignFirstResponder];
}

#pragma mark - textfield action methods

-(IBAction)fieldDidEndEditing:(id)sender
{
    [sender resignFirstResponder];
    
    if(sender == self.age)
    {
        UITextField *textField = (UITextField *)sender;
        
        textField.text = [NSString stringWithFormat:@"%i",[textField.text intValue] < 16 ? 16 : [textField.text intValue] > 120 ? 120 : [textField.text intValue]];
    }
}

#pragma mark - photo delegat methods

-(IBAction)selectPhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

-(IBAction)takePhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:picker animated:YES completion:NULL];
}

-(IBAction)deletePhoto:(UIButton *)sender
{
    [[PPDatabaseManager sharedDatabaseManager]deleteProfilePhotoCompletionHandler:^(bool success) {
    }];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    [fm removeItemAtPath:[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[[PPDataShare sharedSingleton]currentUser]]] error:nil];
    self.imageView.image = [UIImage imageNamed:@"profile.png"];
}

#pragma mark - gesutre recoginizer methods

-(void)tap:(UITapGestureRecognizer *)tapRec{
    [[self view] endEditing: YES];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES;
}

#pragma mark - account action methods

-(IBAction)updatePassword:(id)sender
{
    [self.view endEditing:YES];
    
    if([passwordField.text isEqualToString:confirmPasswordField.text] && (passwordField.text.length > 6 && confirmPasswordField.text.length > 6 ))
    {
        [[PPDatabaseManager sharedDatabaseManager]updatePasswordWithPassword:passwordField.text completionHandler:^(bool success)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your password has been changed." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
            [alert show];
        }];
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Passwords did not match or they are blank, try again." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
    }
    
    passwordField.text = @"";
    confirmPasswordField.text = @"";
}

-(IBAction)deleteAccount:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Caution!" message:@"There is no coming back from this, choose carefully." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Delete", nil];
    [alert show];
}

#pragma mark - Alert View Delegate Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[PPDatabaseManager sharedDatabaseManager]deleteProfileCompletionHandler:^(bool success) {
            [self performSegueWithIdentifier:@"logout" sender:self];
        }];
    }
    
    else{
        return;
    }
}

#pragma mark - seque methods

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (![self validateEmail:self.privateEmailField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Please enter a valid email address." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    
    if([identifier isEqualToString:@"doneSegue"])
    {
        [[PPDatabaseManager sharedDatabaseManager]updateUserProfileWithEmail:privateEmailField.text country:countryField.text profile:profile.text age:age.text gender:(int)gender.selectedSegmentIndex completionHandler:^(bool success) {
        }];
        
        return YES;
    }
    
    return YES;
}

#pragma mark - Image Picker Controller delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if(chosenImage.size.width*chosenImage.size.height >= 62500)chosenImage = [UIImage imageWithImage:chosenImage scaledToSize:CGSizeMake(250, 250)];
    self.imageView.image = chosenImage;
    [[PPDatabaseManager sharedDatabaseManager]uploadProfileImage:self.imageView.image completionHandler:^(bool success) {
    }];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

#pragma mark - picker view delegate methods

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [listOfCountries count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [listOfCountries objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.countryField.text = [listOfCountries objectAtIndex:row];
    [self.countryField resignFirstResponder];
}

#pragma mark - email validation

-(BOOL)validateEmail:(NSString *)emailAddress
{
    NSString *regex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailPred = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", regex];
    
    return [emailPred evaluateWithObject:emailAddress];
}

@end
