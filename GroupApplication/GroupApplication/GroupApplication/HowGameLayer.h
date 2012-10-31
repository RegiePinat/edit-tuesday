//
//  HowGameLayer.h
//  GroupApplication
//
//  Created by Henricson Cedrick Z. Cuevas on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HowGameLayer : CCLayer {
    
    CCLabelTTF *title;
    CCMenuItemImage *backToMenuButton;

}

+(id) scene;

- (void) backToMenu: (id) sender;

@end
