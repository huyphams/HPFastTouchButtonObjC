//
//  HPFastTouchButton.h
//  HPFastTouchButtonObjC
//
//  Created by Huy Pham on 3/11/15.
//  Copyright (c) 2015 CoreDump. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPFastTouchButton : UIView

@property (nonatomic, copy) UIColor *selectedColor;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, readwrite) Boolean selected;
@property (nonatomic, readwrite) Boolean toggle;
@property (nonatomic, readwrite) UIEdgeInsets titleInsets;
@property (nonatomic, readwrite) UIEdgeInsets imageInsets;
@property (nonatomic, readwrite) Boolean enable;

- (void)addTarget:(NSObject *)target
           action:(SEL)action
 forControlEvents:(UIControlEvents)controlEvents;

- (void)setImage:(UIImage *)image
        forState:(UIControlState)state;

- (void)setTitle:(NSString *)title
        forState:(UIControlState)state;

@end
