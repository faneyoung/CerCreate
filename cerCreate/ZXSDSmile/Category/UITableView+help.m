//
//  UITableView+help.m
//  wlive
//
//  Created by fane on 2020/6/27.
//  Copyright © 2020 xxxx. All rights reserved.
//

#import "UITableView+help.h"

static void _exchanged_instance_method(SEL originalSelector, SEL swizzledSelector, Class class){
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UITableView (help)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _exchanged_instance_method(@selector(reloadData),@selector(custom_reloadData),[self class]);
    });
}

- (void)custom_reloadData{
    if (!self.showPlaceholdWhenLoad) {
        [self checkEmpty];
    }
    self.showPlaceholdWhenLoad = NO;
    [self custom_reloadData];
}


- (void)checkEmpty{
    BOOL isEmpty = YES;//flag标示
    id <UITableViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 1;//默认一组
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        //获取当前TableView组数
        sections = [dataSource numberOfSectionsInTableView:self] - 1;
    }
    
    for (NSInteger i = 0; i <= sections; i++) {
        //获取当前TableView各组行数
        NSInteger rows = [dataSource tableView:self numberOfRowsInSection:i];
        if (rows) {
            isEmpty = NO;//若行数存在，不为空
        }
    }
    if (isEmpty) {//若为空，加载占位图
        self.placeholderView.hidden = NO;
        [self addSubview:self.placeholderView];
        
        [self.placeholderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self.mas_centerY).offset((self.centery != 0) ? self.centery : 0);
        }];
    } else {//不为空，移除占位图
        self.placeholderView.hidden = YES;
    }
}


#pragma mark - 类目添加的属性
- (float)centery {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setCentery:(float)centery{
    objc_setAssociatedObject(self, @selector(centery), @(centery), OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)placeholderView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPlaceholderView:(UIView *)placeholderView {
    objc_setAssociatedObject(self, @selector(placeholderView), placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)placeholderImage{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPlaceholderImage:(UIImage *)placeholderImage{
    objc_setAssociatedObject(self, @selector(placeholderImage), placeholderImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)showPlaceholdWhenLoad {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setShowPlaceholdWhenLoad:(BOOL)showPlaceholdWhenLoad{
    objc_setAssociatedObject(self, @selector(showPlaceholdWhenLoad), @(showPlaceholdWhenLoad), OBJC_ASSOCIATION_ASSIGN);
}

- (void (^)(void))reloadBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setReloadBlock:(void (^)(void))reloadBlock {
    objc_setAssociatedObject(self, @selector(reloadBlock), reloadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


#pragma mark - tableview -
-(void)registerNibs:(NSArray *)nibArr
{
    [nibArr enumerateObjectsUsingBlock:^(NSString*  _Nonnull nib, NSUInteger idx, BOOL * _Nonnull stop) {
        [self registerNib:[UINib nibWithNibName:nib bundle:nil] forCellReuseIdentifier:nib];
    }];
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 50;
//    self.tableFooterView = [UIView new];

}
-(void)registerClasses:(NSArray *)classes
{
    [classes enumerateObjectsUsingBlock:^(NSString*  _Nonnull cls, NSUInteger idx, BOOL * _Nonnull stop) {
        [self registerClass:NSClassFromString(cls) forCellReuseIdentifier:cls];
    }];
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 50;
}


#pragma mark - refresh -

- (void)addHeaderRefreshingBlock:(void(^)(void))refreshBlock{
    
    ((MJRefreshNormalHeader *)self.mj_header).stateLabel.textColor = UIColorFromHex(0xA0AFC3);
    ((MJRefreshNormalHeader *)self.mj_header).lastUpdatedTimeLabel.textColor = UIColorFromHex(0xA0AFC3);
    
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
}
- (void)addFooterRefreshingBlock:(void(^)(void))refreshBlock{
    [(MJRefreshNormalHeader *)self.mj_footer setTitle:@"" forState:MJRefreshStateIdle];
    //    [(MJRefreshAutoNormalFooter *)self.mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    ((MJRefreshNormalHeader *)self.mj_footer).stateLabel.textColor = UIColorFromHex(0xA0AFC3);

    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
}

- (void)startHeaderRefresh{
    [self.mj_header beginRefreshing];
}

- (void)endHeaderFooterAnimation{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

#pragma mark - views -
- (UIView*)sepFooterView{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *sepView = [[UILabel alloc] init];
    sepView.backgroundColor = kThemeColorLine;
    [footerView addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerView).offset(15);
        make.right.mas_equalTo(footerView).offset(-15);
        make.top.mas_equalTo(footerView);
        make.height.mas_equalTo(1.0);
    }];
    footerView.clipsToBounds = YES;
    return footerView;
}

- (UITableViewCell *)defaultReuseCell{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:@"kDefaultReuseCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kDefaultReuseCellIdentifier"];
        cell.textLabel.text = @"default";
    }
    
    return cell;
}

- (UIView*)defaultHeaderFooterView{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = kThemeColorLine;
    footerView.clipsToBounds = YES;
    return footerView;
}

- (UIView*)commonPlaceholderView{
    UIView *emptyView = [[UIView alloc] init];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"smile_bank_default"];
    [emptyView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(emptyView);
        make.centerX.mas_equalTo(emptyView);
        make.width.height.mas_equalTo(110);
    }];

    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:12];
    lab.textColor = TextColorSubTitle;
    lab.text = @"暂时没有内容";
    [emptyView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_bottom).inset(10);
        make.centerX.mas_equalTo(emptyView);
        make.height.mas_equalTo(17);
    }];
    
    return emptyView;
}

#pragma mark - help methods -

- (UIView*)defaultPlaceholdViewWithMsg:(NSString*)msg subTitle:(NSString*)subTitle{
    UIView *pView = [[UIView alloc] init];
    
    UIImage *img = self.placeholderImage ?: UIImageNamed(@"icon_common_none");
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [pView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(pView);
        make.width.height.mas_equalTo(120.0);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = UIColorFromHex(0xA0AFC3);
    titleLab.textAlignment = NSTextAlignmentCenter;
    NSString *title = msg;
    if (!IsValidString(title)) {
        title = @"暂时没有内容";
    }
    titleLab.text = title;
    
    [pView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
        make.centerX.offset(0);
    }];
    
    UILabel *subLab = [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.textColor = TextColorSubTitle;
    subLab.textAlignment = NSTextAlignmentCenter;
    subLab.text = subTitle;
    [pView addSubview:subLab];
    [subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom);
        make.height.mas_equalTo(17);
        make.centerX.mas_equalTo(pView);
        make.bottom.mas_equalTo(pView).offset(-20);
    }];
    
    pView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeholderViewAction)];
    [pView addGestureRecognizer:gesture];
    
    return pView;

}

- (UIView*)defaultPlaceholdViewWithMsg:(NSString*)msg{
    return [self defaultPlaceholdViewWithMsg:msg subTitle:@""];
}

#pragma mark - action methods -
- (void)placeholderViewAction{
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}



@end

