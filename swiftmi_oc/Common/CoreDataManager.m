//
//  CoreDataManager.m
//  swiftmi_oc
//
//  Created by wings on 7/27/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "CoreDataManager.h"
#import "CoreData/CoreData.h"


@interface CoreDataManager()

//var _managedObjectModel:NSManagedObjectModel?=nil
//var _persistentStoreCoordinator:NSPersistentStoreCoordinator?=nil



@end

@implementation CoreDataManager
+ (instancetype)shared {
    static CoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CoreDataManager alloc] init];
    });
    return manager;
}

- (NSManagedObjectContext*) managedObjectContext{
    if ([NSThread isMainThread]) {
        if (_managedObjectContext == nil) {
            NSPersistentStoreCoordinator* coordinator = self.persistentStoreCoordinator;
            if (coordinator != nil) {
                _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
                _managedObjectContext.persistentStoreCoordinator = coordinator;
            }
            return _managedObjectContext;
        }
    } else {
        NSManagedObjectContext* threadContext = (NSManagedObjectContext*)[NSThread currentThread].threadDictionary[@"NSManagedObjectContext"];
        if (threadContext == nil) {
            threadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            threadContext.parentContext = _managedObjectContext;
            threadContext.name = [[NSThread currentThread] description];
            [NSThread currentThread].threadDictionary[@"NSManagedObjectContext"] = threadContext;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextWillSave:) name:NSManagedObjectContextWillSaveNotification object:threadContext];
        }else {
            Log(@"using old context");
        }
        return threadContext;
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
-(NSManagedObjectModel*) managedObjectModel{
    if (_managedObjectModel == nil) {
        NSURL * modelURL = [[NSBundle mainBundle] URLForResource:dataModelName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator*) persistentStoreCoordinator{
    if (_persistentStoreCoordinator == nil) {
        NSURL* storeURL = [self.applicationDocumentsDirectory URLByAppendingPathComponent:storeName];
        NSError* error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        if ([_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
            configuration:nil URL:storeURL options:[self databaseOptions] error:&error] == nil) {
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

// #pragma mark - fetches
-(NSArray*) executeFetchRequest:(NSFetchRequest*)request{
    __block NSArray* results;
    [self.managedObjectContext performBlockAndWait:^(void){
        NSError* fetchError = nil;
        results = [self.managedObjectContext executeFetchRequest:request error:&fetchError];
        if (fetchError != nil) {
            Log(@"Warning!!%@", fetchError.description);
        }
        
    }];
    
    return results;
}

-(void) executeFetchRequest:(NSFetchRequest*)request completionHandler:(void (^)(NSArray* results))block{
    [self.managedObjectContext performBlock:^(void){
        NSError* fetchError = nil;
        NSArray* results;
        results = [self.managedObjectContext executeFetchRequest:request error:&fetchError];
        if (results != nil) {
            Log(@"Warning!!%@", fetchError.description);
        }
        block(results);
    }];
}

-(void) save{
    NSManagedObjectContext* context = self.managedObjectContext;
    if ([context hasChanges]) {
        [context performBlock:^(void){
            NSError* saveError = nil;
            BOOL saved = [context save:&saveError];
            if (!saved) {
                if (saveError != nil) {
                    Log(@"Warning!! Saving error%@", saveError.description);
                }
            }
            
            if (context.parentContext != nil) {
                [context.parentContext performBlockAndWait:^(void){
                    NSError* saveError = nil;
                    BOOL saved = [context.parentContext save:&saveError];
                    if (!saved) {
                        if (saveError != nil) {
                            Log(@"Warning!! Saving error%@", saveError.description);
                        }
                    }
                }];
            }
        }];
    }
}


-(void) contextWillSave:(NSNotification*)notification{
    NSManagedObjectContext* context = (NSManagedObjectContext*)notification.object;
    NSSet* insertedObjects = context.insertedObjects;
    
    if ([insertedObjects count] != 0){
        NSError* obtainError = nil;
        [context obtainPermanentIDsForObjects:insertedObjects.allObjects error:&obtainError];
        
        if (obtainError != nil) {
            Log(@"Warning!!obtain ids error %@", obtainError.description);
        }
    }
}


-(void)deleteEntity:(NSManagedObject*)object{
    [object.managedObjectContext deleteObject:object];
}

-(void)deleteTable:(NSString*)tableName{
    NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
    NSEntityDescription* entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:managedObjectContext];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    
    NSArray* items = [self executeFetchRequest:request];
    if (items != nil && items.count > 0) {
        for (NSManagedObject* obj in items) {
            [self deleteEntity:obj];
        }
        [self save];
    }
}

// #pragma mark - Application's Documents directory
-(NSURL*) applicationDocumentsDirectory{
    NSArray* urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return urls[urls.count -1];
}

-(NSDictionary*)databaseOptions{
//    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:TRUE], NSInferMappingModelAutomaticallyOption, nil];
    return @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
}






























@end
