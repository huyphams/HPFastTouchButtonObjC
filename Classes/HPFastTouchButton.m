//
//  HPFastTouchButton.m
//  HPFastTouchButtonObjC
//
//  Created by Huy Pham on 3/11/15.
//  Copyright (c) 2015 CoreDump. All rights reserved.
//

#import "HPFastTouchButton.h"

@interface Target: NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, readwrite) SEL action;
@property (nonatomic, readwrite) UIControlEvents event;

@end

@implementation Target

@end

@interface ImageForState : NSObject

@property (nonatomic, copy) UIImage *image;
@property (nonatomic, readwrite) UIControlState state;

@end

@implementation ImageForState

@end

@interface TitleForState : NSObject

@property (nonatomic, copy) NSString *string;
@property (nonatomic, readwrite) UIControlState state;

@end

@implementation TitleForState

@end

@implementation HPFastTouchButton {
    
    UIImageView *_imageView;
    UIView *_overlayView;
    
    NSMutableArray *_targets;
    NSMutableArray *_imagesForState;
    NSMutableArray *_titlesForState;
    
    Boolean _cancelEvent;
    UIControlState _currentState;
}

- (instancetype)init {
    
    self = [super init];
    if (!self) return nil;
    [self commonInt];
    return self;
}

- (void)commonInt {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self initView];
}

- (void)initView {
    
    _selected = NO;
    _cancelEvent = NO;
    _titleInsets = UIEdgeInsetsZero;
    _imageInsets = UIEdgeInsetsZero;
    _enable = YES;
    _targets = [NSMutableArray array];
    _titlesForState = [NSMutableArray array];
    _imagesForState = [NSMutableArray array];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.userInteractionEnabled = NO;
    
    _overlayView = [[UIView alloc] init];
    _overlayView.backgroundColor = [UIColor clearColor];
    _overlayView.userInteractionEnabled =  NO;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _selectedColor = [UIColor colorWithRed:217.0/255.0
                                     green:217.0/255.0
                                      blue:217.0/255.0
                                     alpha:1.0];
    
    [self addSubview:_imageView];
    [self addSubview:_overlayView];
    [self addSubview:_titleLabel];
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    [self relayout];
}

- (void)setTitleInsets:(UIEdgeInsets)titleInsets {
    
    _titleInsets = titleInsets;
    [self relayout];
}

- (void)setImageInsets:(UIEdgeInsets)imageInsets {
    
    _imageInsets = imageInsets;
    [self relayout];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _currentState = UIControlStateHighlighted;
    _cancelEvent = NO;
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _cancelEvent = YES;
    _currentState = UIControlStateNormal;
    [self setNeedsDisplay];
    if (self.nextResponder) {
        [self.nextResponder touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _currentState = UIControlStateNormal;
    [self setNeedsDisplay];
    
    if (_cancelEvent) {
        if (self.nextResponder) {
            [self.nextResponder touchesEnded:touches withEvent:event];
        }
    } else {
        [self triggerSelector];
    }
    _cancelEvent = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _currentState = UIControlStateNormal;
    [self setNeedsDisplay];
    if (self.nextResponder) {
        [self.nextResponder touchesCancelled:touches withEvent:event];
    }
    _cancelEvent = NO;
    
}

- (Boolean)compareTarget:(Target *)firstTarget withTarget:(Target *)secondTarget {
    
    if ([firstTarget.target isEqual:secondTarget.target]
        && firstTarget.event == secondTarget.event
        && firstTarget.action == secondTarget.action) {
        return YES;
    }
    return NO;
}

- (void)triggerSelector {
    
    if (_toggle) {
        _selected = !_selected;
    }
    for (Target *target in _targets) {
        if (target.target) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSThread detachNewThreadSelector:target.action toTarget:target.target withObject:self];
            });
        }
    }
    
}

- (UIImage *)imageForState:(UIControlState)state {
    
    UIImage *normalImage = nil;
    for (ImageForState *imageForState in _imagesForState) {
        if (imageForState.state == state) {
            return imageForState.image;
        } else if (imageForState.state == UIControlStateNormal) {
            normalImage = imageForState.image;
        }
    }
    return normalImage;
}

- (NSString *)titleForState:(UIControlState)state {
    
    NSString *normalTitle = nil;
    for (TitleForState *titleForState in _titlesForState) {
        if (titleForState.state == state) {
            return titleForState.string;
        } else if (titleForState.state == UIControlStateNormal) {
            normalTitle = titleForState.string;
        }
    }
    return normalTitle;
}

- (void)addImageForState:(ImageForState *)imageForState {
    
    NSMutableArray *arrayToRemove = [NSMutableArray array];
    for (ImageForState *imageForStateElement in _imagesForState) {
        if (imageForStateElement.state == imageForState.state) {
            [arrayToRemove addObject:imageForStateElement];
        }
    }
    [_imagesForState removeObjectsInArray:arrayToRemove];
    [_imagesForState addObject:imageForState];
}

- (void)addTitleForState:(TitleForState *)titleForState {
    
    NSMutableArray *arrayToRemove = [NSMutableArray array];
    for (TitleForState *titleForStateElement in _titlesForState) {
        if (titleForStateElement.state == titleForState.state) {
            [arrayToRemove addObject:titleForStateElement];
        }
    }
    [_titlesForState removeObjectsInArray:arrayToRemove];
    [_titlesForState addObject:titleForState];
}

- (void)addTarget:(NSObject *)target
           action:(SEL)action
 forControlEvents:(UIControlEvents)controlEvents {
    
    Target *newTarget = [[Target alloc] init];
    newTarget.target = target;
    newTarget.action = action;
    newTarget.event = controlEvents;
    
    for (Target *targetElement in _targets) {
        if ([self compareTarget:newTarget withTarget:targetElement]) {
            return;
        }
    }
    [_targets addObject:newTarget];
}

- (void)removeTarget:(NSObject *)target
              action:(SEL)action
    forControlEvents:(UIControlEvents)controlEvents {
    
    Target *newTarget = [[Target alloc] init];
    newTarget.target = target;
    newTarget.action = action;
    newTarget.event = controlEvents;
    
    NSMutableArray *arrayToRemove = [NSMutableArray array];
    for (Target *targetElement in _targets) {
        if ([self compareTarget:newTarget withTarget:targetElement]) {
            [arrayToRemove addObject:targetElement];
        }
    }
    [_targets removeObjectsInArray:arrayToRemove];
}

- (void)setImage:(UIImage *)image
        forState:(UIControlState)state {
    
    ImageForState *imageForState = [[ImageForState alloc] init];
    imageForState.image = image;
    imageForState.state = state;
    [self addImageForState:imageForState];
}

- (void)setTitle:(NSString *)title
        forState:(UIControlState)state {
    
    TitleForState *titleForState = [[TitleForState alloc] init];
    titleForState.string = title;
    titleForState.state = state;
    [self addTitleForState:titleForState];
}

- (void)relayout {
    
    _imageView.frame = CGRectMake(self.imageInsets.left,
                                  self.imageInsets.top,
                                  CGRectGetWidth(self.bounds) - self.imageInsets.left - self.imageInsets.right,
                                  CGRectGetHeight(self.bounds) - self.imageInsets.top - self.imageInsets.bottom);
    
    _overlayView.frame = self.bounds;
    _titleLabel.frame = CGRectMake(self.titleInsets.left,
                                   self.imageInsets.top,
                                   CGRectGetWidth(self.bounds) - self.titleInsets.left - self.titleInsets.right,
                                   CGRectGetHeight(self.bounds) - self.titleInsets.top - self.titleInsets.bottom);
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    // Change background color.
    if (_selected) {
        _overlayView.backgroundColor = self.selectedColor;
    } else {
        switch (_currentState) {
            case UIControlStateNormal:
                _overlayView.backgroundColor = [UIColor clearColor];
                break;
            case UIControlStateHighlighted:
                _overlayView.backgroundColor = self.selectedColor;
                break;
            default:
                _overlayView.backgroundColor = [UIColor clearColor];
        }
    }
    
    // Change image for state.
    if  (_selected) {
        UIImage *image = [self imageForState:UIControlStateSelected];
        if (image) {
            _imageView.image = image;
        } else {
            _imageView.image = [self imageForState:_currentState];
        }
        
        NSString *title = [self titleForState:UIControlStateSelected];
        if (title) {
            _titleLabel.text = title;
        } else {
            _titleLabel.text = [self titleForState:_currentState];
        }
    } else {
        _imageView.image = [self imageForState:_currentState];
        _titleLabel.text = [self titleForState:_currentState];
    }
    
    // Set overlay alpha.
    if (_imageView.image) {
        _overlayView.alpha = 0.6;
    } else {
        _overlayView.alpha = 1.0;
    }
}

@end
