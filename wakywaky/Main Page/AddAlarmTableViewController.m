//
//  AddAlarmTableViewController.m
//  wakywaky
//
//  Created by Yas Abdolmaleki on 2018-03-01.
//  Copyright © 2018 Yas Marcu. All rights reserved.
//

#import "AddAlarmTableViewController.h"
#import "AlarmTableViewCell.h"

@interface AddAlarmTableViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic,strong) UIPickerView *timePickerView;

@property (nonatomic,assign) NSInteger hour;
@property (nonatomic,assign) NSInteger mins;
@property (nonatomic,strong) NSString *AMPM;
@end

@implementation AddAlarmTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    [self setTitle:@"Add Alarm"];
    [self.view setBackgroundColor:[UIColor colorWithRed:0/255.0 green:23/255.0 blue:100/255.0 alpha:1.0]];
    
    //right button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(saveTime)];
    [addButton setTintColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    [self.navigationItem setRightBarButtonItem:addButton];
}

- (void)saveTime {

    // set timer
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setHour:10];
//    [comps setMinute:10];
//    [comps setSecond:0];
//    NSCalendar *theCalendar = [NSCalendar currentCalendar];
//    NSDate *itemDate = [theCalendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    
    // today's date
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    
    // set hour/min for today
    [components setHour: self.hour];
    [components setMinute: self.mins];
    NSDate *newDate = [gregorian dateFromComponents: components];
    
    // Date has passed
    if ([newDate timeIntervalSinceNow] < 0.0) {
        #warning not accurate, doesn't consider the end of month or next year
        [components setDay:[components day] + 1];
        newDate = [gregorian dateFromComponents: components];
    }
    
    // save
    [[NSUserDefaults standardUserDefaults] setObject:newDate forKey:@"alarmSet"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // testing
    if ([newDate timeIntervalSinceNow] < 200.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"60 seconds or less" message:@"Text" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    [self.timePickerView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:240/255.0 blue:0/255.0 alpha:1.0]];
    [view addSubview:self.timePickerView];
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            self.hour = (row+1);
            break;
        case 1:
            self.mins = (row);
            break;
        default:
            self.AMPM = (row == 0) ? @"AM" : @"PM";
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
