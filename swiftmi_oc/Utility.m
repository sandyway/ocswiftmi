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

+(NSData*)rawData:(id)object opt:(NSJSONWritingOptions)opt error:(NSError**)error{
    return [NSJSONSerialization dataWithJSONObject:object options:opt error:error];
}

+(NSString*)rawString:(id)object encoding:(int)encoding opt:(NSJSONWritingOptions)opt{
    if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
        NSData* data = [self rawData:object opt:opt error:nil];
        if (data == nil) {
            return nil;
        }else {
            return [[NSString alloc] initWithData:data encoding:encoding];
        }
    }else if ([object isKindOfClass:[NSString class]]){
        return object;
    }else if ([object isKindOfClass:[NSNumber class]]){
        return [object stringValue];
    }else if([object isKindOfClass:[NSNull class]]){
        return @"null";
    }else{
        return nil;
    }
}

@end
