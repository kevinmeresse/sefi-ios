//
//  TryCatch.m
//  sefi
//
//  Created by Kevin Meresse on 6/1/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

#import "TryCatch.h"

@implementation TryCatch

/**
 Provides try catch functionality for swift by wrapping around Objective-C
 */
+(void)try:(void (^)())try catch:(void (^)(NSException *))catch finally:(void (^)())finally{
    @try {
        try ? try() : nil;
    }
    
    @catch (NSException *exception) {
        catch ? catch(exception) : nil;
    }
    @finally {
        finally ? finally() : nil;
    }
}

+ (void)throwString:(NSString*)s
{
    @throw [NSException exceptionWithName:s reason:s userInfo:nil];
}

+ (void)throwException:(NSException*)e
{
    @throw e;
}

@end
