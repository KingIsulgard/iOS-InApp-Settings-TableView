//
//  MultiValueTableViewController.h
//
//  Created by Gilles Lesire on 16/07/14.
//  GNU General Public License (GPL)
//  https://github.com/KingIsulgard/iOS-InApp-Settings-TableView
//

#import <UIKit/UIKit.h>
#import "SettingsController.h"

@protocol MultiValueDelegate

- (void) selectedMultiValue;

@end

@interface MultiValueTableViewController : UITableViewController {
    NSDictionary *prefSpecification;
}

@property (nonatomic) id<MultiValueDelegate> delegate;
@property (strong, nonatomic) NSDictionary *prefSpecification;

@end
