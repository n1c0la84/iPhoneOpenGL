//
//  GLViewController.h
//  Part5Project
//
//  Created by jeff on 5/4/09.
//  Edited by Nicola Nicodemo on 06/10.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "OpenGLCommon.h"
#import "GroupOfBalls.h"
#import "Ball.h"

@class GLView;

@interface GLViewController : UIViewController {
	
    Vertex3D  *sphereTriangleStripVertices;
    Vector3D  *sphereTriangleStripNormals;
    GLuint    sphereTriangleStripVertexCount;
    
    Vertex3D  *sphereTriangleFanVertices;
    Vector3D  *sphereTriangleFanNormals;
    GLuint    sphereTriangleFanVertexCount;
	
	GroupOfBalls  *group;
	GLuint texture[1]; 
	
	NSTimeInterval startTime;
	long int frames;

}

@property(retain) GroupOfBalls *group;
@property NSTimeInterval startTime;
@property long int frames;

- (void) drawView: (GLView*) view;
- (void) setupView: (GLView*) view;

- (void) setUpLights;
- (void) drawBackground;
- (void) loadTexture;

@end
