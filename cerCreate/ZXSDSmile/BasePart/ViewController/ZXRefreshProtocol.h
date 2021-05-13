//
//  ZXRefreshProtocol.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/3.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#ifndef ZXRefreshProtocol_h
#define ZXRefreshProtocol_h

@required

/// tableview/collectionView
@property (nonatomic, strong, readonly)UIScrollView *scrollView;

/// 数据的数组
@property (nonatomic, strong)NSMutableArray *datas;

/// 请求
- (void)requestListData;


#endif /* ZXRefreshProtocol_h */
