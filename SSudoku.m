//
//  SSudoku.m
//  Sdoku_Solver_2
//
//  Created by Nicolas Kessler on 19.04.15.
//  Copyright (c) 2015 nicolaskessler. All rights reserved.
//

#import "SSudoku.h"

void printSudoku(unsigned int *buffer, unsigned int size);

BOOL getPossibleNumbers(unsigned int* buffer, unsigned int size, unsigned int x, unsigned int y, unsigned int* numArray);

void solveSudoku(unsigned int* buffer, unsigned int size, unsigned int** preallocatedRAM, unsigned int numOfUnknowns,  bufferList **list);

void setBuffer(unsigned int *buffer, unsigned int x, unsigned int y, unsigned int size, unsigned int value)
{
    buffer[y*size + x] = value;
}

unsigned int getBuffer(unsigned int *buffer, unsigned int x, unsigned int y, unsigned int size)
{
    return buffer[y*size + x];
}

void printSudoku(unsigned int *buffer, unsigned int size)
{
    for (int i = 0; i < size*size; ++i) {
        printf("%2i Sudoku: %u\n", i ,buffer[i]);
    }
}

BOOL getPossibleNumbers(unsigned int* buffer, unsigned int size, unsigned int x, unsigned int y, unsigned int* numArray)
{
    unsigned int boxBeginX = x-(x%3);
    unsigned int boxBeginY = y-(y%3);
    
    // by default, all numbers are possible. i know this is waisting time
    for (int i = 1; i < 10; ++i)
    {
        numArray[i] = true;
    }
    
    // check x-axis
    for (int i = 0; i < 9; ++i)
    {
        if (buffer[i+size*y])
        {
            numArray[buffer[i+size*y]] = false;
        }
    }
    
    // check y-axis
    for (int i = 0; i < 9; ++i)
    {
        if (buffer[x+i*size])
        {
            numArray[buffer[x+i*size]] = false;
        }
    }
    
    //check box
    for (int x = 0; x < 3; ++x)
    {
        for (int y = 0; y < 3; ++y)
        {
            if (buffer[ (boxBeginX+x) + (boxBeginY+y)*size ])
            {
                numArray[buffer[ (boxBeginX+x) + (boxBeginY+y)*size ]] = false;
            }
        }
    }
    
    // if one value in numArray is possible, return true
    for (int i = 1; i < size+1; ++i)
    {
        if (numArray[i])
        {
            return true;
        }
    }
    
    // else return false
    return false;
}

void solveSudoku(unsigned int* buffer, unsigned int size, unsigned int** preallocatedRAM, unsigned int numOfUnknowns, bufferList **list)
{
    // check, if there are any unkowns left. if not, write solution
    // to the buffer lsit and return succes
    // also fill the linked list with buffers
    // ownership of malloced bufffers is returned to caller
    
    unsigned int *newBuffer = NULL;
    bufferList *newListElement = NULL;
    bufferList *lastListElement = NULL;
    
    if (!numOfUnknowns)
    {
        //check, if the first element of the list exists
        if (!*list)
        {
            // if not, create it
            *list = malloc(sizeof(bufferList));
            newBuffer = malloc(size*size*sizeof(unsigned int));
            memcpy(newBuffer, buffer, size*size*sizeof(unsigned int));
            (*list)->buffer = newBuffer;
            (*list)->next = NULL;
        }
        else
        {
            // attach new solution to linked list
            
            newBuffer = malloc(size*size*sizeof(unsigned int));
            memcpy(newBuffer, buffer, size*size*sizeof(unsigned int));
            newListElement = malloc(sizeof(bufferList));
            lastListElement = *list;
            
            // find the last element of the list and add the new one
            while (lastListElement->next)
            {
                lastListElement = lastListElement->next;
            }
            
            newListElement->buffer = newBuffer;
            newListElement->next = NULL;
            lastListElement->next = newListElement;
        }
        return;
    }
    
    unsigned int unknownValIndex = 0;
    unsigned int unknownX = 0;
    unsigned int unknownY = 0;
    
    // indicate, if a number at index i is impossible
    unsigned int *possibleNumbers = calloc(10, sizeof(unsigned int));
    
    // make a copy of the sudoku
    memcpy(preallocatedRAM[numOfUnknowns-1], buffer, size*size*sizeof(unsigned int));
    
    // find the first unkonwn number's x and y coordinates
    
    for (int i = 0; i < size*size; ++i)
    {
        if (buffer[i] == 0)
        {
            unknownValIndex = i;
            break;
        }
    }
    unknownY = unknownValIndex/9;
    unknownX = unknownValIndex%9;
    
    if (getPossibleNumbers(buffer, size, unknownX, unknownY, possibleNumbers))
    {
        // try to solve the sudoku with each possible solution
        for (int i = 1; i < 10; ++i)
        {
            if (possibleNumbers[i])
            {
                // this number is possible
                setBuffer(preallocatedRAM[numOfUnknowns-1], unknownX, unknownY, size, i);
                
                solveSudoku(preallocatedRAM[numOfUnknowns-1], size, preallocatedRAM, numOfUnknowns-1, list);
            }
        }
    }
    else
    {
        // no solution found in this part of the trial tree
        free(possibleNumbers);
        return;
    }
    
    free(possibleNumbers);
    return;
}

@implementation SSudoku

-(SSudoku *)initWithSize:(unsigned int)size
{
    if (self = [super init])
    {
        
        // allocate array for sudoku numbers with error handling
        _buffer = calloc(size*size, sizeof(unsigned int));
        if (!_buffer)
        {
            exit(EXIT_FAILURE);
        }
        _size = size;
    }
    return self;
}

-(bufferList *) solve
{
    BOOL success; // could we solve the sudoku
    unsigned int firstUnknownValIndex = 0;
    unsigned int firstUnknownX = 0;
    unsigned int firstUnknownY = 0;
    
    // this var indicates the depth of the recursion
    unsigned int numberOfUnknownValues = 0;
    
    // array of pointers to the buffers used for solving
    unsigned int **buffers = NULL;
    
    // first pointer to the list of solutions
    bufferList *solvedSudokuList = NULL;
    
    // determine, how many values are missing
    
    for (int i = 0; i < _size*_size; ++i)
    {
        if (_buffer[i] == 0)
        {
            if (!firstUnknownValIndex)
            {
                firstUnknownValIndex = i;
            }
            ++numberOfUnknownValues;
        }
    }
    
    // if no value is missing, return
    if (!numberOfUnknownValues) {
        return NULL;
    }
    
    // prepare for solving
    
    // allocate RAM
    buffers = calloc((numberOfUnknownValues),sizeof(unsigned int*));
    if(!buffers)
        exit(EXIT_FAILURE);
    
    for (int i = 0; i < numberOfUnknownValues; ++i)
    {
        buffers[i] = calloc(_size*_size,sizeof(unsigned int));
        if(!buffers[i])
            exit(EXIT_FAILURE);
    }
    
    memcpy(buffers[numberOfUnknownValues-1], _buffer, _size*_size*sizeof(unsigned int));
    
    //measure time
    clock_t start = clock();
    
    // solve the sudoku
    solveSudoku(buffers[numberOfUnknownValues-1], _size, buffers, numberOfUnknownValues, &solvedSudokuList);
    
    // print needed time
    clock_t end = clock();
    printf("Time:\t%f\n", (double)(end-start)/(double)CLOCKS_PER_SEC);
    
    if (!solvedSudokuList)
    {
        NSLog(@"Could not solve the sudoku :(");
    }
    
    // clean up used RAM
    for (int i = 0; i < numberOfUnknownValues; ++i)
    {
        free(buffers[i]);
    }
    free(buffers);
    
    // caller needs to clean up the RAM reserved for the linked list
    return solvedSudokuList;
}

-(void) freeBufferList:(bufferList *) list
{
    // use while loop to free the list elements
    bufferList *tmp = list;
    
    while (list)
    {
        tmp = list;
        list = tmp -> next;
        free(tmp->buffer);
        free(tmp);
    }
    /*
    // old recursive code
    if (list)
    {
        free(list->buffer);
        [self freeBufferList:list->next];
        free(list);
    }
    else
    {
        return;
    }*/
}

-(void) dealloc
{
    free(_buffer);
}

@end
