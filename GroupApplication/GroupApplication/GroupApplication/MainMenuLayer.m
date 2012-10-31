//
//  MainMenuLayer.m
//  GroupApplication
//
//  Created by Henricson Cedrick Z. Cuevas on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "HelloWorldLayer.h"
#import "HowGameLayer.h"



@implementation MainMenuLayer

/*+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuLayer *layer = [MainMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}*/

+(id) scene
{
    CCScene *scene = [CCScene node];
    
    MainMenuLayer *layer = [MainMenuLayer node];
    
    [scene addChild: layer];
    
    return scene;
}

-(id) init
{
    
    if( (self=[super init] )) {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        title = [[CCLabelTTF labelWithString:@"Main Menu" dimensions:CGSizeMake(0, 300) hAlignment:UITextAlignmentCenter fontName:@"Courier" fontSize:40]retain];
        
        title.position =  ccp(winSize.width/2,winSize.height-(title.contentSize.height/2));
        [self addChild: title];
        
        /*startGameButton = [CCMenuItemImage
                                        itemFromNormalImage:@"StartButtonIMG.png"
                                        selectedImage:@"StartButtonIMG.png"
                                        target:self
                                        selector:@selector(startGame:)];
        
        startGameButton.position = ccp(150, 400);
        CCMenu *startGameMenu = [CCMenu menuWithItems:startGameButton, nil];
        startGameMenu.position = CGPointZero;
        [self addChild:startGameMenu];
        
        howGameButton = [CCMenuItemImage
                           itemFromNormalImage:@"HowButtonIMG.png"
                           selectedImage:@"HowButtonIMG.png"
                           target:self
                           selector:@selector(howGame:)];
        
        howGameButton.position = ccp(150, 350);
        CCMenu *howGameMenu = [CCMenu menuWithItems:howGameButton, nil];
        howGameMenu.position = CGPointZero;
        [self addChild:howGameMenu];*/
        /////////////////////////////
        startGameButton = [CCMenuItemImage itemWithNormalImage:@"StartButtonIMG.png" selectedImage:@"StartButtonIMG.png" target:self selector:@selector(startGame:)];
        
        howGameButton = [CCMenuItemImage itemWithNormalImage:@"HowButtonIMG.png" selectedImage:@"HowButtonIMG.png" target:self selector:@selector(howGame:)];
        
        
        startGameButton.position = ccp(150, 400);
        CCMenu *startGame = [CCMenu menuWithItems:startGameButton, nil];
        startGame.position = CGPointZero;
        
        howGameButton.position = ccp(150, 300);
        CCMenu *howGame = [CCMenu menuWithItems:howGameButton, nil];
        howGame.position = CGPointZero;
        
        [self addChild:startGame z:1];
        [self addChild:howGame z:1];
        
    }
    return self;
}
- (void) startGame: (id) sender;
{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}

- (void) howGame: (id) sender;
{
    [[CCDirector sharedDirector] replaceScene:[HowGameLayer scene]];
}


- (void) dealloc
{
    
    [super dealloc];
}


@end
