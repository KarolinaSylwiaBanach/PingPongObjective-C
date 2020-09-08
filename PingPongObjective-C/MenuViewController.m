//
//  MenuViewController.m
//  PingPongObjective-C
//
//  Created by Karolina Banach on 08/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *gameButton;
@property (weak, nonatomic) IBOutlet UIButton *getResultButton;
@property (weak, nonatomic) IBOutlet UIButton *getMyResultButton;

@property (weak, nonatomic) IBOutlet UIButton *logOut;

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@end

@implementation MenuViewController

BOOL urlPlayer = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    _gameButton.layer.cornerRadius = 8;
    _gameButton.clipsToBounds = YES;
    _getResultButton.layer.cornerRadius = 8;
    _getResultButton.clipsToBounds = YES;
    _getMyResultButton.layer.cornerRadius = 8;
    _getMyResultButton.clipsToBounds = YES;
    _editButton.layer.cornerRadius = 8;
    _editButton.clipsToBounds = YES;
    _logOut.layer.cornerRadius = 8;
    _logOut.clipsToBounds = YES;
    if(_namePlayer.length == 0){
        LoginViewController *lvc = LoginViewController.new;
        _namePlayer = [lvc getName];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [self shouldPerformSegueWithIdentifier:@"menuController" sender: self];
}
- (IBAction)gameButton:(id)sender {
    [self performSegueWithIdentifier: @"goToGame" sender:self];
}
- (IBAction)getResultButton:(id)sender {
    urlPlayer= NO;
    [self performSegueWithIdentifier: @"goToResult" sender:self];
}
- (IBAction)getMyResultButton:(id)sender {
    urlPlayer = YES;
    [self performSegueWithIdentifier: @"goToResult" sender:self];
}
- (IBAction)editButton:(id)sender {
    [self performSegueWithIdentifier: @"goToEdit" sender:self];
}

- (IBAction)LogOut:(id)sender {
    [self performSegueWithIdentifier: @"logOut" sender:self];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   // Make sure your segue name in storyboard is the same as this line
   if ([[segue identifier] isEqualToString:@"goToGame"])
   {
       GameViewController *gv = [segue destinationViewController];
       gv.namePlayer = _namePlayer;
       gv.timer = [NSDate timeIntervalSinceReferenceDate];
   }
   else if ([[segue identifier] isEqualToString:@"goToResult"])
   {
       ResultViewController *rv = [segue destinationViewController];
       rv.namePlayer = _namePlayer;
       rv.urlPlayer = urlPlayer;
   }else if ([[segue identifier] isEqualToString:@"goToEdit"])
   {
      EditViewController  *evc = [segue destinationViewController];
       evc.namePlayer = _namePlayer;
   }
     
}


@end
