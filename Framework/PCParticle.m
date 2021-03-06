#import "PCParticle.h"
#import "Util.h"
#import <Foundation/Foundation.h>

static NSMutableArray *liveParticles = nil;
static NSMutableArray *deadParticles = nil;
static NSMutableArray *liveEmitters = nil;
static NSMutableArray *deadEmitters = nil;



@implementation PCParticle
@synthesize velocity, life;

- (PCParticle*) initWithX: (int) x Y: (int) y velocityX: (int) vx velocityY: (int) vy imagePath: (NSString*) path lifeSpan: (float) _life {
	UIImage *img = [UIImage imageNamed: path];
	CGSize size = img.size;

	self = [super initWithFrame: CGRectMake(0, 0, size.width, size.height)];
	self.center = CGPointMake(x, y);
	life = _life;
	velocity = CGPointMake(vx, vy);
	self.image = img;
	return self;
}

+ (PCParticle*) getParticle {
	if (![deadParticles count]) {
		for (int LCV = 0; LCV < 18; LCV++) {
			[deadParticles addObject: [[PCParticle alloc] init]];
		}
	}
	PCParticle *retval = [deadParticles lastObject];
	[liveParticles addObject: retval];
	[deadParticles removeLastObject];
	return retval;
}

+ (void) initialize {
	deadParticles = [[NSMutableArray alloc] initWithCapacity: 36];
	liveParticles = [[NSMutableArray alloc] initWithCapacity: 36];
	for (int LCV = 0; LCV < 18; LCV++) {
		[deadParticles addObject: [[PCParticle alloc] init]];
	}
}

- (void) stopAnimation: (NSString*) animationID finished: (BOOL) finished context: (void*) context {
	[deadParticles addObject: self];
	[liveParticles removeObject: self];
	[self removeFromSuperview];
}


@end


@implementation PCEmitter
@synthesize frequency, bias;

- (PCEmitter*) initWithX: (int) x Y: (int) y velocityX: (int) vx velocityY: (int) vy
			   imagePath: (NSString*) path lifeSpan: (float) _life freq: (float) _frequency bias: (CGPoint) _bias {
	[super initWithX: x Y: y velocityX: vx velocityY: vy imagePath: path lifeSpan: _life];
	frequency = _frequency;
	bias = _bias;
	life *= frequency;
	DLog(@"life after init: %f %f %f",life, _life, _frequency);

	return self;
}

+ (PCEmitter*) get {
	if (!deadEmitters) {
		deadEmitters = [[NSMutableArray alloc] initWithCapacity: 6];
		liveEmitters = [[NSMutableArray alloc] initWithCapacity: 6];
	}
	if (![deadEmitters count]) {
		for (int LCV = 0; LCV < 6; LCV++) {
			[deadEmitters addObject: [PCEmitter alloc]];
		}
	}
	PCEmitter *retval = [deadEmitters lastObject];
	[liveEmitters addObject: retval];
	[deadEmitters removeLastObject];
	return retval;
}

float calcBias (float delta, float velocity) {	
	if (delta < 0) return -fabs(velocity * delta);
	if (delta > 0) return fabs(velocity * delta);
	return delta;
}

float randomer (float input) {
	float rand = [Rand min: 0 max: 200] / 100.0;
	input += [Rand min: -100 max: 100] / 10.0;
	return rand * input;
}

- (void) updateEmitter: (NSTimer*) timer {
	// FIXME randomize
	self.center = CGPointMake(self.center.x + velocity.x / life, self.center.y + velocity.y / life);
//	self.center.x += velocity.x / life;
//	self.center.y += velocity.y / life;

	PCParticle *particle = [[PCParticle getParticle] initWithX: self.center.x Y: self.center.y
													 velocityX: velocity.x * 1.5 velocityY: velocity.y * 1.5
													 imagePath: @"blood.png" lifeSpan: 1];
	[self.superview addSubview: particle];
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDelegate: particle];
	[UIView setAnimationDidStopSelector:@selector(stopAnimation:finished:context:)];
	[UIView setAnimationDuration: particle.life];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	
	float dx = randomer(calcBias(bias.x, velocity.x));
	float dy = randomer(calcBias(bias.y, velocity.y));

	particle.center = CGPointMake (self.center.x + dx, self.center.y + dy);
	[UIView commitAnimations];

	life--;
//	DLog(@"%f", life);	FIXME: why does life <= 0 cause these to stay forever?
	if (life <= 30) {
		[deadEmitters addObject: self];
		[liveEmitters removeObject: self];
		[self removeFromSuperview];
		[timer invalidate];
	}
}

+ (PCEmitter*) startWithX: (int) x Y: (int) y velocityX: (int) vx velocityY: (int) vy
			  imagePath: (NSString*) path lifeSpan: (float) _life freq: (float) _frequency bias: (CGPoint) _bias {
	PCEmitter *retval = [PCEmitter get];
	[retval initWithX: x Y: y velocityX: vx velocityY: vy imagePath: path lifeSpan: _life freq: _frequency bias: _bias];

	DLog(@"%d %d %d %d",[deadEmitters count],[liveEmitters count], [deadParticles count], [liveParticles count]);

	[NSTimer scheduledTimerWithTimeInterval: 1.0 / _frequency target: retval selector:@selector(updateEmitter:) userInfo:nil repeats: true];
	return retval;
}


//- (void) finishedMoveOutAnimation:(NSString*)animationID finished:(BOOL)finished context:(void *)context {	
//	shrinker.imageView.transform = CGAffineTransformMakeScale(1, 1);
//	shrinker.imageView.center = CGPointMake(shrinker.imageView.center.x, shrinker.view.center.y - 36);
//	[shrinker.view removeFromSuperview];
//	
//	shrinker = nil;
//	if (verbose) NSLog(@"shrinker unloaded");
//	
//	[[ManagedObject context] save: nil];
//	
//	[MovieViewController stopIgnore];
//	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
//	ignoreScroll = false;
//	
//	for (int LCV = -PAGES_TO_LOAD; LCV <= PAGES_TO_LOAD; LCV++) {
//		[self loadScrollViewWithPage: [self page] + LCV];
//	}
//}
//
//- (void) finishedMoveInAnimation:(NSString*)animationID finished:(BOOL)finished context:(void *)context {
//	NSMutableArray *array = (NSMutableArray*)context;
//	MovieViewController *left = (MovieViewController*) [array objectAtIndex:0];
//	MovieViewController *right = (MovieViewController*) [array objectAtIndex:1];
//	
//	[UIView beginAnimations:animationID context:context];
//	[UIView setAnimationBeginsFromCurrentState:YES];
//	[UIView setAnimationDelegate:self];
//	[UIView setAnimationDidStopSelector:@selector(finishedMoveOutAnimation:finished:context:)];
//	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];	// EaseOut seems to cause a jump...?
//	[UIView setAnimationDuration: shrinkDuration];
//	left.view.center = CGPointMake(left.view.center.x - PAGE_WIDTH / 2, left.view.center.y);
//	right.view.center = CGPointMake(right.view.center.x - PAGE_WIDTH / 2, right.view.center.y);	
//	[UIView commitAnimations];
//}


@end


