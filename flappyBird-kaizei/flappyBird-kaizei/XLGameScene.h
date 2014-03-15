//
//  XLGameScene.h
//  flappyBird-kaizei
//

//  Copyright (c) 2014年 王凯. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class XLGameScene;

@protocol XLGameSceneDelegate <NSObject>

- (void)gameSceneGameStarted:(XLGameScene *)scene;
- (void)gameScene:(XLGameScene *)scene didGetScore:(NSInteger)score;
- (void)gameSceneGameEnded:(XLGameScene *)scene;

@end


@interface XLGameScene : SKScene

@property (nonatomic, weak) id<XLGameSceneDelegate> delegate;

@end
