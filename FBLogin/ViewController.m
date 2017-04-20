//
//  ViewController.m
//  FBLogin
//
//  Created by Admin on 20.04.17.
//  Copyright © 2017 da_manifest. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUserInfo];
    
    self.loginButton.delegate = self;
    self.loginButton.readPermissions = @[@"public_profile",
                                         @"email",
                                         @"user_friends"];
}

- (void) updateUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue: @"id, name, email, gender, link, about, birthday, hometown, location, timezone" forKey: @"fields"];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath: @"me" parameters: parameters]
         startWithCompletionHandler: ^(FBSDKGraphRequestConnection *connection,
                                      id result, NSError *error)
         {
             if (!error)
             {
                 self.loginStatusLabel.text = @"LOGGED IN";
                 self.userNameLabel.text = [result objectForKey: @"name"];
                 self.userEmailLabel.text = [result objectForKey: @"email"];
                 self.userIdLabel.text = [result objectForKey: @"id"];
                 NSLog(@"fetched user:%@", result);
             }
             else
             {
                 self.loginStatusLabel.text = @"LOGGED OUT";
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
    else
    {
        self.loginStatusLabel.text = @"LOGGED OUT";
        self.userNameLabel.text = @"";
        self.userEmailLabel.text = @"";
        self.userIdLabel.text = @"";
    }
}

// MARK: - FB button delegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    if (!error)
    {
        [self updateUserInfo];
    }
    else
    {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    [self updateUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
