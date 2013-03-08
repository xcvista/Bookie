//
//  BKTasker.h
//  Bookie
//
//  Created by Maxthon Chan on 13-1-5.
//
//

#import <Foundation/Foundation.h>

@interface BKTasker : NSObject

@property (readonly) NSUInteger taskCount;

+ (BKTasker *)tasker;

- (void)start;
- (void)stop;

@end
