//
//  GameScene.m
//  PingPongObjective-C
//
//  Created by Karolina Banach on 05/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    
    SKSpriteNode *rocketPlayer;
    SKSpriteNode *rocketEnemy;
    SKLabelNode *scorePlayerLabel;
    SKLabelNode *scPlayerLabel;
    SKLabelNode *scoreEnemyLabel;
    SKSpriteNode *ball;
    NSDateFormatter *formatter;
    int firstTime;
    NSString *stringURL;
    NSString *userName;
    NSString *dateString;
}
    
    NSString *const URL = @"http://karolinabanachios.cba.pl/setResult.php";
    NSString *timeStartGame = @"/Users/karolinabanach/timeStartGame.txt", *memoryRAM= @"/Users/karolinabanach/memory.txt", *saveDBTime= @"/Users/karolinabanach/saveDB.txt";
    int scoreToFinish = 1;
    int speedBall = 20;
    int scorePlayer = 0;
    int scoreEnemy = 0;

- (void)didMoveToView:(SKView *)view {
    
    
    scorePlayerLabel = (SKLabelNode *)[self childNodeWithName: @"scorePlayerLabel"];
    scPlayerLabel = (SKLabelNode *)[self childNodeWithName: @"scPlayerLabel"];
    scoreEnemyLabel = (SKLabelNode *)[self childNodeWithName: @"scoreEnemyLabel"];
    
    ball = (SKSpriteNode *)[self childNodeWithName: @"ball"];
    rocketPlayer = (SKSpriteNode *)[self childNodeWithName: @"rocketPlayer"];
    rocketEnemy = (SKSpriteNode *)[self childNodeWithName: @"rocketEnemy"];
    
    //setup responive game
    rocketPlayer.position = CGPointMake(0,-((self.frame.size.height/2)-50));
    rocketEnemy.position = CGPointMake(0,(self.frame.size.height/2)-50);
    [ball.physicsBody applyImpulse:CGVectorMake (speedBall, speedBall)];
    
    SKPhysicsBody *border = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    border.friction = 0.f;
    border.restitution = 1.f;
    
    self.physicsBody = border;

    userName = _namePlayer;
    
    [self startGame];
    [self report_memory];
    NSTimeInterval timer2 = [NSDate timeIntervalSinceReferenceDate];
    [self setTimeStartGame:[NSString stringWithFormat: @"%f",(timer2 - _timer) * 1000]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInNode:(self)];
        
        [rocketPlayer runAction:[SKAction moveToX:location.x duration:0.1]];
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInNode:(self)];
        
        [rocketPlayer runAction:[SKAction moveToX:location.x duration:0.1]];
    }
}


-(void)update:(CFTimeInterval)currentTime {
    [rocketEnemy runAction:[SKAction moveToX:ball.position.x duration:0.22]];
    
    if (ball.position.y <= rocketPlayer.position.y - 30){
        scoreEnemy+=1;
        [self restartBall];
    }else if (ball.position.y >= rocketEnemy.position.y + 30){
        scorePlayer+=1;
        [self restartBall];
    }
    if (scoreEnemy == scoreToFinish){
        [self stop];
        if(firstTime==0){
            [self winPlayer:@"Wygrał przeciwnik"];
        }
        firstTime+=1;
    }else if (scorePlayer == scoreToFinish){
        [self stop];
        if(firstTime==0){
            [self winPlayer:@"Wygrałeś"];
        }
        firstTime+=1;
    }
    
    scoreEnemyLabel.text=[@(scoreEnemy) stringValue];
    scorePlayerLabel.text=[@(scorePlayer) stringValue];
}

-(void) winPlayer: (NSString *)title{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                   message:@""
                                   preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction: [UIAlertAction actionWithTitle:@"Wróć do menu" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {
        
        UIStoryboard *storyboard = UIApplication.sharedApplication.delegate.window.rootViewController.storyboard;
        UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"menuController"];
        UIApplication.sharedApplication.delegate.window.rootViewController = rootViewController;
        [UIApplication.sharedApplication.delegate.window makeKeyAndVisible];
    }]];

    UIViewController *currentTopVC = currentTopViewController();
     
    [currentTopVC presentViewController:(alert) animated:true completion:^{}];
   
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateString=[dateFormatter stringFromDate:[NSDate date]];
    [self json];
}

UIViewController* currentTopViewController()
{
    UIViewController *topVC = UIApplication.sharedApplication.delegate.window.rootViewController;
    while ((topVC.presentedViewController) != nil) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
-(void) startGame
{
    scoreEnemy = 0;
    scorePlayer = 0;
    scPlayerLabel.text= [NSString stringWithFormat:@"%@:", userName];
}
-(void) stop{
    ball.physicsBody.velocity = CGVectorMake( 0, 0);
    }

-(void) restartBall{
    ball.position = CGPointMake(0, 0);
    ball.physicsBody.velocity = CGVectorMake( 0, 0);
    ball.physicsBody.velocity = CGVectorMake( 22*speedBall, 22*speedBall);
    }

- (void) json{
    NSTimeInterval timer = [NSDate timeIntervalSinceReferenceDate];
    stringURL = [NSString stringWithFormat:URL];
    NSString * dbstr = [NSString stringWithFormat:@"name=%@&date=%@&userScore=%@&enemyScore=%@",userName,dateString,[@(scorePlayer) stringValue],[@(scoreEnemy) stringValue]];
    
    [Webservice executequery: stringURL strpremeter:dbstr withblock:^(NSData * data , NSError * error){
   }];
    NSTimeInterval timer2 = [NSDate timeIntervalSinceReferenceDate];
    [self setTimeSaveToDB:[NSString stringWithFormat: @"%f",(timer2 - timer)*1000]];
    }
- (void) report_memory
{
    struct task_basic_info info;
    mach_msg_type_number_t size = TASK_BASIC_INFO_COUNT;
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
      NSLog(@"Memory in use (in bytes): %lu", info.resident_size);
        [self setMemory: [NSString stringWithFormat: @"%f",((CGFloat)info.resident_size / 1048576)]];
    } else {
      NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
}
-(void) setMemory: (NSString * ) memory{
    
    NSString *memory2 = [NSString stringWithFormat: @"%@\n%@", [self getMemory], memory];
    NSURL  *fileURL= [NSURL fileURLWithPath: memoryRAM];
    [memory2 writeToURL: fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(NSString *) getMemory{
    NSURL  *fileURL= [NSURL fileURLWithPath: memoryRAM];
    NSString *memory = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    return memory;
}

-(void) setTimeSaveToDB: (NSString * ) saveDB{
    
    NSString *saveDB2 = [NSString stringWithFormat: @"%@\n%@", [self getTimeSaveToDB], saveDB];
    NSURL  *fileURL= [NSURL fileURLWithPath: saveDBTime];
    [saveDB2 writeToURL: fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(NSString *) getTimeSaveToDB{
    NSURL  *fileURL= [NSURL fileURLWithPath: saveDBTime];
    NSString *saveDB = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    return saveDB;
}
-(void) setTimeStartGame: (NSString * ) startGameTime{
    
    NSString *startGameTime2 = [NSString stringWithFormat: @"%@\n%@", [self getTimeStartGame], startGameTime];
    NSURL  *fileURL= [NSURL fileURLWithPath: timeStartGame];
    [startGameTime2 writeToURL: fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(NSString *) getTimeStartGame{
    NSURL  *fileURL= [NSURL fileURLWithPath: timeStartGame];
    NSString *startGameTime = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    return startGameTime;
}

@end


