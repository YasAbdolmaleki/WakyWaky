//
//  ViewController.m
//  wakywaky
//
//  Created by Yas Abdolmaleki on 2018-02-05.
//  Copyright © 2018 Yas Marcu. All rights reserved.
//

#import "MainViewController.h"
#import "AlarmTableViewCell.h"
#import "AddAlarmTableViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *alarmsTableView;
@property (strong, nonatomic) AddAlarmTableViewController *addAlarmTableViewController;
@property (strong, nonatomic) NSMutableArray *testArray; 

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerForRemoteNotification];
    
    self.testArray = [NSMutableArray arrayWithObjects:@"09:00AM", @"12:25AM", @"04:14AM", @"02:12AM", @"01:08AM", nil];
    [self setupNavigationBar];
    
    [self.alarmsTableView registerNib:[UINib nibWithNibName:@"AlarmTableViewCell" bundle:nil] forCellReuseIdentifier:@"AlarmTableViewCell"];
    
    self.alarmsTableView.tableFooterView = [UIView new];
    [self.alarmsTableView reloadData];
}

#pragma notification registration

- (void)registerForRemoteNotification {
    UNUserNotificationCenter *uncenter = [UNUserNotificationCenter currentNotificationCenter];
    [uncenter setDelegate:self];
    [uncenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionBadge+UNAuthorizationOptionSound)
                            completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                NSLog(@"%@" , granted ? @"success to request authorization." : @"failed to request authorization .");
                            }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [uncenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"%s\nline:%@\n-----\n%@\n\n", __func__, @(__LINE__), settings);
        if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
            //TODO:
        } else if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
            //TODO:
        } else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            //TODO:
        }
    }];
    
    
    /// 4. update application icon badge number
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"Elon said:" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:@"Hello Tom！Get up, let's play with Jerry!" arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @(UIApplication.sharedApplication.applicationIconBadgeNumber + 1);
    
    
    // Deliver the notification in five seconds.
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5.f repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond" content:content trigger:trigger];
    
    /// 3. schedule localNotification
    [uncenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"add NotificationRequest succeeded!");
        }
    }];
    
    //given a time and date, ring
    
}

#pragma setup

- (void)setupNavigationBar {
    //right button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(addAlarmView)];
    [addButton setTintColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    //left button
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)addAlarmView {
    AddAlarmTableViewController *addAlarmTableViewController = [[AddAlarmTableViewController alloc] init];
    [self.navigationController pushViewController:addAlarmTableViewController
                                         animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.alarmsTableView setEditing:editing animated:animated];
}

#pragma UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmTableViewCell"];
    cell.timeLabel.text = [self.testArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [self.testArray  removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.testArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
