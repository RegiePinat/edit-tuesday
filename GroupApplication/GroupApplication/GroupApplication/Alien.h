//
//  Alien.h
//  GroupApplication
//
//  Created by Henricson Cedrick Z. Cuevas on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Alien : CCSprite 
{
        int size;
        CGPoint velocity;
}
    
@property int size;
@property CGPoint velocity;
    
- (id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect;
- (void)update:(ccTime)dt;
- (bool)collidesWith:(CCSprite *)obj;
    
@end
