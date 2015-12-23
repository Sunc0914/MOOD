//
//  UIView+Progress.h
//  wCityHB
//
//  Created by apple on 11-10-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	ResultViewTypeOK,
	ResultViewTypeFaild,
	ResultViewTypeCancel,
} ResultViewType;

@interface UIView(Progress)

- (void)showProgress:(BOOL)show;
- (void)showProgressWithOutText:(BOOL)show;
- (void)drawShadow;
- (void)drawRectShadow;
- (void)showResult:(ResultViewType)type text:(NSString *)text;	//结果提示窗

-(void)showProgress:(BOOL)show text:(NSString *)text;

- (void)wjShowProgress:(BOOL)show moveX:(float)x moveY:(float)y;

@end
