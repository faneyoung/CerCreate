//
//  ZXMemberMessageViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXMemberMessageViewController.h"
#import "UITableView+help.h"

//views
#import "ZXMessageItemCell.h"

#import "EPNetworkManager+message.h"
#import "ZXMessageList.h"

@interface ZXMemberMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *notiView;

@property (nonatomic, strong) NSMutableArray *messages;

@end

@implementation ZXMemberMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.enableInteractivePopGesture = YES;
    
    self.title = @"会员";
    
    self.tableView.showPlaceholdWhenLoad = NO;

    self.tableView.placeholderView = [self.tableView defaultPlaceholdViewWithMsg:@"还没有任何消息哦~"];

    @weakify(self);
    [self.tableView addHeaderRefreshingBlock:^{
        @strongify(self);
        [self refreshMessageData];
    }];
    [self.tableView addFooterRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshMessageData];
    
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
    ]];
    
    
}

#pragma mark - data handle -

static const int kPageSize = 10;
- (void)refreshMessageData{
    NSMutableDictionary *pms = @{}.mutableCopy;
    [pms setSafeValue:@(0) forKey:@"offset"];
    [pms setSafeValue:@(kPageSize) forKey:@"limit"];
    [pms setSafeValue:@"member" forKey:@"type"];
    [[EPNetworkManager defaultManager] getAPI:@"rest/notice/record/list" parameters:pms.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
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
    
    NSMutableDictionary *pms = @{}.mutableCopy;
    [pms setSafeValue:@(self.messages.count) forKey:@"offset"];
    [pms setSafeValue:@(kPageSize) forKey:@"limit"];
    [pms setSafeValue:@"member" forKey:@"type"];
    [[EPNetworkManager defaultManager] getAPI:@"rest/notice/record/list" parameters:pms.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
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
    
    ZXMessageItemCell *cell = [ZXMessageItemCell instanceCell:tableView];
    [cell updateWithData:self.messages[indexPath.row]];
    return cell;

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
    
    ZXSDWebViewController *webVC = [[ZXSDWebViewController alloc] init];
    webVC.requestURL = GetString(item.url);
    [self.navigationController pushViewController:webVC animated:YES];
    
    
}



@end
