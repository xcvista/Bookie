//
//  BKChapter.h
//  Bookie
//
//  Created by Maxthon Chan on 13-1-2.
//
//

#import <Foundation/Foundation.h>

@class BKBook;

@interface BKChapter : NSObject

@property NSURL *baseURL;
@property NSDictionary *chapterInfo;

- (id)initWithChapterURL:(NSURL *)url;

- (void)gotoPage:(NSUInteger)page;

- (NSURL *)currentPage;
- (NSURL *)nextPage;
- (NSURL *)previousPage;

- (NSString *)name;

@end
