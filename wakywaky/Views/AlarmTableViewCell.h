//
//  AlarmTableViewCell.h
//  wakywaky
//
//  Created by Yas Abdolmaleki on 2018-02-23.
//  Copyright © 2018 Yas Marcu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlarmTableViewCellDelegate <NSObject>
- (void)valueChanged:(BOOL)switchIsON;
@end

@interface AlarmTableViewCell : UITableViewCell
@property (nonatomic, weak) id <AlarmTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISwitch *alertSwitch;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
