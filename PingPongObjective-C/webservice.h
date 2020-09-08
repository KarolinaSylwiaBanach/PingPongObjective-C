//
//  Webservice.h
//  PingPongObjective-C
//
//  Created by Karolina Banach on 11/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Webservice : NSObject
+(void)executequery:(NSString *)strurl strpremeter:(NSString *)premeter withblock:(void(^)(NSData *, NSError*))block;

@end

NS_ASSUME_NONNULL_END
