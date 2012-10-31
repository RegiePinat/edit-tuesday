//
//  Bullet.h
//  GroupApplication
//
//  Created by Henricson Cedrick Z. Cuevas on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Bullet : CCSprite
{
        float distanceMoved;
        CGPoint velocity;
        bool expired;
}
@property float distanceMoved;
@property CGPoint velocity;
@property bool expired;
    
// Declared methods
- (id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect;
- (void)update:(ccTime *)dt;
@end