//
//  SViewController.h
//  Sdoku_Solver_2
//
//  Created by Nicolas Kessler on 19.04.15.
//  Copyright (c) 2015 nicolaskessler. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

#import "SSudoku.h"

@interface SViewController : NSObject

@property (weak) IBOutlet NSTextField *textField00;
@property (weak) IBOutlet NSTextField *textField01;
@property (weak) IBOutlet NSTextField *textField02;
@property (weak) IBOutlet NSTextField *textField03;
@property (weak) IBOutlet NSTextField *textField04;
@property (weak) IBOutlet NSTextField *textField05;
@property (weak) IBOutlet NSTextField *textField06;
@property (weak) IBOutlet NSTextField *textField07;
@property (weak) IBOutlet NSTextField *textField08;
@property (weak) IBOutlet NSTextField *textField10;
@property (weak) IBOutlet NSTextField *textField11;
@property (weak) IBOutlet NSTextField *textField12;
@property (weak) IBOutlet NSTextField *textField13;
@property (weak) IBOutlet NSTextField *textField14;
@property (weak) IBOutlet NSTextField *textField15;
@property (weak) IBOutlet NSTextField *textField16;
@property (weak) IBOutlet NSTextField *textField17;
@property (weak) IBOutlet NSTextField *textField18;
@property (weak) IBOutlet NSTextField *textField20;
@property (weak) IBOutlet NSTextField *textField21;
@property (weak) IBOutlet NSTextField *textField22;
@property (weak) IBOutlet NSTextField *textField23;
@property (weak) IBOutlet NSTextField *textField24;
@property (weak) IBOutlet NSTextField *textField25;
@property (weak) IBOutlet NSTextField *textField26;
@property (weak) IBOutlet NSTextField *textField27;
@property (weak) IBOutlet NSTextField *textField28;
@property (weak) IBOutlet NSTextField *textField30;
@property (weak) IBOutlet NSTextField *textField31;
@property (weak) IBOutlet NSTextField *textField32;
@property (weak) IBOutlet NSTextField *textField33;
@property (weak) IBOutlet NSTextField *textField34;
@property (weak) IBOutlet NSTextField *textField35;
@property (weak) IBOutlet NSTextField *textField36;
@property (weak) IBOutlet NSTextField *textField37;
@property (weak) IBOutlet NSTextField *textField38;
@property (weak) IBOutlet NSTextField *textField40;
@property (weak) IBOutlet NSTextField *textField41;
@property (weak) IBOutlet NSTextField *textField42;
@property (weak) IBOutlet NSTextField *textField43;
@property (weak) IBOutlet NSTextField *textField44;
@property (weak) IBOutlet NSTextField *textField45;
@property (weak) IBOutlet NSTextField *textField46;
@property (weak) IBOutlet NSTextField *textField47;
@property (weak) IBOutlet NSTextField *textField48;
@property (weak) IBOutlet NSTextField *textField50;
@property (weak) IBOutlet NSTextField *textField51;
@property (weak) IBOutlet NSTextField *textField52;
@property (weak) IBOutlet NSTextField *textField53;
@property (weak) IBOutlet NSTextField *textField54;
@property (weak) IBOutlet NSTextField *textField55;
@property (weak) IBOutlet NSTextField *textField56;
@property (weak) IBOutlet NSTextField *textField57;
@property (weak) IBOutlet NSTextField *textField58;
@property (weak) IBOutlet NSTextField *textField60;
@property (weak) IBOutlet NSTextField *textField61;
@property (weak) IBOutlet NSTextField *textField62;
@property (weak) IBOutlet NSTextField *textField63;
@property (weak) IBOutlet NSTextField *textField64;
@property (weak) IBOutlet NSTextField *textField65;
@property (weak) IBOutlet NSTextField *textField66;
@property (weak) IBOutlet NSTextField *textField67;
@property (weak) IBOutlet NSTextField *textField68;
@property (weak) IBOutlet NSTextField *textField70;
@property (weak) IBOutlet NSTextField *textField71;
@property (weak) IBOutlet NSTextField *textField72;
@property (weak) IBOutlet NSTextField *textField73;
@property (weak) IBOutlet NSTextField *textField74;
@property (weak) IBOutlet NSTextField *textField75;
@property (weak) IBOutlet NSTextField *textField76;
@property (weak) IBOutlet NSTextField *textField77;
@property (weak) IBOutlet NSTextField *textField78;
@property (weak) IBOutlet NSTextField *textField80;
@property (weak) IBOutlet NSTextField *textField81;
@property (weak) IBOutlet NSTextField *textField82;
@property (weak) IBOutlet NSTextField *textField83;
@property (weak) IBOutlet NSTextField *textField84;
@property (weak) IBOutlet NSTextField *textField85;
@property (weak) IBOutlet NSTextField *textField86;
@property (weak) IBOutlet NSTextField *textField87;
@property (weak) IBOutlet NSTextField *textField88;

@property (weak) IBOutlet NSButton *solveButtom;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSButton *nextButton;

@property (strong) SSudoku *sudoku;
@property (assign) bufferList *solvedSudokus;
@property (assign) bufferList *currentSudokuList;

- (IBAction)solveButtomClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;

-(NSTextField *)textFieldAtX: (unsigned int) x Y: (unsigned int) y;

@end
