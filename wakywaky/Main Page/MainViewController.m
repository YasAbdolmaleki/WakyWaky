//
//  ViewController.m
//  wakywaky
//
//  Created by Yas Abdolmaleki on 2018-02-05.
//  Copyright © 2018 Yas Marcu. All rights reserved.
//

#import "MainViewController.h"
#import "AlertCollectionViewCell.h"
#import "AlarmTableViewCell.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *alarmsTableView;
@property (strong, nonatomic) NSMutableArray *testArray;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.testArray = [NSMutableArray arrayWithObjects:@"09:00AM", @"12:25AM", @"04:14AM", @"02:12AM", @"01:08AM", nil];
    [self setupNavigationBar];
    
    [self.alarmsTableView registerNib:[UINib nibWithNibName:@"AlarmTableViewCell" bundle:nil] forCellReuseIdentifier:@"AlarmTableViewCell"];
    
    self.alarmsTableView.tableFooterView = [UIView new];
    [self.alarmsTableView reloadData];
}

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
    //asdfa
}

- (void)editAlarmView {
    //asdfa
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

@end
