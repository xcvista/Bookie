//
//  BKImageGalleryViewController.m
//  Bookie
//
//  Created by Maxthon Chan on 13-1-14.
//
//

#import "BKImageGalleryViewController.h"
#import "BKImageViewController.h"

@interface BKImageGalleryViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property NSArray *images;
@property NSURL *baseURL;
@property NSUInteger currentPage;

@end

@implementation BKImageGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.images = self.data[@"BKImages"];
    self.baseURL = [NSURL URLWithString:self.data[@"BKBaseURL"]];
    self.currentPage = 0;
    
    self.dataSource = self;
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    @synchronized (self)
    {
        NSURL *imageURL = [NSURL URLWithString:self.images[self.currentPage] relativeToURL:self.baseURL];
        [self setViewControllers:@[[[BKImageViewController alloc] initWithURL:imageURL]]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:nil];
    }
}

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    @synchronized (self)
    {
        if (self.currentPage < self.images.count - 1)
            self.currentPage++;
        else
            return nil;
        
        NSURL *imageURL = [NSURL URLWithString:self.images[self.currentPage] relativeToURL:self.baseURL];
        return [[BKImageViewController alloc] initWithURL:imageURL];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    @synchronized (self)
    {
        if (self.currentPage > 0)
            self.currentPage--;
        else
            return nil;
        
        NSURL *imageURL = [NSURL URLWithString:self.images[self.currentPage] relativeToURL:self.baseURL];
        return [[BKImageViewController alloc] initWithURL:imageURL];
    }
}

@end
