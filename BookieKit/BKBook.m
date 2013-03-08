//
//  BKBook.m
//  Bookie
//
//  Created by Maxthon Chan on 13-1-2.
//
//

#import "BKBook.h"
#import "BKChapter.h"
#import "BKChapter_Private.h"

BKBook *defaultBook;

@interface BKBook ()

@property NSUInteger currentChapterID;

@end

@implementation BKBook

+ (BKBook *)book
{
    if (!defaultBook)
        defaultBook = [[self alloc] init];
    return defaultBook;
}

- (void)reloadData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.bookInfo = [defaults objectForKey:@"BKBook"]; // Retrive local data
    
    if (!self.bookInfo) // No local data - retrive initial data
        self.bookInfo = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"book"
                                                                                          withExtension:@"plist"]];
    
    if (!self.bookInfo) // No intial data - go to error page.
        self.bookInfo = @{@"BKBookRoot": @"http://bookie.maxius.tk/error-damaged-app/index.plist"};
    
    if (!self.bookInfo[@"BKType"] && !self.bookInfo[@"BKBookRoot"])
        self.bookInfo = @{@"BKBookRoot": @"http://bookie.maxius.tk/error-damaged-app/index.plist"};
    
    self.baseURL = [NSURL URLWithString:self.bookInfo[@"BKBookRoot"]];
    
    while (!self.bookInfo[@"BKType"])
    {
        NSDictionary *bookInfo = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:self.bookInfo[@"BKBookRoot"]]];
        if (!bookInfo)
        {
            bookInfo = @{@"BKBookRoot": @"http://bookie.maxius.tk/error-damaged-app/index.plist"};
        }
        self.bookInfo = bookInfo;
    }
}

- (id)init
{
    if (self = [super init])
    {
        
        [self reloadData];
        
    }
    return self;
}

- (void)gotoChapter:(NSUInteger)chapter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(chapter) forKey:@"BKLastChapter"];
    self.currentChapterID = chapter;
    [defaults synchronize];
}

- (BKChapter *)currentChapter
{
    return [[BKChapter alloc] initWithChapterURL:[NSURL URLWithString:self.bookInfo[@"BKBookChapters"][self.currentChapterID] relativeToURL:self.baseURL]];
}

- (BKChapter *)nextChapter
{
    if (self.currentChapterID < [self.bookInfo[@"BKBookChapters"] count])
    {
        [self gotoChapter:self.currentChapterID + 1];
        return [self currentChapter];
    }
    else
        return nil;
}

- (BKChapter *)previousChapter
{
    if (self.currentChapterID > 0)
    {
        [self gotoChapter:self.currentChapterID - 1];
        return [self currentChapter];
    }
    else
        return nil;
}

- (void)closeBook
{
    if ([self.bookInfo[@"BKBookDownloadable"] boolValue])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.bookInfo forKey:@"BKBook"];
        [defaults synchronize];
    }
}

@end
