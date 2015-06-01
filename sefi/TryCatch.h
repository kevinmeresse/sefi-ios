//
//  TryCatch.h
//  sefi
//
//  Created by Kevin Meresse on 6/1/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TryCatch : NSObject

/**
 Provides try catch functionality for swift by wrapping around Objective-C
 */
+ (void)try:(void(^)())try catch:(void(^)(NSException*exception))catch finally:(void(^)())finally;
+ (void)throwString:(NSString*)s;
+ (void)throwException:(NSException*)e;

@end
