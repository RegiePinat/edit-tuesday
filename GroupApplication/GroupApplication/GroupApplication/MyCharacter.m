//
//  MyCharacter.m
//  GroupApplication
//
//  Created by Henricson Cedrick Z. Cuevas on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MyCharacter.h"


@implementation MyCharacter

@synthesize velocity,myCharPointPerSecY;

- (id)initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
{
	if ((self = [super initWithTexture:texture rect:rect]))
	{
		[self scheduleUpdate];
        CGSize windowSize = [CCDirector sharedDirector].winSize;
        
        [self setPosition:ccp(windowSize.width * 0.5, windowSize.height * 0.5 + 60)];
	}
	return self;
}

- (void)update:(ccTime)dt
{
	
	
    
	// Get window size
	CGSize windowSize = [CCDirector sharedDirector].winSize;
    
    // Move the ship based on the "velocity" variable

    
    float maxY = windowSize.height - self.contentSize.height/2;
    float minY = self.contentSize.height/2;
    
    float newY = self.position.y + (myCharPointPerSecY * dt);
    newY = MIN(MAX(newY, minY), maxY);
    self.position = ccp(self.position.x, newY);


	// If object moves off the bounds of the screen, make it appear on the other size
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
