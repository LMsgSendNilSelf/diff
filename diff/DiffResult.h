//
//  DiffResult.h
//  diff
//
//  Created by LMsgSendNilSelf  on 2018/1/2.
//  Copyright © 2018年 LMsgSendNilSelf . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RuleDelegate.h"
#include "vector"
#import "DiffStructs.h"

typedef NS_ENUM(NSInteger, DiffResultFlag)
{
    DiffFlagNotChanged  = 1,//1
    DiffFlagChanged = 1 << 1,//2
    DiffFlagMovedChanged = 1 << 2,//4
    DiffFlagMovedNotChanged = 1 << 3,//8
    DiffFlagIgnore = 1 << 4 //16
};

static const NSInteger DiffFlagOffset = 5;
static const NSInteger  DiffFlagMask = (1<<5) - 1;

@interface DiffResult : NSObject

- (instancetype)initWithDataSource:(id <RuleDelegate>)DataSource snakes:(std::vector<Snake>)snakes oldItemStatuses:(NSInteger *) oldItemStatuses newItemStatuses:(NSInteger *) newItemStatuses size:(NSInteger)size detectMoves:(BOOL)detectMoves;

@end
