//
//  ZXPromotionMessageViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXPromotionMessageViewController.h"
#import "UITableView+help.h"

#import "ZXLocationManager.h"

//views
#import "ZXMessageItemCell.h"
#import "ZXRecommendWorkCell.h"


#import "EPNetworkManager+message.h"
#import "ZXMessageList.h"

@interface ZXPromotionMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *notiView;

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSDictionary *locDic;


@end

@implementation ZXPromotionMessageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.enableInteractivePopGesture = YES;
    
    self.title = @"活动";

    self.tableView.showPlaceholdWhenLoad = NO;

    self.tableView.placeholderView = [self.tableView defaultPlaceholdViewWithMsg:@"还没有任何消息哦~"];

    @weakify(self);
    [self.tableView addHeaderRefreshingBlock:^{
        @strongify(self);
        [self refreshMessageData];
    }];
    [self.tableView addFooterRefreshingBlock:^{
        @strongify(self);
        if (!IsValidArray(self.messages)) {
            [self.tableView endHeaderFooterAnimation];
            return;
        }
        [self loadMoreData];
    }];
      
    [self requestRecordListWithLocation];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - views -
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 165;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    
    return _tableView;
}

- (void)setupSubViews{

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.bottom.inset(kBottomSafeAreaHeight);
    }];
    
    [self.tableView registerNibs:@[
        NSStringFromClass(ZXMessageItemCell.class),
        NSStringFromClass(ZXRecommendWorkCell.class),
    ]];
    
    
}

#pragma mark - data handle -

static const int kPageSize = 10;

- (NSDictionary*)recordListParamsWithOffset:(int)offset{
    NSMutableDictionary *pms = @{}.mutableCopy;
    [pms setSafeValue:@(offset) forKey:@"offset"];
    [pms setSafeValue:@(kPageSize) forKey:@"limit"];
    [pms setSafeValue:@"activity" forKey:@"type"];
    
    [pms setSafeValue:GetStrDefault(self.businessType, @"0") forKey:@"businessType"];
    if (IsValidDictionary(self.locDic)) {
        [pms addEntriesFromDictionary:self.locDic];
    }
    return pms.copy;
}

- (void)requestRecordListWithLocation{
    LoadingManagerShow();
    @weakify(self);
    [ZXLocationManager.sharedManger startLocationWithSuccessBlock:^(NSDictionary * _Nonnull loc) {
        @strongify(self);
        LoadingManagerHidden();
        self.locDic = loc;
        [self refreshMessageData];
    } failureBlock:^(NSError * _Nonnull error) {
        LoadingManagerHidden();

        [self refreshMessageData];
    }];

}

- (void)refreshMessageData{
    
    NSDictionary *params = [self recordListParamsWithOffset:0];
    
    [[EPNetworkManager defaultManager] getAPI:@"rest/notice/record/list" parameters:params decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        dispatch_safe_async_main(^{
            [self.tableView.mj_header endRefreshing];
        });
        if (error) {
            return;
        }
        
        ZXMessageList *messageList = [ZXMessageList instanceWithDictionary:response.originalContent];
        
        [self.messages removeAllObjects];
        [self.messages addObjectsFromArray:messageList.messages];
        
        dispatch_safe_async_main(^{
            [self.tableView reloadData];
        });
    }];
}

- (void)loadMoreData{
    
    NSDictionary *pms = [self recordListParamsWithOffset:(int)self.messages.count];

    [[EPNetworkManager defaultManager] getAPI:@"rest/notice/record/list" parameters:pms decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_safe_async_main(^{
            [self.tableView.mj_footer endRefreshing];
        });
        if (error) {
            return;
        }
        
        ZXMessageList *messageList = [ZXMessageList instanceWithDictionary:response.originalContent];
        if (IsValidArray(messageList.messages)) {
            [self.messages addObjectsFromArray:messageList.messages];
        }
        
        dispatch_safe_async_main(^{
            [self.tableView reloadData];
        });
        
        
    }];

}

#pragma mark - help methods -
- (NSMutableArray *)messages{
    if (!_messages) {
        _messages = [NSMutableArray arrayWithCapacity:1];
    }
    return _messages;
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if ([self.businessType isEqualToString:@"1"]) {//推荐工作
        ZXRecommendWorkCell *cell = [ZXRecommendWorkCell instanceCell:tableView];
        [cell updateWithData:self.messages[indexPath.row]];
        return cell;
//    }
//
//    ZXMessageItemCell *cell = [ZXMessageItemCell instanceCell:tableView];
//    [cell updateWithData:self.messages[indexPath.row]];
//
//    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZXMessageItem *item = self.messages[indexPath.row];
    if (!IsValidString(item.url)) {
        return;
    }
    
    NSString *url = GetString(item.url);
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:item.configId forKey:@"configId"];
    [tmps setSafeValue:[ZXSDCurrentUser currentUser].phone forKey:@"phone"];
    [tmps setSafeValue:item.distance forKey:@"distance"];
    
    NSString *flag = @"false";
    if (item.flag) {
        flag = @"true";
    }
    [tmps setSafeValue:flag forKey:@"flag"];

    
    url = QueryStrEncoding(url, tmps.copy);
    
    
    ZXSDWebViewController *webVC = [[ZXSDWebViewController alloc] init];
    webVC.routeBlock = ^{
        [self refreshMessageData];

    };
    webVC.requestURL = url;
    [self.navigationController pushViewController:webVC animated:YES];
    
}


@end
