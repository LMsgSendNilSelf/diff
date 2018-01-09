//
//  DiffStructs.h
//  diff
//
//  Created by LMsgSendNilSelf  on 2018/1/8.
//  Copyright © 2018年 LMsgSendNilSelf . All rights reserved.
//

#ifndef DiffStructs_h
#define DiffStructs_h

struct DiffRange {
    NSInteger oldListStart, oldListEnd, newListStart, newListEnd;
    DiffRange() {
        oldListStart = oldListEnd = newListStart = newListEnd = 0;
    }
};

struct Snake {
    NSInteger x,y,size;
    BOOL removal,reverse,invalid;
    Snake() {
        x = y = size = 0;
        removal = reverse = invalid = NO;
    }
};

#endif /* DiffStructs_h */
