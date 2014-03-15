//
//  XLHorizontalScrollingLeftNode.h
//  flappyBird-kaizei
//
//  Created by 王凯 on 14-3-13.
//  Copyright (c) 2014年 王凯. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface XLHorizontalScrollingLeftNode : SKSpriteNode

@property (nonatomic, assign, readonly) CGFloat scrollingSpeed;

+ (instancetype)nodeWithImageNamed:(NSString *)imageName width:(float)width scrollingSpeed:(CGFloat)scrollingSpeed;
- (void)setScrollingEnabled:(BOOL)enabled;

@end
