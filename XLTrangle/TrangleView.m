//
//  TrangleView.m
//  iUnis
//
//  Created by 张雷 on 16/9/12.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "TrangleView.h"

@implementation TrangleView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(ctx, 210/255., 210/255., 210/255., 1);
    }
    return self;
}

//- (void)setType:(StatusType)type{
//    _type = type;
//    [self setNeedsDisplay];
//}
- (void)setTypeColor:(UIColor *)typeColor{
    _typeColor = typeColor;
    [self setNeedsDisplay];
}

- (NSArray *)getRGBWithColor:(UIColor *)color
{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}
- (void)drawRect:(CGRect)rect {
        
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    NSArray *rgbs = [self getRGBWithColor:_typeColor];
    CGContextSetRGBFillColor(ctx, [rgbs[0] floatValue], [rgbs[1] floatValue], [rgbs[2] floatValue], 1);
    
//    switch (_type) {
//        case StatusReday:{    // 待生产
//            CGContextSetRGBFillColor(ctx, 223/255., 129/255.f, 123/255.f, 1);
//        }break;
//        case StatusProducing:{    // 生产中
//            CGContextSetRGBFillColor(ctx, 242/255.f, 178/255.f, 62/255.f, 1);
//        }break;
//        case StatusNeedInspect:{    // 待商检
//            CGContextSetRGBFillColor(ctx, 229/255.f, 169/255.f, 58/255.f, 1);
//        }break;
//        case StatusInspecting:{    // 商检中
//            CGContextSetRGBFillColor(ctx, 169/255.f, 125/255.f, 206/255.f, 1);
//        }break;
//        case StatusNeedPackge:{    // 待包装||商检完毕
//            CGContextSetRGBFillColor(ctx, 244/255.f, 177/255.f, 62/255.f, 1);
//        }break;
//        case StatusPackging:{   // 包装中
//            CGContextSetRGBFillColor(ctx, 77/255., 154/255., 204/255., 1);
//        }break;
//        case StatusPackged:{    // 包装完毕
//            CGContextSetRGBFillColor(ctx, 242/255., 178/255., 62/255., 1);
//        }break;
//        case StatusOutGoing:{    // 出库中
//            CGContextSetRGBFillColor(ctx, 169/255., 153/255., 147/255., 1);
//        }break;
//        case StatusTransporting:{    // 运输中
//            CGContextSetRGBFillColor(ctx, 58/255., 108/255., 194/255., 1);
//        }break;
//            
//        default:    // default 历史状态
//            CGContextSetRGBFillColor(ctx, 230/255.f, 230/255.f, 230/255.f, 1);
//            break;
//    }
    
    CGPoint sPoints[3];
    sPoints[0] = CGPointMake(0, 0);
    sPoints[1] = CGPointMake(rect.size.width, rect.size.height/2.f);
    sPoints[2] = CGPointMake(0, rect.size.height);
    CGContextAddLines(ctx, sPoints, 3);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFill);
    
}


@end
