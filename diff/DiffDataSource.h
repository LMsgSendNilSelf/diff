//
//  DiffDataSource.h
//  diff
//
//  Created by LMsgSendNilSelf  on 2018/1/8.
//  Copyright © 2018年 LMsgSendNilSelf . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RuleDelegate.h"

@interface DiffDataSource : NSObject <RuleDelegate>

- (instancetype)initWithOldDatas:(NSArray *)old newDatas:(NSArray *)new;

@end
