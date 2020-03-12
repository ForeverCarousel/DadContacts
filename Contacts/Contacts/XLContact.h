//
//  XLContact.h
//  Contacts
//
//  Created by chenxiaolong on 2020/3/12.
//  Copyright © 2020 chenxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XLGender) {
	XLGenderMan = 100,
	XLGenderWoman = 101,
	XLGenderUnknown = 404,
};
NS_ASSUME_NONNULL_BEGIN

@interface XLContact : NSObject<NSCoding>
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* nickName;
@property (nonatomic, copy) NSData* avatar;
@property (nonatomic, assign) XLGender gender;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString* desc;
@end

NS_ASSUME_NONNULL_END
