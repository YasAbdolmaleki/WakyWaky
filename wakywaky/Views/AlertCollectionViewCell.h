//
//  AlertCollectionViewCell.h
//  wakywaky
//
//  Created by Yas Abdolmaleki on 2018-02-19.
//  Copyright © 2018 Yas Marcu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *alarmLabel;
@property (weak, nonatomic) IBOutlet UISwitch *onOffSwitch;
@end
