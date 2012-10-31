//
//  HowGameLayer.m
//  GroupApplication
//
//  Created by Henricson Cedrick Z. Cuevas on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HowGameLayer.h"
#import "MainMenuLayer.h"


@implementation HowGameLayer

+(id) scene
{
    CCScene *scene = [CCScene node];
    
    HowGameLayer *layer = [HowGameLayer node];
    
    [scene addChild: layer];
    
    return scene;
}

-(id) init
{
    
    if( (self=[super init] )) {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        title = [[CCLabelTTF labelWithString:@"How" dimensions:CGSizeMake(0, 300) hAlignment:UITextAlignmentCenter fontName:@"Courier" fontSize:40]retain];
        
        title.position =  ccp(winSize.width/2,winSize.height-(title.contentSize.height/2));
        [self addChild: title];
        
        backToMenuButton = [CCMenuItemImage itemWithNormalImage:@"buttonHome.png" selectedImage:@"buttonHome.png" target:self selector:@selector(backToMenu:)];
        
        
        backToMenuButton.position = ccp(150, 400);
        CCMenu *backToMenu = [CCMenu menuWithItems:backToMenuButton, nil];
        backToMenu.position = CGPointZero;

        [self addChild:backToMenu z:1];

        
        
    }
    return self;
}
- (void) backToMenu:(id)sender;
{
    [[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
}


- (void) dealloc
{
    
    [super dealloc];
}




@end
