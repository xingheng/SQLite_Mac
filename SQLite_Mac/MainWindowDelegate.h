//
//  MainWindowDelegate.h
//  SQLite_Mac
//
//  Created by Will Han on 8/14/13.
//  Copyright (c) 2013 Will Han. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MyTableView.h"

@interface MainWindowDelegate : NSObject <NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (assign) IBOutlet NSTableView *myTableView;
@property (assign) IBOutlet NSTextField *textFieldID;
@property (assign) IBOutlet NSTextField *textFieldName;
@property (assign) IBOutlet NSTextField *textFieldAge;

@property (assign) IBOutlet NSWindow *mainWindow;

- (IBAction)Insert:(id)sender;
- (IBAction)Update:(id)sender;
- (IBAction)DeleteRow:(id)sender;
- (IBAction)RefreshAll:(id)sender;

@end
