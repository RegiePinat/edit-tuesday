//
//  MyCharacter.h
//  GroupApplication
//
//  Created by Henricson Cedrick Z. Cuevas on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MyCharacter : CCSprite {
    
    CGPoint velocity;
    float myCharPointPerSecY; 
}

@property CGPoint velocity;
@property float myCharPointPerSecY;

// Have to override this method in order to subclass CCSprite
- (id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect;

- (void)update:(ccTime)dt;


@end
