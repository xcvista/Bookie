//
//  BKBookViewController.m
//  Bookie
//
//  Created by Maxthon Chan on 13-1-2.
//
//

#import "BKBookViewController.h"
#import "BKContentPageViewController.h"
#import "UINavigationController+Data.h"

@interface BKBookViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property BKChapter *currentChapter;
@property NSUInteger currentPage;
@property NSArray *pages;

@end

@implementation BKBookViewController

- (id)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options
{
    if (self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options])
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.dataSource = self;
}

- (NSURL *)pageURL:(NSString *)pageAddress
{
    return [NSURL URLWithString:pageAddress relativeToURL:[BKBook book].baseURL];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.pages = [[BKBook book] bookInfo][@"BKBookPages"];
    self.currentPage = 0;
    
    if (!self.viewControllers.count)
    {
        [self setViewControllers:@[[[BKContentPageViewController alloc] initWithPage:[self pageURL:self.pages[self.currentPage]]]]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:nil];
    }
    
    /*
     
     if (!self.currentChapter)
     self.currentChapter = [BKBook book].currentChapter;
     
     if (!self.viewControllers.count)
     {
     [self setViewControllers:@[[[BKContentPageViewController alloc] initWithPage:self.currentChapter.currentPage]]
     direction:UIPageViewControllerNavigationDirectionForward
     animated:NO
     completion:nil];
     }
     
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    /*
     NSURL *nextURL = self.currentChapter.nextPage;
     
     if (!nextURL)
     {
     BKChapter *nextChapter = [[BKBook book] nextChapter];
     if (!nextChapter)
     return nil;
     else
     {
     self.currentChapter = nextChapter;
     nextURL = self.currentChapter.currentPage;
     }
     }
     
     
     */
    
    @synchronized (self)
    {
        // Try turn to the next page
        if (self.currentPage + 1 < self.pages.count)
            self.currentPage++;
        else
            return nil;
        
        NSURL *nextURL = [self pageURL:self.pages[self.currentPage]];
        
        if ([nextURL.scheme compare:@"bookie" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            return nil;
        }
        else if ([nextURL.pathExtension compare:@"plist" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            return nil;
        }
        else
        {
            return [[BKContentPageViewController alloc] initWithPage:nextURL];
        }
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    /*
     NSURL *nextURL = self.currentChapter.previousPage;
     
     if (!nextURL)
     {
     BKChapter *nextChapter = [[BKBook book] previousChapter];
     if (!nextChapter)
     return nil;
     else
     {
     self.currentChapter = nextChapter;
     nextURL = self.currentChapter.currentPage;
     }
     }
     
     if ([nextURL.scheme compare:@"bookie" options:NSCaseInsensitiveSearch] == NSOrderedSame)
     {
     
     }
     else if ([nextURL.pathExtension compare:@"plist" options:NSCaseInsensitiveSearch] == NSOrderedSame)
     {
     
     }
     else
     {
     return [[BKContentPageViewController alloc] initWithPage:nextURL];
     }
     */
    @synchronized (self)
    {
        if (self.currentPage > 0)
            self.currentPage--;
        else
            return nil;
        
        NSURL *nextURL = [self pageURL:self.pages[self.currentPage]];
        
        if ([nextURL.scheme compare:@"bookie" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            return nil;
        }
        else if ([nextURL.pathExtension compare:@"plist" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            return nil;
        }
        else
        {
            return [[BKContentPageViewController alloc] initWithPage:nextURL];
        }
    }
    
}

- (void)processURL:(NSURL *)nextURL
{
    if ([nextURL.scheme compare:@"bookie" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        if ([nextURL.host compare:@"goto" options:NSCaseInsensitiveSearch] == NSOrderedSame && nextURL.pathComponents.count > 1)
        {
            @synchronized (self)
            {
                NSUInteger destPage = [nextURL.pathComponents[1] integerValue];
                if (destPage >= self.pages.count)
                    return;
                if (destPage == self.currentPage)
                    return;
                UIPageViewControllerNavigationDirection direction = (destPage < self.currentPage) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
                self.currentPage = destPage;
                [self setViewControllers:@[[[BKContentPageViewController alloc] initWithPage:[self pageURL:self.pages[self.currentPage]]]]
                               direction:direction
                                animated:YES
                              completion:nil];
            }
            
        }
    }
    else if ([nextURL.pathExtension compare:@"plist" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        NSMutableDictionary *data = [[NSDictionary dictionaryWithContentsOfURL:nextURL] mutableCopy];
        if (!data)
            return;
        data[@"BKBaseURL"] = [nextURL absoluteString];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:data[@"BKType"] bundle:[NSBundle mainBundle]];
        if (!storyboard)
            return;
        id vc = [storyboard instantiateInitialViewController];
        if ([vc respondsToSelector:@selector(setData:)])
            [vc setData:data];
        if (data[@"BKPresentationMode"])
            [vc setModalPresentationStyle:[data[@"BKPresentationMode"] integerValue]];
        else
            [vc setModalPresentationStyle:UIModalPresentationFormSheet];
        [self presentViewController:vc
                           animated:YES
                         completion:nil];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:nextURL];
    }
}

- (void)homePage
{
    @synchronized (self)
    {
        NSUInteger destPage = 0;
        if (destPage >= self.pages.count)
            return;
        if (destPage == self.currentPage)
            return;
        UIPageViewControllerNavigationDirection direction = (destPage < self.currentPage) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
        self.currentPage = destPage;
        [self setViewControllers:@[[[BKContentPageViewController alloc] initWithPage:[self pageURL:self.pages[self.currentPage]]]]
                       direction:direction
                        animated:YES
                      completion:nil];
    }
}

@end
