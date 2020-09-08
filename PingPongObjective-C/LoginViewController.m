//
//  LoginViewController.m
//  PingPongObjective-C
//
//  Created by Karolina Banach on 07/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

@implementation LoginViewController

NSString *const URLlogin = @"http://karolinabanachios.cba.pl/login.php";
NSString *const USER_NOT_EXIST = @"User not exist";
NSString *const USER_EXIST = @"User exist";
NSString *const ALL_RIGHT = @"All right";
NSString *stringURLLogin;
NSString *nameUser = @"";
NSString *file = @"/Users/karolinabanach/file.txt", *widok = @"/Users/karolinabanach/widok.txt", *fileSaveTime = @"/Users/karolinabanach/fileSave.txt", *fileDownloadTime = @"/Users/karolinabanach/fileDownload.txt";

- (void)viewDidLoad {
    [super viewDidLoad];
    _logInButton.layer.cornerRadius = 8;
    _logInButton.clipsToBounds = YES;
    NSTimeInterval timer2 = [NSDate timeIntervalSinceReferenceDate];
    [self setView2:[NSString stringWithFormat: @"%f",(timer2 - _timer)*1000]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [self shouldPerformSegueWithIdentifier:@"loginController" sender: self];
}

- (IBAction)logInButton:(id)sender {
    NSString *const nameString = _nameText.text ;
    NSString *const passwordString = _passwordText.text ;

    if([nameString length]==0){
        [self InformativeAlertWithmsg:@"Prosze wprowadź nazwę"];
    }else if([passwordString length]==0){
        [self InformativeAlertWithmsg:@"Prosze wprowadź hasło"];
    }
    nameUser = nameString;
    [self setName:nameString];
    
    stringURLLogin = [NSString stringWithFormat:URLlogin];
    NSString * dbstr = [NSString stringWithFormat:@"name=%@&password=%@",nameString,passwordString];
    [Webservice executequery: stringURLLogin strpremeter:dbstr withblock:^(NSData * data , NSError * error) {
        if(data!=nil){
            NSDictionary *maindic = [NSJSONSerialization JSONObjectWithData:(data) options:NSJSONReadingAllowFragments error:nil];
            NSString *message = maindic.allValues.lastObject;
            if([message caseInsensitiveCompare:ALL_RIGHT]==NSOrderedSame){
                [self performSegueWithIdentifier: @"goToMenu" sender:self];
            }else if([message caseInsensitiveCompare:USER_NOT_EXIST]==NSOrderedSame){

                UIAlertController * alertvc = [UIAlertController alertControllerWithTitle: @ "Uwaga!"
                                               message: @"Użytkownik o podanej nazwie nie istnieje" preferredStyle: UIAlertControllerStyleAlert
                                              ];
                [alertvc addAction: [UIAlertAction actionWithTitle: @ "Popraw"
                style: UIAlertActionStyleDefault handler: ^ (UIAlertAction * _Nonnull action) {
                }
                ]];
                [alertvc addAction:[UIAlertAction actionWithTitle: @ "Zarejestruj się"
                style: UIAlertActionStyleDefault handler: ^ (UIAlertAction * _Nonnull action) {
                    [self performSegueWithIdentifier: @"backToRegister" sender:self];
                 }
                ]];
                
                [self presentViewController: alertvc animated: true completion: nil];
            }else if([message caseInsensitiveCompare:USER_EXIST]==NSOrderedSame){
                [self InformativeAlertWithmsg:@"Błędne hasło"];
            }else{
                [self InformativeAlertWithmsg:@"Nieoczekiwany błąd sieci, spróbuj ponownie później"];
            }
        }
    }];
}

    

- (IBAction)backToRegister:(id)sender {
    [self performSegueWithIdentifier: @"backToRegister" sender:self];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   // Make sure your segue name in storyboard is the same as this line
   if ([[segue identifier] isEqualToString:@"goToMenu"])
   {
       MenuViewController *mvc = [segue destinationViewController];
       mvc.namePlayer = nameUser;
   }
    
}


-(void) InformativeAlertWithmsg: (NSString * ) message {
  UIAlertController * alertvc = [UIAlertController alertControllerWithTitle: @ "Pole jest puste"
                                 message: message preferredStyle: UIAlertControllerStyleAlert
                                ];
  UIAlertAction * action = [UIAlertAction actionWithTitle: @ "Popraw"
                            style: UIAlertActionStyleDefault handler: ^ (UIAlertAction * _Nonnull action) {
                            }
                           ];
  [alertvc addAction: action];
  [self presentViewController: alertvc animated: true completion: nil];
}

-(void) setName: (NSString * ) name{
    [self getName];
    NSTimeInterval timer = [NSDate timeIntervalSinceReferenceDate];
    NSURL  *fileURL= [NSURL fileURLWithPath: file];
    [name writeToURL: fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSTimeInterval timer2 = [NSDate timeIntervalSinceReferenceDate];
    [self setTimeSaveFile:[NSString stringWithFormat: @"%f",(timer2 - timer)*1000]];
    NSLog(@"%@", name);
}

-(NSString *) getName{
    NSTimeInterval timer = [NSDate timeIntervalSinceReferenceDate];
    NSURL  *fileURL= [NSURL fileURLWithPath: file];
    NSString *name = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    NSTimeInterval timer2 = [NSDate timeIntervalSinceReferenceDate];
    [self setTimeDownloadFile: [NSString stringWithFormat: @"%f",(timer2 - timer)*1000]];
    return name;
}

-(void) setView2: (NSString * ) view{
    
    NSString *view2 = [NSString stringWithFormat:@"%@\n%@", [self getView], view];
    NSURL  *fileURL= [NSURL fileURLWithPath: widok];
    [view2 writeToURL: fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(NSString *) getView{
    NSURL  *fileURL= [NSURL fileURLWithPath: widok];
    NSString *view = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    return view;
}

-(void) setTimeSaveFile: (NSString * ) fileSave{
    
    NSString *fileSave2 = [NSString stringWithFormat:@"%@\n%@", [self getTimeSaveFile], fileSave];
    NSURL  *fileURL= [NSURL fileURLWithPath: fileSaveTime];
    [fileSave2 writeToURL: fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(void) setTimeDownloadFile: (NSString * ) fileDownload{
    
    NSString *fileDownload2 = [NSString stringWithFormat:@"%@\n%@", [self getTimeDownloadFile], fileDownload];
    NSURL  *fileURL= [NSURL fileURLWithPath: fileDownloadTime];
    [fileDownload2 writeToURL: fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(NSString *) getTimeSaveFile{
    NSURL  *fileURL= [NSURL fileURLWithPath: fileSaveTime];
    NSString *fileSave = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    return fileSave;
}

-(NSString *) getTimeDownloadFile{
    NSURL  *fileURL= [NSURL fileURLWithPath: fileDownloadTime];
    NSString *fileDownload = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    return fileDownload;
}

@end
