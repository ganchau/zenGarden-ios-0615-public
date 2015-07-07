//
//  FISZenGardenViewController.m
//  zenGarden
//
//  Created by Gan Chau on 7/6/15.
//  Copyright (c) 2015 The Flatiron School. All rights reserved.
//

#import "FISZenGardenViewController.h"

@interface FISZenGardenViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *shrubImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stoneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rakeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *excaliburImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rakeLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rakeTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stoneTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stoneRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *excaliburBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *excaliburLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shrubRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shrubBottomConstraint;

@property (nonatomic) BOOL winCondition1;
@property (nonatomic) BOOL winCondition2;

@property (nonatomic) CGPoint previousPoint;

@end

@implementation FISZenGardenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.shrubImageView.userInteractionEnabled = YES;
    self.stoneImageView.userInteractionEnabled = YES;
    self.rakeImageView.userInteractionEnabled = YES;
    self.excaliburImageView.userInteractionEnabled = YES;
    self.shrubImageView.exclusiveTouch = YES;
    self.stoneImageView.exclusiveTouch = YES;
    self.rakeImageView.exclusiveTouch = YES;
    self.excaliburImageView.exclusiveTouch = YES;
    
    UIPanGestureRecognizer *rakePanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(rakePanned:)];
    UIPanGestureRecognizer *stonePanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(stonePanned:)];
    UIPanGestureRecognizer *shrubPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(shrubPanned:)];
    UIPanGestureRecognizer *excaliburPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(excaliburPanned:)];
    
    [self.rakeImageView addGestureRecognizer:rakePanRecognizer];
    [self.stoneImageView addGestureRecognizer:stonePanRecognizer];
    [self.shrubImageView addGestureRecognizer:shrubPanRecognizer];
    [self.excaliburImageView addGestureRecognizer:excaliburPanRecognizer];
}

- (void)rakePanned:(UIPanGestureRecognizer *)recognizer
{
    [self panWithRecognizer:recognizer
                xConstraint:self.rakeLeftConstraint
                yConstraint:self.rakeTopConstraint];
    [self checkCondition2];
    [self checkForWin];
}

- (void)stonePanned:(UIPanGestureRecognizer *)recognizer
{
    [self panWithRecognizer:recognizer
                xConstraint:self.stoneRightConstraint
                yConstraint:self.stoneTopConstraint];
    [self checkCondition1];
    [self checkForWin];
}

- (void)shrubPanned:(UIPanGestureRecognizer *)recognizer
{
    [self panWithRecognizer:recognizer
                xConstraint:self.shrubRightConstraint
                yConstraint:self.shrubBottomConstraint];
    [self checkCondition2];
    [self checkForWin];
}

- (void)excaliburPanned:(UIPanGestureRecognizer *)recognizer
{
    [self panWithRecognizer:recognizer
                xConstraint:self.excaliburLeftConstraint
                yConstraint:self.excaliburBottomConstraint];
    [self checkCondition1];
    [self checkForWin];
}

- (void)panWithRecognizer:(UIPanGestureRecognizer *)recognizer
              xConstraint:(NSLayoutConstraint *)xConstraint
              yConstraint:(NSLayoutConstraint *)yConstraint
{
    CGPoint point = [recognizer locationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.previousPoint = point;
    }
    
    CGFloat deltaX = point.x - self.previousPoint.x;
    CGFloat deltaY = point.y - self.previousPoint.y;
    
    xConstraint.constant += deltaX;
    yConstraint.constant += deltaY;
    
    self.previousPoint = point;
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.rakeImageView.userInteractionEnabled = YES;
        self.stoneImageView.userInteractionEnabled = YES;
        self.excaliburImageView.userInteractionEnabled = YES;
        self.shrubImageView.userInteractionEnabled = YES;
    }
}

- (void)checkCondition2
{
    if (self.shrubImageView.center.x - self.rakeImageView.center.x <= 100 &&
        self.shrubImageView.center.y - self.rakeImageView.center.y <= 100) {
        self.winCondition2 = YES;
        NSLog(@"condition 2 met");
    } else {
        self.winCondition2 = NO;
        NSLog(@"condition 2 not met");
    }
}

- (void)checkCondition1
{
    if (((self.excaliburImageView.center.x <= 75 && self.excaliburImageView.center.y <= 75) &&
         (self.stoneImageView.center.x <= 75 && self.stoneImageView.center.y >= self.view.frame.size.height - 75)) ||
        ((self.excaliburImageView.center.x <= 75 && self.excaliburImageView.center.y >= self.view.frame.size.height - 75) &&
         (self.stoneImageView.center.x <= 75 && self.stoneImageView.center.y <= 75)))
    {
        self.winCondition1 = YES;
        NSLog(@"condition 1 met");
    } else {
        self.winCondition1 = NO;
        NSLog(@"condition 1 not met");
    }
}

- (void)checkForWin
{
    if (self.winCondition1 && self.winCondition2) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Game Over"
                                                                       message:@"You Win!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self scrambleImages];
                                                              }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)scrambleImages
{
    self.winCondition1 = NO;
    self.winCondition2 = NO;
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.excaliburLeftConstraint.constant = 150;
                         self.excaliburBottomConstraint.constant = -100;
                         self.stoneTopConstraint.constant = 200;
                         self.stoneRightConstraint.constant = -50;
                         self.shrubRightConstraint.constant = -190;
                         self.shrubBottomConstraint.constant = -200;
                         self.rakeTopConstraint.constant = 50;
                         self.rakeLeftConstraint.constant = 90;
                         [self.view layoutIfNeeded];
                     }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
