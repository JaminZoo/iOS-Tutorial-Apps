//
//  ViewController.m
//  DropMe
//
//  Created by Ben Zhu on 31/10/2015.
//  Copyright (c) 2015 Ben Zhu. All rights reserved.
//

#import "ViewController.h"

// Declare constants for size of box and the coordinates of the array in which each will be positioned.
static const CGFloat SQUARE_SIZE = 40;
static const NSUInteger NUMBER_OF_COLUMNS = 9;
//static const NSUInteger NUMBER_OF_ROWS = 10;

@interface ViewController () <UICollisionBehaviorDelegate>

//- (IBAction)tapToAddBox:(UITapGestureRecognizer *)sender;

@property (strong, nonatomic) NSArray *colours;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collision;
@property (strong, nonatomic) UIDynamicItemBehavior *itemBehaviour;
@property (strong, nonatomic) NSMutableSet *bottomRow;  // Add/remove boxes that are at the bottom row of the view
@property (strong, nonatomic) UIAttachmentBehavior *attachment;  // Connection between box and user pan gesture
@property (strong, nonatomic) UIView *droppingBoxView;  // Identify which box 'view' the user taps in the game view
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Instantiate animator property
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // Instantiate an NSMutableSet with the capacity equal to the number of boxes in each row i.e. the number of columns
    self.bottomRow = [[NSMutableSet alloc] initWithCapacity:NUMBER_OF_COLUMNS];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gravity Lazy Instantiation

-(UIGravityBehavior *)gravity {
    if (! _gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
        // Set magnitude of gravity property from its default value of 1 to 0.9
        _gravity.magnitude = 0.9;
        [self.animator addBehavior:_gravity];  // Add gravity behaviour to animator
    }
    return _gravity;
}

#pragma mark - Collision Lazy Instantiation

-(UICollisionBehavior *)collision {
    if (! _collision) {
        _collision = [[UICollisionBehavior alloc] init];
        // Set collision's property to collide at the boundaries of the view.
        _collision.translatesReferenceBoundsIntoBoundary = YES;
        // Conform to UICollisionBehaviourDelegate protocol in order to implement methods for when last row is full
        _collision.collisionDelegate = self;
        [self.animator addBehavior:_collision];
    }
    return _collision;
}

#pragma mark - Item behaviour Lazy Instantiation

-(UIDynamicItemBehavior *)itemBehaviour {
    
    if (! _itemBehaviour) {
        _itemBehaviour = [[UIDynamicItemBehavior alloc] init];
        _itemBehaviour.allowsRotation = NO;  // Prevent each boxes behaviour from rotating
        _itemBehaviour.elasticity = 0.5;  // Increase the boxes bounciness through the elasticity property
        [self.animator addBehavior:_itemBehaviour];
    }
    return _itemBehaviour;
}

#pragma mark - IBAction TapGuestureRecognizer

- (IBAction)tapToAddBox:(UITapGestureRecognizer *)sender {
    
    [self createBox];  // Will call createBox method on self each time user taps screen, which will initialise a box at a random location in the 8 x 10 CGRect with a colour randomlly selected from the colours array.
}

#pragma mark - IBAction PanGestureRecognizer

- (IBAction)tapToPanBox:(UIPanGestureRecognizer *)sender {
    
    // Define a point associated with where in the view the pan begins i.e. where the user taps to 'capture' the falling box
    CGPoint gesturePoint = [sender locationInView:self.view];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self attachDroppingViewToPoint:gesturePoint];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.attachment.anchorPoint = gesturePoint;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachment];
    }
    
}

#pragma mark - Helper method to attach anchor to box

// Attach the view of the dropping box to an achor point defined in the above method.
- (void)attachDroppingViewToPoint: (CGPoint)anchorPoint {

    if (self.droppingBoxView) {
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.droppingBoxView attachedToAnchor:anchorPoint];
        self.droppingBoxView = nil;  // allow only one pan of the box i.e. user cannot continue to tap box to reposition
        [self.animator addBehavior:self.attachment];
    }
}


#pragma mark - Helper method to create box and populate on view

// Create a box that is initialised at a random location on the screen and with a random background colour.
-(void)createBox {
    UIView *nextBox = [[UIView alloc] initWithFrame:[self randomInitialPosition]];
    nextBox.backgroundColor = [self randomColour];
    [self.view addSubview:nextBox];
    [self addBehaviourForBox:nextBox];  // set gravity property to each box that is initialised
}

// Method that returns a CGRect (origin and WxH) goverend by the constant column and row values defined.
-(CGRect)randomInitialPosition {
    CGFloat column = arc4random_uniform(NUMBER_OF_COLUMNS);
    //CGFloat row = arc4random_uniform(NUMBER_OF_ROWS);
    // Position each box at a random origin based on the column number.
    return CGRectMake(column * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE , SQUARE_SIZE);
}

// Get random colour for each box from colours NSArray
-(UIColor *)randomColour {
    
    return self.colours[arc4random_uniform((int)[self.colours count])];
    // The count method of NSArray returns an NSUInteger, which is defined as an unsigned long or a 64-bit unsigned integer. Cast an int to the return of this method call on self.colours array in order to align the datatypes between NSUInteger and int.
}

#pragma mark - Lazy instantiation of colours array

- (NSArray *)colours {
    
    if (! _colours) {
        _colours = @[[UIColor redColor], [UIColor blueColor], [UIColor yellowColor], [UIColor orangeColor], [UIColor greenColor], [UIColor magentaColor], [UIColor whiteColor]];
    }
    return _colours;
}

#pragma mark - Apply gravity and collision behaviours to boxes

// Each box needs to register to have the gravity, collision behaviour properties applied to it.
-(void)addBehaviourForBox: (UIView *)box {
    [self.gravity addItem:box];
    [self.collision addItem:box];
    [self.itemBehaviour addItem:box];
    
    
}

// Remove all the animate behaviours that were applied to each box prior to being added to the NSMutableSet
-(void)removeBehaviourBox: (UIView *)box {
    [self.gravity removeItem:box];
    [self.collision removeItem:box];
    [self.itemBehaviour removeItem:box];
    
}

#pragma mark - Helper methods for when box collides with the bottom row

-(BOOL)didCollideWithBottom: (CGFloat) yValue {
    
    CGFloat distanceFromBottom = self.view.frame.size.height - yValue;
    return (distanceFromBottom < SQUARE_SIZE);  // Return YES if distance from bottom is less than square size
}

// Method that goes through each box in the bottomRow NSMutableSet and then removes the behaviour and box
-(void)clearBottomRow {
    for (UIView *box in self.bottomRow) {
        [self removeBehaviourBox: box];
        [self removeBox:box];
    }
    [self.bottomRow removeAllObjects];  // empty the NSMutableSet so that a new set of boxes can be added when they collide with the bottom row.
    
}

// Animate boxes off the screen so that no object refers to to any of these UIView objects
-(void)removeBox: (UIView *)box {
    CGFloat offscreenXCoordinate = 2 * (box.center.x - self.view.center.x) + self.view.center.x;
    //CGFloat offscreenYCoordinate = 2 * (box.center.y - self.view.center.y) + self.view.center.y;
    [UIView animateWithDuration:0.9 animations:^{
        box.center = CGPointMake(offscreenXCoordinate, -5 * SQUARE_SIZE);
    } completion:^(BOOL finished) {
        [box removeFromSuperview];
    }];
    
}

#pragma mark - UICollisionBehaviourDelegate

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    // If the box has collided with the bottom of the view, which is checked by using the return y value of the point provided by the delegate method, then add it to the NSMutableSet
    if ([self didCollideWithBottom:p.y]) {
        [self.bottomRow addObject:item];
        // Check if the number of boxes is equal to the size of the column
        if ([self.bottomRow count] == NUMBER_OF_COLUMNS) {
            [self clearBottomRow];
        }
    }
}
@end
