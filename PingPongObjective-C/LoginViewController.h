//
//  LoginViewController.h
//  PingPongObjective-C
//
//  Created by Karolina Banach on 07/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MenuViewController.h"
#import "webservice.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController

@property NSTimeInterval timer;

-(NSString *) getName;

@end

NS_ASSUME_NONNULL_END
