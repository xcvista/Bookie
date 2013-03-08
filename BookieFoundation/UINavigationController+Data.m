//
//  UINavigationController+Data.m
//  Bookie
//
//  Created by Maxthon Chan on 13-1-14.
//
//

#import "UINavigationController+Data.h"

@implementation UINavigationController (Data)

- (id)data
{
    if ([self.viewControllers[0] respondsToSelector:@selector(data)])
    {
        return [self.viewControllers[0] data];
    }
    else
    {
        return nil;
    }
}

- (void)setData:(id)data
{
    if ([self.viewControllers[0] respondsToSelector:@selector(setData:)])
    {
        [self.viewControllers[0] setData:data];
    }
}

@end
