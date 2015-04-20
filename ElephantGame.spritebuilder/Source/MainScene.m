#import "MainScene.h"

@implementation MainScene

- (void)play {
    CCScene *firstLevel = [CCBReader loadAsScene:@"Level"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
}

@end
