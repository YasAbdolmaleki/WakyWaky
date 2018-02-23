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
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(editAlarmView)];
    [editButton setTintColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    [self.navigationItem setLeftBarButtonItem:editButton];
}

- (void)addAlarmView {
    //asdfa
}

- (void)editAlarmView {
    //asdfa
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmTableViewCell"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
