//
//  RegisterViewController.m
//  PingPongObjective-C
//
//  Created by Karolina Banach on 08/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *password2Text;
@property NSString *stringURL;
@end

@implementation RegisterViewController

NSString *const URL_REGISTER = @"http://karolinabanachios.cba.pl/register.php";
NSString *const USER_CREATED_REGISTER = @"User created successfully";
NSString *const USER_EXIST_REGISTER = @"User already exist";



- (void)viewDidLoad {
    [super viewDidLoad];
    _registerButton.layer.cornerRadius = 8;
    _registerButton.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [self shouldPerformSegueWithIdentifier:@"registerController" sender: self];
}

- (IBAction)registerButton:(id)sender {
    NSString *nameString = _nameText.text;
    NSString *emailString = _emailText.text;
    NSString *passwordString = _passwordText.text;
    NSString *password2String = _password2Text.text;
    // check for empty
   if([nameString length]==0){
        [self InformativeAlertWithmsg:@"Prosze wprowadź nazwę"];
    }else if([emailString length]==0){
        [self InformativeAlertWithmsg:@"Prosze wprowadź email"];
    }else if([passwordString length]==0){
        [self InformativeAlertWithmsg:@"Prosze wprowadź hasło"];
    }else if([password2String length]==0){
        [self InformativeAlertWithmsg:@"Prosze powtórz hasło"];
    }else if([passwordString length]< 4 || [passwordString length] > 50 ){
        [self InformativeAlertWithmsg:@"Wprowadź hasło o długości od 4 do 50 znaków"];
    }else if([nameString length] < 4 || [nameString length] > 20 ){
        [self InformativeAlertWithmsg:@"Wprowadź nazwę o długości od 4 do 20 znaków"];
    }
    // check if email is valid
    else if([self validateEmailWithString: emailString]==NO){
        [self InformativeAlertWithmsg:@"Email nie przeszedł walidacji, sprawdź poprawność wpisania adresu email"];
    }
    // compare 2 password
    else if([passwordString caseInsensitiveCompare:password2String]!=NSOrderedSame){
        [self InformativeAlertWithmsg:@"Wprowadzone hasła nie są takie same, proszę wpisać takie same hasła "];
    }
    _stringURL = [NSString stringWithFormat:URL_REGISTER];
    NSString * dbstr = [NSString stringWithFormat:@"name=%@&email=%@&password=%@",nameString,emailString,passwordString];
    [Webservice executequery: _stringURL strpremeter:dbstr withblock:^(NSData * data , NSError * error) {
        if(data!=nil){
            NSDictionary *maindic = [NSJSONSerialization JSONObjectWithData:(data) options:NSJSONReadingAllowFragments error:nil];
            NSString *message = maindic.allValues.lastObject;
            if([message caseInsensitiveCompare:USER_CREATED_REGISTER]==NSOrderedSame){
                [self performSegueWithIdentifier: @"backToLogin" sender:self];
            }else if([message caseInsensitiveCompare:USER_EXIST_REGISTER]==NSOrderedSame){
                
                UIAlertController * alertvc = [UIAlertController alertControllerWithTitle: @ "Uwaga!"
                                               message: @"Użytkownik o danej nazwie lub emailu już istnieje" preferredStyle: UIAlertControllerStyleAlert
                                              ];
                [alertvc addAction: [UIAlertAction actionWithTitle: @ "Popraw"
                style: UIAlertActionStyleDefault handler: ^ (UIAlertAction * _Nonnull action) {
                }
                ]];
                [alertvc addAction:[UIAlertAction actionWithTitle: @ "Zaloguj się"
                style: UIAlertActionStyleDefault handler: ^ (UIAlertAction * _Nonnull action) {
                    [self performSegueWithIdentifier: @"backToLogin" sender:self];
                 }
                ]];
                
                [self presentViewController: alertvc animated: true completion: nil];
            }else{
                [self InformativeAlertWithmsg:@"Nieoczekiwany błąd sieci, spróbuj ponownie później"];
            }
        }
    }];
}
- (IBAction)backToLoginButton:(id)sender {
    [self performSegueWithIdentifier: @"backToLogin" sender:self];
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
-(void) InformativeAlertWithmsg: (NSString * ) message {
  UIAlertController * alertvc = [UIAlertController alertControllerWithTitle: @ "Uwaga!"
                                 message: message preferredStyle: UIAlertControllerStyleAlert
                                ];
  UIAlertAction * action = [UIAlertAction actionWithTitle: @ "Popraw"
                            style: UIAlertActionStyleDefault handler: ^ (UIAlertAction * _Nonnull action) {
                            }
                           ];
  [alertvc addAction: action];
  [self presentViewController: alertvc animated: true completion: nil];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   // Make sure your segue name in storyboard is the same as this line
   if ([[segue identifier] isEqualToString:@"backToLogin"])
   {
       LoginViewController *lvc = [segue destinationViewController];
       lvc.timer = [NSDate timeIntervalSinceReferenceDate];
       
   }
    
}

@end
