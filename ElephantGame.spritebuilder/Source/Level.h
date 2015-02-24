//
//  Feather.h
//  ElephantGame
//
//  Created by 张璇 on 15/2/20.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Level : CCPhysicsNode<CCPhysicsCollisionDelegate>
{
    CCPhysicsNode* _physicsNode;
    CCNode* _launcher;
}

@end
