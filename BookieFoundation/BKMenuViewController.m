//
//  BKMenuViewController.m
//  Bookie
//
//  Created by Maxthon Chan on 12-12-17.
//
//

#import "BKMenuViewController.h"

@interface BKMenuViewController () <UIScrollViewDelegate>

@property (weak) IBOutlet UIView *containerView;
@property (weak) IBOutlet UIScrollView *scrollView;
@property (weak) IBOutlet UIPageControl *pageControl;

@property NSArray *pages;

- (IBAction)pageChanged:(id)sender;

@end

@implementation BKMenuViewController

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
    self.pages =
    [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"chapters"
                                                            withExtension:@"plist"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.pageControl.numberOfPages = self.pages.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGSize size = CGSizeMake(self.scrollView.frame.size.width * self.pages.count, self.scrollView.frame.size.height);
    self.scrollView.contentSize = size;
    self.containerView.frame = CGRectMake(0, 0, size.width, size.height);
}

- (void)pageChanged:(id)sender
{
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * self.pageControl.currentPage, 0, 0, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
}

@end
