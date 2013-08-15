//
//  Person.h
//  SQLite_Mac
//
//  Created by Wei Han on 8/15/13.
//  Copyright (c) 2013 Will Han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (readonly, assign) NSInteger Id;
@property (readwrite, retain) NSString* name;
@property (readwrite, assign) NSInteger age;

- (id)initWithID:(NSInteger)aID;

- (id)initWithName:(NSString*)aName
           withAge:(NSInteger)aAge
       forPersonID:(NSInteger)aID;

- (void)ToStringForDebug;

- (void)dealloc;

@end
