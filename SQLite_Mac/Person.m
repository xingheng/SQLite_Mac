//
//  Person.m
//  SQLite_Mac
//
//  Created by Wei Han on 8/15/13.
//  Copyright (c) 2013 Will Han. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)initWithID:(NSInteger)aID
{
    _Id = aID;
    _name = @"";
    _age = 0;
    return self;
}

- (id)initWithName:(NSString*)aName
           withAge:(NSInteger)aAge
       forPersonID:(NSInteger)aID
{
    _Id = aAge;
    _name = [aName retain];
    _age = aID;
    return self;
}

- (void)ToStringForDebug
{
#if DEBUG
    NSLog(@"%ld", (long)_Id);
    NSLog(@"%@", _name);
    NSLog(@"%ld", (long)_age);
#endif
}

- (void)dealloc
{
    [_name release];
    [super dealloc];
}

@end
