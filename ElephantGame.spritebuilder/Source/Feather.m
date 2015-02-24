//
//  Feather.m
//  ElephantGame
//
//  Created by 张璇 on 15/2/20.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "Feather.h"

@implementation Feather
- (void)didLoadFromCCB
{
    self.position = ccp(200, 250);
    self.physicsBody.collisionType = @"Feather";
}


@end
