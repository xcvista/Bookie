//
//  BKImageViewController.m
//  Bookie
//
//  Created by Maxthon Chan on 13-1-14.
//
//

#import "BKImageViewController.h"
#import "BKTasker.h"

@interface BKImageViewController ()

@property NSURL *baseURL;
@property (weak) IBOutlet UIImageView *imageView;
@property (weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation BKImageViewController

- (id)initWithURL:(NSURL *)url
{
    if (self = [self initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]])
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
    
    [[BKTasker tasker] start];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:self.baseURL];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            [self.activityIndicator stopAnimating];
            [[BKTasker tasker] stop];
        });
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
