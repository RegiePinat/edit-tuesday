//
//  HelloWorldLayer.m
//  GroupApplication
//
//  Created by Henricson Cedrick Z. Cuevas on 10/17/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "CCParallaxNode-Extras.h"
#import "SimpleAudioEngine.h"
#define kNumSpinach 15
#define kNumMilk 5
#define kNumPowUpShield 1
#import "MyMenu.h"
#import "GameOver.h"
#import "ContinueGame.h"
#define kNumUfo 6
#define kNumClouds 10


// Needed to obtain the Navigation Controller
#import "AppDelegate.h"



#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer
@synthesize timeInt;
@synthesize secs;
@synthesize mins;
@synthesize TotalTimeString;
@synthesize pauseMenuItem;
@synthesize levelString;


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
	
    points = 0;
    kills = 0;
    lives = 0;
    timeInt = 30;
    counterForLifeHeart = 3;
    counterForSpinachRegenLife = 0;
    powUpShield = 0;

    
    
    if( (self=[super initWithColor:ccc4(134, 879, 196, 361)]) ) {
        pauseScreenUp = FALSE;
        
        CGSize windowSize = [CCDirector sharedDirector].winSize;
        pauseMenuItem = [CCMenuItemImage itemWithNormalImage:@"bird.png" selectedImage:nil target:self selector:@selector(PauseButtonTapped:)];
        pauseMenuItem.position = ccp(windowSize.width * 0.5 + 110, windowSize.height * 0.5 + 230);
        
        toLeft = [CCMenuItemImage itemWithNormalImage:@"bird.png" selectedImage:@"bird.png" target:self selector:@selector(GoToLeft:)];
        toLeft.position = ccp(100, 100);
        
        toRight = [CCMenuItemImage itemWithNormalImage:@"bird.png" selectedImage:@"bird.png" target:self selector:@selector(GoToRight:)];
        toRight.position = ccp(200, 100);
        
        CCMenu *upgradeMenu = [CCMenu menuWithItems:pauseMenuItem, toRight, toLeft, nil];
        upgradeMenu.position = CGPointZero;
        [self addChild:upgradeMenu z:2];
        

        
        pointsDisplay = [CCLabelTTF labelWithString:@"0" fontName:@"Courier" fontSize:32.0];
		[pointsDisplay setPosition:ccp(windowSize.width * 0.5 + 110, windowSize.height * 0.5 + 200)];
		[pointsDisplay setColor:ccc3(255, 255, 255)];
		[self addChild:pointsDisplay z:1];

        
       CCLabelTTF *title = [CCLabelTTF labelWithString:@"Level 1" fontName:@"Marker Felt" fontSize:40];
        title.position = ccp(155, 450);
        [self addChild:title];
        
        
        TotalTimeString = [NSString stringWithFormat:@"%02d", secs];
        
        timeLabel = [[CCLabelTTF labelWithString:TotalTimeString dimensions:CGSizeMake(130, 27)  hAlignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:25.0]retain];
        
        
        timeLabel.position = ccp(155, 425);
        [self schedule:@selector(tick2:)interval: 1.0];
        [self addChild:timeLabel z:3 tag: timeInt];
        
        lifeHeart1 = [CCSprite spriteWithFile:@"LifeHeart.png"];
        [lifeHeart1 setPosition:CGPointMake(15, 470)];
        [self addChild:lifeHeart1];
        
        lifeHeart2 = [CCSprite spriteWithFile:@"LifeHeart.png"];
        [lifeHeart2 setPosition:CGPointMake(30, 470)];
        [self addChild:lifeHeart2];
        
        lifeHeart3 = [CCSprite spriteWithFile:@"LifeHeart.png"];
        [lifeHeart3 setPosition:CGPointMake(45, 470)];
        [self addChild:lifeHeart3];
       
        
        //batchNode = [CCSpriteBatchNode batchNodeWithFile:@"f.png"];
        //[self addChild:batchNode];
        //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"f.plist"];
        
        cow = [CCSprite spriteWithFile:@"1.png"];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        //[_ship setTexture:[_batchNode texture]];
        cow.position = ccp(winSize.width * 0.5, winSize.height * 0.35);
        [self addChild:cow z:3];
		
        backgroundNode = [CCParallaxNode node];
        [self addChild:backgroundNode z:1];
        
        self.isAccelerometerEnabled = YES;
        
        
        
        spinach = [[CCArray alloc]initWithCapacity:kNumSpinach];
        for(int i = 0; i < kNumSpinach; i++)
        {
            CCSprite *spinachSprite = [CCSprite spriteWithFile:@"spinach.png"];
            spinachSprite.visible = NO;
            [self addChild:spinachSprite];
            [spinach addObject:spinachSprite];
        }
        
        shield = [[CCArray alloc] initWithCapacity:kNumPowUpShield];
        for(int i = 0; i < kNumPowUpShield; ++i)
        {
            CCSprite *powShield = [CCSprite spriteWithFile:@"bote.png"];
            powShield.visible = NO;
            [self addChild:powShield];
            [shield addObject:powShield];
        }
        

        milk = [[CCArray alloc] initWithCapacity:kNumMilk];
        for(int i = 0; i < kNumMilk; ++i)
        {
            CCSprite *milkSprite = [CCSprite spriteWithFile:@"Milk-Bullet.png"];
            milkSprite.visible = NO;
            [self addChild:milkSprite];
            [milk addObject:milkSprite];
        }
        
        
        ufo = [[CCArray alloc]initWithCapacity:kNumUfo];
        for(int i = 0; i<kNumUfo; i++)
        {
            CCSprite *ufoSprite = [CCSprite spriteWithFile:@"ufomain.png"];
            
            ufoSprite.visible = YES;
            
            [self addChild: ufoSprite];
            [ufo addObject: ufoSprite];
            
        }
        
        clouds1 = [[CCArray alloc]initWithCapacity:kNumClouds];
        for(int i = 0; i<kNumClouds; i++)
        {
            CCSprite *cloudsSprite = [CCSprite spriteWithFile:@"Stars.png"];
            
            cloudsSprite.visible = NO;
            
            [self addChild: cloudsSprite];
            [clouds1 addObject: cloudsSprite];
            
            
        }
        
        
        
        self.isTouchEnabled = YES;
        
	}
    lives = 3;
    double curTime = CACurrentMediaTime();
    gameOverTime = curTime + 30;
    [self scheduleUpdate];
	return self;
}

-(void)GoToLeft: (id)sender
{
    cow.position = ccp(cow.position.x - 20, cow.position.y);
}

-(void)GoToRight: (id)sender
{
    cow.position = ccp(cow.position.x + 20, cow.position.y);
}



-(void)PauseButtonTapped: (id)sender
{
    
    
    
    if (pauseScreenUp == FALSE)
    {
        [[CCDirector sharedDirector]pause];
        
        CGSize s = [[CCDirector sharedDirector]winSize];
        
        pauseLayer = [CCLayerColor layerWithColor:ccc4(150, 150, 150, 150)width: s.width height: s.height];
        pauseLayer. position = CGPointZero;
        
        [self addChild:pauseLayer z:8];
        
        //pauseScreen = [[CCSprite spriteWithFile:@"1.png"]retain];
        //pauseScreen.position = ccp(250, 190);
        //[self addChild:pauseScreen z:8];
        
        [CCMenuItemFont setFontName:@"Arial"];
        
        
        CCMenuItemFont *resumeGame = [CCMenuItemFont itemWithString:@"Resume" target:self selector:@selector(ResumeButtonTapped:)];
        resumeGame.position = ccp(150, 150);
        
        //CCMenuItemFont *restartGame = [CCMenuItemFont itemWithString:@"Restart" target:self selector:@selector(restartTapped:)];
        //restartGame.position = ccp(150, 100);
        
        CCMenuItemFont *quitGame = [CCMenuItemFont itemWithString:@"Quit" target:self selector:@selector(QuitButtonTapped:)];
        quitGame.position = ccp(150, 100);
        
        
        pauseScreenMenu = [CCMenu menuWithItems:resumeGame,quitGame, nil];
        
        pauseScreenMenu.position = ccp(0,0);
        [self addChild:pauseScreenMenu z: 10];
        
    }
    
    
}
-(void)ResumeButtonTapped: (id)sender
{
    [self removeChild:pauseScreen cleanup:YES];
    [self removeChild:pauseScreenMenu cleanup:YES];
    [self removeChild:pauseLayer cleanup:YES];
    [[CCDirector sharedDirector]resume];
    pauseScreenUp= FALSE;
    
}

-(void)QuitButtonTapped: (id) sender
{
    [self removeChild:pauseScreen cleanup:YES];
    [self removeChild:pauseScreenMenu cleanup:YES];
    [self removeChild:pauseLayer cleanup:YES];
    [[CCDirector sharedDirector]resume];
    pauseScreenUp=FALSE;
    
    [[CCDirector sharedDirector]replaceScene:[MyMenu scene]];    

    //[[UIApplication sharedApplication] terminateWithSuccess];
    
}
    

-(void)tick2: (id) sender
{
    timeInt--;
    
    secs = timeInt %30;
    mins = timeInt/60;
    
    if(powUpShield > 0)
    {
        powUpShield--;
    }
    
    [timeLabel setString:[NSString stringWithFormat:@"%02d", secs]];
    
}


- (float) randomValueBetween:(float)low andValue:(float)high
{
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

- (void)restartTapped:(id)sender
{
    [[CCDirector sharedDirector]replaceScene:[CCTransitionZoomFlipY transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
}



-(void) MenuButton: (id)sender
{
    
    [[CCDirector sharedDirector]replaceScene:[MyMenu scene]];
    
}


- (void)update:(ccTime)dt
{
    
    
    CGPoint backgroundScrollVel = ccp(0, +1000);
    backgroundNode.position = (ccpAdd(backgroundNode.position,ccpMult(backgroundScrollVel, dt)));
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float maxX = winSize.width - cow.contentSize.width/2;
    float minX = cow.contentSize.width/2;
    
    float newX = cow.position.x + (cowPointPerSecX * dt);
    newX = MIN(MAX(newX, minX), maxX);
    cow.position = ccp(newX, cow.position.y);
    
    double curTime = CACurrentMediaTime();
    if (curTime > nextSpinachSpawn)
    {
        float randSecs = [self randomValueBetween:0.0 andValue:3.0];
        nextSpinachSpawn = randSecs + curTime;
        //nextufospawn = randSecs + curTime;
        nextcloudsspawn1 = randSecs +curTime;
        
        CCSprite *spinachSprite = [spinach objectAtIndex:nextSpinach];
        nextSpinach++;
        
        
        CCSprite *cloudsSprite = [clouds1 objectAtIndex:nextclouds1];
        nextclouds1++;
        
        
        //CCSprite *ufoSprite = [ufo objectAtIndex:nextufo];
        //nextufo++;
        
        
        float randX = [self randomValueBetween:spinachSprite.contentSize.width/2 andValue:winSize.width-spinachSprite.contentSize.width/2];
        float randDuration = [self randomValueBetween:5.0 andValue:10.0];
        
        
        if(nextclouds1>= clouds1.count) nextclouds1 = 0;
        [cloudsSprite stopAllActions];
        cloudsSprite.position = ccp(randX, winSize.height - cloudsSprite.contentSize.height - 500);
        cloudsSprite.visible = YES;
        [cloudsSprite runAction:[CCSequence actions:
                                 [CCMoveBy actionWithDuration:3.0 position:ccp(0,+winSize.height+cloudsSprite.contentSize.height)],
                                 [CCCallFuncN actionWithTarget:self selector:@selector(setInvisible:)],nil]];
        
        if(nextSpinach >= spinach.count) nextSpinach = 0;
        {
            [spinachSprite stopAllActions];
            spinachSprite.position = ccp(randX, winSize.height - spinachSprite.contentSize.height - 500);
            spinachSprite.visible = YES;
            [spinachSprite runAction:[CCSequence actions:
                                      [CCMoveBy actionWithDuration:randDuration position:ccp(0,+winSize.height+spinachSprite.contentSize.height)],
                                      [CCCallFuncN actionWithTarget:self selector:@selector(setInvisible:)],nil]];
            
        }
    }
    
    ////////
    if (curTime > nextufospawn)
    {
        
        float randSecs = [self randomValueBetween:0.0 andValue:1.0];
        nextufospawn = randSecs + curTime;
        
        
        CCSprite *ufoSprite = [ufo objectAtIndex:nextufo];
        nextufo++;
        
        if(nextufo>= ufo.count) nextufo = 0;
        
        // If UFO position is less than or equal to 0 then respawn
        // If UFO position is greater than window height then respawn
        // If UFO not yet visible or been hit then respawn
        // This prevents UFO[n] (slow duration) from suddenly disappearing
        if(ufoSprite.position.y > winSize.height || !ufoSprite.visible || ufoSprite.position.y <= 0)
        {
            float randX = [self randomValueBetween:ufoSprite.contentSize.width/2 andValue:winSize.width-ufoSprite.contentSize.width/2];
            float randDuration = [self randomValueBetween:8.0 andValue:10.0];
            
            
            
            [ufoSprite stopAllActions];
            ufoSprite.position = ccp(randX + 20, -winSize.height + ufoSprite.contentSize.height + 1000);
            ufoSprite.visible = YES;
            [ufoSprite runAction:[CCSequence actions:
                                  [CCMoveBy actionWithDuration:randDuration position:ccp(0,-winSize.height-ufoSprite.contentSize.height-100)],
                                  [CCCallFuncN actionWithTarget:self selector:@selector(setInvisible2:)],nil]];
        }
    }
    
    if (curTime > nextShieldSpawn)
    {
        
        float randSecs = [self randomValueBetween:0.0 andValue:1.0];
        nextShieldSpawn = randSecs + curTime;
        
        
        CCSprite *shieldSprite = [shield objectAtIndex:nextShield];
        nextShield++;
        
        if(nextShield>= shield.count) nextShield = 0;
        
        // If UFO position is less than or equal to 0 then respawn
        // If UFO position is greater than window height then respawn
        // If UFO not yet visible or been hit then respawn
        // This prevents UFO[n] (slow duration) from suddenly disappearing
        if(shieldSprite.position.y > winSize.height || !shieldSprite.visible || shieldSprite.position.y <= 0)
        {
            float randX = [self randomValueBetween:shieldSprite.contentSize.width/2 andValue:winSize.width-shieldSprite.contentSize.width/2];
            float randDuration = [self randomValueBetween:6.0 andValue:10.0];
            
            //test
            
            
            [shieldSprite stopAllActions];
            shieldSprite.position = shieldSprite.position = ccp(randX, winSize.height - shieldSprite.contentSize.height - 500);
            shieldSprite.visible = YES;
            [shieldSprite runAction:[CCSequence actions:
                                  [CCMoveBy actionWithDuration:randDuration position:ccp(0,+winSize.height+shieldSprite.contentSize.height-100)],
                                  [CCCallFuncN actionWithTarget:self selector:@selector(setInvisible2:)],nil]];
        }
    }

    for (CCSprite *spinachSprite in spinach)
    {
        if(!spinachSprite.visible)
        {
            continue;
        }
        
        for (CCSprite *milkSprite in milk)
        {
            if(!milkSprite.visible)
            {
                continue;
            }
            //if(CGRectIntersectsRect(milkSprite.boundingBox, spinachSprite.boundingBox))
            //{
            //[[SimpleAudioEngine sharedEngine] playEffect:@"explosion_large.caf"];
            //milkSprite.visible = NO;
            //spinachSprite.visible = NO;
            //continue;
            //}
        }
        
        if(CGRectIntersectsRect(cow.boundingBox, spinachSprite.boundingBox))
        {
            
            //powUpShield = 10;
            points +=1;
            counterForSpinachRegenLife = counterForSpinachRegenLife + 1;
            //NSLog(@"ASD");
            //NSLog(@"%i",points);
            spinachSprite.visible = NO;
            if(counterForLifeHeart == 2)
            {
                if (counterForSpinachRegenLife == 4)
                {
                    counterForSpinachRegenLife = 0;
                    lifeHeart3.visible = YES;
                    lives++;
                }
            }
            
            if(counterForLifeHeart == 1)
            {
                if (counterForSpinachRegenLife == 4)
                {
                    counterForSpinachRegenLife = 0;
                    lifeHeart2.visible = YES;
                    lives++;
                }
            }
            //NSLog(@"Kain spinach! %i",lives);
            //_lives++;
        }
    }
    
    for (CCSprite *shieldSprite in shield)
    {
        if(!shieldSprite.visible)
        {
            continue;
        }
        
        if(CGRectIntersectsRect(cow.boundingBox, shieldSprite.boundingBox))
        {
            
            powUpShield = 5;
            shieldSprite.visible = NO;
            //_lives++;
        }
    }

    
    for (CCSprite *ufoSprite in ufo)
    {
        if(!ufoSprite.visible)
        {
            continue;
        }
        
        for (CCSprite *milkSprite in milk)
        {
            if(!milkSprite.visible)
            {
                continue;
            }
            if(CGRectIntersectsRect(milkSprite.boundingBox, ufoSprite.boundingBox))
            {
                kills+=100;
                [pointsDisplay setString:[NSString stringWithFormat:@"%i", kills]];
                NSLog(@"%i", kills);
                milkSprite.visible = NO;
                ufoSprite.visible = NO;
                
                continue;
            }
        }
        
        //Collision detection for ufo and powerup still active
        if(CGRectIntersectsRect(cow.boundingBox, ufoSprite.boundingBox)  && powUpShield == 0)
        {
            lives--;
            ufoSprite.visible = NO;
            [cow runAction:[CCBlink actionWithDuration:0.5 blinks:9]];
            
            counterForLifeHeart = counterForLifeHeart - 1;
            if(counterForLifeHeart == 2)
            {
                lifeHeart3.visible = NO;
            }
            if(counterForLifeHeart == 1)
            {
                lifeHeart2.visible = NO;
            }
            if(counterForLifeHeart == 0)
            {
                lifeHeart1.visible = NO;
            }
            NSLog(@"Tinamaan! %i",lives);
            
        }
    }
    
    
    if (lives <= 0 || curTime >= gameOverTime)
    {
        [cow stopAllActions];
        cow.visible = FALSE;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if (lives <= 0)
        {
            // Get high scores array from "defaults" object
            NSMutableArray *highScores = [NSMutableArray arrayWithArray:[defaults arrayForKey:@"scores"]];
            
            // Iterate thru high scores; see if current point value is higher than any of the stored values
            for (int i = 0; i < [highScores count]; i++)
            {
                if (kills >= [[highScores objectAtIndex:i] intValue])
                {
                    // Insert new high score, which pushes all others down
                    [highScores insertObject:[NSNumber numberWithInt:kills] atIndex:i];
                    
                    // Remove last score, so as to ensure only 5 entries in the high score array
                    [highScores removeLastObject];
                    
                    // Re-save scores array to user defaults
                    [defaults setObject:highScores forKey:@"scores"];
                    
                    [defaults synchronize];
                    
                    NSLog(@"Saved new high score of %i", kills);
                    
                    // Bust out of the loop
                    break;
                }
            }
            
            [[CCDirector sharedDirector]replaceScene:[GameOver scene]];
        }
        else
        {
            //NSInteger lastScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"last_score"];
            [[NSUserDefaults standardUserDefaults] setInteger:kills forKey:@"last_score"];
            //NSLog(@"Con Score %i",lastScore);
            [[CCDirector sharedDirector]replaceScene:[ContinueGame scene]];
        }
        
    }
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *milkSprite = [milk objectAtIndex:nextMilk];
    nextMilk++;
    if (nextMilk >= milk.count) nextMilk = 0;
    
    milkSprite.position = ccpAdd(ccp(0, milkSprite.contentSize.height*.5), cow.position);
    milkSprite.visible = YES;
    [milkSprite stopAllActions];
    [milkSprite runAction:[CCSequence actions:
                           [CCMoveBy actionWithDuration:2.0 position:ccp(0, +winSize.height)],
                           [CCCallFuncN actionWithTarget:self selector:@selector(setInvisible:)],
                           nil]];
    
}

- (void)setInvisible:(CCNode *)node
{
    node.visible = NO;
}

- (void)setInvisible2:(CCNode *)node
{
    node.visible = NO;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
#define kFilteringFactor 0.1
#define kRestAccelX -0.6
#define kShipMaxPointsPerSec (winSize.width * 0.5)
#define kMaxDiffX 0.2
    
    UIAccelerationValue rollingX, rollingY, rollingZ;
    
    rollingX = (acceleration.x * kFilteringFactor) + (rollingX * (1.0 - kFilteringFactor));
    rollingY = (acceleration.y * kFilteringFactor) + (rollingY * (1.0 - kFilteringFactor));
    rollingZ = (acceleration.z * kFilteringFactor) + (rollingZ * (1.0 - kFilteringFactor));
    
    float accelX = acceleration.x - rollingX;
    //float accelY = acceleration.y - rollingY;
    //float accelZ = acceleration.z - rollingZ;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    float accelDiff = accelX - kRestAccelX;
    float accelFraction = accelDiff / kMaxDiffX;
    float pointPerSec = kShipMaxPointsPerSec * accelFraction;
    
    cowPointPerSecX = pointPerSec;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
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
