//
//  STCacheManager.m
// SweetDream
//
//  Created by cxl on 2020/1/10.
//  Copyright © 2020 chenxiaolong. All rights reserved.
//

#import "STCacheManager.h"
#import <FMDB.h>
#import <YYCache/YYCache.h>


#define XL_TABLE_CONTACTS @"xl_table_contacts"
#define ST_USER_PREFERENCE_KEY @"st_user_preference_key"

@interface STCacheManager ()
@property (nonatomic, strong) FMDatabaseQueue* dbQueue;
@property (nonatomic, copy) NSString* dbPath;
@property (nonatomic, strong) YYCache* serializeCache;
@end

@implementation STCacheManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static STCacheManager* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - DB
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.serializeCache = [YYCache cacheWithName:@"STSerializeCache"];
        _serializeCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        
        NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString * fileDir = [docPath stringByAppendingPathComponent:@"XLContactsData"];
        self.dbPath = [docPath stringByAppendingPathComponent:@"SqliteFile/sleep_event.sqlite"];//设置数据库名称
        BOOL isDir;
        if (![NSFileManager.defaultManager fileExistsAtPath:fileDir isDirectory:&isDir] && !isDir) {
            NSError* e;
            if ([NSFileManager.defaultManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:&e]) {
                [self openDataBase];
            }else{
                [self openDataBase];
            }
        }else{
            [self openDataBase];
        }
    }
    return self;
}

-(void)openDataBase {
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSLog(@"ST_DB_LOG 数据库打开成功");
        [self createSleepEventTable:db];
       
    }];
}

- (void)createSleepEventTable:(FMDatabase *)db {
	/*
	 @property (nonatomic, copy) NSString* name;
	 @property (nonatomic, copy) NSString* nickName;
	 @property (nonatomic, copy) NSData* avatar;
	 @property (nonatomic, assign) XLGender gender;
	 @property (nonatomic, assign) NSInteger age;
	 @property (nonatomic, copy) NSString* desc;
	 */
    //事件表
    NSString* contact_table_create = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                                    id integer PRIMARY KEY AUTOINCREMENT,	\
                                    contact_name integer NOT NULL,	\
                                    contact_nickName         date     NOT NULL,	\
                                    contact_avatar         date     NOT NULL,	\
                                    contact_gender			 integer NOT NULL,	\
                                    contact_age 		double  NOT NULL,\
									contact_desc)",XL_TABLE_CONTACTS];
    BOOL executeUpdate = [db executeUpdate:contact_table_create];
    if (executeUpdate) {
        NSLog(@"ST_DB_LOG Contact Table 创建/打开成功");
    }
}


-(FMDatabaseQueue *)dbQueue {
    if (!_dbQueue) {
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
    }
    return _dbQueue;
}


#pragma mark - Contacts

//- (void)clearSleepEvent:(NSInteger)startDateTimestamp{
//    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
//        NSString *delSql = [NSString stringWithFormat:@"DELETE FROM %@  WHERE start_timeStamp = %@",ST_EVENT_TABLE,@(startDateTimestamp)];
//        BOOL success = [db executeUpdate:delSql];
//        if (success) {
//            NSLog(@"ST_DB_LOG 删除旧数据成功_event表 ：%@",[NSDate dateWithTimeIntervalSince1970:startDateTimestamp]);
//        }else{
//            NSLog(@"ST_DB_LOG 删除旧数据失败_event表 ：%@",[NSDate dateWithTimeIntervalSince1970:startDateTimestamp]);
//        }
//    }];
//
//}
//
//- (void)fetchSleepEventWithDate:(NSInteger)startDateTimestamp finish:(void (^)(STSleepEvent * _Nonnull))finish{
//    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
//        //根据条件查询
//        FMResultSet* resultSet = nil;
//        if (startDateTimestamp != -1) {
//            NSInteger key = startDateTimestamp;
//            resultSet = [db executeQueryWithFormat:@"SELECT * from st_event_table WHERE start_timeStamp = %@",@(key)];
//        }else{
//            resultSet = [db executeQueryWithFormat:@"SELECT * from st_event_table"];
//        }
//        //遍历结果集合
//        STSleepEvent* event = [self generateEventObjectFrom:resultSet];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            finish(event);
//        });
//    }];
//}
//
//- (STSleepEvent*)generateEventObjectFrom:(FMResultSet*) resultSet {
//    NSMutableArray<STEventPoint*>* points =[NSMutableArray array];
//    //遍历结果集合
//    while ([resultSet next]) {
//        //start_date,start_timeStamp,point_date,point_timeStamp, point_value)
//        //读数据
//        NSInteger eventTimestamp = [resultSet intForColumn:@"start_timeStamp"];
//        NSInteger pointTimestamp = [resultSet intForColumn:@"point_timeStamp"];
//        CGFloat powerLevel = [resultSet doubleForColumn:@"point_value"];
//        //转模型
//        STEventPoint* point = [STEventPoint new];
//        point.eventDate = [NSDate dateWithTimeIntervalSince1970:eventTimestamp];
//        point.eventTimestamp = eventTimestamp;
//        point.pointDate = [NSDate dateWithTimeIntervalSince1970:pointTimestamp];
//        point.pointTimestamp = pointTimestamp;
//        point.powerLevel = powerLevel;
//
//        [points addObject:point];
//    }
//    //生成event对象
//    STSleepEvent* event = [STSleepEvent new];
//    event.points = points;
//    event.date = points.firstObject.eventDate;
//    event.timeStamp = points.firstObject.eventTimestamp;
//    return event;
//}

- (void)cacheContact:(XLContact*)contact {
	[_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
		NSString* name = contact.name;
		NSString* nickName = contact.nickName;
		NSData* avatar = contact.avatar;
        NSInteger gender = contact.gender;
		NSInteger age = contact.age;
		NSString* desc = contact.desc;

		
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO %@ (\
                         contact_name, contact_nickName, contact_avatar, contact_gender, contact_age,contact_desc) \
                         VALUES (?,?,?,?,?,?)",XL_TABLE_CONTACTS];
        NSArray* args = @[name,nickName,avatar,@(gender),@(age),desc];
        BOOL result = [db executeUpdate:sql withArgumentsInArray:args];
        if (result) {
			NSLog(@"ST_DB_LOG 插入成功_contact");
        } else {
            NSLog(@"ST_DB_LOG 插入失败_contact");
        }
    }];
}
- (void)fetchContactsListFinish:(void(^)(NSArray<XLContact*>* contactList))finish {
	
}

#pragma mark - H5返回数据 暂时
- (void)cacheSerializationData:(id<NSCoding>)data forKey:(NSString*)key {
    if (data && key) {
        [_serializeCache setObject:data forKey:key withBlock:^{
        }];
    }else{
        NSLog(@"ST_DB_LOG key:%@ object:%@ 缓存错误",key,data);
    }
}

- (id<NSCoding>)fetchSerializationByKey:(NSString* )key {
    id obj = [_serializeCache objectForKey:key];
    return  obj;
}



@end
