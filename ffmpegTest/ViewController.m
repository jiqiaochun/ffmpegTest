//
//  ViewController.m
//  ffmpegTest
//
//  Created by qiaochun ji on 2018/12/7.
//  Copyright © 2018 qiaochun ji. All rights reserved.
//

#import "ViewController.h"

#import <libavformat/avformat.h>
#import "RTSPPlayer.h"

@interface ViewController ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *switchBtn;
@property (nonatomic, strong) RTSPPlayer *video;
@property (nonatomic, strong) NSTimer *nextFrameTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width * 320 / 426)];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    self.imageView.userInteractionEnabled = YES;
    
    UIButton *switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(imageView.frame.size.width-32, imageView.frame.size.height-32, 32, 32)];
    switchBtn.backgroundColor = [UIColor redColor];
    [switchBtn addTarget:self action:@selector(switchBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:switchBtn];
    self.switchBtn = switchBtn;
    
    self.video = [[RTSPPlayer alloc] initWithVideo:@"rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mov" usesTcp:YES];
    self.video.outputWidth = 426;
    self.video.outputHeight = 320;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [_nextFrameTimer invalidate];
    self.nextFrameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/30
                                                           target:self
                                                         selector:@selector(displayNextFrame:)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [_nextFrameTimer invalidate];
    self.nextFrameTimer = nil;
}
-(void)displayNextFrame:(NSTimer *)timer{
    if (![self.video stepFrame]) {
        [timer invalidate];
        [self.video closeAudio];
        return;
    }
    self.imageView.image = self.video.currentImage;
}


- (BOOL)shouldAutorotate{
    return NO;
}

- (void)switchBtnClcik:(UIButton *)btn{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 320 / 426);
        self.switchBtn.frame = CGRectMake(self.imageView.frame.size.width-32, self.imageView.frame.size.height-32, 32, 32);
        [self.navigationController.navigationBar setHidden:YES];
    }else if (orientation == UIInterfaceOrientationLandscapeRight){
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        self.imageView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width * 320 / 426);
        self.switchBtn.frame = CGRectMake(self.imageView.frame.size.width-32, self.imageView.frame.size.height-32, 32, 32);
        [self.navigationController.navigationBar setHidden:NO];
    }
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

@end
