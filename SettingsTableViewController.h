//
//  SettingsTableViewController.h
//  Cochlear App
//
//  Created by Gilles Lesire on 16/07/14.
//  GNU General Public License (GPL)
//

#import <UIKit/UIKit.h>
#import "MultiValueTableViewController.h"

@interface SettingsTableViewController : UITableViewController <MultiValueDelegate> {
    NSMutableArray *labelViews;
    NSMutableArray *textViews;
    NSMutableArray *settingsKeys;
    NSMutableArray *settingsTableSections;
    NSMutableArray *settingsTableData;
}

@end
