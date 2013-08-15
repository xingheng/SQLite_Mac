//
//  DBOperation.h
//  SQLite_Mac
//
//  Created by Will Han on 8/14/13.
//  Copyright (c) 2013 Will Han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

typedef int (*callback)(void*, int, char**, char**);

#ifdef __cplusplus__
extern "C"
{
#endif
int sqlite_request_read(const char * dbName,
                        const char * strRequest,
                        callback pFunc);

int sqlite_request_write(const char * dbName,
                         const char * strRequest);
#ifdef __cplusplus__
}
#endif
