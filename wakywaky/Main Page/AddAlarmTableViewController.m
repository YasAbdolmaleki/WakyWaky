//
//  AddAlarmTableViewController.m
//  wakywaky
//
//  Created by Yas Abdolmaleki on 2018-03-01.
//  Copyright © 2018 Yas Marcu. All rights reserved.
//

#import "AddAlarmTableViewController.h"

#import "AlarmTableViewCell.h"

@import AVFoundation;
@import UserNotifications;

@interface AddAlarmTableViewController () <UIPickerViewDelegate,UIPickerViewDataSource,UNUserNotificationCenterDelegate,AVAudioPlayerDelegate>
@property (nonatomic,strong) UIPickerView *timePickerView;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) UNUserNotificationCenter *uncenter;

@property (nonatomic,assign) NSInteger hour;
@property (nonatomic,assign) NSInteger mins;
@property (nonatomic,strong) NSString *AMPM;
@end

@implementation AddAlarmTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerForRemoteNotification];
    
    self.tableView.tableFooterView = [UIView new];
    [self setTitle:@"Add Alarm"];
    
    //right button
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(setAlarmInNotificationForm)];
    [saveButton setTintColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    [self.navigationItem setRightBarButtonItem:saveButton];
}

#pragma notification registration

- (void)registerForRemoteNotification {
    self.uncenter = [UNUserNotificationCenter currentNotificationCenter];
    [self.uncenter setDelegate:self];
    [self.uncenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionBadge+UNAuthorizationOptionSound)
                            completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                NSLog(@"%@" , granted ? @"success to request authorization." : @"failed to request authorization .");
                            }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [self.uncenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"%s\nline:%@\n-----\n%@\n\n", __func__, @(__LINE__), settings);
        if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
        } else if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
        } else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
        }
    }];
}

- (void)setAlarmInNotificationForm {
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"WAKY WAKY:" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:@"Just making sure you are up!" arguments:nil];
    content.sound = [UNNotificationSound soundNamed:@"beep.mp3"];
    content.badge = @(UIApplication.sharedApplication.applicationIconBadgeNumber + 1);
    
    
    NSDateComponents *components = [self dateComponentsAddedUserAlarm];
    NSString *uniqueIdentifier = [NSString stringWithFormat: @"%ld%ld%ld", (long)[components day],  (long)[components minute],  (long)[components hour]];
    
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components
                                                                                                      repeats:YES];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:uniqueIdentifier
                                                                          content:content
                                                                          trigger:trigger];
    
    
    /// 3. schedule localNotification
    [self.uncenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"add NotificationRequest succeeded!");
        }
    }];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSDateComponents *)dateComponentsAddedUserAlarm {
    // today's date
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    // set hour/min for today
    [components setHour: self.hour];
    [components setMinute: self.mins];
    [components setSecond:0];
    
    NSDate *newDate = [gregorian dateFromComponents: components];
    
    // Date has passed
    if ([newDate timeIntervalSinceNow] < 0.0) {
        #warning not accurate, doesn't consider the end of month or next year
        [components setDay:[components day] + 1];
        newDate = [gregorian dateFromComponents: components];
    }
    
    NSLog(@"--now\n %@",date);
    NSLog(@"--alert\n %@",newDate);
    NSLog(@"--hour\n %ld",self.hour);
    NSLog(@"--components\n %@",components);
    
    [self saveNewAlarmLocally:newDate];
    
    return components;
}

- (void)saveNewAlarmLocally:(NSDate *)newDate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // get and modify
    NSMutableArray *dateArrayCopy = [[NSMutableArray alloc] init];
    id dateArray = [defaults objectForKey:@"dateArray"];
    if (dateArray) {
        dateArrayCopy = [dateArray mutableCopy];
    }
    [dateArrayCopy addObject:newDate];
    
    // add
    [defaults setObject:dateArrayCopy forKey:@"dateArray"];
    [defaults synchronize];
}

-(NSInteger)hourIn24Format:(NSInteger)selectedHour
{
    if ([self.AMPM isEqualToString:@"PM"]) {
        return selectedHour + 12;
    } else {
        return selectedHour;
    }
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    if ([response.actionIdentifier isEqualToString:UNNotificationDismissActionIdentifier]) {
        NSLog(@"Message Closed");
    } else if ([response.actionIdentifier isEqualToString:UNNotificationDefaultActionIdentifier]) {
        NSLog(@"App is Open");
        [self startAlerting];
    }
    
    completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"----willPresentNotification");
}

#pragma AVAudioPlayerDelegate

- (void)startAlerting {
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(playSound)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)playSound {
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.mp3", [[NSBundle mainBundle] resourcePath], @"beep"]];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.numberOfLoops = -1;
    if (self.audioPlayer == nil) {
        NSLog (@"%@",[error description]);
    } else {
        [self.audioPlayer play];
    }
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector (pauseMethod:) userInfo:nil repeats:NO];
}

-(void)pauseMethod:(NSTimer *)timer{
    if (self.audioPlayer) {
        self.audioPlayer = nil;
    }
    [timer invalidate];
    timer = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmTableViewCell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 400;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 400)];
    
    self.timePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 400)];
    self.timePickerView.delegate = self;
    self.timePickerView.dataSource = self;
    [view addSubview:self.timePickerView];
    return view;
}

#pragma mark - UIPickerViewDataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            self.hour = [self hourIn24Format:(row+1)];
            break;
        case 1:
            self.mins = (row);
            break;
        default:
            self.AMPM = (row == 0) ? @"AM" : @"PM";
            self.hour = [self hourIn24Format:self.hour];
            break;
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:80.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    switch (component) {
        case 0:
            return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @"%ld", (long)(row+1)] attributes:attrsDictionary];
            break;
        case 1:
            return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @"%ld", (long)(row)] attributes:attrsDictionary];
            break;
        default:
            return [[NSAttributedString alloc] initWithString:((row == 0) ? @"AM" : @"PM") attributes:attrsDictionary];
            break;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 12;
            break;
        case 1:
            return 60;
            break;
        default:
            return 2;
            break;
    }
}

@end
