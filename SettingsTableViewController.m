//
//  SettingsTableViewController.m
//
//  Created by Gilles Lesire on 16/07/14.
//  GNU General Public License (GPL)
////

#import "SettingsTableViewController.h"

#define labelCGRectX 25
#define labelCGRectY 25
#define labelCGRectWidth 140
#define labelCGRectHeight 21

#define typeGroup @"PSGroupSpecifier"
#define typeTitle @"PSTitleValueSpecifier"
#define typeToggleSwitch @"PSToggleSwitchSpecifier"
#define typeMultiValue @"PSMultiValueSpecifier"
#define typeTextField @"PSTextFieldSpecifier"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (id)initWithStyle: (UITableViewStyle)style
{
    self = [super initWithStyle: style];

    if (self) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Track rotation changes
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange) name: UIDeviceOrientationDidChangeNotification object: nil];

    // Avoid tab bar to overlap tableview
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);

    // Custom initialization
    labelViews = [NSMutableArray arrayWithObjects: nil];
    textViews = [NSMutableArray arrayWithObjects: nil];
    settingsTableSections = [NSMutableArray arrayWithObjects: nil];
    settingsTableData = [NSMutableArray arrayWithObjects: nil];
    settingsKeys = [NSMutableArray arrayWithObjects: nil];

    NSLog(@"Created arrays");


    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource: @"Settings" ofType: @"bundle"];

    if(!settingsBundle) {

        NSLog(@"Could not find Settings.bundle");

    } else {

        NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent: @"Root.plist"]];
        NSArray *preferences = [settings objectForKey: @"PreferenceSpecifiers"];
        NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity: [preferences count]];

        for (NSDictionary *prefSpecification in preferences) {

            NSLog(@"%@", prefSpecification);

            NSString *title = [prefSpecification objectForKey: @"Title"];
            NSString *type = [prefSpecification objectForKey: @"Type"];

            if([type isEqualToString: typeGroup]) {

                // Create new section
                [settingsTableSections addObject: title];
                NSMutableArray *newSection = [NSMutableArray arrayWithObjects: nil];
                [settingsTableData addObject: newSection];

            } else {

                // Add specification to last section
                [[settingsTableData objectAtIndex: ([settingsTableData count] - 1)] addObject:prefSpecification];

            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    // Return the number of sections.
    return [settingsTableSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[settingsTableData objectAtIndex: section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [settingsTableSections objectAtIndex: section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Get the dictionary item
    NSDictionary *prefSpecification = [[settingsTableData objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];

    NSString *title = [prefSpecification objectForKey: @"Title"];
    NSString *key = [prefSpecification objectForKey: @"Key"];
    NSString *type = [prefSpecification objectForKey: @"Type"];

    // Define cell
    UITableViewCell *cell;

    // Keep tag of keys
    [settingsKeys addObject: key];
    int tag = [settingsKeys count] - 1;

    if([type isEqualToString: typeTitle]) {

        // Create cell
        cell = [tableView dequeueReusableCellWithIdentifier: @"Cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        // Set title
        cell.textLabel.text = title;

        // Add label
        UILabel *labelView = [[UILabel alloc] initWithFrame: CGRectMake(labelCGRectX, labelCGRectY, labelCGRectWidth, labelCGRectHeight)];
        labelView.text = [[NSUserDefaults standardUserDefaults] objectForKey: key];
        labelView.textAlignment = NSTextAlignmentRight;
        labelView.textColor = [UIColor grayColor];
        cell.accessoryView = labelView;

    }
    if([type isEqualToString: typeToggleSwitch]) {

        // Create cell
        cell = [tableView dequeueReusableCellWithIdentifier: @"Cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        // Set title
        cell.textLabel.text = title;

        // Add switch
        UISwitch *switchView = [[UISwitch alloc] initWithFrame: CGRectZero];
        cell.accessoryView = switchView;
        switchView.tag = tag;
        [switchView setOn: [[[NSUserDefaults standardUserDefaults] objectForKey: key] boolValue] animated: NO];

        // Connect action to switch
        [switchView addTarget: self action: @selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

    }
    if([type isEqualToString: typeTextField]) {

        // Create cell
        cell = [tableView dequeueReusableCellWithIdentifier: @"Cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        int frameSize = self.view.frame.size.width;

        UITextField *textField = [[UITextField alloc] initWithFrame: CGRectMake(15, 10, frameSize,labelCGRectHeight)];
        textField.tag = tag;
        textField.text = [[NSUserDefaults standardUserDefaults] objectForKey: key];

        [textField addTarget: self
                      action: @selector(textFieldChanged:)
            forControlEvents: UIControlEventEditingChanged];

        [cell.contentView addSubview: textField];

        // Tract text field
        [textViews addObject: textField];
    }
    if([type isEqualToString: typeMultiValue]) {

        // Create cell
        cell = [tableView dequeueReusableCellWithIdentifier: @"MultiValueCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        // Get value
        int value = [[[NSUserDefaults standardUserDefaults] objectForKey: key] intValue];
        NSArray *values = [prefSpecification objectForKey: @"Values"];
        NSArray *titles = [prefSpecification objectForKey: @"Titles"];
        NSString *multiValue = @"Unknown";
        int index = [values indexOfObject: [NSString stringWithFormat: @"%d", value]];

        if(index >= 0 && index < [values count]) {
            multiValue = [titles objectAtIndex: index];
        }

        // Set title
        cell.textLabel.text = title;

        int frameSize = self.view.frame.size.width;

        // Add label
        UILabel *labelView = [[UILabel alloc] initWithFrame: CGRectMake((frameSize - labelCGRectWidth - 30), 12, labelCGRectWidth, labelCGRectHeight)];
        labelView.textAlignment = NSTextAlignmentRight;
        labelView.text = multiValue;
        labelView.textColor = [UIColor grayColor];

        [cell addSubview: labelView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        // Track label
        [labelViews addObject: labelView];
    }

    return cell;
}

- (void) switchChanged: (id) sender {
    UISwitch* switchControl = sender;

    NSString *key = [settingsKeys objectAtIndex: switchControl.tag];
    NSNumber *numberValue = [NSNumber numberWithBool: switchControl.on];

    [[NSUserDefaults standardUserDefaults] setObject: numberValue forKey: key];
}
- (void) textFieldChanged: (id) sender {
    UITextField* textControl = sender;

    NSString *key = [settingsKeys objectAtIndex: textControl.tag];
    NSString *stringValue = textControl.text;

    [[NSUserDefaults standardUserDefaults] setObject: stringValue forKey: key];
}

- (void) selectedMultiValue {
    [self reloadTable];
}

- (void) deviceOrientationDidChange {
    [self reloadTable];
}

- (void)prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ([[segue identifier] isEqualToString: @"changeMultiValue"])
    {
        MultiValueTableViewController *multiValueViewController =
        [segue destinationViewController];

        NSIndexPath *indexPath = [self.tableView
                                  indexPathForSelectedRow];

        // Get the dictionary item
        NSDictionary *prefSpecification = [[settingsTableData objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];

        multiValueViewController.prefSpecification = prefSpecification;
        multiValueViewController.delegate = self;
    }
}

- (void) reloadTable {
    for (UILabel *labelView in labelViews) {
        [labelView removeFromSuperview];
    }
    for (UITextField *textView in textViews) {
        [textView removeFromSuperview];
    }

    // Remove references to objects for garbage collection
    labelViews = [NSMutableArray arrayWithObjects: nil];
    textViews = [NSMutableArray arrayWithObjects: nil];

    [self.tableView reloadData];
}

- (void) dealloc {
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}
@end
