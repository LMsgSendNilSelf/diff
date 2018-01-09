//
//  DiffUtil.h
//  diff
//
//  Created by LMsgSendNilSelf  on 2018/1/2.
//  Copyright © 2018年 LMsgSendNilSelf . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RuleDelegate.h"

@class DiffResult;

@interface DiffUtil : NSObject

+ (DiffResult *)diffWithDataSource:(id<RuleDelegate>)cb;

@end
