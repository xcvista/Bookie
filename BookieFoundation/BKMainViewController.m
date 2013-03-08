//
//  BKMainViewController.m
//  Bookie
//
//  Created by Maxthon Chan on 13-1-5.
//
//

#import "BKMainViewController.h"
#import "BKBookViewController.h"

@interface BKMainViewController ()

@property (weak) IBOutlet UIBarButtonItem *titleButton;

@end

@implementation BKMainViewController

- (id)init
{
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoHome:(id)sender
{
    if ([self.childViewControllers[0] respondsToSelector:@selector(homePage)])
        [self.childViewControllers[0] homePage];
}

@end
