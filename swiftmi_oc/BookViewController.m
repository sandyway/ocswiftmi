//
//  BookViewController.m
//  swiftmi_oc
//
//  Created by swing on 15/8/9.
//  Copyright (c) 2015年 swing. All rights reserved.
//

#import "BookViewController.h"
#import "MJRefresh.h"
#import "BookCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WebViewController.h"

@interface BookViewController ()
@property (nonatomic, strong)NSArray* data;
@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    _data = @[[NSMutableArray new], [NSMutableArray new]];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120;

    @weakify(self);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadData:[self GetBookType] maxId:0 isPullRefresh:TRUE];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if ([self.data count] > 0) {
            int maxId = [[self.data.lastObject objectForSafeKey:@"bookId"] intValue];
            [self loadData:[self GetBookType] maxId:maxId isPullRefresh:FALSE];
        }
    }];
    
    [self.tableView.header beginRefreshing];
}

-(id)getBookData:(NSInteger)row{
    return self.data[_bookType.selectedSegmentIndex][row];
}

-(NSMutableArray*) GetBookDataSource{
    return self.data[_bookType.selectedSegmentIndex];
}

-(NSInteger)GetBookType{
    return _bookType.selectedSegmentIndex +1;
}

-(void)setBookData:(NSArray*)items type:(NSInteger)type isPullRefresh:(BOOL)isPullRefresh{
    if (isPullRefresh) {
        [self.data[type-1] removeAllObjects];
    }
    
    [self.data[type-1] addObjectsFromArray:items];
}


- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    if ([self.data[index] count] == 0) {
        [self.tableView.header beginRefreshing];
        [self loadData:index+1 maxId:0 isPullRefresh:TRUE];
    } else {
        [self.tableView reloadData];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) endRefresh:(BOOL)isPullRefresh{
    if (isPullRefresh) {
        [self.tableView.header endRefreshing];
    } else {
        [self.tableView.footer endRefreshing];
    }
}

-(void)loadData:(NSInteger)type maxId:(NSInteger)maxId isPullRefresh:(BOOL)isPullRefresh{
    @weakify(self);
    [[DataManager manager] BookList:type maxId:maxId count:16 success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self endRefresh:isPullRefresh];
        NSDictionary* result = (NSDictionary*)responseObject;
        if ([[result objectForSafeKey:@"isSuc"] boolValue]) {
            NSArray* items =  (NSArray*)[result objectForSafeKey:@"result"];
            if ([items count] == 0) {
                return;
            }
            
            [self setBookData:items type:type isPullRefresh:isPullRefresh];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
        
    } failure:^(NSError *error) {
        @strongify(self);
        [self endRefresh:isPullRefresh];
    }];
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
    return [[self GetBookDataSource] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookCell* cell = (BookCell*)[tableView dequeueReusableCellWithIdentifier:@"BookCell" forIndexPath:indexPath];

    id item = [self getBookData:indexPath.row];
    // Configure the cell...
    NSMutableString* cover = [item objectForSafeKey:@"cover"];
    if (cover != nil) {
        if ([cover hasPrefix:@"http://swiftmi."]) {
            [cover appendString:@"-book"];
        }
        [cell.cover sd_setImageWithURL:[NSURL URLWithString:cover] placeholderImage:nil];
    }
    cell.author.text = [item objectForSafeKey:@"author"];
    double pubTime = [[item objectForSafeKey:@"publishTime"] doubleValue];
    NSDate* createDate = [NSDate dateWithTimeIntervalSince1970: pubTime];
    cell.year.text = [Utility formatDate:createDate];
    cell.title.text = [item objectForSafeKey:@"title"];
    
    cell.desc.text = [item objectForSafeKey:@"intro"];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [self getBookData:indexPath.row];
    NSString* bookUrl = [item objectForSafeKey:@"link"];
    if (bookUrl != nil) {
        WebViewController* webViewController = [Utility GetViewController:@"webViewController"];
        webViewController.webUrl = bookUrl;
        webViewController.isPop = TRUE;
        [self.navigationController pushViewController:webViewController animated:TRUE];
    }
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

@end
