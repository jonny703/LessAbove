//
//  RKCommon.m
//  LESSABOVE
//
//  Created by John Nik on 9/16/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "RKCommon.h"

@implementation RKCommon

+(BOOL)checkInternetConnection
{
    Reachability* wifiReach = [Reachability reachabilityWithHostname:@"www.apple.com"];
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    
    if(netStatus == NotReachable)
    {
        return NO;
    }
    else if(netStatus == ReachableViaWWAN)
    {
        return YES;
    }
    else if(netStatus == ReachableViaWiFi)
    {
        return YES;
    }
    return NO;
}

+(NSString *)displayTodayDate
{
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy"];
    NSString *formattedDate = [df stringFromDate:today];
    NSString *todayDate = [NSString stringWithFormat:@"%@",formattedDate];
    return todayDate;
}

+(NSString *)getSyncDateInString
{
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy"];
    NSString *formattedDate = [df stringFromDate:today];
    NSString *todayDate = [NSString stringWithFormat:@"%@",formattedDate];
    return todayDate;
}

+(NSString *)stringFromTheDate:(NSDate*)date
{
    NSDate *today = date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy"];
    NSString *formattedDate = [df stringFromDate:today];
    NSString *todayDate = [NSString stringWithFormat:@"%@",formattedDate];
    return todayDate;
}

@end
