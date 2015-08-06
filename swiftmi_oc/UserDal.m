//
//  UserDal.m
//  swiftmi_oc
//
//  Created by wings on 8/6/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "UserDal.h"
#import "CoreDataManager.h"


@implementation UserDal

-(Users*)addUser:(id)obj save:(BOOL)save{
    NSManagedObjectContext* context = [CoreDataManager shared].managedObjectContext;
    
    NSEntityDescription* model = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    
    Users* user = [[Users alloc] initWithEntity:model insertIntoManagedObjectContext:context];
    
    if (model != nil) {
        Users* addUser = [self JSON2Object:obj user:user];
        if (save) {
            [[CoreDataManager shared] save];
        }
        return addUser;
    }
    return nil;
}

-(void) deleteAll{
    [[CoreDataManager shared] deleteTable:@"Users"];
}

-(void) save{
    [[CoreDataManager shared].managedObjectContext save:nil];
}

-(Users*)getCurrentUser{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Users"];
    request.fetchLimit = 1;
    
    NSArray* result = [[CoreDataManager shared] executeFetchRequest:request];
    if (result != nil) {
        if (result.count > 0) {
            return  result[0];
        }
        return nil;
    }
    else{
        return nil;
    }
}

-(Users*) JSON2Object:(id)obj user:(Users*)user{
    user.userId = @([[obj objectForSafeKey:@"userId"] intValue]);
    user.username = [obj objectForSafeKey:@"username"];
    user.email = [obj objectForSafeKey:@"email"];
    user.follower_count = @([[obj objectForSafeKey:@"follower_count"] intValue]);
    user.following_count = @([[obj objectForSafeKey:@"following_count"] intValue]);
    user.points = @([[obj objectForSafeKey:@"points"] intValue]);
    user.signature = [obj objectForSafeKey:@"signature"];
    user.profile = [obj objectForSafeKey:@"profile"];
    user.isAdmin = @([[obj objectForSafeKey:@"isAdmin"] intValue]);
    user.avatar = [obj objectForSafeKey:@"avatar"];
    user.createTime = @([[obj objectForSafeKey:@"createTime"] intValue]);
    user.updateTime = @([[obj objectForSafeKey:@"updateTime"] intValue]);
    return user;
}

@end
