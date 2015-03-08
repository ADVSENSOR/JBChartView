//
//  LineChartWithTooltipView.m
//  TemperatureSensor
//
//  Created by Harmon, Trevor on 3/4/15.
//  Copyright (c) 2015 ASI, Inc. All rights reserved.
//

#import "LineChartWithTooltipView.h"
#import "JBChartTooltipTipView.h"
#import "JBChartTooltipView.h"

CGFloat const kJBBaseChartViewControllerAnimationDuration = 0.25f;

@interface LineChartWithTooltipView ()

@property (nonatomic, strong) JBChartTooltipView *tooltipView;
@property (nonatomic, strong) JBChartTooltipTipView *tooltipTipView;

@end

@implementation LineChartWithTooltipView

- (void)setTooltipVisible:(BOOL)tooltipVisible animated:(BOOL)animated atTouchPoint:(CGPoint)touchPoint {
    if (!self.tooltipView)
    {
        self.tooltipView = [[JBChartTooltipView alloc] init];
        self.tooltipView.alpha = 0.0;
        [self addSubview:self.tooltipView];
    }
    
    [self bringSubviewToFront:self.tooltipView];
    
    if (!self.tooltipTipView)
    {
        self.tooltipTipView = [[JBChartTooltipTipView alloc] init];
        self.tooltipTipView.alpha = 0.0;
        [self addSubview:self.tooltipTipView];
    }
    
    [self bringSubviewToFront:self.tooltipTipView];

    dispatch_block_t adjustTooltipPosition = ^{
        CGPoint originalTouchPoint = touchPoint;
        CGPoint convertedTouchPoint = touchPoint;
        CGFloat minChartX = (self.bounds.origin.x + ceil(self.tooltipView.frame.size.width * 0.5));
        if (convertedTouchPoint.x < minChartX)
        {
            convertedTouchPoint.x = minChartX;
        }
        CGFloat maxChartX = (self.bounds.origin.x + self.bounds.size.width - ceil(self.tooltipView.frame.size.width * 0.5));
        if (convertedTouchPoint.x > maxChartX)
        {
            convertedTouchPoint.x = maxChartX;
        }
        self.tooltipView.frame = CGRectMake(convertedTouchPoint.x - ceil(self.tooltipView.frame.size.width * 0.5), CGRectGetMaxY(self.headerView.frame), self.tooltipView.frame.size.width, self.tooltipView.frame.size.height);
        
        CGFloat minTipX = (self.bounds.origin.x + self.tooltipTipView.frame.size.width);
        if (originalTouchPoint.x < minTipX)
        {
            originalTouchPoint.x = minTipX;
        }
        CGFloat maxTipX = (self.bounds.origin.x + self.bounds.size.width - self.tooltipTipView.frame.size.width);
        if (originalTouchPoint.x > maxTipX)
        {
            originalTouchPoint.x = maxTipX;
        }
        self.tooltipTipView.frame = CGRectMake(originalTouchPoint.x - ceil(self.tooltipTipView.frame.size.width * 0.5), CGRectGetMaxY(self.tooltipView.frame), self.tooltipTipView.frame.size.width, self.tooltipTipView.frame.size.height);
    };
    
    dispatch_block_t adjustTooltipVisibility = ^{
        self.tooltipView.alpha = tooltipVisible ? 1.0 : 0.0;
        self.tooltipTipView.alpha = tooltipVisible ? 1.0 : 0.0;
    };
    
    if (tooltipVisible)
    {
        adjustTooltipPosition();
    }
    
    if (animated)
    {
        [UIView animateWithDuration:kJBBaseChartViewControllerAnimationDuration animations:^{
            adjustTooltipVisibility();
        } completion:^(BOOL finished) {
            if (!tooltipVisible)
            {
                adjustTooltipPosition();
            }
        }];
    }
    else
    {
        adjustTooltipVisibility();
    }
}

- (void)setTooltipText:(NSString *)text {
    [self.tooltipView setText:text];
}

@end
