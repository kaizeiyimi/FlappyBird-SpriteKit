//
//  XLHorizontalScrollingLeftNode.m
//  flappyBird-kaizei
//
//  Created by 王凯 on 14-3-13.
//  Copyright (c) 2014年 王凯. All rights reserved.
//

#import "XLHorizontalScrollingLeftNode.h"

@interface XLHorizontalScrollingLeftNode ()

@property (nonatomic, assign) CGFloat scrollingSpeed;
@property (nonatomic, strong) SKAction *scrollingAction;

@end

@implementation XLHorizontalScrollingLeftNode

+ (instancetype)nodeWithImageNamed:(NSString *)imageName width:(float)width scrollingSpeed:(CGFloat)scrollingSpeed
{
    UIImage * image = [UIImage imageNamed:imageName];
    XLHorizontalScrollingLeftNode * node = [self spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(width, image.size.height)];
    node.scrollingSpeed = fabs(scrollingSpeed);
    NSInteger number = 0;
    CGFloat total = 0.0;
    while(total < (width + image.size.width)){
        SKSpriteNode * childNode = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        [childNode setAnchorPoint:CGPointZero];
        [childNode setPosition:CGPointMake(total, 0)];
        childNode.userData = [@{@"id":@(number++)} mutableCopy];
        [node addChild:childNode];
        total += image.size.width;
    }
    return node;
}

- (void)setScrollingEnabled:(BOOL)enabled
{
    if (enabled) {
        for (SKSpriteNode *child in self.children) {
            [self scrollChildNode:child];
        }
    } else {
        [self.children makeObjectsPerformSelector:@selector(removeAllActions)];
    }
}

- (SKAction *)scrollingAction
{
    if (!_scrollingAction) {
        SKSpriteNode *anyChild = [self.children firstObject];
        _scrollingAction = [SKAction moveByX:-anyChild.size.width y:0 duration:anyChild.size.width / self.scrollingSpeed];
    }
    return _scrollingAction;
}

- (void)scrollChildNode:(SKNode *)node
{
    [node runAction:self.scrollingAction completion:^{
        if ([node.userData[@"id"] integerValue] == 0) {
            node.position = CGPointMake(CGRectGetWidth(node.frame) * (self.children.count - 1), 0);
            node.userData[@"id"] = @(self.children.count - 1);
        } else {
            node.userData[@"id"] = @([node.userData[@"id"] integerValue] - 1);
        }
        [self scrollChildNode:node];
    }];
}

@end
