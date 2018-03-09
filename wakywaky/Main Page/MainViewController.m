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

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *alarmsTableView;
@property (strong, nonatomic) AddAlarmTableViewController *addAlarmTableViewController;
@property (strong, nonatomic) NSMutableArray *excitingAlarmArray;
@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addAlarmTableViewController = [[AddAlarmTableViewController alloc] init];
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    [self setupNavigationBar];
    
    [self.alarmsTableView registerNib:[UINib nibWithNibName:@"AlarmTableViewCell" bundle:nil]
               forCellReuseIdentifier:@"AlarmTableViewCell"];
    
    self.alarmsTableView.tableFooterView = [UIView new];
    [self.alarmsTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    id dateArray = [self.defaults objectForKey:@"dateArray"];
    if (dateArray) {
        self.excitingAlarmArray  = [dateArray mutableCopy];
    }
    
   [self.alarmsTableView reloadData];
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
    [self.navigationController pushViewController:self.addAlarmTableViewController
                                         animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.alarmsTableView setEditing:editing animated:animated];
}

#pragma UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmTableViewCell"];
    
    NSInteger hour = [[self currentDateComponents:indexPath] hour];
    NSInteger minute = [[self currentDateComponents:indexPath] minute];
    cell.timeLabel.text = [NSString stringWithFormat: @"%ld:%ld", (long)hour, (long)minute];
    
    return cell;
}

- (NSDateComponents *)currentDateComponents:(NSIndexPath *)indexPath {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"<your date format goes here"];
    NSDate *date = (NSDate *)[self.excitingAlarmArray objectAtIndex:indexPath.row];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [self.excitingAlarmArray  removeObjectAtIndex:[indexPath row]];
        [self.defaults setObject:self.excitingAlarmArray forKey:@"dateArray"];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.excitingAlarmArray count];
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
