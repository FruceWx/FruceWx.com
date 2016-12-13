//
//  WelcomeController.m
//  WXFZP
//
//  Created by 魏雄飞 on 2016/12/7.
//  Copyright © 2016年 Fruce.Wei. All rights reserved.
//

#import "WelcomeController.h"
#import "PageViewController.h"

@import AVFoundation;

@interface WelcomeController ()

@property (nonatomic) AVPlayer *player;
@property (nonatomic) AVPlayerLayer *playLayer;

@end

@implementation WelcomeController

static void *rate = &rate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    NSURL *mp4URL = [[NSBundle mainBundle] URLForResource:@"dyla_movie" withExtension:@"mp4"];
    _player = [AVPlayer playerWithURL:mp4URL];
    [_player play];
    
    _playLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playLayer.frame = self.view.bounds;
    _playLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_playLayer];
    
    //[UIApplication sharedApplication].statusBarHidden = YES;
    [_player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:&rate];
    
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == rate) {
        if ([change[@"new"] intValue] == 0) {
            [self playToEnd];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)playToEnd {
    [UIView animateWithDuration:1 animations:^{
        self.view.window.alpha = 0;
        self.view.window.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [_playLayer removeFromSuperlayer];
        _playLayer = nil;
        self.view.window.hidden = YES;
        /*
        PageViewController *pageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
        [UIApplication sharedApplication].keyWindow.rootViewController = pageVC;
        [self presentViewController:pageVC animated:NO completion:nil];
         */
    }];
}

- (void)dealloc {
    [_player removeObserver:self forKeyPath:@"rate"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
