//
//  HelloWorldLayer.m
//  GroupApplication
//
//  Created by Henricson Cedrick Z. Cuevas on 10/17/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "Alien.h"
#import "Bullet.h"
#import "GameConfig.h"
#import "MyCharacter.h"
#import "CCParallaxNode-Extras.h"
#import "SimpleAudioEngine.h"
#define kNumCoins 15
#define kNumBullets 5

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"



#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super initWithColor:ccc4(0, 191, 250, 255)]) ) {
        
        //[self setIsTouchEnabled:TRUE];
        
		// Schedule the update method in this layer
		//[self scheduleUpdate];
		
		// Get window size
		CGSize windowSize = [CCDirector sharedDirector].winSize;
        
		// Create ship object and add it to layer
		myCharacter = [MyCharacter spriteWithFile:@"Cow.png"];
		[self addChild:myCharacter];
		
		// Create label to show player score
		pointsDisplay = [CCLabelTTF labelWithString:@"0" fontName:@"Courier" fontSize:32.0];
		[pointsDisplay setPosition:ccp(windowSize.width * 0.5 + 150, windowSize.height * 0.5 + 200)];
		[pointsDisplay setColor:ccc3(255, 255, 255)];
		[self addChild:pointsDisplay z:1];

        
        moveToLeftCtrl = [CCMenuItemImage itemWithNormalImage:@"buttonToLeft.png" selectedImage:@"buttonToLeft.png" target:self selector:@selector(moveToLeftButtonTapped:)];
        
        moveToRightCtrl = [CCMenuItemImage itemWithNormalImage:@"buttonToRight.png" selectedImage:@"buttonToRight.png" target:self selector:@selector(moveToRightButtonTapped:)];
        
        moveToLeftCtrl.position = ccp(60, 60);
        CCMenu *moveToLeft = [CCMenu menuWithItems:moveToLeftCtrl, nil];
        moveToLeft.position = CGPointZero;
        
        moveToRightCtrl.position = ccp(270, 60);
        CCMenu *moveToRight = [CCMenu menuWithItems:moveToRightCtrl, nil];
        moveToRight.position = CGPointZero;
        
        
        [self addChild:moveToLeft z:1];
        [self addChild:moveToRight z:1];
        
        ////////////////
        
        batchNode = [CCSpriteBatchNode batchNodeWithFile:@"CCGASprites.png"];
        [self addChild: batchNode];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CCGASprites.plist"];
        
		
        bgNode = [CCParallaxNode node];
        [self addChild:bgNode z:-1];
        
		
        // Initialize arrays that will be used to store other game objects
		aliens = [[NSMutableArray array] retain];
		bullets = [[NSMutableArray array] retain];
        
        // Call method which positions the ship and creates asteroids

		[self startLevel];
        
        
        
        
        //////////////////////////////////////////////////////////////////////8***********
        
        
		       
        
        self.isAccelerometerEnabled = YES;
        
        coins = [[CCArray alloc]initWithCapacity:kNumCoins];
        for(int i = 0; i < kNumCoins; i++)
        {
            CCSprite *coin = [CCSprite spriteWithSpriteFrameName:@"Coins.png"];
            coin.visible = NO;
            [batchNode addChild:coin];
            [coins addObject:coin];
        }
        /*fireBullets = [[CCArray alloc] initWithCapacity:kNumLasers];
        for(int i = 0; i < kNumLasers; ++i)
        {
            CCSprite *shipLaser = [CCSprite spriteWithSpriteFrameName:@"Bullet.png"];
            shipLaser.visible = NO;
            [batchNode addChild:shipLaser];
            [fireBullets addObject:shipLaser];
        }*/
        self.isTouchEnabled = YES;
        

	}
    lives = 3;
    double currentTime = CACurrentMediaTime();
    gameTime = currentTime + 100;
    [self scheduleUpdate];
	return self;
}

- (void)moveToLeftButtonTapped:(id)sender
{
    //[labelButtonCtrl setString:@"Last button: Move To Left!"];
    NSLog(@"Left");
    
    myCharacter.position = CGPointMake(myCharacter.position.x - 5, myCharacter.position.y);
}

- (void)moveToRightButtonTapped:(id)sender
{
    //[labelButtonCtrl setString:@"Last button: Move To Right!"];
    NSLog(@"Right");
    myCharacter.position = CGPointMake(myCharacter.position.x + 5, myCharacter.position.y);
}

- (float) randomValueBetween:(float)low andValue:(float)high {
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

- (void)restartTapped:(id)sender
{
    [[CCDirector sharedDirector]replaceScene:[CCTransitionZoomFlipY transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
}

- (void)endScene:(EndReason)endReason
{
    if (gameOver) return;
    gameOver = true;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    NSString *message;
    if (endReason == kEndReasonWin)
    {
        message = @"You win!";
    }
    else if (endReason == kEndReasonLose)
    {
        message = @"You Lose!";
    }
    
    CCLabelBMFont *label;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial-hd.fnt"];
    }
    else
    {
        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial.fnt"];
    }
    
    label.scale = 0.1;
    label.position = ccp(winSize.width / 2, winSize.height * 0.6);
    [self addChild:label];
    
    CCLabelBMFont *restartLabel;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial-hd.fnt"];
    }
    else
    {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial.fnt"];
    }
    
    CCMenuItemLabel *restartItem = [CCMenuItemLabel itemWithLabel:restartLabel target:self selector:@selector(restartTapped:)];
    restartItem.scale = 0.1;
    restartItem.position = ccp(winSize.width / 2, winSize.height * 0.4);
    
    CCMenu *menu = [CCMenu menuWithItems:restartItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu];
    
    [restartItem runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    [label runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];

}

- (void)update:(ccTime)dt
{
    score = score + 1;
    
    //score += 10;
    [labelScore setString: [NSString stringWithFormat:@"%d",score]];

    CGPoint backgroundScrollVel = ccp(0, +1000);
    bgNode.position = ccpAdd(bgNode.position,ccpMult(backgroundScrollVel, dt));
    
    NSArray *spaceDusts = [NSArray arrayWithObjects:_spacedust1,_spacedust2, nil];
    for (CCSprite *spaceDust in spaceDusts)
    {
        if(-[bgNode convertToWorldSpace:spaceDust.position].y < -spaceDust.contentSize.height)
        {
            //NSLog(@"Test1");
            [bgNode incrementOffset:ccp(0,-2 * spaceDust.contentSize.height) forChild:spaceDust];
        }
    }
    
    //NSLog(@"Score: %d",score);
    
    NSArray *backgrounds = [NSArray arrayWithObjects:_planetsunrise,_galaxy,_spacialanomaly,_spacialanomaly2, nil];
    for ( CCSprite *background in backgrounds)
    {
        if (-[bgNode convertToWorldSpace:background.position].y < -background.contentSize.height)
        {
            //NSLog(@"Test2");
            [bgNode incrementOffset:ccp(0, -2000) forChild:background];
        }
        
    }
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    //float maxY = winSize.height - myCharacter.contentSize.height/2;
    //float minY = myCharacter.contentSize.height/2;
    
    //float newY = myCharacter.position.y + (myCharPointPerSecY * dt);
    //newY = MIN(MAX(newY, minY), maxY);
    //myCharacter.position = ccp(myCharacter.position.x, newY);
    
    double currentTime = CACurrentMediaTime();
    if (currentTime > nextCoinSpawn)
    {
        //float randSecs = [self randomValueBetween:0.0 andValue:1.0];
        nextCoinSpawn = 0.5 + currentTime;
        
        /////////////////////EDIT
        //float randY = [self randomValueBetween:0.0 andValue:winSize.height];
        float randX = [self randomValueBetween:40.0 andValue:80.0];
        //float randDuration = [self randomValueBetween:2.0 andValue:10.0];
        
        CCSprite *coin = [coins objectAtIndex: nextCoin];
        nextCoin++;
        
        if(nextCoin >= coins.count) nextCoin = 0;
        {
            [coin stopAllActions];
            coin.position = ccp(randX, winSize.height - coin.contentSize.height - 500);
            coin.visible = YES;
            [coin runAction:[CCSequence actions:
                                 [CCMoveBy actionWithDuration:4.0 position:ccp(0, +winSize.height + coin.contentSize.height)],
                                 [CCCallFuncN actionWithTarget:self selector:@selector(setInvisible:)],nil]];
        }
    }
    
    for (CCSprite *coin in coins)
    {
        //if(!coin.visible)
        //{
            //continue;
        //}
        
        //for (CCSprite *fireBullet in fireBullets)
        //{
            //if(!fireBullet.visible)
            //{
                //continue;
            //}
            //if(CGRectIntersectsRect(fireBullet.boundingBox, coin.boundingBox))
            //{
                //[[SimpleAudioEngine sharedEngine] playEffect:@"explosion_large.caf"];
                //fireBullet.visible = NO;
                //coin.visible = NO;
                //continue;
            //}
        //}
        
        if(CGRectIntersectsRect(myCharacter.boundingBox, coin.boundingBox))
        {
            //[[SimpleAudioEngine sharedEngine] playEffect:@""];
            coin.visible = NO;
            score = score + 10;
            [myCharacter runAction:[CCBlink actionWithDuration:1.0 blinks:9]];
            //lives--;
        }
    }
    
    if (lives <= 0)
    {
        [myCharacter stopAllActions];
        myCharacter.visible = FALSE;
        [self endScene:kEndReasonLose];
    }
    else if (currentTime >= gameTime)
    {
        [self endScene:kEndReasonWin];
    }
//////////////////////////////////////////////Alien
    if ([aliens count] == 0)
	{
		currentLevel++;
		[self startLevel];
	}
	
	// Check for collisions vs. asteroids
    for (int i = 0; i < [aliens count]; i++)
	{
        Alien *alien = [aliens objectAtIndex:i];
        
		// Check if asteroid hits ship
		if ([alien collidesWith:myCharacter])
		{
            //NSLog(@"Boom!");
			// Game over, man!
			//[self gameOver];
		}
		
		//Check if asteroid hits bullet, or if bullet is expired
        for (int j = 0; j < [bullets count]; j++)
		{
            Bullet *bullet = [bullets objectAtIndex:j];
            
			if (bullet.expired)
			{
				// Remove the bullet from organizational array
                [bullets removeObjectAtIndex:j];
                j--;
				
				// Remove bullet sprite from layer
				[self removeChild:bullet cleanup:NO];
			}
			else if ([alien collidesWith:bullet])
			{
				// Remove the asteroid the bullet collided with
                [aliens removeObjectAtIndex:i];
                i--;
				
				// Remove asteroid sprite from layer
				[self removeChild:alien cleanup:NO];
				
				// Remove the bullet the asteroid collided with
                [bullets removeObjectAtIndex:j];
                j--;
				
				// Remove bullet sprite from layer
				[self removeChild:bullet cleanup:NO];
				
				// Increment player score
				points += 10;
				[pointsDisplay setString:[NSString stringWithFormat:@"%i", points]];
				
				// Create two new asteroids in the place of the destroyed one, if the destroyed one wasn't already the smallest
				if (alien.size < kAlienSmall)
				{
					for (int i = 0; i < 2; i++)
						[self createAlienAt:alien.position withSize:alien.size + 1];
				}
			}	// End bullet/asteroid collision check
		}	// End bullet loop
		
	}	// End asteroid loop

    
}

- (void)startLevel
{
	// Reset the ship's position, which also removes all bullets
	[self resetShip];
    
	// Get window size
	CGSize windowSize = [CCDirector sharedDirector].winSize;
	
	// Create asteroids based on level number
	for (int i = 0; i < (currentLevel + 2); i++)
	{
		CGPoint randomPointOnScreen = ccp((float)(arc4random() % 100) / 100 * windowSize.width, (float)(arc4random() % 100) / 100 * windowSize.height);
        
		[self createAlienAt:randomPointOnScreen withSize:kAlienLarge];
	}
}

- (void)resetShip
{
	// Reset ship position/speed
	CGSize windowSize = [CCDirector sharedDirector].winSize;
	myCharacter.position = ccp(windowSize.width / 2, windowSize.height / 2);
	myCharacter.velocity = ccp(0, 0);
	
	// Remove all existing bullets from layer
	for (Bullet *bullet in bullets)
		[self removeChild:bullet cleanup:NO];
	
	// Empty out bullet-storing array
	[bullets removeAllObjects];
}



- (void)createAlienAt:(CGPoint)position withSize:(int)size
{
	// Decide which image file to use for the new asteroid
	NSString *imageFile;
	switch (size)
	{
		default:
		case kAlienLarge:
			imageFile = @"ball.png";
			break;
		case kAlienMedium:
			imageFile = @"ballMed.png";
			break;
		case kAlienSmall:
			imageFile = @"ballSmall.png";
			break;
	}
	
	// Create a new asteroid object using the appropriate image file
	Alien *alien = [Alien spriteWithFile:imageFile];
	
	// Set the size and position
	alien.size = size;
	alien.position = position;

	alien.velocity = ccp((float)(arc4random() % 100) / 100 - 1, (float)(arc4random() % 100) / 100 - 1);
	
	// Add asteroid to organizational array
	[aliens addObject:alien];
	
	// Add asteroid to layer
	[self addChild:alien];
}

- (void)createBullet
{
	// Create a new asteroid object using the appropriate image file
	Bullet *bullet = [Bullet spriteWithFile:@"Bullet.png"];
	
	// Set the bullet's position by starting w/ the ship's position, then adding the rotation vector, so the bullet appears to come from the ship's nose
	bullet.position = ccp(myCharacter.position.x + sin(CC_DEGREES_TO_RADIANS(myCharacter.rotation)) * myCharacter.contentSize.width, myCharacter.position.y - cos(CC_DEGREES_TO_RADIANS(myCharacter.rotation)) * myCharacter.contentSize.height);
	
	// Set the bullet's velocity to be in the same direction as the ship is pointing, plus whatever the ship's velocity is
	bullet.velocity = ccp(+sin(CC_DEGREES_TO_RADIANS(myCharacter.rotation)) * 2 + myCharacter.velocity.x, -cos(CC_DEGREES_TO_RADIANS(myCharacter.rotation)) * 2 + myCharacter.velocity.y);
	
	// Add bullet to organizational array
	[bullets addObject:bullet];
	
	// Add bullet to layer
	[self addChild:bullet];
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Fire!");
    [self createBullet];
    
}

- (void)setInvisible:(CCNode *)node
{
    node.visible = NO;
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [labelButtonCtrl release];
    labelButtonCtrl = nil;
    [aliens release];
    [bullets release];
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
