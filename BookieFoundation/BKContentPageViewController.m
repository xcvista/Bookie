//
//  BKContentPageViewController.m
//  Bookie
//
//  Created by Maxthon Chan on 13-1-2.
//
//

#import "BKContentPageViewController.h"
#import "BKTasker.h"
#import "BKBookViewController.h"

@interface BKContentPageViewController () <UIWebViewDelegate>

@property (weak) IBOutlet UIWebView *webView;
@property NSURL *baseURL;
@property BOOL loaded;

@end

@implementation BKContentPageViewController

- (id)init
{
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (id)initWithPage:(NSURL *)url
{
    if (self = [self init])
    {
        self.baseURL = url;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.loaded = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.baseURL]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[BKTasker tasker] start];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[BKTasker tasker] stop];
    self.loaded = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        [((BKBookViewController *)self.parentViewController) processURL:request.URL];
        return NO;
    }
    else
        return YES;
}

@end
