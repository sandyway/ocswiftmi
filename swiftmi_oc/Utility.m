//
//  Utility.m
//  swiftmi_oc
//
//  Created by wings on 7/31/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(NSString*) formatDate:(NSDate*)date{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
   return [fmt stringFromDate:date];
}

+(id) GetViewController:(NSString*)controllerName{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return [mainStoryboard instantiateViewControllerWithIdentifier:controllerName];
}

@end
