//
//  Feather.m
//  ElephantGame
//
//  Created by 张璇 on 15/2/20.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "Level.h"
#import "Feather.h"

@implementation Level {
    CCNode* feather;
    CCNode* ground;
    CCButton *restartButton;
    CCNode* peanut;
    CCButton *touchEle;
    BOOL _gameOver;
    CCAction *followFeather;
    CCNode *contentNode;
    CCNode *elephant;
    CCPhysicsJoint *springLink;

}


- (void) onEnter {
    [super onEnter];
    restartButton.visible = FALSE;
    feather.physicsBody.collisionType = @"feather";
    ground.physicsBody.collisionType = @"ground";
    
}


- (void)didLoadFromCCB {
    feather = (Feather*)[CCBReader load:@"Feather"];
    _physicsNode.collisionDelegate =self;
    [_physicsNode addChild:feather];
    springLink = [CCPhysicsJoint connectedSpringJointWithBodyA:feather.physicsBody bodyB:elephant.physicsBody anchorA:ccp(0, 0) anchorB:ccp(30, 30) restLength:150.f stiffness:500.f damping:40.f];
    
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
        
        CGPoint spawnPosition = _launcher.position;
        spawnPosition.x = spawnPosition.x+25;
        spawnPosition.y = spawnPosition.y-15;
        peanut.position = ccpAdd(spawnPosition, peanutOffset);
        peanut.rotation = _launcher.rotation-50;
        peanut.scale = 0.5;
        
        [_physicsNode addChild:peanut];
        
        // Make and impulse and apply it
        CGPoint force = ccpMult(directionVector, 18000);
        [peanut.physicsBody applyForce:force];
    
    CCActionFollow *follow = [CCActionFollow actionWithTarget:feather worldBoundary:self.boundingBox];
    [contentNode runAction:follow];
    
    
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair*)pair feather:(CCSprite*)feather ground:(CCNode*)ground {
    //NSLog(@"Collision");
    [self gameOver];
    return TRUE;
}

- (void)gameOver {
    
    _gameOver = TRUE;
    restartButton.visible = TRUE;
    [contentNode stopAction:followFeather];
    [_launcher stopAllActions];
    CCActionMoveTo *actionMoveTo = [CCActionMoveTo actionWithDuration:1.f position:ccp(0,0)];
    [contentNode runAction:actionMoveTo];
}

- (void)restart {
    CCScene *scene = [CCBReader loadAsScene:@"Level"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)update:(CCTime)delta {
    if ((feather.position.x-self.boundingBox.origin.x > self.boundingBox.size.width) ||
        (feather.position.y-self.boundingBox.origin.y > self.boundingBox.size.height))
    {
        //NSLog(@"Update:%g, %g",feather.position.x,self.boundingBox.size.width);
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
}

@end
