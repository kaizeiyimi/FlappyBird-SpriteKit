//
//  XLBirdNode.h
//  flappyBird-kaizei
//
//  Created by 王凯 on 14-3-13.
//  Copyright (c) 2014年 王凯. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface XLBirdNode : SKSpriteNode

- (instancetype)init;

- (void)setReady;
- (void)flyForever;
- (void)flap;

@end
