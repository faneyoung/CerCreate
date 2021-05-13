//
//  ZXCircleView.m
//  ZXSDSmile
//
//  Created by Fane on 2021/5/10.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXCircleView.h"
#import "ZXCircelLayout.h"
#import "ZXCircleWordCell.h"

#define MaxWordNum     16

#define DEG(angle) (angle * M_PI / 180.0)
#define P_SIN(radius, angle) (radius * sin(angle * M_PI / 180.0))
#define P_COS(radius, angle) (radius * cos(angle * M_PI / 180.0))

@interface ZXCircleView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIImageView *starImgView;

@property (nonatomic, assign) CGPoint pointcenter;

@property (nonatomic, strong) NSArray *titles;


@end

@implementation ZXCircleView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self setupSubView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    ///转盘的中心点
    _pointcenter = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);
    
    [self initOutCircle];

}
#pragma mark - views -

- (void)drawStar{
    
    
    CGFloat r = self.starImgView.bounds.size.height / 2;//五角星外接圆半径
    //    CGFloat radius_scale = 3 - 4 * sin(DEG(18)) * sin(DEG(18));内外圆半径比
    //    CGFloat inside_radius = out_radius / radius_scale;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint point1 = CGPointMake(0, -r);//顶部的点，开始顺时针，
    CGPoint point2 = CGPointMake(P_COS(r, 18), -P_SIN(r, 18));
    CGPoint point3 = CGPointMake(P_COS(r, 54), P_SIN(r, 54));
    CGPoint point4 = CGPointMake(-P_SIN(r, 36), P_COS(r, 36));
    CGPoint point5 = CGPointMake(-P_COS(r, 18), -P_SIN(r, 18));
    
    //    注意连接的顺序
    [path moveToPoint:point1];
    [path addLineToPoint:point3];
    [path addLineToPoint:point5];
    [path addLineToPoint:point2];
    [path addLineToPoint:point4];
    
    //    [path closePath];//调不调用都可以
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //    layer.anchorPoint = CGPointMake(0.5, 0.5);动画中心点
    shapeLayer.fillRule = kCAFillRuleNonZero; //kCAFillRuleEvenOdd
    //    从矩形的中心（五角星外接圆的中心，方便坐标计算）开始   有一部分是绘制到了layer外面
    CGRect rect = self.starImgView.frame;
    shapeLayer.frame = CGRectMake(rect.origin.x+r, rect.origin.y+r, self.starImgView.bounds.size.height, self.starImgView.bounds.size.height);
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = UIColorFromHex(0xcc0000).CGColor;
    
    [self.layer addSublayer:shapeLayer];

}

- (void)setupSubView{
    _starImgView = [[UIImageView alloc] init];
    _starImgView.contentMode = UIViewContentModeScaleToFill;
//    _starImgView.image = UIImageNamed(@"icon_cer_star");
    [self addSubview:self.starImgView];
    [self.starImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.height.mas_equalTo(140);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self drawStar];
    });
    
//    ZXCircelLayout *layout = [[ZXCircelLayout alloc] init];
//    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
//    collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.02];
//    collectionView.delegate=self;
//    collectionView.dataSource=self;
//
//    [collectionView registerNib:[UINib nibWithNibName:@"ZXCircleWordCell" bundle:nil] forCellWithReuseIdentifier:@"ZXCircleWordCell"];
//    [self addSubview:collectionView];
//    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.inset(15);
//    }];
//    self.collectionView = collectionView;
    
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lab = [[UILabel alloc] init];
        lab.textColor = UIColorFromHex(0xcc0000);
        lab.font = FONT_Songti_bold(50);
        lab.text = obj;
        [self addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(50);

        }];
    }];
    
    
}

////初始化基本图案 （外圈、中间的图案）
-(void)initOutCircle
{
    
    CGFloat lineBorderWidth = 15.0;///外边的线宽
    CGFloat yinWidth = self.bounds.size.width-2*lineBorderWidth;///印的直径
    
    //An opaque type that represents a Quartz 2D drawing environment.
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*画圆*/
    //边框圆
    CGContextSetRGBStrokeColor(context,204/255.0,0,0,1.0);//画笔线的颜色
    //画大圆并填充颜
    UIColor* aColor = [UIColor colorWithRed:1 green:1.0 blue:1 alpha:0];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextSetLineWidth(context, lineBorderWidth);//线的宽度
    CGContextAddArc(context, _pointcenter.x, _pointcenter.y, yinWidth/2.0f, 0, 2*M_PI, 0); //添加一个圆
    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
}

- (NSArray *)titles{
    if (!_titles) {

        NSString *words = @"上海市青浦区市场监督管理局";
        
        NSMutableArray *tmps = [NSMutableArray arrayWithCapacity:MaxWordNum];
        for (int i=0; i<words.length; i++) {
            NSString *word = [words substringWithRange:NSMakeRange(i, 1)];
            [tmps addObject:word];
        }
        
        for (int i=(int)tmps.count-1; i<MaxWordNum; i++) {
            [tmps addObject:@" "];
        }
        
        _titles = tmps.copy;

    }
    return _titles;
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MaxWordNum;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXCircleWordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXCircleWordCell" forIndexPath:indexPath];
    cell.backgroundColor = UIColor.lightGrayColor;
    cell.titleLab.text = self.titles[indexPath.item];
    cell.transform = CGAffineTransformMakeRotation(M_PI_2*indexPath.item/MaxWordNum);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

}



@end
