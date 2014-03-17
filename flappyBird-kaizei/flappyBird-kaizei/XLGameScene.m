//
//  XLGameScene.m
//  flappyBird-kaizei
//
//  Created by 王凯 on 14-3-13.
//  Copyright (c) 2014年 王凯. All rights reserved.
//

#import "XLGameScene.h"

#import "XLHorizontalScrollingLeftNode.h"
#import "XLBirdNode.h"

@interface XLGameScene () <SKPhysicsContactDelegate>

@property (nonatomic, assign) BOOL gameStarted;
@property (nonatomic, weak) XLBirdNode *bird;
@property (nonatomic, weak) XLHorizontalScrollingLeftNode *floor;
@property (nonatomic, weak) XLHorizontalScrollingLeftNode *background;
@property (nonatomic, strong) NSMutableArray *pipes;
@property (nonatomic, assign) CFTimeInterval lastPipeGenerationTime;
@property (nonatomic, assign) NSInteger currentScore;

@end

@implementation XLGameScene

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.gameStarted = NO;
        //创建背景
        XLHorizontalScrollingLeftNode *background = [XLHorizontalScrollingLeftNode nodeWithImageNamed:@"background"
                                                                                        width:CGRectGetWidth(self.frame)
                                                                               scrollingSpeed:KXLBackgroundScrollingSpeed];
        [background setAnchorPoint:CGPointZero];
        [background setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
        background.physicsBody.categoryBitMask = kXLBlockBitMask;
        background.physicsBody.contactTestBitMask = kXLBirdBitMask;
        [self addChild:background];
        [background setScrollingEnabled:YES];
        self.background = background;
        //地板
        XLHorizontalScrollingLeftNode *floor = [XLHorizontalScrollingLeftNode nodeWithImageNamed:@"floor"
                                                                                   width:CGRectGetWidth(self.frame)
                                                                          scrollingSpeed:kXLFloorScrollingSpeed];
        [floor setAnchorPoint:CGPointZero];
        floor.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:floor.frame];
        floor.physicsBody.categoryBitMask = kXLBlockBitMask;
        floor.physicsBody.contactTestBitMask = kXLBirdBitMask;
        floor.position = CGPointMake(0, -(floor.size.height - kXLFloorHeight));
        floor.zPosition = 1;
        [self addChild:floor];
        [floor setScrollingEnabled:YES];
        self.floor = floor;
        //创建bird
        XLBirdNode *bird = [[XLBirdNode alloc]init];
        [bird setPosition:CGPointMake(CGRectGetMidX(self.frame) - 50, CGRectGetMidY(self.frame) - 20)];
        [self addChild:bird];
        [bird flyForever];
        self.bird = bird;
        
        self.pipes = [NSMutableArray arrayWithCapacity:6];
        
        self.physicsWorld.contactDelegate = self;
        self.lastPipeGenerationTime = 0.0;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.gameStarted) {
        self.gameStarted = YES;
    }
    [self.bird flap];
}

- (void)setGameStarted:(BOOL)gameStarted
{
    if (_gameStarted == gameStarted) {
        return;
    }
    _gameStarted = gameStarted;
    if (gameStarted) {
        [self.bird setReady];
        SKAction *wait = [SKAction waitForDuration:kXLPipeGenerationTimeInterval];
        SKAction *generate = [SKAction runBlock:^{[self generatePipes];}];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[wait,generate]]]];
        [self.delegate gameSceneGameStarted:self];
    } else {
        self.userInteractionEnabled = NO;
        [self.background setScrollingEnabled:NO];
        [self.floor setScrollingEnabled:NO];
        for (SKNode *pipe in self.pipes) {
            [pipe removeAllActions];
        }
        [self removeAllActions];
        [self.delegate gameSceneGameEnded:self];
    }
}

- (void)generatePipes
{
    long randomPositionY = random() % (long)(self.size.height - 4 * kXLFloorHeight - kXLPipeGapHeight) + 2 * kXLFloorHeight;
    
    CGFloat totalMoveDistance = self.size.width + kXLPipeWidth;
    SKAction *move = [SKAction moveByX:-totalMoveDistance y:0 duration:totalMoveDistance / kXLFloorScrollingSpeed];
    SKAction *pipeAction = [SKAction sequence:@[move, [SKAction removeFromParent]]];
    
    SKSpriteNode *bottomPipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipeBottom"];
    bottomPipe.anchorPoint = CGPointMake(0, 1);
    bottomPipe.position = CGPointMake(self.size.width, randomPositionY);
    bottomPipe.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, - bottomPipe.size.height, bottomPipe.size.width, bottomPipe.size.height)];
    bottomPipe.physicsBody.categoryBitMask = kXLBlockBitMask;
    bottomPipe.physicsBody.contactTestBitMask = kXLBirdBitMask;
    [self addChild:bottomPipe];
    [bottomPipe runAction:[SKAction sequence:@[pipeAction, [SKAction runBlock:^{[self.pipes removeObject:bottomPipe];}]]]];
    
    SKSpriteNode *topPipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipeTop"];
    topPipe.anchorPoint = CGPointMake(0, 0);
    topPipe.position = CGPointMake(self.size.width, randomPositionY + kXLPipeGapHeight);
    topPipe.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, topPipe.size.width, topPipe.size.height)];
    topPipe.physicsBody.categoryBitMask = kXLBlockBitMask;
    topPipe.physicsBody.contactTestBitMask = kXLBirdBitMask;
    [self addChild:topPipe];
    [topPipe runAction:[SKAction sequence:@[pipeAction, [SKAction runBlock:^{[self.pipes removeObject:topPipe];}]]]];
    
    [self.pipes addObjectsFromArray:@[bottomPipe, topPipe]];
    
    SKAction *timeAction = [SKAction waitForDuration:(CGRectGetMidX(self.frame) + 50 + kXLPipeWidth) / kXLFloorScrollingSpeed];
    [self runAction:[SKAction sequence:@[timeAction, [SKAction runBlock:^{
        self.currentScore += 1;
        [self.delegate gameScene:self didGetScore:self.currentScore];
    }]]]];
}

#pragma mark - contact delegate
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (self.gameStarted) {
        self.gameStarted = NO;
    }
}

@end
