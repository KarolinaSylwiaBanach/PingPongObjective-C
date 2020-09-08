//
//  GameScene.h
//  PingPongObjective-C
//
//  Created by Karolina Banach on 05/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameViewController.h"
#import "webservice.h"
#import "MenuViewController.h"
#import <mach/mach.h>

@interface GameScene : SKScene
@property NSString *namePlayer ;
@property NSTimeInterval timer; 


@end
