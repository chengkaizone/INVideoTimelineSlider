//
//  ViewController.m
//  INVideoTimelineSliderDemo
//
//  Created by iN on 27.01.13.
//  Copyright (c) 2013 iN. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController{
    INVideoTimelineSlider *_slider;
    float _buffer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _slider = [[INVideoTimelineSlider alloc] initWithStartValue:0.0f center:self.view.center bgImageName:@"bg" sliderImageName:@"slider" borderImgName:@"bg" playedPartColor:[UIColor colorWithRed:(51.0/255) green:(51.0/255) blue:(51.0/255) alpha:1] bufferedPartColor:[UIColor colorWithRed:(95.0/255) green:(95.0/255) blue:(95.0/255) alpha:1] backgroundYInset:2.0];
    _slider.delegate = self;
    [self.view addSubview:_slider];
    
    [self buffer];
}

- (void)buffer {
    _buffer += 0.001;
    [_slider buffer:_buffer];
    [self performSelector:@selector(buffer) withObject:nil afterDelay:0.01];
}

#pragma mark - <INSliderDelegate>

- (void)slider:(INVideoTimelineSlider *)slider valueChangedTo:(double)level {
    NSLog(@"slider dragging to %.2f", level);
}

- (void)slider:(INVideoTimelineSlider *)slider valueChangingFinishedWith:(double)level {
    NSLog(@"slider did ends with %.2f", level);
}

- (void)sliderStartsDragging:(INVideoTimelineSlider *)slider {
    NSLog(@"slider starts graggin");
}

@end
