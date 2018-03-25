//
//  AlarmTableViewCell.m
//  wakywaky
//
//  Created by Yas Abdolmaleki on 2018-02-23.
//  Copyright © 2018 Yas Marcu. All rights reserved.
//

#import "AlarmTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface AlarmTableViewCell () <AVAudioPlayerDelegate>
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@end

@implementation AlarmTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)valueChanged:(id)sender {
    if (self.delegate) {
        [self.delegate valueChanged:sender];
    }
}

@end
