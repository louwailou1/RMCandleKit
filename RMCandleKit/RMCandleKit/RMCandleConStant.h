//
//  RMCandleConStant.h
//  RMCandleKit
//
//  Created byRMCandleKit on 2019/1/8.
//  Copyright © 2019年RMCandleKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMCandleConStant : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSString *accuracy;

@end
