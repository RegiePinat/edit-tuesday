//
//  HelloWorldLayer.h
//  GroupApplication
//
//  Created by Henricson Cedrick Z. Cuevas on 10/17/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "MyCharacter.h"

typedef enum
{
    kEndReasonWin,
    kEndReasonLose
} EndReason;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    
    NSMutableArray *aliens;
    NSMutableArray *bullets;

    CCArray *coins;
    //CCArray *fireBullets;
    
    MyCharacter *myCharacter;
    
    int nextCoin;
    //int nextFireBullet;
    int lives;
    int score;
    double nextCoinSpawn;
    double gameTime;
    
    bool gameOver;
    
    //float myCharPointPerSecY;
    
    CCLabelTTF *labelButtonCtrl;
    CCLabelTTF *labelScore;
    CCMenuItemImage *moveToLeftCtrl;
    CCMenuItemImage *moveToRightCtrl;
    
    CCSpriteBatchNode *batchNode;
    //CCSprite *myChar;
    
    CCParallaxNode *bgNode;
    CCSprite *_spacedust1;
    CCSprite *_spacedust2;
    CCSprite *_planetsunrise;
    CCSprite *_galaxy;
    CCSprite *_spacialanomaly;
    CCSprite *_spacialanomaly2;
    
    /////////////////////Alien
    
    //Ship *ship;
	
	// Used to determine the number of asteroids that appear
	int currentLevel;
	
	// To determine rotation
	float previousTouchAngle, currentTouchAngle;
	
	// To determine movement/shooting
	CGPoint startTouchPoint, endTouchPoint;
	
	// Player score
	int points;
	CCLabelTTF *pointsDisplay;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
- (void)createAlienAt:(CGPoint)position withSize:(int)size;
- (void)createBullet;
- (void)startLevel;
- (void)resetShip;
//- (void)gameOver;
@end
