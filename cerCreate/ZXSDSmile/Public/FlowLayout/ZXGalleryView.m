//
//  ZXGalleryView.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/19.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXGalleryView.h"

#import "ZXGalleryLayout.h"

@interface ZXGalleryView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property(nonatomic,assign) CGFloat space;

@property (nonatomic, assign) int curIndex;
@property (nonatomic, assign) int nextItem;
@property (nonatomic, assign) int endDisplayItem;

@property(nonatomic,assign) CGFloat unitOffset;
@property (nonatomic, strong) NSArray *originItems;

@end

@implementation ZXGalleryView
-(instancetype)initWithFrame:(CGRect)frame space:(CGFloat)space{
    
   CGSize itemSize = CGSizeMake(frame.size.width-self.space*2, frame.size.height);
    return [self initWithFrame:frame itemSize:itemSize space:space];
}

-(instancetype)initWithFrame:(CGRect)frame itemSize:(CGSize)itemSize space:(CGFloat)space{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.space = space;
        self.unitOffset = self.width-self.space*3-2*15;
        
        ZXGalleryLayout *layout = [[ZXGalleryLayout alloc]init];
        layout.itemSize = itemSize;
        
        _collectionView=[[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.decelerationRate = 0.5;
        _collectionView.clipsToBounds = NO;
        _collectionView.backgroundColor=[UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource=self;
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.showsHorizontalScrollIndicator=NO;
        [self addSubview:_collectionView];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gallaryImageCollectionCell"];
        
    }
    
    return self;
}



#pragma mark - help methods -

static int kBeautyRepetCount = 500;
int  kMidOffsetX = 0;

-(void)setImageArr:(NSMutableArray *)imageArr
{
    _imageArr = imageArr;
    self.originItems = imageArr.copy;
    
    if (imageArr.count > 0) {
        NSMutableArray *tmps = [NSMutableArray arrayWithCapacity:kBeautyRepetCount*imageArr.count];

        for (int i=0;i<kBeautyRepetCount;i++) {
            [tmps addObjectsFromArray:imageArr];
        }
        _imageArr = tmps.copy;
    }
    

    [self.collectionView reloadData];
    
    //默认滚动到第一张图片
//    CGFloat scrollUnitWidth = [self scrollUnitWidth];
//    [self.collectionView setContentOffset:CGPointMake(scrollUnitWidth, 0)];
    
    int idx = ((int)self.originItems.count * kBeautyRepetCount)/2 + 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];

    CGPoint offset = self.collectionView.contentOffset;
    if (kMidOffsetX<=0) {
        CGFloat space = 8.0;
        CGFloat half = 15.0;
        
        kMidOffsetX = offset.x+space+half;
    }
    self.collectionView.contentOffset = CGPointMake(kMidOffsetX, 0);
    
}


- (CGFloat)scrollUnitWidth{
    CGFloat space = 8;
    CGFloat scrollUnitWidth = self.itemSize.width+space;
    return scrollUnitWidth;
}

////cell将要出现的时候就调用一次。
//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    //记录将要出现的cell，来作为下面的是否换cell做判断。
//    self.nextItem = (int)indexPath.item;
//}
//
////这个方法是上一个视图完全消失，就调用一次
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    /**
//     例如：5123451来做判断，
//     如果当前的内容是第一个5，则直接无动画的转到倒数第二个的5。
//     如果当前内容是最后一个1，则无动画的跳转到正数第二个1。
//     */
//    if (indexPath.item == 1 && self.nextItem == 0) {
//        NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForItem:(self.imageArr.count - 2) inSection:0];
//        [collectionView scrollToItemAtIndexPath:tmpIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//    }else if ((indexPath.item == (self.imageArr.count - 2)) && (self.nextItem == (self.imageArr.count - 1))){
//        NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
//        [self.collectionView scrollToItemAtIndexPath:tmpIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//    }else{
//
//    }
//
//
//    if(indexPath.item == self.imageArr.count - 1){
//        self.endDisplayItem = 0;
//    }else{
//
//    }
//
//}
//
////这里是定时器所调用的方法，每调用一次，都向前一张跳转。这里为什么使用self.endDisplayItem而不是使用self.nextItem呢？原因是当你手动拖动的时候，只要稍微拖动一下，就会改变self.nextItem的值，等到定时器下次跳转的时候就会跳转两张，用户体验不是很好。
//- (void)circularRollViewToNextItem
//{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(self.endDisplayItem + 2) inSection:0];
//    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//}




//#pragma mark - UIScrollViewDelegate -
//
//-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    int tempIndex = self.collectionView.contentOffset.x / self.unitOffset;
//    if (tempIndex == self.imageArr.count+1) {
//        /** 到了最后一个*/
//        self.curIndex = 0;
//        [self.collectionView setContentOffset:CGPointMake(self.unitOffset, 0) animated:NO];
//    }
//}
//
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    /** 拖动开始时，需要将定时器关了*/
//    [self stopTimer];
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (scrollView == self.collectionView) {
//        [self handleCurIndexWithOffsetX:self.collectionView.contentOffset.x tag:0];
//    }
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    CGFloat width = self.frame.size.width;
//    NSInteger index = scrollView.contentOffset.x / width;
//
//    //当滚动到最后一张图片时，继续滚向后动跳到第一张
//    if (index == self.imageArr.count + 1)
//    {
//        self.curIndex = 1;
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.curIndex inSection:0];
//        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//        return;
//    }
//
//    //当滚动到第一张图片时，继续向前滚动跳到最后一张
//    //当且仅当滚过第0张图片的一半的时候，滚动到最后一张
//    if (scrollView.contentOffset.x < width * 0.5){
//        self.curIndex = (int)self.imageArr.count;
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.curIndex inSection:0];
//        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//        return;
//    }
//
//}
#pragma mark - UICollectionViewDelegate * datasource -

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageArr.count == 0) {
        return 1;
    } else if(self.imageArr.count == 1) {
        return 1;
    } else {
        return self.imageArr.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"gallaryImageCollectionCell" forIndexPath:indexPath];
    NSString *imageUrl = @"";
    
//    cell.contentView.layer.shadowOpacity = 0.3;
//    cell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
//    cell.contentView.layer.shadowRadius = 4;
//    cell.contentView.layer.shadowOffset = CGSizeMake(0, 2);
    
    [cell.contentView removeAllSubviews];

    if (self.placeholdImage == nil) {
        self.placeholdImage = @"icon_placeholer";
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.contentView.bounds];
    imageView.backgroundColor = kThemeColorBg;
    imageView.layer.cornerRadius = 4;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeCenter;
    [cell.contentView addSubview:imageView];
    
    if(self.imageArr.count == 1){
        imageUrl = self.originItems[0];
    }
    else{
        NSInteger selectIndex = indexPath.item%(self.originItems.count);
        
//        NSLog(@"----------indexPath=%d",selectIndex);

        imageUrl = self.originItems[selectIndex];
    }
    
    __weak typeof(imageView)weakImageView = imageView;
    [imageView setImgWithUrl:imageUrl completed:^(UIImage * _Nonnull image) {
        if (image) {
            weakImageView.backgroundColor = UIColor.whiteColor;
        }
    }];
//    #warning &&&& test -->>>>>
//        imageUrl = nil;
//        imageView.image = nil;
//    #warning <<<<<<-- test &&&&
//    UILabel *lab = [[UILabel alloc] init];
//    lab.font = FONT_Akrobat_ExtraBold(40);
//    lab.textColor = UIColor.brownColor;
//    lab.text = [NSString stringWithFormat:@"%d",idx];
//    [cell.contentView addSubview:lab];
//    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.offset(0);
//    }];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger selectIndex = indexPath.item%(self.originItems.count);

    if ([self.delegate respondsToSelector:@selector(gallaryView:didSelectedRowAtIndex:)]) {
        [self.delegate gallaryView:self didSelectedRowAtIndex:selectIndex];
    }
}



//手动拖拽结束
- (void)scrollViewDidEndDecelerating:(UICollectionView *)scrollView {
   NSIndexPath *indexPath = [scrollView indexPathsForVisibleItems].lastObject;

    [self cycleScrollWithIndexPath:indexPath];
}


/**
 例如：4 01234 0来做判断，
 A.如果当前的内容是第一个4，则直接无动画的转到倒数第二个的4。
 B.如果当前内容是最后一个0，则无动画的跳转到正数第二个0。
 */

- (void)cycleScrollWithIndexPath:(NSIndexPath*)indexPath {
    
    NSLog(@"----------cycleScrollWithIndexPath index=%d",indexPath.item);

    if (indexPath.item == 0) {//A情况，滑到最左时，跳转到倒数第二个
        self.collectionView.contentOffset = CGPointMake(kMidOffsetX, 0);
    }
    else if (indexPath.item == self.imageArr.count-1){//B情况
        self.collectionView.contentOffset = CGPointMake(kMidOffsetX, 0);
    }
    else{//正常滑动

    }
}


@end
