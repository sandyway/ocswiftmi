//
//  CodeDal.m
//  swiftmi_oc
//
//  Created by wings on 8/7/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "CodeDal.h"
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"
#import "Codedown.h"

@implementation CodeDal

-(void) addList:(id) items{
    for (id po in items) {
        [self addCode:po save:false];
    }
    [[CoreDataManager shared] save];
}

-(void)addCode:(id)obj save:(BOOL)save{
    NSManagedObjectContext* context = [CoreDataManager shared].managedObjectContext;
    
    NSEntityDescription* model = [NSEntityDescription entityForName:@"Codedown" inManagedObjectContext:context];
    
    Codedown* codeDown = [[Codedown alloc] initWithEntity:model insertIntoManagedObjectContext:context];
    
    if (model != nil) {
        [self obj2ManagedObject:obj codeDown:codeDown];
        
        if (save) {
            [[CoreDataManager shared] save];
        }
    }
}

-(void)deleteAll{
    [[CoreDataManager shared] deleteTable:@"Codedown"];
}

-(void)save{
    NSManagedObjectContext* context = [CoreDataManager shared].managedObjectContext;
    [context save:nil];
}

-(NSArray*)getCodeList{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Codedown"];
    NSSortDescriptor* sort1 = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:FALSE];
    request.fetchLimit = 30;
    request.sortDescriptors = @[sort1];
    request.resultType = NSDictionaryResultType;
    return [[CoreDataManager shared] executeFetchRequest:request];
}

-(Codedown*)obj2ManagedObject:(id)obj codeDown:(Codedown*)codeDown{
    codeDown.author = [obj objectForSafeKey:@"author"];
    codeDown.categoryId = @([[obj objectForSafeKey:@"categoryId"] intValue]);
    codeDown.categoryName = [obj objectForSafeKey:@"categoryName"];//data["categoryName"].string
    codeDown.codeId = @([[obj objectForSafeKey:@"codeId"] intValue]);//data["codeId"].int64Value
    codeDown.commentCount = @([[obj objectForSafeKey:@"commentCount"] intValue]);//data["commentCount"].int32Value
    codeDown.content = [obj objectForSafeKey:@"content"];//data["content"].string
    codeDown.contentLength  = @([[obj objectForSafeKey:@"contentLength"] doubleValue]);
    codeDown.createTime = @([[obj objectForSafeKey:@"createTime"] intValue]);//data["createTime"].int64Value
    codeDown.desc = [obj objectForSafeKey:@"desc"];//data["desc"].string
    codeDown.devices = [obj objectForSafeKey:@"devices"];//data["devices"].string
    codeDown.downCount = @([[obj objectForSafeKey:@"downCount"] intValue]);//data["downCount"].int32Value
    codeDown.downUrl = [obj objectForSafeKey:@"downUrl"];//data["downUrl"].stringValue
    codeDown.isHtml = @([[obj objectForSafeKey:@"isHtml"] intValue]);//data["isHtml"].int32Value
    codeDown.keywords = [obj objectForSafeKey:@"keywords"];//data["keywords"].string
    codeDown.lastCommentId = @([[obj objectForSafeKey:@"lastCommentId"] intValue]);//data["lastCommentId"].int64Value
    codeDown.lastCommentTime = @([[obj objectForSafeKey:@"lastCommentTime"] intValue]);//data["lastCommentTime"].int64Value
    codeDown.licence = [obj objectForSafeKey:@"licence"];//data["licence"].string
    codeDown.platform = [obj objectForSafeKey:@"platform"];//data["platform"].string
    codeDown.preview = [obj objectForSafeKey:@"preview"];//data["preview"].stringValue
    codeDown.sourceName = [obj objectForSafeKey:@"sourceName"];//data["sourceName"].stringValue
    codeDown.sourceType = @([[obj objectForSafeKey:@"sourceType"] intValue]);//data["sourceType"].int32Value
    codeDown.sourceUrl = [obj objectForSafeKey:@"sourceUrl"];//data["sourceUrl"].stringValue
    codeDown.state = @([[obj objectForSafeKey:@"state"] intValue]);//data["state"].int32Value
    codeDown.tags = [obj objectForSafeKey:@"tags"];//data["tags"].string
    codeDown.title = [obj objectForSafeKey:@"title"];//data["title"].string
    codeDown.updateTime = [[obj objectForSafeKey:@"updateTime"] stringValue];//data["updateTime"].int64Value
    codeDown.userId = @([[obj objectForSafeKey:@"userId"] intValue]);//data["userId"].int64Value
    codeDown.username = [obj objectForSafeKey:@"username"];//data["username"].stringValue
    codeDown.viewCount = @([[obj objectForSafeKey:@"viewCount"] intValue]);//data["viewCount"].int32Value
    
    return codeDown;

}

@end
