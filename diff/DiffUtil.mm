//
//  DiffUtil.m
//  diff
//
//  Created by LMsgSendNilSelf  on 2018/1/2.
//  Copyright © 2018年 LMsgSendNilSelf . All rights reserved.
//

#import "DiffUtil.h"
#import "DiffResult.h"
#import "RuleDelegate.h"
#import "DiffStructs.h"

#include "vector"

@implementation DiffUtil

+ (DiffResult *)diffWithDataSource:(id<RuleDelegate>)cb {
    return [self diffWithDataSource:cb detectMoves:YES];
    }
+ (DiffResult *)diffWithDataSource:(id<RuleDelegate>)cb detectMoves:(BOOL)detectMoves {
    NSInteger oldSize = cb.getOldListSize;
    NSInteger newSize = cb.getNewListSize;
    std::vector<Snake> snakes;
    std::vector<DiffRange> stack;
    DiffRange range = DiffRange();
    range.oldListEnd = oldSize;
    range.newListEnd = newSize;
    stack.push_back(range);
    NSInteger max = oldSize + newSize + abs(oldSize - newSize);
    NSInteger forward[max * 2];
    NSInteger backward[max * 2];
    std::vector<DiffRange> rangePool;
        while (!stack.empty()) {
            DiffRange range = stack.back();
            stack.pop_back();
            Snake snake = diffPartial(cb, range.oldListStart, range.oldListEnd,
                                            range.newListStart, range.newListEnd, forward, backward, max);
            if (!snake.invalid) {
                if (snake.size > 0) {
                    snakes.push_back(snake);
                }
                
                snake.x += range.oldListStart;
                snake.y += range.newListStart;
          
                DiffRange left;
                if (rangePool.empty()) {
                    left = DiffRange();
                }else {
                    left = rangePool.back();
                    rangePool.pop_back();
                }
                
                left.oldListStart = range.oldListStart;
                left.newListStart = range.newListStart;
                if (snake.reverse) {
                    left.oldListEnd = snake.x;
                    left.newListEnd = snake.y;
                } else {
                    if (snake.removal) {
                        left.oldListEnd = snake.x - 1;
                        left.newListEnd = snake.y;
                    } else {
                        left.oldListEnd = snake.x;
                        left.newListEnd = snake.y - 1;
                    }
                }
                stack.push_back(left);
  
                DiffRange right = range;
                if (snake.reverse) {
                    if (snake.removal) {
                        right.oldListStart = snake.x + snake.size + 1;
                        right.newListStart = snake.y + snake.size;
                    } else {
                        right.oldListStart = snake.x + snake.size;
                        right.newListStart = snake.y + snake.size + 1;
                    }
                } else {
                    right.oldListStart = snake.x + snake.size;
                    right.newListStart = snake.y + snake.size;
                }
                stack.push_back(right);
            } else {
                rangePool.push_back(range);
            }
        }
    
    std::sort(snakes.begin(), snakes.end(),compare);
    
    DiffResult *diffRes = [[DiffResult alloc] initWithDataSource:cb snakes:snakes oldItemStatuses:forward newItemStatuses:backward size:2*max detectMoves:detectMoves];
    return diffRes;
}

static NSInteger compare(Snake o1, Snake o2) {
    NSInteger cmpX = o1.x - o2.x;
    return cmpX == 0 ? o1.y - o2.y : cmpX;
}

static Snake diffPartial(id<RuleDelegate> cb, NSInteger startOld, NSInteger endOld,
                                     NSInteger startNew, NSInteger endNew, NSInteger forward[], NSInteger backward[], NSInteger kOffset) {
        NSInteger oldSize = endOld - startOld;
        NSInteger newSize = endNew - startNew;
        if (endOld - startOld < 1 || endNew - startNew < 1) {
            Snake sn = Snake();
            sn.invalid = YES;
            return sn;
        }
        NSInteger delta = oldSize - newSize;
        NSInteger dLimit = (oldSize + newSize + 1) / 2;
    for (NSInteger i = kOffset - dLimit - 1;i < kOffset + dLimit + 1;i++) {
        forward[i] = 0;
        backward[i+delta] = oldSize;
    }
    BOOL checkInFwd = delta % 2 != 0;
    for (NSInteger d = 0; d <= dLimit; d++) {
        for (NSInteger k = -d; k <= d; k += 2) {
            NSInteger x;
            BOOL removal;
            if (k == -d ||
                (k != d &&
                (forward[kOffset + k - 1] < forward[kOffset + k + 1]))) {
                x = forward[kOffset + k + 1];
                removal = NO;
            } else {
                x = forward[kOffset + k - 1] + 1;
                removal = YES;
            }

            NSInteger y = x - k;

            while (x < oldSize &&
                   y < newSize &&
                   [cb areItemsTheSameWithOldItemPosition:(startOld + x) newItemPosition:(startNew + y)]) {
                x++;
                y++;
            }
            forward[kOffset + k] = x;
            if (checkInFwd &&
                k >= delta - d + 1 &&
                k <= delta + d - 1) {
                if (forward[kOffset + k] >= backward[kOffset + k]) {
                    Snake outSnake;
                    outSnake.x = backward[kOffset + k];
                    outSnake.y = outSnake.x - k;
                    outSnake.size = forward[kOffset + k] - backward[kOffset + k];
                    outSnake.removal = removal;
                    outSnake.reverse = NO;
                    return outSnake;
                }
            }
        }
        for (NSInteger k = -d; k <= d; k += 2) {
            // find reverse path at k + delta, in reverse
            NSInteger backwardK = k + delta;
            NSInteger x;
            BOOL removal;
            if (backwardK == d + delta ||
                (backwardK != -d + delta
                && backward[kOffset + backwardK - 1] < backward[kOffset + backwardK + 1])) {
                x = backward[kOffset + backwardK - 1];
                removal = NO;
            } else {
                x = backward[kOffset + backwardK + 1] - 1;
                removal = YES;
            }
            NSInteger y = x - backwardK;

            while (x > 0 &&
                   y > 0 &&
                   [cb areItemsTheSameWithOldItemPosition:(startOld + x - 1) newItemPosition:(startNew + y - 1)]) {
                x--;
                y--;
            }
            backward[kOffset + backwardK] = x;
            if (!checkInFwd && k + delta >= -d && k + delta <= d) {
                if (forward[kOffset + backwardK] >= backward[kOffset + backwardK]) {
                    Snake outSnake;
                    outSnake.x = backward[kOffset + backwardK];
                    outSnake.y = outSnake.x - backwardK;
                    outSnake.size =
                    forward[kOffset + backwardK] - backward[kOffset + backwardK];
                    outSnake.removal = removal;
                    outSnake.reverse = YES;
                    return outSnake;
                }
            }
        }
    }
    NSException *e = [NSException exceptionWithName:@"an unexpected case" reason:@"  Please make sure DATA is not changed during  diffing" userInfo:nil];
    @throw e;
}

@end
