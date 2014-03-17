//
//  XLBirdNode.m
//  flappyBird-kaizei
//
//  Created by 王凯 on 14-3-13.
//  Copyright (c) 2014年 王凯. All rights reserved.
//

#import "XLBirdNode.h"

@interface XLBirdNode ()

@property (nonatomic, strong) SKAction *flapAction;

@end

@implementation XLBirdNode

static NSString * const kXLBirdFlyingForeverActionKey = @"kXLBirdFlyingForeverActionKey";

- (instancetype)init
{
    if (self = [super initWithImageNamed:@"birdFlying1"]) {
        SKTexture* birdTexture1 = [SKTexture textureWithImageNamed:@"birdFlying1"];
        SKTexture* birdTexture2 = [SKTexture textureWithImageNamed:@"birdFlying2"];
        SKTexture* birdTexture3 = [SKTexture textureWithImageNamed:@"birdFlying3"];
        self.flapAction = [SKAction animateWithTextures:@[birdTexture1, birdTexture2, birdTexture3] timePerFrame:0.2];
    }
    return self;
}

- (void)flyForever
{
    [self runAction:[SKAction repeatActionForever:self.flapAction]];
    
    SKAction *moveUp = [SKAction moveByX:0 y:40 duration:1];
    SKAction *moveDown = [SKAction moveByX:0 y:-40 duration:1];
    SKAction *move = [SKAction sequence:@[moveUp, moveDown]];
    [self runAction:[SKAction repeatActionForever:move]];
}

- (void)setReady
{
    [self removeAllActions];
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(30, 20)];
    self.physicsBody.categoryBitMask = kXLBirdBitMask;
    self.physicsBody.mass = 0.1;
    SKAction *rotation = [SKAction runBlock:^{
        self.zRotation = M_PI * self.physicsBody.velocity.dy * 0.0003;
    }];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:1.0/60], rotation]]]];
}

- (void)flap
{
    [self.physicsBody setVelocity:CGVectorMake(0, 0)];
    [self.physicsBody applyImpulse:CGVectorMake(0, 40)];
    [self runAction:[SKAction repeatAction:self.flapAction count:2]];
}

@end
