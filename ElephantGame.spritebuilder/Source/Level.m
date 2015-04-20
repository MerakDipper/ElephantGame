//
//  Feather.m
//  ElephantGame
//
//  Created by 张璇 on 15/2/20.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "Level.h"
#import "Feather.h"
#import "WinPopup.h"
#import "LevelType.h"
//#import "Elephant.h"

static NSString *const kFirstLevel = @"Levels/Level1";
static NSString *selectedLevel = @"Levels/Level1";
static const float MIN_SPEED=1.f;

@implementation Level {
    Feather* feather;
    CCNode* ground;
    CCNode* background;
    CCButton *restartButton;
    CCButton *winButton;
    CCNode* peanut;
    CCButton *touchEle;
    BOOL _gameOver;
    CCAction *followFeather;
    CCNode *contentNode;
    CCNode *elephant;
    CCButton *moveButton;
    CCNode *levelNode;
    //CCScene *levels;
    //CCSprite* star;
    CCLabelTTF *_scoreLabel;
    LevelType *_loadedLevel;
    int _score;

}


- (void) onEnter {
    [super onEnter];
    restartButton.visible = FALSE;
    feather.physicsBody.collisionType = @"feather";
    
    ground.physicsBody.collisionType = @"ground";
    
    CGRect box = CGRectMake(0, 0, self.boundingBox.size.width, self.boundingBox.size.height);
    followFeather = [CCActionFollow actionWithTarget:feather worldBoundary:box];
    [contentNode runAction:followFeather];
    
}


- (void)didLoadFromCCB {
    feather = (Feather*)[CCBReader load:@"Feather"];
    //elephant = (Elephant*)[CCBReader load:@"Elephant"];
    _physicsNode.collisionDelegate =self;
    [_physicsNode addChild:feather];
    //springLink = [CCPhysicsJoint connectedSpringJointWithBodyA:feather.physicsBody bodyB:elephant.physicsBody anchorA:ccp(0, 0) anchorB:ccp(30, 30) restLength:150.f stiffness:500.f damping:40.f];
    //CCScene *levels = [CCBReader loadAsScene:@"Levels/Level1"];
    _loadedLevel= (LevelType *)[CCBReader load: selectedLevel owner:self];
    [levelNode addChild:_loadedLevel];
    
    
}

-(void)loadNextLevel {
    selectedLevel = _loadedLevel.nextLevelName;
    CCScene *nextScene = nil;
    if(selectedLevel) {
        nextScene = [CCBReader loadAsScene:@"Level"];
    }else {
        selectedLevel = kFirstLevel;
        nextScene = [CCBReader loadAsScene:@"MainScene"];
    }
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:nextScene withTransition:transition];
}

-(void)launchPeanut:(id)sender
{
    // Calculate rotation in radians
    float rotationRadians = CC_DEGREES_TO_RADIANS(_launcher.rotation+38);
    
    // Vector for rotation
    CGPoint directionVector = ccp(sinf(rotationRadians), cosf(rotationRadians));
    CGPoint peanutOffset = ccpMult(directionVector, 30);
    
        // Load peanut and set it's initial position
        peanut = [CCBReader load:@"Peanut"];
        peanut.physicsBody.collisionType=@"peanutc";
    
        CGPoint spawnPosition = elephant.position;
        //CGPoint spawnPosition = _launcher1.position;
        spawnPosition.x = spawnPosition.x+150;
        spawnPosition.y = spawnPosition.y+100;
        peanut.position = ccpAdd(spawnPosition, peanutOffset);
        peanut.rotation = _launcher.rotation-50;
        peanut.scale = 0.5;
        
        [_physicsNode addChild:peanut];
        
        // Make and impulse and apply it
        CGPoint force = ccpMult(directionVector, 350000);
        [peanut.physicsBody applyForce:force];
    
    
    
    
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair*)pair feather:(CCSprite*)feather ground:(CCNode*)ground {
    //NSLog(@"Collision");
    [self gameOver];
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair*)pair feather:(CCSprite*)feather star:(CCSprite*)star {
    CCLOG(@"star");
    [star removeFromParent];
    _score++;
    _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair*)pair peanutc:(CCNode*)peanut feather:(CCSprite*)feather {
    CCLOG(@"CollisionBulletfeather");
    //peanut.physicsBody=nil;
    [peanut removeFromParent];
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair*)pair peanutc:(CCNode*)peanut ground:(CCNode*)ground {
    CCLOG(@"CollisionBulletground");
    //peanut.physicsBody=nil;
    [peanut removeFromParent];
    return TRUE;
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair*)pair peanutc:(CCNode*)peanut star:(CCSprite*)star {
    CCLOG(@"peanutandstar");
    return NO;
}





- (void)gameOver {
    
    _gameOver = TRUE;
    restartButton.visible = TRUE;
    //[contentNode stopAction:followFeather];
    [_launcher stopAllActions];
    [feather stopAllActions];
    [elephant stopAllActions];
    touchEle.enabled = FALSE;
    CCActionMoveTo *actionMoveTo = [CCActionMoveTo actionWithDuration:1.f position:ccp(0,0)];
    [contentNode runAction:actionMoveTo];
    feather.physicsBody = nil;

    //[[CCDirector sharedDirector] pause];
}

- (void)gameWin {
    _gameOver = TRUE;
    //winButton.visible = TRUE;
    feather.physicsBody = nil;
    //[[CCDirector sharedDirector] pause];
    WinPopup *popup = (WinPopup *)[CCBReader load:@"WinPopup" owner:self];
    popup.positionType = CCPositionTypeNormalized;
    popup.position=ccp(0.3,0.5);
    [self addChild:popup];
}
    

- (void)restart {
    CCScene *scene = [CCBReader loadAsScene:@"Level"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void)moveElephantForward {
    NSLog(@"touched ground2");
    CCActionMoveBy* moveForward = [CCActionMoveBy actionWithDuration:0.3f position:ccp(50.0f, 0.0f)];
    [elephant runAction:moveForward];
}

-(void)move {
    [self moveElephantForward];
    NSLog(@"touched ground1");
}

- (void)update:(CCTime)delta {
    if ((feather.position.x-self.boundingBox.origin.x > self.boundingBox.size.width)) //||
        //(feather.position.y-self.boundingBox.origin.y > self.boundingBox.size.height))
    {
        //NSLog(@"Update:%g, %g",feather.position.x,self.boundingBox.size.width);
        [self gameWin];
        return;
        //ground.position = ccp(ground.position.x + ground.contentSize.width, ground.position.y);
        
    }
    if((feather.position.x-self.boundingBox.origin.x>200)&&(ccpLength(feather.physicsBody.velocity)<MIN_SPEED)) {
        [self gameOver];
        return;
    }
//    if(!_gameOver) {
//        @try {
//            [super update:delta];
//        }
//        @catch(NSException* ex)
//        {
//            
//        }
//    }
    
    //loop the backgrounf
    //get the world
//    CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
//    CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
//    if (groundScreenPosition.x <= (-1 * ground.contentSize.width)) {
//        ground.position = ccp(ground.position.x + 2 * ground.contentSize.width, ground.position.y);
//    }
}

@end
