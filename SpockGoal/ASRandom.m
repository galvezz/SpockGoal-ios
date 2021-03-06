//
//  ASRandom.m
//  SpockGoal
//
//  Created by Alan Sparrow on 1/8/14.
//  Copyright (c) 2014 Alan Sparrow. All rights reserved.
//

#import "ASRandom.h"
#import "ASRecord.h"

@implementation ASRandom

- (void)initRandomValueFor:(ASRecord *)record
{
    [record setDuration:[self randomDuration]];
    [record setQuality:[self randomQuality]];
    [record setNote:[self randomNote]];
}

- (NSString *)randomQuality
{
    NSString *resultString = nil;
    NSArray *randomStrings = [NSArray arrayWithObjects:@"H", @"M", @"L", nil];
    resultString = [randomStrings objectAtIndex:rand() % 3];
    
    return resultString;
}

- (float)randomDuration
{
    float resultFloat = 0.0;
    
    resultFloat = rand() % 10;
    
    return resultFloat;
}

- (NSString *)randomNote
{
    NSString *resultString = nil;
    NSArray *randomStrings = [NSArray arrayWithObjects:@"Fuck you", @"Godlike", @"Triple Kill", nil];
    resultString = [randomStrings objectAtIndex:rand() % 3];
    
    
    return resultString;
}

- (NSString *)randomGoalTitle
{
    rand();
    NSArray *randomTitles = [NSArray arrayWithObjects:@"Ruby on Rails",
                             @"iOS",
                             @"Javascript",
                             @"System Programming"
                             @"Hacking",
                             @"Machine Learning",
                             @"Big Data", nil];
    
    return [randomTitles objectAtIndex:rand() % [randomTitles count]];
}

- (float)randomAccumulatedHours
{
    rand();
    NSArray *randomAccumulatedHours = [NSArray arrayWithObjects:[NSNumber numberWithFloat:10000.0],
                                       [NSNumber numberWithFloat:1000.0],
                                       [NSNumber numberWithFloat:8000.0],
                                       [NSNumber numberWithFloat:4000.0],
                                       [NSNumber numberWithFloat:20.55],
                                       [NSNumber numberWithFloat:133.0],
                                       [NSNumber numberWithFloat:1200.12], nil];
    return [[randomAccumulatedHours
            objectAtIndex:
            rand() % [randomAccumulatedHours count]] floatValue];
}

- (NSDate *)randomTimePoint1
{
    NSDate *resultDate = nil;
    
    NSArray *randomDates = [NSArray arrayWithObjects:@"1:07 AM",
                            @"5:27 AM",
                            @"3:07 AM", nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    resultDate = [dateFormatter dateFromString:[randomDates objectAtIndex:rand()%3]];
    return resultDate;
}

- (NSDate *)randomTimePoint2
{
    NSDate *resultDate = nil;
    
    NSArray *randomDates = [NSArray arrayWithObjects:@"4:07 PM",
                            @"11:47 PM",
                            @"10:07 PM", nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    resultDate = [dateFormatter dateFromString:[randomDates objectAtIndex:rand()%3]];
    return resultDate;
}

- (BOOL)randomBoolean
{
    return rand()%2;
}

- (NSDate *)randomDate
{
    NSTimeInterval randomTimeInterval = 24*60*60*(rand() % 10); // random +- 10 date
    NSDate *dateResult = [NSDate dateWithTimeInterval:randomTimeInterval sinceDate:[NSDate date]];
    
    return dateResult;
}


@end
