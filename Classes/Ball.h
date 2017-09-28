//
//  Ball.h
//  Part5Project
//
//  Created by sadboy84 on 30/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "OpenGLCommon.h"

@interface Ball : NSObject {

	Vertex3D    *sphereTriangleStripVertices;
    Vector3D    *sphereTriangleStripNormals;
    GLuint      sphereTriangleStripVertexCount;
    
    Vertex3D    *sphereTriangleFanVertices;
    Vector3D    *sphereTriangleFanNormals;
    GLuint      sphereTriangleFanVertexCount;
	
	GLfloat		x_pos, y_pos;
	GLfloat		x_speed, y_speed;
	
}

@property CGFloat x_pos, y_pos, x_speed, y_speed;

- (void) start;
- (void) draw;

@end
