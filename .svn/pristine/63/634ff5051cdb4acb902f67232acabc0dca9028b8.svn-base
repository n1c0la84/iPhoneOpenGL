//
//  GroupOfBalls.h
//  Part5Project
//
//  Created by sadboy84 on 30/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <AudioToolbox/AudioServices.h>
#import "OpenGLCommon.h"
#import "Ball.h"

#define BALLS_COUNT 4

@interface GroupOfBalls : NSObject {

	Ball	 *balls[BALLS_COUNT];
	GLfloat	 materials[BALLS_COUNT][4];
	
	SystemSoundID ballHitID; 
	
}

- (void) start;
- (void) draw;
- (void) animate;

- (void) loadMaterials;
- (void) detectCollisions;

@end
