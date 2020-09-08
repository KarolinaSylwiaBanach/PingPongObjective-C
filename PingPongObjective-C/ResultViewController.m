//
//  ResultViewController.m
//  PingPongObjective-C
//
//  Created by Karolina Banach on 08/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()
@property (weak, nonatomic) IBOutlet UIButton *bactToMenuButton;
@property (weak, nonatomic) IBOutlet UITableView *tableViewUI;
@property NSMutableArray <Result *> *resultArray;
@end

@implementation ResultViewController

NSString *downloadDBTime= @"/Users/karolinabanach/downloadDBTime.txt";

- (void)viewDidLoad {
    [super viewDidLoad];
    _bactToMenuButton.layer.cornerRadius = 8;
    _bactToMenuButton.clipsToBounds = YES;
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    _resultArray = [NSMutableArray new];
    [self json];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [self shouldPerformSegueWithIdentifier:@"resultController" sender: self];
}
- (IBAction)bactToMenuButton:(id)sender {
    [self performSegueWithIdentifier: @"goToMenu" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   // Make sure your segue name in storyboard is the same as this line
   if ([[segue identifier] isEqualToString:@"goToMenu"])
   {
       MenuViewController *mvc = [segue destinationViewController];
       mvc.namePlayer = _namePlayer;
   }
}

-(void) json {
    if(_urlPlayer==YES){
        _URLRESULT = @"http://karolinabanachios.cba.pl/getPlayerResult.php";
    }else{
        _URLRESULT = @"http://karolinabanachios.cba.pl/getResult.php";
    }
    _stringURLResult = [NSString stringWithFormat:@"%@", _URLRESULT];
    NSString * dbstr = [NSString stringWithFormat:@"name=%@",_namePlayer];
    NSTimeInterval timer = [NSDate timeIntervalSinceReferenceDate];
    [Webservice executequery:_stringURLResult strpremeter:dbstr withblock:^(NSData * data , NSError * error) {
        if(data!=nil){
            NSDictionary *maindic = [NSJSONSerialization JSONObjectWithData:(data) options:NSJSONReadingAllowFragments error:nil];
            NSMutableArray <Result *> *resultArray = NSMutableArray.new;
            for (NSDictionary *dic in maindic){
                Result *result = [Result new];
                result.name =dic[@"name"];
                result.date =dic[@"date"];
                result.userScore =dic[@"userScore"];
                result.enemyScore =dic[@"enemyScore"];
                [resultArray addObject:result];
            }
            self.resultArray = resultArray;
            if(resultArray.count==0){
            UIAlertController * alertvc = [UIAlertController alertControllerWithTitle: @ "Uwaga!"
                                           message: @"Użytkownik nie posiada wyników" preferredStyle: UIAlertControllerStyleAlert
                                          ];
            [alertvc addAction:[UIAlertAction actionWithTitle: @ "Wróć do menu"
            style: UIAlertActionStyleDefault handler: ^ (UIAlertAction * _Nonnull action) {
                [self performSegueWithIdentifier: @"goToMenu" sender:self];
             }
            ]];
                [self presentViewController: alertvc animated: true completion: nil];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->tableView reloadData];
            });
            
        }
        
    }];
    NSTimeInterval timer2 = [NSDate timeIntervalSinceReferenceDate];
    [self setTimeDownloadDB:[NSString stringWithFormat: @"%f",(timer2 - timer)*1000]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"BasicCell" forIndexPath: indexPath];
    
    cell.textLabel.font =  [UIFont fontWithName:@"Avenir Book " size: 20];
    cell.textLabel.text = [NSString stringWithFormat:@"%@   %@   %@   %@",_resultArray[indexPath.row].date, _resultArray[indexPath.row].userScore, _resultArray[indexPath.row].enemyScore, _resultArray[indexPath.row].name];
    return cell;
}

-(void) setTimeDownloadDB: (NSString * ) downloadDB{
    
    NSString *downloadDB2 = [NSString stringWithFormat: @"%@\n%@", [self getTimeDownloadDB], downloadDB];
    NSURL  *fileURL= [NSURL fileURLWithPath: downloadDBTime];
    [downloadDB2 writeToURL: fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(NSString *) getTimeDownloadDB{
    NSURL  *fileURL= [NSURL fileURLWithPath: downloadDBTime];
    NSString *downloadDB = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    return downloadDB;
}
@end
