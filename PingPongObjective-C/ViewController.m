//
//  ViewController.m
//  PingPongObjective-C
//
//  Created by Karolina Banach on 07/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _logInButton.layer.cornerRadius = 8; 
    _logInButton.clipsToBounds = YES;
    _registerButton.layer.cornerRadius = 8;
    _registerButton.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [self shouldPerformSegueWithIdentifier:@"viewController" sender: self];
}

- (IBAction)logInButton:(id)sender {

    [self performSegueWithIdentifier:@"goToLogin" sender:self];
}

- (IBAction)registerButton:(id)sender {
    [self performSegueWithIdentifier:@"goToRegister" sender:self];
}

@end
