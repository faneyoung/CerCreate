//
//  ZXSDIDCardPhotoCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDIDCardPhotoCell : ZXSDBaseTableViewCell

@property (nonatomic, copy) void(^takePhotoAction)(NSInteger tag);

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *frontImageView;

@property (nonatomic, strong) UILabel *backStatusLabel;
@property (nonatomic, strong) UILabel *frontStatuslabel;

@end

NS_ASSUME_NONNULL_END
