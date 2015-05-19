
#import "ViewController.h"
#import "CollectionViewImageCell.h"
@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property NSMutableArray *moonImages;
@property (weak, nonatomic) IBOutlet UIView *shadeView;
@property UICollisionBehavior *collisionBehaviour;
@property UIDynamicItemBehavior *dynamicItemBehaviour;
@property UIGravityBehavior *gravityBehaviour;
@property UIPushBehavior *pushBehaviour;
@property UIDynamicAnimator *dynamicAnimator;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.moonImages = [NSMutableArray array];
    [self.moonImages addObject:[UIImage imageNamed:@"moon_1"]];
    [self.moonImages addObject:[UIImage imageNamed:@"moon_2"]];
    [self.moonImages addObject:[UIImage imageNamed:@"moon_3"]];
    [self.moonImages addObject:[UIImage imageNamed:@"moon_4"]];
    [self.moonImages addObject:[UIImage imageNamed:@"moon_5"]];
    [self.moonImages addObject:[UIImage imageNamed:@"moon_6"]];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView]];
    self.gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView]];
    self.dynamicItemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView]];
    self.pushBehaviour = [[UIPushBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView] mode:UIPushBehaviorModeContinuous];
    
    [self.collisionBehaviour addBoundaryWithIdentifier:@"bottom" fromPoint:CGPointMake(-10, self.view.frame.size.height) toPoint:CGPointMake(self.view.frame.size.width -20, self.view.frame.size.height)];
    
    [self.gravityBehaviour setGravityDirection:CGVectorMake(0,0)];
    [self.dynamicItemBehaviour setElasticity:0.25];
    
    [self.dynamicAnimator addBehavior:self.collisionBehaviour];
    [self.dynamicAnimator addBehavior:self.gravityBehaviour];
    [self.dynamicAnimator addBehavior:self.pushBehaviour];
    [self.dynamicAnimator addBehavior:self.dynamicItemBehaviour];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.moonImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.imageView.image = [self.moonImages objectAtIndex:indexPath.row];
    
    return cell;
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)gesture{
    
    CGPoint point = [gesture translationInView: gesture.view];
    CGFloat yVelocity = [gesture velocityInView:gesture.view].y;
    
    self.shadeView.center = CGPointMake(self.shadeView.center.x, self.shadeView.center.y + point.y);
    [gesture setTranslation:CGPointMake(0,0) inView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.dynamicAnimator updateItemUsingCurrentState:self.shadeView];
    }
    
    if (yVelocity < -500) {
        [self.gravityBehaviour setGravityDirection:CGVectorMake(0,-1)];
        [self.dynamicItemBehaviour setElasticity:0.5];
        [self.pushBehaviour setPushDirection:CGVectorMake(0, [gesture velocityInView:gesture.view].y)];
    }
    else if (yVelocity >= -500 && yVelocity <0){
        [self.gravityBehaviour setGravityDirection:CGVectorMake(0,-1)];
        [self.dynamicItemBehaviour setElasticity:0.25];
        [self.pushBehaviour setPushDirection:CGVectorMake(0, -500)];
    }else if (yVelocity >=0 && yVelocity < 500){
        [self.gravityBehaviour setGravityDirection:CGVectorMake(0,1)];
        [self.dynamicItemBehaviour setElasticity:0.25];
        [self.pushBehaviour setPushDirection:CGVectorMake(0, 500)];
    }else{
        [self.gravityBehaviour setGravityDirection:CGVectorMake(0,1)];
        [self.dynamicItemBehaviour setElasticity:0.5];
        [self.pushBehaviour setPushDirection:CGVectorMake(0, [gesture velocityInView:gesture.view].y)];
    }
}

@end
