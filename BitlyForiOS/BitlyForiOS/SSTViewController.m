//
//  SSTViewController.m
//  BitlyForiOS
//
//  Created by Brennan Stehling on 7/10/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTViewController.h"

#import "SSTURLShortener.h"

NSString * const SSTUsername = @"username";
NSString * const SSTApiKey = @"apiKey";
NSString * const SSTURL = @"url";

@interface SSTViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *apiKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *shortenButton;
@property (weak, nonatomic) IBOutlet UILabel *shortenedURLLabel;

@end

@implementation SSTViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.shortenedURLLabel.text = nil;
    [self loadSettings];
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)shortenURLButtonTapped:(id)sender {
    [self.view endEditing:TRUE];
    [self saveSettings];
    
    [SSTURLShortener shortenURL:[NSURL URLWithString:self.urlTextField.text]
                       username:self.usernameTextField.text
                         apiKey:self.apiKeyTextField.text
            withCompletionBlock:^(NSURL *shortenedURL, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:error.userInfo[NSLocalizedDescriptionKey]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
                else {
                    self.shortenedURLLabel.text = shortenedURL.absoluteString;
                }
    }];
}

#pragma mark - Private
#pragma mark -

- (void)loadSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults objectForKey:SSTUsername];
    NSString *apiKey = [defaults objectForKey:SSTApiKey];
    NSString *url = [defaults objectForKey:SSTURL];
    
    self.usernameTextField.text = username;
    self.apiKeyTextField.text = apiKey;
    self.urlTextField.text = url;
}

- (void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (self.usernameTextField.text.length) {
        [defaults setObject:self.usernameTextField.text forKey:SSTUsername];
    }
    if (self.apiKeyTextField.text.length) {
        [defaults setObject:self.apiKeyTextField.text forKey:SSTApiKey];
    }
    if (self.apiKeyTextField.text.length) {
        [defaults setObject:self.urlTextField.text forKey:SSTURL];
    }
    
    [defaults synchronize];
}

@end
