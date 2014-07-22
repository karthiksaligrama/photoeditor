//
//  AnnotateView.m
//  PhotoEditor
//
//  Created by Karthik Saligrama on 7/21/14.
//  Copyright (c) 2014 Karthik Saligrama. All rights reserved.
//

#import "AnnotateView.h"

@interface AnnotateView()

@property (nonatomic, assign) CGPoint location;

@end

@implementation AnnotateView


@synthesize annotateColor;


- (id)initWithColor:(UIColor *)color;
{
    self = [super init];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        annotateColor = color;
    }
    return self;
}

-(void)annotationDone{
    self.userInteractionEnabled = NO;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.location = [touch locationInView:self];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 5.0);
    CGFloat red, green, blue, alpha;
    [annotateColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(ctx, red, green, blue, alpha);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, self.location.x, self.location.y);
    CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
    CGContextStrokePath(ctx);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.location = currentLocation;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 5.0);
    CGFloat red, green, blue, alpha;
    [annotateColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(ctx, red, green, blue, alpha);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, self.location.x, self.location.y);
    CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
    CGContextStrokePath(ctx);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.location = currentLocation;
}


@end
