//
//  Result.h
//  PingPongObjective-C
//
//  Created by Karolina Banach on 11/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Result : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic)  NSString *date;
@property (strong, nonatomic)  NSString *userScore;
@property (strong, nonatomic)  NSString *enemyScore;

@end

NS_ASSUME_NONNULL_END
