//
//  Bullet.m
//  GroupApplication
//
//  Created by Henricson Cedrick Z. Cuevas on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Bullet.h"

@implementation Bullet

@synthesize distanceMoved, velocity, expired;

- (id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect
{
	if ((self = [super initWithTexture:texture rect:rect]))
	{
		// Schedule update for this object
		[self scheduleUpdate];
		
		// Initialize the distance the bullet has moved
		distanceMoved = 0;
	}
	return self;
}

- (void)update:(ccTime *)dt
{
	// Get window size
	CGSize windowSize = [CCDirector sharedDirector].winSize;
	
	// Move
	[self setPosition:ccp(self.position.x + velocity.x, self.position.y + velocity.y)];
	
	// Increment the distance moved by the velocity vector
	distanceMoved += sqrt(pow(velocity.x, 2) + pow(velocity.y, 2));
	
	// Determine if bullet is expired -- check to see if its gone at least half the width of the screen
	if (distanceMoved > windowSize.width / 2)
		expired = TRUE;
    
	/*if (self.position.x < 0)
		[self setPosition:ccp(windowSize.width, self.position.y)];
	else if (self.position.x > windowSize.width)
		[self setPosition:ccp(0, self.position.y)];
	
	if (self.position.y < 0)
		[self setPosition:ccp(self.position.x, windowSize.height)];
	else if (self.position.y > windowSize.height)
		[self setPosition:ccp(self.position.x, 0)];*/
}

@end
