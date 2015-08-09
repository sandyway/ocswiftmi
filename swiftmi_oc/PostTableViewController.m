//
//  PostTableViewController.m
//  swiftmi_oc
//
//  Created by swing on 15/7/27.
//  Copyright (c) 2015年 swing. All rights reserved.
//

#import "PostTableViewController.h"
#import "PostDal.h"
#import "MJRefresh.h"
#import "PostCell.h"
#import "Utility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FXKeychain.h"
#import "LoginController.h"
#import "PostDetailController.h"

@interface PostTableViewController ()
//internal var data:[AnyObject] = [AnyObject]()
@property (nonatomic, strong) NSMutableArray* data;
@property (nonatomic, strong) PostCell* prototypeCell;
@end

@implementation PostTableViewController

-(void) getDefaultData{
    PostDal* dalPost = [PostDal new];
    NSArray* result = [dalPost getPostList];
    if (result != nil) {
        self.data = [result mutableCopy];
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //读取默认数据
    [self getDefaultData];
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData:0 isPullRefresh: true];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([weakSelf.data count] > 0) {
            int maxId = (int)[weakSelf.data.lastObject objectForSafeKey:@"postId"];
            [weakSelf loadData:maxId isPullRefresh:FALSE];
        }
    }];
    
    
    
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.data count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = (PostCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    id item = self.data[indexPath.row];
    
    int commentCount = (int)[item objectForSafeKey:@"viewCount"];
    
    cell.commentCount.text = [NSString stringWithFormat:@"%d", commentCount];
    
    double pubTime = [[item objectForSafeKey:@"createTime"] doubleValue];
    NSDate* createDate = [NSDate dateWithTimeIntervalSince1970:pubTime];
    
    cell.timeLabel.text = [Utility formatDate:createDate];
    
    cell.title.text = [item objectForSafeKey:@"title"];
    cell.authorName.text = [item objectForSafeKey:@"authorName"];
    cell.channelName.text = [item objectForSafeKey:@"channelName"];
    
    NSString* url = [[item objectForSafeKey:@"avatar"] stringByAppendingString:@"-a80"];
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"avatar_default"]];

    cell.avatar.layer.cornerRadius = 5;
    cell.avatar.layer.masksToBounds = TRUE;
    // cell.avatar.set
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateConstraintsIfNeeded];
    
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     PostCell* cell = (PostCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.containerView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.9];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void) configureCell:(PostCell*) cell indexPath:(NSIndexPath*)indexPath isForOffscreenUse:(BOOL)isForOffscreenUse{
    id item = self.data[indexPath.row];
    cell.title.text = [item objectForSafeKey:@"title"];
    cell.channelName.text = [item objectForSafeKey:@"channelName"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_prototypeCell == nil) {
        self.prototypeCell = (PostCell*)[self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    
    [self configureCell:_prototypeCell indexPath:indexPath isForOffscreenUse:false];
    
    [self.prototypeCell setNeedsUpdateConstraints];
    [self.prototypeCell updateConstraintsIfNeeded];
    [self.prototypeCell setNeedsLayout];
    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.containerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height;
    
}

-(void) endRefresh:(BOOL)isPullRefresh{
    if (isPullRefresh) {
        [self.tableView.header endRefreshing];
    } else {
        [self.tableView.footer endRefreshing];
    }
}

-(void) loadData:(int)maxId isPullRefresh:(BOOL)isPullRefresh{
    if (self.loading) {
        return;
    }
    self.loading = true;
    
    @weakify(self);
    [[DataManager manager] getTopicList:maxId count:16 success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        self.loading = false;
        [self endRefresh:isPullRefresh];
        NSDictionary* result = (NSDictionary*)responseObject;        
        if ([[result objectForSafeKey:@"isSuc"] boolValue]) {
            NSArray* items =  (NSArray*)[result objectForSafeKey:@"result"];
            if ([items count] == 0) {
                return;
            }
            
            if (isPullRefresh) {
                PostDal* dalPost = [PostDal new];
                [dalPost deleteAll];
                [dalPost addPostList:items];
                [self.data removeAllObjects];
            }
            
            [self.data addObjectsFromArray:items];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
        
    } failure:^(NSError *error) {
        @strongify(self);
        [self endRefresh:isPullRefresh];
        
        UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:@"回复失败" message:nil];
        [alertView bk_setCancelBlock:^{
            ;
        }];
        [alertView show];
    }];
    
}


- (IBAction)addTopic:(id)sender {
    id token = [[FXKeychain defaultKeychain] objectForKey:tokenName];
    if (token == nil) {
        LoginController* loginController = (LoginController*)[Utility GetViewController:@"loginController"];
        [self.navigationController pushViewController:loginController animated:TRUE];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
//    if ([[segue identifier] isEqualToString:@"PostDetail"])
    {
        // Get reference to the destination view controller
        id vc = [segue destinationViewController];
        if ([vc isKindOfClass:[PostDetailController class]]) {
            PostDetailController* view = (PostDetailController*)vc;
            NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
            
            id article = self.data[indexPath.row];
            view.article = article;
        }
        
        // Pass any objects to the view controller here, like...
//        [vc setMyObjectHere:object];
    }
}





























@end
