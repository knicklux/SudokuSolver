//
//  SSudoku.h
//  Sdoku_Solver_2
//
//  Created by Nicolas Kessler on 19.04.15.
//  Copyright (c) 2015 nicolaskessler. All rights reserved.
//

/*
 This class represents a model for a japanese sudoku that can solve itself.
 0 values in the buffer represent unkown values.
 */

#import <Foundation/Foundation.h>

typedef struct bufferLIst
{
    struct bufferLIst *next;
    unsigned int *buffer;
} bufferList;

// simplify access to the buffer
void setBuffer(unsigned int *buffer, unsigned int x, unsigned int y, unsigned int size, unsigned int value);
unsigned int getBuffer(unsigned int *buffer, unsigned int x, unsigned int y, unsigned int size);

@interface SSudoku : NSObject

@property (assign) unsigned int size;
@property (assign, readonly) unsigned int *buffer;

- (SSudoku *) initWithSize: (unsigned int) size;

// solve self.sudoku
-(bufferList *) solve;

// free bufferList
-(void) freeBufferList:(bufferList *) list;

@end
