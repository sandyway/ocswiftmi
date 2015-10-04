//
//  PostDal.m
//  swiftmi_oc
//
//  Created by wings on 7/27/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "PostDal.h"
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"
#import "Post.h"

@implementation PostDal

//func addPostList(items:[AnyObject]) {
//    
//    for po in items {
//        
//        self.addPost(po, save: false)
//    }
//    
//    CoreDataManager.shared.save()
//}
-(void) addPostList:(NSArray*)items{
    for (id po in items) {
        [self addPost:po save:FALSE];
    }
    [[CoreDataManager shared] save];
}

-(void) addPost:(id)obj save:(BOOL)save{
     NSManagedObjectContext* context = [[CoreDataManager shared]managedObjectContext];
    
    NSEntityDescription* model = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:context];

    Post* post = [[Post alloc] initWithEntity:model insertIntoManagedObjectContext:context];
    
    if (model != nil) {
        [self obj2ManagedObject:obj post:post];
        
        if (save) {
            [[CoreDataManager shared] save];
        }
    }
}

//func getPostList()->[AnyObject]? {
//    
//    var request = NSFetchRequest(entityName: "Post")
//    var sort1=NSSortDescriptor(key: "lastCommentTime", ascending: false)
//    
//    // var sort2=NSSortDescriptor(key: "postId", ascending: false)
//    request.fetchLimit = 30
//    request.sortDescriptors = [sort1]
//    request.resultType = NSFetchRequestResultType.DictionaryResultType
//    var result = CoreDataManager.shared.executeFetchRequest(request)
//    return result
//    
//}
-(NSArray*) getPostList{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
    NSSortDescriptor* sort1 = [NSSortDescriptor sortDescriptorWithKey:@"lastCommentTime" ascending:false];
    
//    NSSortDescriptor* sort2 = [NSSortDescriptor sortDescriptorWithKey:@"postId" ascending:false];
    request.fetchLimit = 30;
    request.sortDescriptors = @[sort1];
    request.resultType = NSDictionaryResultType;
    return [[CoreDataManager shared] executeFetchRequest:request];
}


-(void) deleteAll{
    [[CoreDataManager shared] deleteTable:@"Post"];
}

-(Post*) obj2ManagedObject:(id)obj post:(Post*) post{
    post.postId = @([[obj objectForSafeKey:@"postId"] intValue]);
    post.title = [obj objectForSafeKey:@"title"];
    post.content = [obj objectForSafeKey:@"content"];
    post.createTime = @([[obj objectForSafeKey:@"createTime"] intValue]);
    post.updateTime = @([[obj objectForSafeKey:@"updateTime"] intValue]);
    
    post.channelId = @([[obj objectForSafeKey:@"channelId"] intValue]);
    post.channelName = [obj objectForSafeKey:@"channelName"];
    post.commentCount = @([[obj objectForSafeKey:@"commentCount"] intValue]);
    post.lastCommentId = @([[obj objectForSafeKey:@"lastCommentId"] intValue]);
    post.lastCommentTime = @([[obj objectForSafeKey:@"lastCommentTime"] intValue]);
    post.viewCount = @([[obj objectForSafeKey:@"viewCount"] intValue]);
    post.authorId = @([[obj objectForSafeKey:@"authorId"] intValue]);
    post.authorName = [obj objectForSafeKey:@"authorName"];
    post.avatar = [obj objectForSafeKey:@"avatar"];
    //post.cmtUserId = cmtUserId
    post.cmtUserName = [obj objectForSafeKey:@"cmtUserName"];
    post.desc = [obj objectForSafeKey:@"desc"];
    post.isHtml = @([[obj objectForSafeKey:@"commentCount"] intValue]);
    return post;
}


@end
