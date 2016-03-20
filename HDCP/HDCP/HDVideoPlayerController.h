//
//  HDVideoPlayerController.h
//  HDCP
//
//  Created by 徐琰璋 on 16/3/20.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface HDVideoPlayerController : MPMoviePlayerController

@property (nonatomic, strong) UIImageView *movieBackgroundView;

//全屏回调
@property (nonatomic,copy) void(^fullScreenBlock)(void);
//缩放回调
@property (nonatomic,copy) void(^shrinkScreenBlock)(void);


@property (nonatomic, assign) CGRect frame;

- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  关闭视频
 */
- (void)close;
@end
