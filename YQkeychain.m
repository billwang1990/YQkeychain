//
//  YQkeychain.m
//  Wine
//
//  Created by niko on 13-7-23.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "YQkeychain.h"

NSString *const KeyChainErrorDomain = @"com.billwang1990.keychain";

#if __IPHONE_4_0 && TARGET_OS_IPHONE
CFTypeRef KeychainAccessibilityType = NULL;
#endif

@implementation YQkeychain

+(NSData*)passwordDataForService:(NSString *)service account:(NSString *)account
{
    return [self passwordDataForService:service account:account error:nil];
}

+ (NSData *)passwordDataForService:(NSString *)service account:(NSString *)account error:(NSError **)error
{
    OSStatus status = KeychainErrorBadArguments;
    if (!service || !account) {
        if (error) {
            *error = [NSError errorWithDomain:KeyChainErrorDomain code:status userInfo:nil];
        }
        return nil;
        
    }
    CFTypeRef result = NULL;
    NSMutableDictionary *dic = [self queryForService:service account:account];
    [dic setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [dic setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    status = SecItemCopyMatching((__bridge CFDictionaryRef)(dic), &result);
    
    if(status != noErr && error != NULL)
    {
        *error = [NSError errorWithDomain:KeyChainErrorDomain code:status userInfo:nil];
        return nil;
        
    }
    return (__bridge_transfer NSData*)result;
}

+(NSMutableDictionary *)queryForService :(NSString *)service account:(NSString*)account
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    if(service)
    {
        [dictionary setObject:service forKey:(__bridge id)kSecAttrService];
    }
    if(account)
    {
        [dictionary setObject:account forKey:(__bridge id)kSecAttrAccount];
    }
    return dictionary;
    
}


+ (BOOL)deletePasswordForService:(NSString *)service account:(NSString *)account {
	return [self deletePasswordForService:service account:account error:nil];
}

+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)service account:(NSString *)account {
    return [self setPasswordData:password forService:service account:account error:nil];
}


+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)service account:(NSString *)account error:(NSError **)error {
    OSStatus status = KeychainErrorBadArguments;
	if (password && service && account) {
        [self deletePasswordForService:service account:account];
        NSMutableDictionary *query = [self queryForService:service account:account];
#if __has_feature(objc_arc)
		[query setObject:password forKey:(__bridge id)kSecValueData];
#else
		[query setObject:password forKey:(id)kSecValueData];
#endif
		
#if __IPHONE_4_0 && TARGET_OS_IPHONE
		if (KeychainAccessibilityType) {
#if __has_feature(objc_arc)
			[query setObject:(id)[self accessibilityType] forKey:(__bridge id)kSecAttrAccessible];
#else
			[query setObject:(id)[self accessibilityType] forKey:(id)kSecAttrAccessible];
#endif
		}
#endif
		
#if __has_feature(objc_arc)
        status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
#else
		status = SecItemAdd((CFDictionaryRef)query, NULL);
#endif
	}
	if (status != noErr && error != NULL) {
		*error = [NSError errorWithDomain:KeyChainErrorDomain code:status userInfo:nil];
	}
	return (status == noErr);
}

#if __IPHONE_4_0 && TARGET_OS_IPHONE
+ (CFTypeRef)accessibilityType {
	return KeychainAccessibilityType;
}
+ (void)setAccessibilityType:(CFTypeRef)accessibilityType {
	CFRetain(accessibilityType);
	if (KeychainAccessibilityType) {
		CFRelease(KeychainAccessibilityType);
	}
	KeychainAccessibilityType = accessibilityType;
}
#endif

+ (BOOL)deletePasswordForService:(NSString *)service account:(NSString *)account error:(NSError **)error {
	OSStatus status = KeychainErrorBadArguments;
	if (service && account) {
		NSMutableDictionary *query = [self queryForService:service account:account];
#if __has_feature(objc_arc)
		status = SecItemDelete((__bridge CFDictionaryRef)query);
#else
		status = SecItemDelete((CFDictionaryRef)query);
#endif
	}
	if (status != noErr && error != NULL) {
		*error = [NSError errorWithDomain:KeyChainErrorDomain code:status userInfo:nil];
	}
	return (status == noErr);
    
}


    
@end
