//
//  HDVideoPlayerView.h
//  HDCP
//
//  Created by 徐琰璋 on 16/3/20.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDVideoPlayerView : UIView

@property (nonatomic, strong, readonly) UIView *topBar;
@property (nonatomic, strong, readonly) UIView *bottomBar;
@property (nonatomic, strong, readonly) UIButton *playButton;
@property (nonatomic, strong, readonly) UIButton *pauseButton;
@property (nonatomic, strong, readonly) UIButton *fullScreenButton;
@property (nonatomic, strong, readonly) UIButton *shrinkScreenButton;
@property (nonatomic, strong, readonly) UISlider *progressSlider;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) BOOL isPauseing;

- (void)animateHide;
- (void)animateShow;
- (void)autoFadeOutControlBar;
- (void)cancelAutoFadeOutControlBar;

@end
