#import "MainScene.h"

@implementation MainScene

- (void)play {
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]==NO){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        
        CCScene *firstLevel = [CCBReader loadAsScene:@"LevelTutorial"];
        CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
        [[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
        
    }else {
        CCScene *firstLevel = [CCBReader loadAsScene:@"Level"];
        CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
        [[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
    }
    
}

@end
