//
//  EditViewController.m
//  PingPongObjective-C
//
//  Created by Karolina Banach on 13/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *password2Text;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property NSString *stringURL;

@end


@implementation EditViewController

NSString *const URL_EDIT = @"http://karolinabanachios.cba.pl/edit.php";
NSString *const USER_CREATED_EDIT = @"User created successfully";
NSString *const USER_EXIST_EDIT = @"User already exist";



- (void)viewDidLoad {
    [super viewDidLoad];
    _editButton.layer.cornerRadius = 8;
    _editButton.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [self shouldPerformSegueWithIdentifier:@"editController" sender: self];
}
- (IBAction)editButton:(id)sender {
    NSString *emailString = _emailText.text;
    NSString *passwordString = _passwordText.text;
    NSString *password2String = _password2Text.text;
    
    // check if email is valid
    if([emailString length]!=0){
    if([self validateEmailWithString: emailString]==NO){
        [self InformativeAlertWithmsg:@"Email nie przeszedł walidacji, sprawdź poprawność wpisania adresu email"];
    }
    }else if([passwordString caseInsensitiveCompare:password2String]!=NSOrderedSame){
        [self InformativeAlertWithmsg:@"Wprowadzone hasła nie są takie same, proszę wpisać takie same hasła "];
    }else {
        NSString * dbstr;
        _stringURL = [NSString stringWithFormat:URL_EDIT];
        if([emailString length]==0&&[passwordString length]!=0){
            dbstr = [NSString stringWithFormat:@"name=%@&password=%@",_namePlayer,passwordString];
            
        }else if([passwordString length]==0&&[emailString length]!=0){
            dbstr = [NSString stringWithFormat:@"name=%@&email=%@",_namePlayer,emailString];
        }else if([passwordString length]!=0&&[emailString length]!=0){
            dbstr = [NSString stringWithFormat:@"name=%@&email=%@&password=%@",_namePlayer,emailString,passwordString];
        }
        else{
            [self performSegueWithIdentifier: @"goToMenu" sender:self];
        }
        [Webservice executequery: _stringURL strpremeter:dbstr withblock:^(NSData * data , NSError * error) {
            if(data!=nil){
                NSDictionary *maindic = [NSJSONSerialization JSONObjectWithData:(data) options:NSJSONReadingAllowFragments error:nil];
                NSString *message = maindic.allValues.lastObject;
                if([message caseInsensitiveCompare:USER_CREATED_EDIT]==NSOrderedSame){
                    [self performSegueWithIdentifier: @"goToMenu" sender:self];
                }else if([message caseInsensitiveCompare:USER_EXIST_EDIT]==NSOrderedSame){
                    
                    UIAlertController * alertvc = [UIAlertController alertControllerWithTitle: @ "Uwaga!"
                                                   message: @"Użytkownik o danym emailu już istnieje" preferredStyle: UIAlertControllerStyleAlert
                                                  ];
                    [alertvc addAction: [UIAlertAction actionWithTitle: @ "Popraw"
                    style: UIAlertActionStyleDefault handler: ^ (UIAlertAction * _Nonnull action) {
                    }
                    ]];
                    [alertvc addAction:[UIAlertAction actionWithTitle: @ "Wróć do menu"
                    style: UIAlertActionStyleDefault handler: ^ (UIAlertAction * _Nonnull action) {
                        [self performSegueWithIdentifier: @"goToMenu" sender:self];
                     }
                    ]];
                    
                    [self presentViewController: alertvc animated: true completion: nil];
                }else{
                    [self InformativeAlertWithmsg:@"Nieoczekiwany błąd sieci, spróbuj ponownie później"];
                }
            }
        }];
    }
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   // Make sure your segue name in storyboard is the same as this line
   if ([[segue identifier] isEqualToString:@"goToMenu"])
   {
       MenuViewController *mvc = [segue destinationViewController];
       mvc.namePlayer = _namePlayer;
   }
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)goToMenu:(id)sender {
    [self performSegueWithIdentifier: @"goToMenu" sender:self];
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

@end
