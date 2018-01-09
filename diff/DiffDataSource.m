//
//  DiffDataSource.m
//  diff
//
//  Created by LMsgSendNilSelf  on 2018/1/8.
//  Copyright © 2018年 LMsgSendNilSelf . All rights reserved.
//

#import "DiffDataSource.h"

@interface DiffDataSource () {
    NSArray *_mOldDatas;
    NSArray *_mNewDatas;
}

@end

@implementation DiffDataSource

- (instancetype)initWithOldDatas:(NSArray *)old newDatas:(NSArray *)new {
    if (self = [super init]) {
        _mOldDatas = old;
        _mNewDatas = new;
    }
    return self;
}

#pragma mark- RuleDelegate
- (NSInteger)getOldListSize {
    return _mOldDatas.count;
}
- (NSInteger)getNewListSize {
    return _mNewDatas.count;
}

- (BOOL)areItemsTheSameWithOldItemPosition:(NSInteger)oldItemPosition newItemPosition:(NSInteger)newItemPosition {
    id old = [_mOldDatas objectAtIndex:oldItemPosition];
    id new =[_mNewDatas objectAtIndex:newItemPosition];
    return [old isEqual:new];
}

- (BOOL)areContentsTheSameWithOldItemPosition:(NSInteger)oldItemPosition newItemPosition:(NSInteger)newItemPosition {
    id old = [_mOldDatas objectAtIndex:oldItemPosition];
    id new =[_mNewDatas objectAtIndex:newItemPosition];
    NSString *oldDes = [old description];
    NSString *newDes = [new description];
    if (![oldDes isEqualToString:newDes]) {
        return NO;
    }

    return YES;
}

@end

