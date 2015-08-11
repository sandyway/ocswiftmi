//
//  CodeController.m
//  swiftmi_oc
//
//  Created by wings on 8/7/15.
//  Copyright (c) 2015 swing. All rights reserved.
//

#import "CodeController.h"
#import "MJRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CodeDal.h"
#import "CodeCell.h"
#import "CodeDetailViewController.h"

@interface CodeController ()
@property (nonatomic, strong) NSMutableArray* data;
@property (nonatomic) BOOL loading;
@end

@implementation CodeController

static NSString * const reuseIdentifier = @"CodeCell";
static UIEdgeInsets const sectionInsets = {6, 6, 6, 6};

-(void) getDefaultData{
    CodeDal* dalCode = [CodeDal new];
    
    NSArray* result = [dalCode getCodeList];
    
    if (result != nil) {
        self.data = [result mutableCopy];
        [self.collectionView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionViewLayout.collectionView.backgroundColor = [UIColor whiteColor];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[CodeCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // Do any additional setup after loading the view.
//    self.data = [NSMutableArray new];
    @weakify(self);
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadData:0 isPullRefresh:TRUE];
    }];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if ([self.data count] > 0) {
            int maxId = [[self.data.lastObject objectForSafeKey:@"codeId"] intValue];
            [self loadData:maxId isPullRefresh:FALSE];
        }
    }];
    [self getDefaultData];
    
    [self.collectionView.header beginRefreshing];
}

-(void) endRefresh:(BOOL)isPullRefresh{
    if (isPullRefresh) {
        [self.collectionView.header endRefreshing];
    } else {
        [self.collectionView.footer endRefreshing];
    }
}

-(void)loadData:(int)maxId isPullRefresh:(BOOL)isPullRefresh{
    if (self.loading) {
        return;
    }
    self.loading = TRUE;
    
    @weakify(self);
    [[DataManager manager] getCodeList:maxId count:12 success:^(NSURLSessionDataTask *task, id responseObject) {
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
                CodeDal* dalCode = [CodeDal new];
                [dalCode deleteAll];
                [dalCode addList:items];
                [self.data removeAllObjects];
            }
            
            [self.data addObjectsFromArray:items];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
        
    } failure:^(NSError *error) {
        @strongify(self);
        [self endRefresh:isPullRefresh];
        
        [AppNotice showNoticeWithText:NoticeTypeError text:@"网络异常" autoClear:TRUE];
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSArray* item = [self.collectionView indexPathsForSelectedItems];
    if ([item count] > 0) {
        NSIndexPath *indexPath = (NSIndexPath*)item[0];
        
        if ([segue.destinationViewController isKindOfClass:[CodeDetailViewController class]]) {
            CodeDetailViewController* view = (CodeDetailViewController*)segue.destinationViewController;
            view.hidesBottomBarWhenPushed = YES;
            id code = self.data[indexPath.row];
            view.shareCode = code;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CodeCell* cell = (CodeCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    id item = self.data[indexPath.row];
    // Configure the cell
    NSString* preview = [item objectForSafeKey:@"preview"];
    if (preview != nil) {
        if ([preview hasPrefix:@"http://swiftmi."]) {
            preview = [preview stringByAppendingString:@"-code"];
        }
        [cell.preview sd_setImageWithURL:[NSURL URLWithString:preview] placeholderImage:nil];
    }
    
    double pubTime = [[item objectForSafeKey:@"createTime"] doubleValue];
    NSDate* createDate = [NSDate dateWithTimeIntervalSince1970:pubTime];
    
    cell.timeLabel.text = [Utility formatDate:createDate];
    cell.title.text = [item objectForSafeKey:@"title"];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect frame = self.view.frame;
    CGFloat width = frame.size.width;
    
    if (frame.size.width > frame.size.height) {
        width = frame.size.height;
    }
    width = (CGFloat)((int)((width-18)/2));
    return CGSizeMake(width, 380);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 6;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 6;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return sectionInsets;
}

#pragma mark <UICollectionViewDelegate>
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    collectionView.layer.shadowOpacity = 0.8;
    return YES;
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
