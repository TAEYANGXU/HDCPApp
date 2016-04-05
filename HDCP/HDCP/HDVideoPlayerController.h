//
//  HDVideoPlayerController.h
//  HDCP
//
//  Created by 徐琰璋 on 16/3/20.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@protocol HDVideoPlayerDelegate <NSObject>

//全屏回调
-(void) didFullScreen;
//缩放回调
-(void) didshrinkScreen;

@end

@interface HDVideoPlayerController : MPMoviePlayerController

@property (nonatomic, strong) UIImageView *movieBackgroundView;

@property (nonatomic,weak) id<HDVideoPlayerDelegate> delegate;

@property (nonatomic, assign) CGRect frame;

- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  关闭视频
 */
- (void)close;
@end
