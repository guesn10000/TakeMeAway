//
//  PersistentStack.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-14.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "PersistentStack.h"

@interface PersistentStack ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSURL* modelURL; // 模型文件的路径
@property (nonatomic, strong) NSURL* storeURL; // 数据的存储路径

@end

@implementation PersistentStack

#pragma mark - Singleton

+ (instancetype)sharedPersistentStack {
    static PersistentStack *stack = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        stack = [[super allocWithZone:NULL] init];
        [stack setupManagedObjectContext];
    });
    
    return stack;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedPersistentStack];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - Initialization

- (void)setupManagedObjectContext {
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSError* error;
    [self.managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:nil error:&error];
    if (error) {
        JCNSLog(@"error: %@", error);
    }
}

- (NSManagedObjectModel*)managedObjectModel {
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
}

- (NSURL*)storeURL {
    NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return [documentsDirectory URLByAppendingPathComponent:@"TakeMeAway.sqlite"];
}

- (NSURL*)modelURL {
    return [[NSBundle mainBundle] URLForResource:@"TakeMeAway" withExtension:@"momd"];
}

#pragma mark - Operations

- (BOOL)save:(NSError **)error {
    if ([_managedObjectContext save:error]) {
        return YES;
    }
    else {
        if (error) {
            JCNSLog(@"error : %@", *error);
        }
        return NO;
    }
}

- (NSArray *)executeFetchWithEntityName:(NSString *)entityName
                              predicate:(NSPredicate *)predicate
                         sortDescriptor:(NSArray *)sortDescriptors
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = predicate;
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchResults = [_managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        JCNSLog(@"error : %@", error);
    }
    
    return fetchResults;
    // 注意，fetchResults可能为nil
}

- (void)updateManagedObject:(NSManagedObject *)object mergeChanges:(BOOL)flag {
    [_managedObjectContext refreshObject:object mergeChanges:flag];
}

- (void)deleteManagedObjects:(NSArray *)managedObjects {
    for (NSManagedObject *object in managedObjects) {
        [_managedObjectContext deleteObject:object];
    }
    
#ifdef LOCAL_TEST
    NSError *error = nil;
    [self save:&error];
    // 程序退出时会自动保存
#endif
}

- (void)deleteManagedObject:(NSManagedObject *)object {
    [_managedObjectContext deleteObject:object];
    
#ifdef LOCAL_TEST
    NSError *error = nil;
    [self save:&error];
    // 程序退出时会自动保存
#endif
}

@end
