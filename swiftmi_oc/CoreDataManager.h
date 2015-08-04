//
//  CoreDataManager.h
//  swiftmi_oc
//
//  Created by wings on 7/27/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData/NSFetchRequest.h"

@interface CoreDataManager : NSObject{
}
@property (nonatomic, strong)NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong) NSURL* applicationDocumentsDirectory;
+ (instancetype)shared;

-(NSArray*) executeFetchRequest:(NSFetchRequest*)request;
-(void)deleteTable:(NSString*)tableName;
-(void) save;
@end
