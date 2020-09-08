//
//  ResultViewController.h
//  PingPongObjective-C
//
//  Created by Karolina Banach on 08/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MenuViewController.h"
#import "Result.h"
#import "webservice.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResultViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{

IBOutlet UITableView *tableView;
}
@property NSString *namePlayer ;
@property NSString *stringURLResult;
@property NSString *URLRESULT;
@property BOOL urlPlayer;

@end

NS_ASSUME_NONNULL_END
