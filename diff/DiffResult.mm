//
//  DiffResult.m
//  diff
//
//  Created by LMsgSendNilSelf  on 2018/1/2.
//  Copyright © 2018年 LMsgSendNilSelf . All rights reserved.
//

#import "DiffResult.h"
#import "DiffStructs.h"
#import "RuleDelegate.h"

@interface DiffResult () {
    std::vector<Snake> _mSnakes;
    NSInteger *_mOldItemStatuses;
    NSInteger *_mNewItemStatuses;
    id <RuleDelegate>_mDataSource;
    NSInteger _mOldListSize;
    NSInteger _mNewListSize;
    BOOL _mDetectMoves;
}
@end

@implementation DiffResult

- (instancetype)initWithDataSource:(id <RuleDelegate>)DataSource snakes:(std::vector<Snake>)snakes oldItemStatuses:(NSInteger *)oldItemStatuses newItemStatuses:(NSInteger *)newItemStatuses size:(NSInteger)size detectMoves:(BOOL)detectMoves {
    if (self = [super init]) {
        _mSnakes = snakes;
        _mOldItemStatuses = oldItemStatuses;
        _mNewItemStatuses = newItemStatuses;
        
        for (NSInteger i = 0; i < size; i++) {
            _mOldItemStatuses[i] = 0;
            _mNewItemStatuses[i] = 0;
        }
        
        _mDataSource = DataSource;
        _mOldListSize = DataSource.getOldListSize;
        _mNewListSize = DataSource.getNewListSize;
        _mDetectMoves = detectMoves;
        [self addRootSnake];
        [self findMatchingItem];
    }
    return self;
}

- (void)addRootSnake {
    if (_mSnakes.empty()) {
        _mSnakes.insert(_mSnakes.begin(), Snake());
    } else {
        Snake first = _mSnakes[0];
        if (first.x != 0 || first.y != 0) {
           _mSnakes.insert(_mSnakes.begin(), Snake());
        }
    }
}

- (void)findMatchingItem {
    NSInteger posOld = _mOldListSize;
    NSInteger posNew = _mNewListSize;
    
    for (NSInteger i = _mSnakes.size() - 1; i >= 0; i--) {
        Snake snake = _mSnakes[i];
        NSInteger endX = snake.x + snake.size;
        NSInteger endY = snake.y + snake.size;
        if (_mDetectMoves) {
            while (posOld > endX) {
                [self findAdditionX:posOld y:posNew snakeIndex:i];
                posOld--;
            }
            while (posNew > endY) {
                [self findRemovalX:posOld y:posNew snakeIndex:i];
                posNew--;
            }
        }
        for (NSInteger j = 0; j < snake.size; j++) {
            NSInteger oldItemPos = snake.x + j;
            NSInteger newItemPos = snake.y + j;
            BOOL theSame = [_mDataSource areContentsTheSameWithOldItemPosition:oldItemPos newItemPosition:newItemPos];
            NSLog(@"oldPos,newPos:{%ld,%ld}",(long)oldItemPos,(long)newItemPos);
            NSInteger changeFlag = theSame ? DiffFlagNotChanged : DiffFlagChanged;
            _mOldItemStatuses[oldItemPos] = (newItemPos << DiffFlagOffset) | changeFlag;
            _mNewItemStatuses[newItemPos] = (oldItemPos << DiffFlagOffset) | changeFlag;
        }
        posOld = snake.x;
        posNew = snake.y;
    }
}

- (void)findAdditionX:(NSInteger)x y:(NSInteger)y snakeIndex:(NSInteger)snakeIndex {
    if (_mOldItemStatuses[x - 1] != 0) {
        return;
    }
    [self findMatchingItemX:x y:y snakeIndex:snakeIndex removal:NO];
}
- (void)findRemovalX:(NSInteger)x y:(NSInteger)y snakeIndex:(NSInteger)snakeIndex {
    if (_mNewItemStatuses[y - 1] != 0) {
        return; 
    }
    [self findMatchingItemX:x y:y snakeIndex:snakeIndex removal:YES];
}

- (BOOL)findMatchingItemX:(NSInteger)x y:(NSInteger)y snakeIndex:(NSInteger)snakeIndex removal:(BOOL)removal {
    NSInteger myItemPos;
    NSInteger curX;
    NSInteger curY;
    if (removal) {
        myItemPos = y - 1;
        curX = x;
        curY = y - 1;
    } else {
        myItemPos = x - 1;
        curX = x - 1;
        curY = y;
    }
    for (NSInteger i = snakeIndex; i >= 0; i--) {
        Snake snake = _mSnakes[i];
        NSInteger endX = snake.x + snake.size;
        NSInteger endY = snake.y + snake.size;
        if (removal) {
            
            for (NSInteger pos = curX - 1; pos >= endX; pos--) {
                if ([_mDataSource areItemsTheSameWithOldItemPosition:pos newItemPosition:myItemPos]) {
                    BOOL theSame = [_mDataSource areContentsTheSameWithOldItemPosition:pos newItemPosition:myItemPos];
                    if (theSame) {
                        NSLog(@"oldPos,newPos:{%ld,%ld}",(long)pos,(long)myItemPos);
                    }
                    NSInteger changeFlag = theSame ? DiffFlagMovedNotChanged
                    : DiffFlagMovedChanged;
                    _mNewItemStatuses[myItemPos] = (pos << DiffFlagOffset) | DiffFlagIgnore;
                    _mOldItemStatuses[pos] = (myItemPos << DiffFlagOffset) | changeFlag;
                    return YES;
                }
            }
        } else {
           
            for (NSInteger pos = curY - 1; pos >= endY; pos--) {
                if ([_mDataSource areContentsTheSameWithOldItemPosition:myItemPos newItemPosition:pos]) {
                    BOOL theSame = [_mDataSource areContentsTheSameWithOldItemPosition:myItemPos newItemPosition:pos];
                    if (theSame) {
                        NSLog(@"oldPos,newPos:{%ld,%ld}",(long)myItemPos,(long)pos);
                    }
                    NSInteger changeFlag = theSame ? DiffFlagMovedNotChanged
                    : DiffFlagMovedChanged;
                    _mOldItemStatuses[x - 1] = (pos << DiffFlagOffset) | DiffFlagIgnore;
                    _mNewItemStatuses[pos] = ((x - 1) << DiffFlagOffset) | changeFlag;
                    return YES;
                }
            }
        }
        curX = snake.x;
        curY = snake.y;
    }
    return NO;
}

@end
