//
//  BKInitialScreenViewController.m
//  Bookie
//
//  Created by Maxthon Chan on 13-1-5.
//
//

#import "BKInitialScreenViewController.h"
#import "BKBookViewController.h"
#import "BKMainViewController.h"
#import "BKBook.h"
#import "BKTasker.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface BKInitialScreenViewController ()

@property (weak) IBOutlet UIImageView *imageView;

- (void)systemInitialize;

@end

@implementation BKInitialScreenViewController

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
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Load up studd in a background thread
    [[BKTasker tasker] start];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if ([reachability currentReachabilityStatus] == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bookie"
                                                        message:NSLocalizedString(@"Bookie requires Intenet to run.", @"")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self systemInitialize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"BKLoadMain" sender:self];
        });
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[BKTasker tasker] stop];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIImage *destinetion = nil;
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        destinetion = [UIImage imageNamed:@"Default-Landscape"];
        if (!destinetion)
            destinetion = [UIImage imageNamed:@"Default"];
    }
    else if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
        destinetion = [UIImage imageNamed:@"Default-Portrait"];
        if (!destinetion)
            destinetion = [UIImage imageNamed:@"Default"];
    }
    
    self.imageView.opaque = NO;
    [UIView animateWithDuration:duration / 2 animations:^{
        self.imageView.alpha = 0;
    } completion:^(BOOL finished){
        if (finished)
        {
            self.imageView.image = destinetion;
            [UIView animateWithDuration:duration / 2 animations:^{
                self.imageView.alpha = 1;
            } completion:^(BOOL finished) {
                self.imageView.opaque = YES;
            }];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)systemInitialize
{
    [BKBook book];
}

@end
