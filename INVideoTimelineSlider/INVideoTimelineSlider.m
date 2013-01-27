#import "INVideoTimelineSlider.h"

@implementation INVideoTimelineSlider {
    UIImageView *_slider;
    BOOL _isDragging;
    
    double _sideOffset;
    double _value;
    
    UIView *_playedPart;
    UIView *_bufferedPart;
    UIImageView *_bg;
}

- (id)initWithStartValue:(double)startValue center:(CGPoint)center bgImageName:(NSString *)bgImageName sliderImageName:(NSString *)sliderImageName borderImgName:(NSString *)borderImgName playedPartColor:(UIColor *)playedColor bufferedPartColor:(UIColor *)bufferedColor backgroundYInset:(float)backgroundYInset{
    
    self = [self initWithStartValue:startValue center:center bgImageName:bgImageName sliderImageName:sliderImageName];
    
    if (self) {
        
        if (bufferedColor) {
            _bufferedPart = [[UIView alloc] initWithFrame:CGRectMake(_sideOffset, _bg.frame.origin.y + backgroundYInset, 0, _bg.bounds.size.height - backgroundYInset*2)];
            _bufferedPart.backgroundColor = bufferedColor;
            [self addSubview:_bufferedPart];
        }
        
        if (playedColor) {
            _playedPart = [[UIView alloc] initWithFrame:CGRectMake(_sideOffset, _bg.frame.origin.y + backgroundYInset, 0, _bg.bounds.size.height - backgroundYInset*2)];
            _playedPart.backgroundColor = playedColor;
            [self addSubview:_playedPart];
            [self drawPlayedPart];
        }
        
        if (borderImgName) {
            UIImageView *border = [[UIImageView alloc] initWithImage:[UIImage imageNamed:borderImgName]];
            border.center = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);;
            [self addSubview:border];
        }
        
        [self bringSubviewToFront:_slider];
        
    }
    return self;
}

- (id)initWithStartValue:(double)startValue center:(CGPoint)center bgImageName:(NSString *)bgImageName sliderImageName:(NSString *)sliderImageName {
    
    NSAssert(bgImageName,@"bgImageName should be not nil");
    
    UIImage *bgImg = [UIImage imageNamed:bgImageName];
    UIImage *sliderImg = [UIImage imageNamed:sliderImageName];
    
    self = [super initWithFrame:CGRectMake(0, 0, bgImg.size.width + sliderImg.size.width, sliderImg.size.width)];
    if (self) {
        self.center = center;
        
        _bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgImg.size.width, bgImg.size.height)];
        _bg.image = bgImg;
        _bg.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:_bg];
        
        _sideOffset = (self.bounds.size.width - _bg.bounds.size.width)/2;
        
        _slider = [[UIImageView alloc] init];
        _slider.bounds = CGRectMake(0, 0, sliderImg.size.width, sliderImg.size.height);
        _slider.image = sliderImg;
        _slider.userInteractionEnabled = YES;
        _slider.center = CGPointMake(_sideOffset, self.bounds.size.height/2);
        [self addSubview:_slider];
        
        [self sliderDraggedTo:(startValue * _bg.bounds.size.width + _sideOffset)];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - Touch handlers
#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (CGRectContainsPoint(_slider.frame, point)){
        _isDragging = YES;
        if ([_delegate respondsToSelector:@selector(sliderStartsDragging:)]){
            [_delegate sliderStartsDragging:self];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_isDragging){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        
        [self sliderDraggedTo:point.x];
        [self calculateValue];
        
        if ([_delegate respondsToSelector:@selector(slider:valueChangedTo:)]) {
            [_delegate slider:self valueChangedTo:_value];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchEnds];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchEnds];
}

- (void)touchEnds {
    _isDragging = NO;
    [self calculateValue];
    
    if ([_delegate respondsToSelector:@selector(slider:valueChangingFinishedWith:)]) {
        [_delegate slider:self valueChangingFinishedWith:_value];
    }
}

#pragma mark -
#pragma mark -

- (void)drawPlayedPart {
    _playedPart.frame = CGRectMake(_playedPart.frame.origin.x, _playedPart.frame.origin.y, _slider.center.x - _sideOffset, _playedPart.bounds.size.height);
}

- (void)calculateValue {
    _value = (_slider.center.x - _sideOffset)/(self.bounds.size.width - _sideOffset*2);
}

- (void)sliderDraggedTo:(double)x {
    
    if (x < _sideOffset) {
        x = _sideOffset;
    } else if (x > self.bounds.size.width - _sideOffset) {
        x = self.bounds.size.width - _sideOffset;
    }
    
    _slider.center = CGPointMake(x, _slider.center.y);
    [self drawPlayedPart];
}

#pragma mark - Callbacks

- (void)buffer:(double)part {
    if (part > 1 || part < 0) return;
    _bufferedPart.frame = CGRectMake(_bufferedPart.frame.origin.x, _bufferedPart.frame.origin.y, _bg.bounds.size.width * part, _bufferedPart.bounds.size.height);;
}

- (void)slide:(double)part {
    if (part > 1 || part < 0) return;
    [self sliderDraggedTo:_bg.bounds.size.width * part + _sideOffset];
}

@end
