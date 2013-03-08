//
//  BKPreferencesViewController.m
//  Bookie
//
//  Created by Maxthon Chan on 13-1-14.
//
//

#import "BKPreferencesViewController.h"
#import "BKBook.h"

@interface BKPreferencesViewController ()

@property (weak) IBOutlet UILabel *bookLabel;

@end

@implementation BKPreferencesViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.bookLabel.text = [NSString stringWithFormat:@"Current book: %@", [BKBook book].baseURL.absoluteString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearCache:(id)sender
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[BKBook book] reloadData];
}

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
