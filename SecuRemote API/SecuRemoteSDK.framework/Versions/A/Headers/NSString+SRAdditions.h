//
//  NSString+Additions.h
//
//  Copyright (c) 2015 sciter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SRAdditions)

- (NSData *)dataUsingStringAsHex;
- (NSData *)dataUsingHexStringAsHex;
@end
