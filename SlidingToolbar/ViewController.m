//
//  ViewController.m
//  SlidingToolbar
//
//  Created by Brandon King on 5/4/13.
//  Copyright (c) 2013 King's Cocoa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIView *toolbarContainer;
@property (nonatomic, weak) IBOutlet UIView *touchZone;
@property (nonatomic, weak) IBOutlet UIView *buttonContainer;
@property (nonatomic, weak) IBOutlet UIButton *collapseButton;

@property (nonatomic, assign) BOOL toolbarIsOpen;
@property (nonatomic, assign) BOOL toolbarIsAnimating;
@end



@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.toolbarIsOpen = YES;
    self.toolbarIsAnimating = NO;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveToolbar:)];
    [self.touchZone addGestureRecognizer:panGesture];
}

- (IBAction)expandCollapseButtonTouched
{
    [self buttonTouchEnded];
    if (!self.toolbarIsAnimating) {
        self.toolbarIsAnimating = YES;
        if (self.toolbarIsOpen) {
            [self collapseToolbar];
        } else {
            [self expandToolbar];
        }
    }
}

- (void)collapseToolbar
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.toolbarContainer setFrame:CGRectMake(0, (self.view.frame.size.height - 100), self.view.frame.size.width, 100.0)];
    } completion:^(BOOL finished) {
        [self collapseToolbarWithoutBounce];
    }];
    
}

- (void)collapseToolbarWithoutBounce
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.toolbarContainer setFrame:CGRectMake(0, (self.view.frame.size.height - 35), self.view.frame.size.width, 100.0)];
    } completion:^(BOOL finished) {
        self.toolbarIsOpen = NO;
        self.toolbarIsAnimating = NO;
        [self.collapseButton setTitle:@"\u2B06" forState:UIControlStateNormal];
    }];
}

- (void)expandToolbar
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.toolbarContainer setFrame:CGRectMake(0, (self.view.frame.size.height - 100), self.view.frame.size.width, 100.0)];
    } completion:^(BOOL finished) {
        [self expandToolbarWithoutBounce];
    }];
}

- (void)expandToolbarWithoutBounce
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.toolbarContainer setFrame:CGRectMake(0, (self.view.frame.size.height - 90), self.view.frame.size.width, 100.0)];
    } completion:^(BOOL finished) {
        self.toolbarIsOpen = YES;
        self.toolbarIsAnimating = NO;
        [self.collapseButton setTitle:@"\u2B07" forState:UIControlStateNormal];
    }];
}

- (void)moveToolbar:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translatedPoint = [panGesture translationInView:self.toolbarContainer];
    
    if ([panGesture state] == UIGestureRecognizerStateBegan) {
        self.buttonContainer.backgroundColor = [UIColor colorWithRed:0.56 green:0.27 blue:0 alpha:1.0];
        self.touchZone.backgroundColor = [UIColor colorWithRed:0.56 green:0.27 blue:0 alpha:1.0];
    }
    
    if ([panGesture state] == UIGestureRecognizerStateChanged) {
        float newYOrigin = self.toolbarContainer.frame.origin.y + translatedPoint.y;
        if ((newYOrigin > (self.view.frame.size.height - 100)) && (newYOrigin < (self.view.frame.size.height - 35))) {
            self.toolbarContainer.center = CGPointMake(self.toolbarContainer.center.x, self.toolbarContainer.center.y + translatedPoint.y);
        }
        [panGesture setTranslation:CGPointMake(0, 0) inView:self.toolbarContainer];
    }
    
    if ([panGesture state] == UIGestureRecognizerStateEnded) {
        self.buttonContainer.backgroundColor = [UIColor colorWithRed:1.0 green:(128.0/255.0) blue:0 alpha:1.0];
        self.touchZone.backgroundColor = [UIColor colorWithRed:1.0 green:(128.0/255.0) blue:0 alpha:1.0];
        self.toolbarIsAnimating = YES;
        if (self.toolbarContainer.frame.origin.y < (self.view.frame.size.height - 65)) {
            [self expandToolbarWithoutBounce];
        } else {
            [self collapseToolbarWithoutBounce];
        }
    }
}

#pragma mark - Collapse Button Actions

- (IBAction)buttonTouchBegin
{
    self.buttonContainer.backgroundColor = [UIColor colorWithRed:0.56 green:0.27 blue:0 alpha:1.0];
    self.touchZone.backgroundColor = [UIColor colorWithRed:0.56 green:0.27 blue:0 alpha:1.0];
}

- (void)buttonTouchEnded
{
    self.buttonContainer.backgroundColor = [UIColor colorWithRed:1.0 green:(128.0/255.0) blue:0 alpha:1.0];
    self.touchZone.backgroundColor = [UIColor colorWithRed:1.0 green:(128.0/255.0) blue:0 alpha:1.0];
}

@end