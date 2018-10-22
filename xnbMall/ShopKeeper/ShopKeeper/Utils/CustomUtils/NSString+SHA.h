//
//  NSString+SHA.h
//  ShopKeeper
//
//  Created by zzheron on 16/6/22.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSString (SHA)
-(NSString *) sha1;
-(NSString *) sha224;
-(NSString *) sha256;
-(NSString *) sha384;
-(NSString *) sha512;
-(NSString *) md5HexDigest;

@end
