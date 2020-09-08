//
//  GameViewController.h
//  PingPongObjective-C
//
//  Created by Karolina Banach on 05/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>
#import "GameScene.h"
#import "MenuViewController.h"

@interface GameViewController : UIViewController
@property NSString *namePlayer ;
@property NSTimeInterval timer;
@end
