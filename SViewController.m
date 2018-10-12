//
//  SViewController.m
//  Sdoku_Solver_2
//
//  Created by Nicolas Kessler on 19.04.15.
//  Copyright (c) 2015 nicolaskessler. All rights reserved.
//

#import "SViewController.h"

#define example 1

@implementation SViewController

-(SViewController *) init
{
    if (self = [super init])
    {
        _sudoku = [[SSudoku alloc] initWithSize:9];
        _solvedSudokus = NULL;
    }
    return self;
}

-(void)awakeFromNib
{
    // setup debug sudoku
    unsigned int *buffer = [_sudoku buffer];
    
    // cumbersome endless typing to hard-code an example sudoku (sigh)
    // see http://www.google.de/imgres?imgurl=http://static.guim.co.uk/sys-images/Guardian/Pix/pictures/2013/12/3/1386087536265/Sudoku2680hard.gif&imgrefurl=http://www.theguardian.com/lifeandstyle/2013/dec/12/sudoku-2680-hard&h=460&w=460&tbnid=GVQGPktAVN4B9M:&zoom=1&tbnh=98&tbnw=98&usg=__5nOE9zTT8SaLoNuImy_-oZywooY=&docid=G_XjfG77wS5WXM

#if example
    setBuffer(buffer, 0, 4, 9, 3);
    setBuffer(buffer, 0, 5, 9, 7);
    setBuffer(buffer, 0, 6, 9, 6);
    setBuffer(buffer, 1, 3, 9, 6);
    setBuffer(buffer, 1, 7, 9, 9);
    setBuffer(buffer, 2, 2, 9, 8);
    setBuffer(buffer, 2, 8, 9, 4);
    setBuffer(buffer, 3, 1, 9, 8);
    setBuffer(buffer, 3, 8, 9, 1);
    setBuffer(buffer, 4, 0, 9, 6);
    setBuffer(buffer, 4, 8, 9, 9);
    setBuffer(buffer, 5, 0, 9, 3);
    setBuffer(buffer, 5, 7, 9, 4);
    setBuffer(buffer, 6, 0, 9, 7);
    setBuffer(buffer, 6, 6, 9, 8);
    setBuffer(buffer, 7, 1, 9, 1);
    setBuffer(buffer, 7, 5, 9, 9);
    setBuffer(buffer, 8, 2, 9, 2);
    setBuffer(buffer, 8, 3, 9, 5);
    setBuffer(buffer, 8, 4, 9, 4);
#endif
    
    // update UI
    [self updateUI];
    
    // hide progressbar
    _progressIndicator.hidden = true;
    
    // set solvedSudokus to NULL
    _solvedSudokus = NULL;
}

- (IBAction)solveButtomClicked:(id)sender
{
    unsigned int *buffer;
    unsigned int c = 0;
    bufferList *allocatedList = NULL;
    
    // free the bufferList
    [_sudoku freeBufferList:_solvedSudokus];
    _solvedSudokus = NULL;
    
    // start progress indicator
    _progressIndicator.hidden = false;
    [_progressIndicator startAnimation:self];
    _nextButton.enabled = NO;
    
    // copy content of UI to model
    [self updateSudoku];
    
    // tell sudoku to solve itself
    _solvedSudokus = allocatedList = _currentSudokuList = [_sudoku solve];
    
    //if we have a solution
    if (_solvedSudokus)
    {
        buffer = _solvedSudokus->buffer;
        
        // copy content of model to UI
        [self updateUIfromBuffer:buffer];
        
        // count, how many solutions are found
        do{
            ++c; // almost c++ ;)
        }
        while ((_solvedSudokus = _solvedSudokus->next));
        _solvedSudokus = allocatedList;
    }
    
    if (c)
    {
        _nextButton.enabled = YES;
    }
    
    NSLog(@"Found %u solution(s)! :)", c);
    
    // stop progressindicator
    [_progressIndicator stopAnimation:self];
    _progressIndicator.hidden = true;
}

- (IBAction)nextButtonClicked:(id)sender
{
    _currentSudokuList = _currentSudokuList->next ? _currentSudokuList->next : _solvedSudokus;
    [self updateUIfromBuffer:_currentSudokuList->buffer];
}

// copy the content of the UI to the sudoku
-(void) updateSudoku
{
    unsigned int val;
    NSTextField *textField;
    
    for (int x = 0; x < 9; ++x)
    {
        for (int y = 0; y < 9; ++y)
        {
            textField = [self textFieldAtX:x Y:y];
            val = textField.intValue;
            
            if (val)
            {
                setBuffer(_sudoku.buffer, x, y, 9, val);
            }
            else
            {
                setBuffer(_sudoku.buffer, x, y, 9, 0);
            }
        }
    }
}

-(void) updateUIfromBuffer: (unsigned int *) buffer
{
    unsigned int val;
    NSTextField *textField;
    
    for (int x = 0; x < 9; ++x)
    {
        for (int y = 0; y < 9; ++y)
        {
            
            val = getBuffer(buffer, x, y, 9);
            textField = [self textFieldAtX:x Y:y];
            
            if (val)
            {
                textField.stringValue = [NSString stringWithFormat:@"%u", val];
            }
            else
            {
                textField.stringValue = @"";
            }
        }
    }
}

// redraw sudoku array
-(void) updateUI
{
    [self updateUIfromBuffer:_sudoku.buffer];
}

-(NSTextField *)textFieldAtX: (unsigned int) x Y: (unsigned int) y
{
    // use KVC to get the corresponding textField
    // which prgramming language rocks? :P
    NSString* path = [NSString stringWithFormat:@"textField%i%i", y, x];
    return [self valueForKey:path];
}

@end
