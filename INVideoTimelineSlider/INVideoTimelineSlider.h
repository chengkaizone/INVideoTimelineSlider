@class INVideoTimelineSlider;

@protocol INVideoTimelineSliderDelegate <NSObject>
@optional
- (void)sliderStartsDragging:(INVideoTimelineSlider *)slider;
- (void)slider:(INVideoTimelineSlider *)slider valueChangedTo:(double)level;
- (void)slider:(INVideoTimelineSlider *)slider valueChangingFinishedWith:(double)level;
@end

@interface INVideoTimelineSlider : UIView

- (id)initWithStartValue:(double)startValue center:(CGPoint)center bgImageName:(NSString *)bgImageName sliderImageName:(NSString *)sliderImageName borderImgName:(NSString *)borderImgName playedPartColor:(UIColor *)playedColor bufferedPartColor:(UIColor *)bufferedColor backgroundYInset:(float)backgroundYInset;
- (id)initWithStartValue:(double)startValue center:(CGPoint)center bgImageName:(NSString *)bgImageName sliderImageName:(NSString *)sliderImageName;

- (void)buffer:(double)part;
- (void)slide:(double)part;

@property (nonatomic, assign) id<INVideoTimelineSliderDelegate> delegate;
@property (nonatomic, assign, readonly, getter = isDragging) BOOL dragging;

@end
