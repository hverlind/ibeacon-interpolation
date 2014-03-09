//
//  View.m
//  Observer
//
//  Created by Hannes Verlinde on 08/03/14.
//  Copyright (c) 2014 In the Pocket. All rights reserved.
//

#import "View.h"

@interface View ()

@property (nonatomic, strong) NSMutableDictionary *mapping;

@end

@implementation View

- (void)setAccuracy:(double)accuracy forBeacon:(NSNumber *)minor
{
    if (!self.mapping)
    {
        self.mapping = [[NSMutableDictionary alloc] init];
    }
    
    self.mapping[minor] = @(accuracy > 0 ? 1/(accuracy*accuracy) : 0);
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint observer = CGPointZero;
    
    double sum = 0;
    
    for (NSNumber *key in self.mapping)
    {
        NSUInteger index = [key unsignedIntegerValue];
        
        CGPoint beacon = CGPointMake(50 + (index / 2) * 500, 50 + (index % 2) * 500);
        
        CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
        CGContextFillEllipseInRect(context, CGRectMake(beacon.x - 10, beacon.y - 10, 20, 20));
        
        double value = [self.mapping[key] doubleValue];
        
        observer.x += value * beacon.x;
        observer.y += value * beacon.y;
        
        sum += value;
    }
    
    observer.x /= sum;
    observer.y /= sum;

    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(observer.x - 10, observer.y - 10, 20, 20));
}

@end
