//
//  BKBook.h
//  Bookie
//
//  Created by Maxthon Chan on 13-1-2.
//
//

#import <Foundation/Foundation.h>

@class BKChapter;

@interface BKBook : NSObject

@property NSURL *baseURL;
@property NSDictionary *bookInfo;

+ (BKBook *)book;
- (void)reloadData;

- (void)gotoChapter:(NSUInteger)chapter;

- (BKChapter *)currentChapter;
- (BKChapter *)nextChapter;
- (BKChapter *)previousChapter;

- (void)closeBook;

@end
