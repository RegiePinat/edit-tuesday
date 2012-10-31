//
//  Alien.m
//  GroupApplication
//
//  Created by Henricson Cedrick Z. Cuevas on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Alien.h"


@implementation Alien

@synthesize size, velocity;

- (id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect
{
	if ((self = [super initWithTexture:texture rect:rect]))
	{
		[self scheduleUpdate];
	}
	return self;
}

- (void)update:(ccTime)dt
{
	[self setRotation:self.rotation + (float)dt * 15];
	
	[self setPosition:ccp(self.position.x + velocity.x, self.position.y + velocity.y)];
	
	CGSize windowSize = [CCDirector sharedDirector].winSize;
    
	if (self.position.x < 0)
		[self setPosition:ccp(windowSize.width, self.position.y)];
	else if (self.position.x > windowSize.width)
		[self setPosition:ccp(0, self.position.y)];
	
	if (self.position.y < 0)
		[self setPosition:ccp(self.position.x, windowSize.height)];
	else if (self.position.y > windowSize.height)
		[self setPosition:ccp(self.position.x, 0)];
}

- (bool)collidesWith:(CCSprite *)obj
{
	CGRect ownRect = CGRectMake(self.position.x - (self.contentSize.width / 2), self.position.y - (self.contentSize.height / 2), self.contentSize.width, self.contentSize.height);
	CGRect otherRect = CGRectMake(obj.position.x - (obj.contentSize.width / 2), obj.position.y - (obj.contentSize.height / 2), obj.contentSize.width, obj.contentSize.height);
	
	return CGRectIntersectsRect(ownRect, otherRect);
}


@end
