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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)valueChanged:(id)sender {
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(playSound)
                                   userInfo:nil
                                    repeats:NO];
}
 
#pragma alarm sound

-(void)playSound {
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.mp3", [[NSBundle mainBundle] resourcePath], @"minions"]];
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

@end
