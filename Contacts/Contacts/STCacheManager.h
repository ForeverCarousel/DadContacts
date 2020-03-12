//
//  STCacheManager.h
// SweetDream
//
//  Created by cxl on 2020/1/10.
//  Copyright © 2020 chenxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLContact.h"

NS_ASSUME_NONNULL_BEGIN

@interface STCacheManager : NSObject
+ (instancetype)shared;
/**

*/
- (void)cacheContact:(XLContact*)contact;
- (void)fetchContactsListFinish:(void(^)(NSArray<XLContact*>* contactList))finish;


/**
 */
- (void)cacheSerializationData:(id<NSCoding>)data forKey:(NSString*)key;
- (__kindof id<NSCoding>)fetchSerializationByKey:(NSString* )key;

@end

NS_ASSUME_NONNULL_END
