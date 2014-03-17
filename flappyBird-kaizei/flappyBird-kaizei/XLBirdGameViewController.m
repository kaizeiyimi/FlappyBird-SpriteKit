//
//  XLBirdGameViewController.m
//  flappyBird-kaizei
//
//  Created by 王凯 on 14-3-13.
//  Copyright (c) 2014年 王凯. All rights reserved.
//

#import "XLBirdGameViewController.h"
#import "XLGameScene.h"

@interface XLBirdGameViewController () <XLGameSceneDelegate>

@property (nonatomic, weak) IBOutlet UIView *getReadyView;
@property (nonatomic, weak) IBOutlet UIView *gameOverView;
@property (nonatomic, weak) IBOutlet UILabel *currentScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *finalScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *bestScoreLabel;
@property (nonatomic, weak) IBOutlet UIImageView *medalImageView;
@property (nonatomic, weak) IBOutlet UILabel *kaizeiLogoLabel;

@end

@implementation XLBirdGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SKView * skView = (SKView *)self.view;
#ifdef DEBUG
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
#endif
    [self reset];
}

- (void)reset
{
    SKView * skView = (SKView *)self.view;
    [skView.scene removeFromParent];
    self.currentScoreLabel.hidden = YES;
    self.gameOverView.hidden = YES;
    self.getReadyView.hidden = NO;
    self.kaizeiLogoLabel.userInteractionEnabled = NO;
    XLGameScene * scene = [XLGameScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    scene.delegate = self;
    [skView presentScene:scene];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - gameSceneDelegate
- (void)gameSceneGameStarted:(XLGameScene *)scene
{
    self.currentScoreLabel.alpha = 0;
    self.currentScoreLabel.hidden = NO;
    self.currentScoreLabel.text = @"0";
    [UIView animateWithDuration:0.3 animations:^{
        self.getReadyView.alpha = 0;
        self.currentScoreLabel.alpha = 1;
    } completion:^(BOOL finished) {
        self.getReadyView.alpha = 1.0;
        self.getReadyView.hidden = YES;
        self.kaizeiLogoLabel.userInteractionEnabled = YES;
    }];
}

- (void)gameScene:(XLGameScene *)scene didGetScore:(NSInteger)score
{
    self.currentScoreLabel.text = [@(score) stringValue];
}

- (void)gameSceneGameEnded:(XLGameScene *)scene
{
    self.view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = YES;
    });
    self.kaizeiLogoLabel.userInteractionEnabled = NO;
    self.currentScoreLabel.hidden = YES;
    //显示gameover
    self.gameOverView.hidden = NO;
    self.gameOverView.alpha = 0;
    self.gameOverView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:0.5 animations:^{
        self.gameOverView.alpha = 1;
        self.gameOverView.transform = CGAffineTransformIdentity;
    }];
    //shake
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    shake.duration = 0.05;
    shake.repeatCount = 4;
    shake.autoreverses = YES;
    shake.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x - 4.0, self.view.center.y)];
    shake.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x + 4.0, self.view.center.y)];
    [[self.view layer] addAnimation:shake forKey:@"position"];
    //add gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnView:)];
    [self.view addGestureRecognizer:tapGesture];
    //更新score
    NSInteger currentScore = [self.currentScoreLabel.text integerValue];
    self.finalScoreLabel.text = [@(currentScore) stringValue];
    NSInteger bestScore = [self refreshBestScoreWithScore:currentScore];
    self.bestScoreLabel.text = [@(bestScore) stringValue];
    //显示合适的奖牌
    [self showMedalWithScore:currentScore];
}

- (void)didTapOnView:(UITapGestureRecognizer *)gesture
{
    [self.view removeGestureRecognizer:gesture];
    [self reset];
}

- (IBAction)didTapOnPauseLabel:(id)sender
{
    SKView *skView = (SKView *)self.view;
    skView.scene.paused = !skView.scene.paused;
}

#pragma mark - score related
- (NSInteger)refreshBestScoreWithScore:(NSInteger)score
{
    NSInteger bestScore = [[[NSUserDefaults standardUserDefaults] valueForKey:@"BestScore"] integerValue];
    if (score > bestScore) {
        [[NSUserDefaults standardUserDefaults] setValue:@(score) forKey:@"BestScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return score;
    }
    return  bestScore;
}

- (void)showMedalWithScore:(NSInteger)score
{
    if (score >= 40) {
        self.medalImageView.image = [UIImage imageNamed:@"medalPlatinum"];
    } else if (score >= 30) {
        self.medalImageView.image = [UIImage imageNamed:@"medalGold"];
    } else if (score >= 20) {
        self.medalImageView.image = [UIImage imageNamed:@"medalSilver"];
    } else if (score >= 10) {
        self.medalImageView.image = [UIImage imageNamed:@"medalBronze"];
    } else {
        self.medalImageView.image = nil;
    }
}

@end
