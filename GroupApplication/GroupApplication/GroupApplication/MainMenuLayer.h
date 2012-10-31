//
//  MainMenuLayer.h
//  GroupApplication
//
//  Created by Henricson Cedrick Z. Cuevas on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainMenuLayer : CCLayer {
    
    CCLabelTTF *title;
    CCMenuItemImage *startGameButton;
    CCMenuItemImage *howGameButton;
}

+(id) scene;

- (void) startGame: (id) sender;
- (void) howGame: (id) sender;

@end
