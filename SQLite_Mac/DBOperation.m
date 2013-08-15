//
//  DBOperation.m
//  SQLite_Mac
//
//  Created by Will Han on 8/14/13.
//  Copyright (c) 2013 Will Han. All rights reserved.
//

#import "DBOperation.h"

//static int callback(void *NotUsed, int argc, char **argv, char **azColName)
//{
//    int i;
//    for(i = 0; i<argc; i++) {
//        printf("%s = %s\n", azColName[i], argv[i] ? argv[i] : "NULL");
//    }
//    printf("\n");
//    return 0;
//}

int sqlite_request(const char * dbName,
                   const char * strRequest,
                   callback pFunc)
{
    sqlite3 *db;
    char *zErrMsg = 0;
    int rc;
    
    rc = sqlite3_open(dbName, &db);
    if( rc ) {
        fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        return(1);
    }
    
    rc = sqlite3_exec(db, strRequest, pFunc, 0, &zErrMsg);
    if( rc != SQLITE_OK ) {
        fprintf(stderr, "SQL error: %s\n", zErrMsg);
        sqlite3_free(zErrMsg);
    }
    sqlite3_close(db);
    return rc;
}

int sqlite_request_read(const char * dbName,
                        const char * strRequest,
                        callback pFunc)
{
    return sqlite_request(dbName, strRequest, pFunc);
}

int sqlite_request_write(const char * dbName,
                         const char * strRequest)
{
    return sqlite_request(dbName, strRequest, NULL);
}

