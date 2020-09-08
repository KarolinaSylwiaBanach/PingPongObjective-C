//
//  Webservice.m
//  PingPongObjective-C
//
//  Created by Karolina Banach on 11/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

#import "webservice.h"

@implementation Webservice
+(void)executequery:(NSString *)strurl strpremeter:(NSString *)premeter withblock:(void (^)(NSData *, NSError *))block
{
    NSURLSessionConfiguration *defaultconfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultconfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL *urlrequest = [NSURL URLWithString:strurl];
    NSMutableURLRequest*mutablerequest = [NSMutableURLRequest requestWithURL:urlrequest];
    
    NSString * parm = premeter;
    [mutablerequest setHTTPMethod:@"POST"];
    [mutablerequest setHTTPBody:[parm dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:mutablerequest completionHandler:^(NSData *  data, NSURLResponse * response, NSError *  error) {
        if (data!=nil)
        {
            NSLog(@"Response %@", data);
            block(data,error);
        }
        else
        {
            NSLog(@"error");
            block(nil,error);
        }
    }];
    [task resume];
    
    
}

@end
