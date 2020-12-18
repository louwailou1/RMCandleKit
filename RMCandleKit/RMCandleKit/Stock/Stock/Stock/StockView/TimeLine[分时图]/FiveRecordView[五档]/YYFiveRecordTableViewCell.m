//
//  YYFiveRecordTableViewCell.m
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/11.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import "YYFiveRecordTableViewCell.h"

@implementation YYFiveRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.label1.adjustsFontSizeToFitWidth = YES;
    self.label2.adjustsFontSizeToFitWidth = YES;
    self.label3.adjustsFontSizeToFitWidth = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
