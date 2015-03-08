//
//  LineChartWithTooltipView.h
//  TemperatureSensor
//
//  Created by Harmon, Trevor on 3/4/15.
//  Copyright (c) 2015 ASI, Inc. All rights reserved.
//

#import "JBLineChartView.h"

@interface LineChartWithTooltipView : JBLineChartView

- (void)setTooltipVisible:(BOOL)tooltipVisible animated:(BOOL)animated atTouchPoint:(CGPoint)touchPoint;
- (void)setTooltipText:(NSString *)text;

@end
