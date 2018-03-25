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

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, AlarmTableViewCellDelegate>
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
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0f]}];
    
    //right button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"New"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(addAlarmView)];
    [addButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} forState:UIControlStateNormal];
    [addButton setTintColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    //left button
    [self.editButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
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
    cell.delegate = self;
    cell.timeLabel.attributedText = [self timeLabelFormatt:indexPath];
    return cell;
}

- (NSMutableAttributedString *)timeLabelFormatt:(NSIndexPath *)indexPath {
    NSInteger hour = [[self currentDateComponents:indexPath] hour];
    NSInteger minute = [[self currentDateComponents:indexPath] minute];

    // setup font and string for AM or PM
    NSDictionary *amOrPMFont = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:25.0] forKey:NSFontAttributeName];
    NSMutableAttributedString *amOrPMAttString = [[NSMutableAttributedString alloc] initWithString:@"AM" attributes:amOrPMFont];

    // PM
    if (hour > 12) {
        [amOrPMAttString.mutableString setString:@"PM"];
        hour = hour - 12;
    } else if (hour == 0) {
        [amOrPMAttString.mutableString setString:@"PM"];
        hour = 12;
    }
    
    // setup font and string for time
    NSDictionary *timeFont = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:32.0] forKey:NSFontAttributeName];
    NSMutableAttributedString *timeAttString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"%02d:%02d", (int)hour, (int)minute] attributes:timeFont];
    
    [timeAttString appendAttributedString:amOrPMAttString];
    return timeAttString;
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

- (void)valueChanged:(id)sender {
    UISwitch *switchValue = (UISwitch*)sender;
    NSLog(@"%@", switchValue.isOn ? @"ON" : @"OFF");
    
    // get the selected row at indexpath 
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.alarmsTableView];
    NSIndexPath *hitIndex = [self.alarmsTableView indexPathForRowAtPoint:hitPoint];
    NSLog(@"row: %ld", (long)hitIndex.row);
    
    // don't repeat
    // s.isOn
    // repeat
    // if off
    // don't repreat
}

@end
