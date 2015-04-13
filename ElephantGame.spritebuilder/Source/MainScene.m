#import "MainScene.h"

@implementation MainScene

- (void)play {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Level"];
    [[CCDirector sharedDirector]replaceScene:gameplayScene];
}

@end
