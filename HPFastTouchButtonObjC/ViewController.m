//
//  ViewController.m
//  HPFastTouchButtonObjC
//
//  Created by Huy Pham on 3/11/15.
//  Copyright (c) 2015 CoreDump. All rights reserved.
//

#import "ViewController.h"
#import "HPFastTouchButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [tableView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:tableView];
    
    // HP's Fast touch button.
    HPFastTouchButton *fastTouchButton = [[HPFastTouchButton alloc] init];
    [fastTouchButton addTarget:self
                        action:@selector(buttonTouched:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [fastTouchButton setImage:[UIImage imageNamed:@"camera"]
                     forState:UIControlStateHighlighted];
    [fastTouchButton setImage:[UIImage imageNamed:@"bell"]
                     forState:UIControlStateNormal];
    [fastTouchButton setTitle:@"Fast Touch Button"
                     forState:UIControlStateNormal];
    
    fastTouchButton.backgroundColor = [UIColor whiteColor];
    fastTouchButton.frame = CGRectMake(10, 100, 140, 140);
    
    // Normal button.
    UIButton *normalButton = [[UIButton alloc] init];
    [normalButton setBackgroundColor:[UIColor whiteColor]];
    
    [normalButton addTarget:self
                        action:@selector(buttonTouched:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [normalButton setImage:[UIImage imageNamed:@"camera"]
                     forState:UIControlStateHighlighted];
    [normalButton setImage:[UIImage imageNamed:@"bell"]
                     forState:UIControlStateNormal];
    normalButton.frame = CGRectMake(170, 100, 140, 140);
    [normalButton setTitle:@"Normal Button"
                     forState:UIControlStateNormal];
    [normalButton setTitleColor:[UIColor blackColor]
                       forState:UIControlStateNormal];

    [tableView addSubview:fastTouchButton];
    [tableView addSubview:normalButton];
}

- (void)buttonTouched:(HPFastTouchButton *)button {
    
    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"You did it"
                                                   message:@"Touch up inside"
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [aler show];
    
}

@end
