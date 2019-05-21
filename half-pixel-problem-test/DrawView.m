//
//  DrawView.m
//  half-pixel-problem-test
//
//  Created by 유동우 on 16/05/2019.
//  Copyright © 2019 frozenrainyoo. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] CGContext];


    // 1 width 라인 그리기.
    CGContextSaveGState(context);
    CGContextConcatCTM(context, CGContextGetUserSpaceToDeviceSpaceTransform(context));

    CGContextSetLineWidth(context, 1);
    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 1, 50);
    CGContextAddLineToPoint(context, 100, 50);
    CGContextStrokePath(context);

    CGContextRestoreGState(context);


    // 위와 같은 1 width인 선이라도 두께가 다르다.
    // 홀수에서만 발생한다.
    CGContextSaveGState(context);
    CGContextConcatCTM(context, CGContextGetUserSpaceToDeviceSpaceTransform(context));
    CGContextTranslateCTM(context, 0.5, 0.5); // workaround code

    CGContextSetLineWidth(context, 1);
    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 1, 100);
    CGContextAddLineToPoint(context, 100, 100);
    CGContextStrokePath(context);

    CGContextRestoreGState(context);


    // Translate 있는 상태의 CTM 정보 코드
    CGContextSaveGState(context);

    CGContextConcatCTM(context, CGContextGetUserSpaceToDeviceSpaceTransform(context));
    CGContextTranslateCTM(context, 0, 50);

    CGAffineTransform currentMapping = CGContextGetCTM(context);
    NSLog(@"currentMapping a=%f, b=%f, c=%f, d=%f, tx=%f, ty=%f", currentMapping.a,
          currentMapping.b, currentMapping.c, currentMapping.d, currentMapping.tx,
          currentMapping.ty);
    // (CGAffineTransform) $0 = (a = 1, b = 0, c = 0, d = -1, tx = 0, ty = 310)

    CGAffineTransform userSpace = CGContextGetUserSpaceToDeviceSpaceTransform(context);
    NSLog(@"userSpace a=%f, b=%f, c=%f, d=%f, tx=%f, ty=%f", userSpace.a,
          userSpace.b, userSpace.c, userSpace.d, userSpace.tx,
          userSpace.ty);
    // (CGAffineTransform) $1 = (a = 1, b = 0, c = 0, d = 1, tx = 0, ty = 50)

    CGPoint point1 = CGContextConvertPointToUserSpace(context, CGPointMake(5, 5));
    NSLog(@"point1 x=%f, y=%f", point1.x, point1.y);
    // (CGPoint) $2 = (x = 5, y = -45)

    CGPoint point2 = CGContextConvertPointToDeviceSpace(context, CGPointMake(5, 5));
    NSLog(@"point2 x=%f, y=%f", point2.x, point2.y);
    // (CGPoint) $2 = (x = 5, y = 55)

    CGContextRestoreGState(context);


    // Translate 없는 상태의 CTM 정보
    CGAffineTransform currentMapping2 = CGContextGetCTM(context);
    NSLog(@"currentMapping2 a=%f, b=%f, c=%f, d=%f, tx=%f, ty=%f", currentMapping2.a,
          currentMapping2.b, currentMapping2.c, currentMapping2.d, currentMapping2.tx,
          currentMapping2.ty);
    // (CGAffineTransform) $1 = (a = 1, b = 0, c = 0, d = 1, tx = 0, ty = 0)

    CGAffineTransform userSpace2 = CGContextGetUserSpaceToDeviceSpaceTransform(context);
    NSLog(@"userSpace2 a=%f, b=%f, c=%f, d=%f, tx=%f, ty=%f", userSpace2.a,
          userSpace2.b, userSpace2.c, userSpace2.d, userSpace2.tx,
          userSpace2.ty);
    // (CGAffineTransform) $0 = (a = 1, b = 0, c = 0, d = -1, tx = 0, ty = 360)

    CGPoint point3 = CGContextConvertPointToUserSpace(context, CGPointMake(5, 5));
    NSLog(@"point3 x=%f, y=%f", point3.x, point3.y);
    // (CGPoint) $2 = (x = 5, y = 355)

    CGPoint point4 = CGContextConvertPointToDeviceSpace(context, CGPointMake(5, 5));
    NSLog(@"point4 x=%f, y=%f", point4.x, point4.y);
    // (CGPoint) $2 = (x = 5, y = 355)
}

@end
