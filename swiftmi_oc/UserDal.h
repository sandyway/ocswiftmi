//
//  UserDal.h
//  swiftmi_oc
//
//  Created by wings on 8/6/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Users.h"

@interface UserDal : NSObject
-(void) save;
-(void) deleteAll;
-(Users*)addUser:(id)obj save:(BOOL)save;
@end
