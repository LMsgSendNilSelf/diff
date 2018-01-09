//
//  DataSource.h
//  diff
//
//  Created by LMsgSendNilSelf  on 2018/1/8.
//  Copyright © 2018年 LMsgSendNilSelf . All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RuleDelegate <NSObject>

- (NSInteger)getOldListSize;
- (NSInteger)getNewListSize;
- (BOOL)areItemsTheSameWithOldItemPosition:(NSInteger)oldItemPosition newItemPosition:(NSInteger)newItemPosition;
- (BOOL)areContentsTheSameWithOldItemPosition:(NSInteger)oldItemPosition newItemPosition:(NSInteger)newItemPosition;

@end

