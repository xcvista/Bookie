//
//  BKTasker.m
//  Bookie
//
//  Created by Maxthon Chan on 13-1-5.
//
//

#import "BKTasker.h"
#import <UIKit/UIKit.h>

@interface BKTasker ()

@property NSUInteger taskCount;

@end

BKTasker *defaultCounter;

@implementation BKTasker

+ (BKTasker *)tasker
{
    if (!defaultCounter)
        defaultCounter = [[self alloc] init];
    return defaultCounter;
}

- (void)start
{
    self.taskCount++;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)stop
{
    if (self.taskCount)
    {
        self.taskCount--;
    }
    if (!self.taskCount)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

@end
