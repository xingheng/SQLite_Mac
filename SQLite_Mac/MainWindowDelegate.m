//
//  MainWindowDelegate.m
//  SQLite_Mac
//
//  Created by Will Han on 8/14/13.
//  Copyright (c) 2013 Will Han. All rights reserved.
//

#import "MainWindowDelegate.h"
#import "DBOperation.h"
#import "Person.h"

#define DBNAME  "person"

//------ Table columns' identifier ------
#define kId     @"kID"
#define kName   @"kName"
#define kAge    @"kAge"
//---------------------------------------

//------------- Utility Functions -------------
static NSString* NSStringFromCString(const char* cString)
{
    return [NSString stringWithCString:cString encoding:NSMacOSRomanStringEncoding];
}
static const char* CStringFromNSString(const NSString* nsString)
{
    return [nsString cStringUsingEncoding:NSMacOSRomanStringEncoding];
}
//---------------------------------------------


static NSMutableArray *pTableDS;    // The data source of tableView. We declare it here to make it accessible for callback callback_read.

@interface MainWindowDelegate()
{
    char* strDBPath;    // The path of data base.
}

@end

@implementation MainWindowDelegate

- (void)awakeFromNib
{
    pTableDS = [[NSMutableArray alloc] init];
    [self RefreshAll:nil];
    
    [_myTableView setDataSource:self];
    [_myTableView setDelegate:self];
}

- (void)dealloc
{
    if (pTableDS) [pTableDS release];
    if (strDBPath) free(strDBPath);
    [super dealloc];
}


- (IBAction)Insert:(id)sender {
    char *strRequestInsert = (char*)malloc(1024);
    strcpy(strRequestInsert, "INSERT OR ROLLBACK INTO person VALUES(");
    strcat(strRequestInsert, CStringFromNSString([_textFieldID stringValue]));
    strcat(strRequestInsert, ", \"");
    strcat(strRequestInsert, CStringFromNSString([_textFieldName stringValue]));
    strcat(strRequestInsert, "\", ");
    strcat(strRequestInsert, CStringFromNSString([_textFieldAge stringValue]));
    strcat(strRequestInsert, ")");
    
    int result = sqlite_request_write(strDBPath, strRequestInsert);
    if (result != 0)
    {
        NSLog(@"operation failed.");
        [self runModelAlertMsg:@"Insert a row" withInfo:@"Failed!"];
    }
    
    free(strRequestInsert);
}

- (IBAction)Update:(id)sender {
    char *strRequestUpdate = (char*)malloc(1024);
    strcpy(strRequestUpdate, "UPDATE OR ROLLBACK person SET name = \"");
    strcat(strRequestUpdate, CStringFromNSString([_textFieldName stringValue]));
    strcat(strRequestUpdate, "\", age = ");
    strcat(strRequestUpdate, CStringFromNSString([_textFieldAge stringValue]));
    strcat(strRequestUpdate, " WHERE id = ");
    strcat(strRequestUpdate, CStringFromNSString([_textFieldID stringValue]));
    
    int result = sqlite_request_write(strDBPath, strRequestUpdate);
    if (result != 0)
    {
        NSLog(@"operation failed.");
        [self runModelAlertMsg:@"Update a row" withInfo:@"Failed!"];
    }
    
    free(strRequestUpdate);
}

- (IBAction)DeleteRow:(id)sender {
    if ([_myTableView selectedRow] < 0)
    {
        [self runModelAlertMsg:@"Delete a row"
                      withInfo:@"Please select a row in table at first."];
        return;
    }
    char *strRequestDelete = (char*)malloc(1024);
    strcpy(strRequestDelete, "DELETE FROM person WHERE id = ");
    strcat(strRequestDelete, CStringFromNSString([_textFieldID stringValue]));
    
    int result = sqlite_request_write(strDBPath, strRequestDelete);
    if (result != 0)
    {
        NSLog(@"operation failed.");
        [self runModelAlertMsg:@"Delete a row" withInfo:@"Failed!"];
    }
    
    free(strRequestDelete);
}

- (IBAction)RefreshAll:(id)sender {
    // Before reload all the records, remove them from data source at first.
    [pTableDS removeAllObjects];
    
    NSString *dbpath = [[NSBundle mainBundle] pathForResource:@DBNAME ofType:@"db"];
    if (dbpath != nil)
    {
        if (strDBPath == NULL)
            strDBPath = (char *)malloc(([dbpath length] + 1) * sizeof(char));
        strcpy(strDBPath, [dbpath cStringUsingEncoding:NSMacOSRomanStringEncoding]);
        
        const char *strRequestRead = "SELECT * FROM person";
        
        int result = sqlite_request_read(strDBPath, strRequestRead, callback_read);
        if (result != 0)
        {
            NSLog(@"operation failed.");
            [self runModelAlertMsg:@"Refresh All" withInfo:@"Failed!"];
        }
    }
    [_myTableView reloadData];
}


- (void)runModelAlertMsg:(NSString*)aMsg
                withInfo:(NSString*)informativeText
{
    NSAlert *alert = [NSAlert alertWithMessageText:aMsg defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:informativeText, nil];
    [alert beginSheetModalForWindow:_mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

static int callback_read(void *NotUsed, int argc, char **argv, char **azColName)
{
    Person *p = NULL;
    for(int i = 0; i<argc; i++) {
        char *strKey = azColName[i];
        char *strValue = argv[i] ? argv[i] : "NULL";
        //printf("%s = %s\n", azColName[i], strValue);
        
        NSString *value = [NSString stringWithCString:strValue encoding:NSMacOSRomanStringEncoding];
        
        if (strcmp(strKey, "id") == 0) {
            p = [[Person alloc] initWithID:[value integerValue]];
        }
        else if (strcmp(strKey, "name") == 0) {
            if (p) p.name = value;
        }
        else if (strcmp(strKey, "age") == 0) {
            if (p) p.age = [value integerValue];
        }
        else
            printf("Additional column in this talbe?");
    }
    [p ToStringForDebug];
    [pTableDS addObject:p];
    
    printf("\n");
    return 0;
}

#pragma mark -
#pragma mark NSWindowDelegate
- (BOOL)windowShouldClose:(id)sender
{
    return NO;
}

#pragma mark -
#pragma mark NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [pTableDS count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    id retValue = NULL;
    Person *p = [pTableDS objectAtIndex:row];
    //[p ToStringForDebug];
    NSString *identifier = [tableColumn identifier];
    if ([identifier isEqualToString: kId]) {
        retValue = @([p Id]);
    }
    else if ([identifier isEqualToString: kName]) {
        retValue = [p name];
    }
    else if ([identifier isEqualToString: kAge]) {
        retValue = @([p age]);
    }
    return retValue;
}

#pragma mark -
#pragma mark NSTableViewDelegate

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    Person *p = [pTableDS objectAtIndex:row];
    if (p)
    {
        [_textFieldID setStringValue:[NSString stringWithFormat:@"%ld", (long)[p Id]]];
        [_textFieldName setStringValue:[p name]];
        [_textFieldAge setStringValue:[NSString stringWithFormat:@"%ld", (long)[p age]]];
    }
    return YES;
}
#pragma mark -

@end
