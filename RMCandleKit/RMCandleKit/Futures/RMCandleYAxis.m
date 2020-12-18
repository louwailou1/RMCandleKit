//
//  RMCandleYAxis.m
//  A50
//
//  Created by lsb on 16/4/13.
//  Copyright © 2016年 lsb. All rights reserved.
//

#import "RMCandleYAxis.h"

@implementation RMCandleYAxis


- (double)calculateYCoordinate:(double)value {
    return self.YOffset - (value-_datumValue)/_scale*_scaleValue;
    
}

@end
