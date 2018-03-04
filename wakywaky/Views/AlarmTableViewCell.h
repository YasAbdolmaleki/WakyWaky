//
//  AlarmTableViewCell.h
//  wakywaky
//
//  Created by Yas Abdolmaleki on 2018-02-23.
//  Copyright © 2018 Yas Marcu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *alertSwitch;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
