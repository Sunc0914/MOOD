//
//  UIView+Progress.m
//  wCityHB
//
//  Created by apple on 11-10-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIView+Progress.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView(Progress)

#define PROGRESS_FOR_UIVIEW_TAG 9907


-(void)showProgress:(BOOL)show text:(NSString *)text {
    if(show) {
        
        UIView *progressView = [self viewWithTag: PROGRESS_FOR_UIVIEW_TAG];
        if (progressView) {
            return;
        }
        
		UIActivityIndicatorView *progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
											 UIActivityIndicatorViewStyleWhiteLarge];
        
        progressView = [[UIView alloc] initWithFrame:CGRectMake(0,0,80,80)];
		progressView.backgroundColor = [UIColor blackColor];
		progressView.layer.cornerRadius = 10;
		progressView.alpha = 0.8f;
		[progressView addSubview: progress];
		progress.center = progressView.center;
		[progress startAnimating];
        progressView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-40);
		progressView.tag = PROGRESS_FOR_UIVIEW_TAG;
		[self addSubview: progressView];
		
		UILabel *loadText = [[UILabel alloc]initWithFrame: CGRectMake(0, 55, 80, 20)];
		loadText.backgroundColor =[UIColor clearColor];
		loadText.font = [UIFont systemFontOfSize:12];
		loadText.textAlignment = NSTextAlignmentCenter;
		loadText.textColor = [UIColor whiteColor];
		loadText.text = text;
		[progressView addSubview: loadText];
		
		[loadText release];
		
		[progress release];
		[progressView release];
	} else {
        
		UIView *progressView = [self viewWithTag: PROGRESS_FOR_UIVIEW_TAG];
		[progressView removeFromSuperview];
		progressView = nil;
	}
}

- (void)showProgress:(BOOL)show{
	if(show) {
        
        UIView *progressView = [self viewWithTag: PROGRESS_FOR_UIVIEW_TAG];
        if (progressView) {
            return;
        }
        
		UIActivityIndicatorView *progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
											 UIActivityIndicatorViewStyleWhiteLarge];

        progressView = [[UIView alloc] initWithFrame:CGRectMake(0,0,80,80)];
		progressView.backgroundColor = [UIColor blackColor];
		progressView.layer.cornerRadius = 10;
		progressView.alpha = 0.8f;
		[progressView addSubview: progress];
		progress.center = progressView.center;
        
		[progress startAnimating];
        progressView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-40);
		progressView.tag = PROGRESS_FOR_UIVIEW_TAG;
		[self addSubview: progressView];
		
		UILabel *loadText = [[UILabel alloc]initWithFrame: CGRectMake(0, 55, 80, 20)];
		loadText.backgroundColor =[UIColor clearColor];
		loadText.font = [UIFont systemFontOfSize:12];
		loadText.textAlignment = NSTextAlignmentCenter;
		loadText.textColor = [UIColor whiteColor];
		loadText.text = @"请等待...";
		[progressView addSubview: loadText];
		
		[loadText release];
		
		[progress release];
		[progressView release];
        
        
	} else {
        
		UIView *progressView = [self viewWithTag: PROGRESS_FOR_UIVIEW_TAG];
		[progressView removeFromSuperview];
		progressView = nil;
	}
}

- (void)showProgressWithOutText:(BOOL)show{
	if(show) {
		UIActivityIndicatorView *progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
											 UIActivityIndicatorViewStyleWhite];
		[progress startAnimating];
		progress.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
		progress.tag = PROGRESS_FOR_UIVIEW_TAG;
		[self addSubview: progress];
		[progress release];
	} else {
		UIView *progress = [self viewWithTag: PROGRESS_FOR_UIVIEW_TAG];
		[progress removeFromSuperview];
		progress = nil;
	}
}
-(void)drawRectShadow{
	self.layer.borderColor=[[UIColor whiteColor] CGColor];
	self.layer.borderWidth=1;
	self.layer.shadowOffset = CGSizeMake(2, 2);
	self.layer.shadowRadius = 1.0;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOpacity = 0.8;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;	
}

-(void)drawShadow{
	self.layer.borderColor=[[UIColor whiteColor] CGColor];
	self.layer.borderWidth=1;
	self.layer.shadowOffset = CGSizeMake(2, 2);
	self.layer.shadowRadius = 1.0;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOpacity = 0.8;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;	
}

//-(void)drawShadow{
//    
//	// 设定CALayer
//	self.layer.cornerRadius =2.0;
//	//self.layer.frame = CGRectInset(self.layer.frame, 2, 2);
//	
//	self.layer.shadowOffset = CGSizeMake(2, 2);
//	self.layer.shadowRadius = 1.0;
//	self.layer.shadowColor = [UIColor blackColor].CGColor;
//	self.layer.shadowOpacity = 0.8;
//    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
//    //self.layer.shouldRasterize = YES;
//}

- (void)showResult:(ResultViewType)type text:(NSString *)text
{
	UIView *resultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
	resultView.userInteractionEnabled = NO;
	resultView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	resultView.backgroundColor = [UIColor clearColor];
	resultView.alpha = 0.0;
	
	UIImage *image;
	if (type == ResultViewTypeOK) {
		image = [UIImage imageNamed:@"成功提示.png"];
	}
	else if (type == ResultViewTypeFaild) {
		image = [UIImage imageNamed:@"失败提示.png"];
	}
	else if (type == ResultViewTypeCancel) {
		image = [UIImage imageNamed:@"取消提示.png"];
	}
	
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
	imageView.image = image;
	[resultView addSubview:imageView];
	[imageView release];
	
	UILabel *loadText = [[UILabel alloc]initWithFrame: CGRectMake(0, 65, 100, 20)];
	loadText.backgroundColor =[UIColor clearColor];
	loadText.adjustsFontSizeToFitWidth = YES;
	loadText.font = [UIFont boldSystemFontOfSize: 15];
	loadText.textAlignment = NSTextAlignmentCenter;
	loadText.textColor = [UIColor whiteColor];
	loadText.text = text;
	[resultView addSubview:loadText];
	[loadText release];
	
	[self addSubview:resultView];
	[resultView release];
	
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:0.3];   
	[UIView setAnimationDelegate:self];  
	resultView.alpha = 1.0;
	[UIView commitAnimations];
	
	[self performSelector:@selector(hideResultView:) withObject:resultView afterDelay:1.3];
}

- (void)hideResultView:(UIView *)resultView
{
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:0.3];   
	[UIView setAnimationDelegate:self];  
	resultView.alpha = 0.0;
	[UIView commitAnimations];
	
	[self performSelector:@selector(removeResultView:) withObject:resultView afterDelay:0.3];
}

- (void)removeResultView:(UIView *)resultView
{
	[resultView removeFromSuperview];
}

- (void)wjShowProgress:(BOOL)show moveX:(float)x moveY:(float)y{
	if(show) {
        
        UIView *progressView = [self viewWithTag: PROGRESS_FOR_UIVIEW_TAG];
        if (progressView) {
            return;
        }
        
		UIActivityIndicatorView *progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
											 UIActivityIndicatorViewStyleWhiteLarge];
        
        progressView = [[UIView alloc] initWithFrame:CGRectMake(0,0,80,80)];
		progressView.backgroundColor = [UIColor blackColor];
		progressView.layer.cornerRadius = 10;
		progressView.alpha = 0.8f;
		[progressView addSubview: progress];
		progress.center = progressView.center;
		[progress startAnimating];
        progressView.center = CGPointMake(self.frame.size.width/2 + x, self.frame.size.height/2-40 + y);
		progressView.tag = PROGRESS_FOR_UIVIEW_TAG;
		[self addSubview: progressView];
		
		UILabel *loadText = [[UILabel alloc]initWithFrame: CGRectMake(0, 55, 80, 20)];
		loadText.backgroundColor =[UIColor clearColor];
		loadText.font = [UIFont systemFontOfSize:12];
		loadText.textAlignment = NSTextAlignmentCenter;
		loadText.textColor = [UIColor whiteColor];
		loadText.text = @"请等待...";
		[progressView addSubview: loadText];
		
		[loadText release];
		
		[progress release];
		[progressView release];
	} else {
        
		UIView *progressView = [self viewWithTag: PROGRESS_FOR_UIVIEW_TAG];
		[progressView removeFromSuperview];
		progressView = nil;
	}
}

@end
