//
//  LevelTutorial.h
//  ElephantGame
//
//  Created by 张璇 on 15/5/1.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface LevelTutorial : CCPhysicsNode<CCPhysicsCollisionDelegate>
{
    CCPhysicsNode* _physicsNode;
    CCNode* _launcher;
    CCNode* _launcher1;
}

@end
