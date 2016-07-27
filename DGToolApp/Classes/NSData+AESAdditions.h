//
//  NSData+AESAdditions.h
//  Pods
//
//  Created by Kyungwoo Park on 2016. 7. 27..
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (AESAdditions)

- (NSData*)AES256EncryptWithKey:(NSString*)key;
- (NSData*)AES256DecryptWithKey:(NSString*)key;
    
@end
