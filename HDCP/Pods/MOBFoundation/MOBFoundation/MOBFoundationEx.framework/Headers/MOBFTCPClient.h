//
//  MOBFSocket.h
//  CFNetworkDemo
//
//  Created by fenghj on 15/8/18.
//  Copyright © 2015年 vimfung. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(unsigned int, MOBFTCPClientState)
{
    MOBFTCPClientStateNone             = 0,
    MOBFTCPClientStateConnecting       = 1,
    MOBFTCPClientStateConnected        = 2,
    MOBFTCPClientStateClosing          = 3,
    MOBFTCPClientStateClosed           = 4,
};

/**
 *  Socket连接处理器
 */
typedef void (^MOBFTCPClientConnectedHandler) ();

/**
 *  Socket断开连接处理器
 *
 *  @param error 错误信息
 */
typedef void (^MOBFTCPClientDisconnectedHandler) (NSError *error);

/**
 *  Socket接收数据处理器
 *
 *  @param data 数据
 */
typedef void (^MOBFTCPClientReceiveDataHandler) (NSData *data);


@class MOBFTCPClient;

@protocol MOBFTCPClientDelegate <NSObject>

@optional
- (void)tcpClient:(MOBFTCPClient *)tcpClient didState:(MOBFTCPClientState)state;
- (void)tcpClient:(MOBFTCPClient *)tcpClient didReceiveData:(NSData *)data;
- (void)tcpClient:(MOBFTCPClient *)tcpClient didFailWithError:(NSError *)error;
- (void)tcpClient:(MOBFTCPClient *)tcpClient didCloseWithError:(NSError *)error;

@end

/**
 *  Socket实现
 */
@interface MOBFTCPClient : NSObject

/**
 *  主机
 */
@property (nonatomic, copy, readonly) NSString *host;

/**
 *  端口
 */
@property (nonatomic, readonly) UInt32 port;

/**
 * 设置连接超时时间
 */
@property (nonatomic, assign) UInt64 timeoutInterval;

/**
 * 设置代理
 */
@property (nonatomic, weak) id<MOBFTCPClientDelegate> delegate;

/**
 *  初始化Socket
 *
 *  @param host 主机名称
 *  @param port 端口号
 *
 *  @return Socket对象
 */
- (instancetype)initWithHost:(NSString *)host port:(UInt32)port;

/**
 *  连接
 *
 *  @return YES 连接成功，NO 连接失败
 */
- (BOOL)connect;

/**
 *  断开连接
 */
- (void)disconnect;

/**
 *  写入数据
 *
 *  @param data 数据
 */
- (void)sendData:(NSData *)data;

/**
 *  设置心跳数据 及 间隔多少秒发送一次心跳包,调用该方法后才会启动, PingData=nil||duration<10 取消自动心跳
 *
 *  @param data 发送心跳数据
 *  @param duration 心跳包间隔
 */
- (void)setHeartbeatWithPingData:(NSData *)pingData duration:(UInt64)duration;

/**
 *  已连接事件
 *
 *  @param handler 事件处理器
 */
- (void)onConnected:(MOBFTCPClientConnectedHandler)handler;

/**
 *  已断开链接事件
 *
 *  @param handler 事件处理器
 */
- (void)onDisconnected:(MOBFTCPClientDisconnectedHandler)handler;

/**
 *  接收数据
 *
 *  @param handler 事件处理器
 */
- (void)onReceiveData:(MOBFTCPClientReceiveDataHandler)handler;

@end
