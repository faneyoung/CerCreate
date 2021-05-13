//
//  ZXYinView.m
//  ZXSDSmile
//
//  Created by Fane on 2021/5/10.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXYinView.h"

#define MaxWordNum     12

#define DEG(angle) (angle * M_PI / 180.0)
#define P_SIN(radius, angle) (radius * sin(angle * M_PI / 180.0))
#define P_COS(radius, angle) (radius * cos(angle * M_PI / 180.0))

#define degreesToRadians(degrees) ((degrees * (float)M_PI) / 180.0f)


@interface ZXYinView ()

@property (weak, nonatomic) IBOutlet UIView *starImgView;
@property (weak, nonatomic) IBOutlet UILabel *lab;

@property (nonatomic, assign) CGPoint pointcenter;

@end

@implementation ZXYinView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

- (instancetype)instancetWithFrame:(CGRect)frame{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil];
    ZXYinView *bookView = [[nib instantiateWithOwner:nil options:nil] firstObject];
    bookView.frame = frame;
    return bookView;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    [self setupSubViews];
}



- (void)setupSubViews{
    
    [self initOutCircle];
//    [self drawInnerCircle];
    [self drawStar];

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
    
    CGPoint center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);
    
    CGContextAddArc(context, center.x, center.y, yinWidth/2.0f, 0, 2*M_PI, 0); //添加一个圆
    
    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
    
    

    
    
}

- (void)drawInnerCircle{
    CGFloat lineBorderWidth = 0;///外边的线宽
    CGFloat yinWidth = 0;///印的直径

    lineBorderWidth = 1.0;
    yinWidth = 204.0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*画圆*/
    //边框圆
    CGContextSetRGBStrokeColor(context,204/255.0,0,0,1.0);//画笔线的颜色
    //画大圆并填充颜
    UIColor* aColor = [UIColor colorWithRed:1 green:1.0 blue:1 alpha:0];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextSetLineWidth(context, lineBorderWidth);//线的宽度
    
    CGPoint center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);

    CGContextAddArc(context, center.x, center.y, yinWidth/2.0f, 0, 2*M_PI, 0); //添加一个圆
    
    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充

}


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

- (void)drawRegistUnit{
    NSMutableArray *units = [NSMutableArray arrayWithCapacity:self.registUnit.length];
    for (int i=0; i<self.registUnit.length;i++) {
        [units addObject:[self.registUnit substringWithRange:NSMakeRange(i, 1)]];
    }
    
    
    CGRect rect = self.frame;
    float dist = (rect.size.width-2*70)/2.0;//半径
    
    CGFloat total = 360.0 - 60.0;
    
    int wordsCount = (int)(units.count);
    CGFloat itemDeg = total/wordsCount;
    
    int count = wordsCount;
    
    CGFloat itemWidth = 70;
    CGFloat itemHeigt = 100;
    while (count >= 1) {
        float angle = degreesToRadians(itemDeg * (count+0.7));
        float y = cos(angle) * dist;
        float x = sin(angle) * dist;

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = FONT_Songti_bold(70);
//        btn.backgroundColor = UIColor.lightGrayColor;
        [btn setTitleColor:UICOLOR_FROM_HEX(0xCC0000) forState:UIControlStateNormal];
        btn.tag = 100 + wordsCount - count;
        [btn setTitle:units[wordsCount - count] forState:UIControlStateNormal];
        btn.width = itemWidth;
        btn.height = itemHeigt;
        
        CGPoint center = CGPointMake(x + rect.size.width/2, y+rect.size.height/2);
        btn.center = center;
        [self addSubview:btn];
        count --;
        
        
    }
    
    
    [self reframeBtns];
    
    
    

}

- (void)reframeBtns{
    NSMutableArray *units = [NSMutableArray arrayWithCapacity:self.registUnit.length];
    for (int i=0; i<self.registUnit.length;i++) {
        [units addObject:[self.registUnit substringWithRange:NSMakeRange(i, 1)]];
    }
    
    int allWorders = (int)units.count;
    CGFloat deltaDegress = 30.0;
    CGFloat allDegress = 180.0 - deltaDegress;
    CGFloat itemDegress = allDegress*2.f/allWorders + 3.0;
    
    for (int i=0; i<allWorders; i++) {
        UIButton *btn = [self viewWithTag:i+100];
        
        CGFloat degress = 0.0;
        
        if (i+1<allWorders/2) {
            degress = - ((allWorders/2 - 1 - i)*itemDegress);
        }
        else{
            degress =  ((i - allWorders/2)*itemDegress)+5;
        }
        
//        if (i == 2) {
//            degress = degress - 3;
//        }
//        if (i == 3) {
//            degress = degress - 5;
//        }
//        if (i == 4) {
//            degress = degress - 15;
//        }
//        if (i == 6) {
//            degress = degress + 15;
//        }

        
        float angle = degreesToRadians(degress);
        
        btn.transform = CGAffineTransformMakeRotation(angle);
        
    }

}

#pragma mark - data -
- (void)setRegistUnit:(NSString *)registUnit{
    _registUnit = registUnit;
    [self drawRegistUnit];
    
    
}

@end
