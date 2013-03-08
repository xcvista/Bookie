//
//  BKChapter.m
//  Bookie
//
//  Created by Maxthon Chan on 13-1-2.
//
//

#import "BKChapter.h"
#import "BKChapter_Private.h"

@implementation BKChapter

- (id)initWithChapterURL:(NSURL *)url
{
    if (self = [super init])
    {
        self.baseURL = url;
        self.chapterInfo = [NSDictionary dictionaryWithContentsOfURL:url];
    }
    return self;
}

- (void)gotoPage:(NSUInteger)page
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(page) forKey:@"BKLastPage"];
    self.currentPageID = page;
    [defaults synchronize];
}

- (NSURL *)currentPage
{
    return [NSURL URLWithString:self.chapterInfo[@"BKChapterPages"][self.currentPageID] relativeToURL:self.baseURL];
}

- (NSURL *)nextPage
{
    if (self.currentPageID < [self.chapterInfo[@"BKChapterPages"] count] - 1)
    {
        [self gotoPage:self.currentPageID + 1];
        return [self currentPage];
    }
    else
        return nil;
}

- (NSURL *)previousPage
{
    if (self.currentPageID > 0)
    {
        [self gotoPage:self.currentPageID - 1];
        return [self currentPage];
    }
    else
        return nil;
}

- (NSString *)name
{
    return self.chapterInfo[@"BKChapterName"];
}

@end
