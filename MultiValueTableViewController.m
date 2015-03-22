//
//  MultiValueTableViewController.m
//
//  Created by Gilles Lesire on 16/07/14.
//  GNU General Public License (GPL)
//  https://github.com/KingIsulgard/iOS-InApp-Settings-TableView
//

#import "MultiValueTableViewController.h"

@interface MultiValueTableViewController ()

@end

@implementation MultiValueTableViewController

@synthesize prefSpecification;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *title = [prefSpecification objectForKey: @"Title"];
    self.navigationItem.title = title;

// Avoid tab bar to overlap tableview
self.edgesForExtendedLayout = UIRectEdgeAll;
self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *values = [prefSpecification objectForKey: @"Values"];

    // Return the number of rows in the section.
    return [values count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell" forIndexPath:indexPath];

    NSString *key = [prefSpecification objectForKey: @"Key"];
    NSArray *titles = [prefSpecification objectForKey: @"Titles"];
    NSArray *values = [prefSpecification objectForKey: @"Values"];
    NSString *title = [titles objectAtIndex: indexPath.row];

    // Create cell
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    // Set title
    cell.textLabel.text = title;

    // If this is the selected value
    if([[values objectAtIndex: indexPath.row] intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey: key] intValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [prefSpecification objectForKey: @"Key"];
    NSArray *values = [prefSpecification objectForKey: @"Values"];

    NSNumber *value = [values objectAtIndex: indexPath.row];

    [[NSUserDefaults standardUserDefaults] setObject: value forKey: key];

    [self.delegate selectedMultiValue];
    [self.tableView reloadData];
}

@end
