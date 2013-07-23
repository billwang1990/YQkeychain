//
//  YQkeychain.h
//  Wine
//
//  Created by niko on 13-7-23.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>


@interface YQkeychain : NSObject


/** Error codes that can be returned in NSError objects. */
typedef enum {
	/** No error. */
	KeychainErrorNone = noErr,
	
	/** Some of the arguments were invalid. */
	KeychainErrorBadArguments = -1001,
	
	/** There was no password. */
	KeychainErrorNoPassword = -1002,
	
	/** One or more parameters passed internally were not valid. */
	KeychainErrorInvalidParameter = errSecParam,
	
	/** Failed to allocate memory. */
	KeychainErrorFailedToAllocated = errSecAllocate,
	
	/** No trust results are available. */
	KeychainErrorNotAvailable = errSecNotAvailable,
	
	/** Authorization/Authentication failed. */
	KeychainErrorAuthorizationFailed = errSecAuthFailed,
	
	/** The item already exists. */
	KeychainErrorDuplicatedItem = errSecDuplicateItem,
	
	/** The item cannot be found.*/
	KeychainErrorNotFound = errSecItemNotFound,
	
	/** Interaction with the Security Server is not allowed. */
	KeychainErrorInteractionNotAllowed = errSecInteractionNotAllowed,
	
	/** Unable to decode the provided data. */
	KeychainErrorFailedToDecode = errSecDecode
} KeychainErrorCode;


+ (NSData *)passwordDataForService:(NSString *)service account:(NSString *)account;

+ (BOOL)deletePasswordForService:(NSString *)service account:(NSString *)account;
+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)service account:(NSString *)account;

@end
