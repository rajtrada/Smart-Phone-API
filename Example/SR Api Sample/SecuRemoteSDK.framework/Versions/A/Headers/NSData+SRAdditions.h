//
//  NSData+Additions.h
//
//  Copyright (c) 2015 SciTER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SRAdditions)

- (NSData *)shuffleData;
- (Byte)byteAtIndex:(NSUInteger)i;
- (NSString *)string;
- (NSString *)hexadecimalString;

@end
