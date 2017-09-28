//
//  Ball.m
//  Part5Project
//
//  Created by sadboy84 on 30/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"

void getSolidSphere(Vertex3D **triangleStripVertexHandle,   // Will hold vertices to be drawn as a triangle strip. 
															//      Calling code responsible for freeing if not NULL
                    Vector3D **triangleStripNormalHandle,   // Will hold normals for vertices to be drawn as triangle 
															//      strip. Calling code is responsible for freeing if 
															//      not NULL
                    GLuint *triangleStripVertexCount,       // On return, will hold the number of vertices contained in
															//      triangleStripVertices
															// =========================================================
                    Vertex3D **triangleFanVertexHandle,     // Will hold vertices to be drawn as a triangle fan. Calling
															//      code responsible for freeing if not NULL
                    Vector3D **triangleFanNormalHandle,     // Will hold normals for vertices to be drawn as triangle 
															//      strip. Calling code is responsible for freeing if 
															//      not NULL
                    GLuint *triangleFanVertexCount,         // On return, will hold the number of vertices contained in
															//      the triangleFanVertices
															// =========================================================
                    GLfloat radius,                         // The radius of the circle to be drawn
                    GLuint slices,                          // The number of slices, determines vertical "resolution"
                    GLuint stacks)                          // the number of stacks, determines horizontal "resolution"
{
    
    GLfloat rho, drho, theta, dtheta;
    GLfloat x, y, z;
    GLfloat s, ds;
    GLfloat nsign;
	nsign = 1.0;
    drho = M_PI / (GLfloat) stacks;
    dtheta = 2.0 * M_PI / (GLfloat) slices;
    
    Vertex3D *triangleStripVertices, *triangleFanVertices;
    Vector3D *triangleStripNormals, *triangleFanNormals;
    
    // Calculate the Triangle Fan for the endcaps
    *triangleFanVertexCount = slices+2;
    triangleFanVertices = calloc(*triangleFanVertexCount, sizeof(Vertex3D));
    triangleFanVertices[0].x = 0.0;
    triangleFanVertices[0].y = 0.0; 
    triangleFanVertices[0].z = nsign * radius;
    int counter = 1;
    for (int j = 0; j <= slices; j++) 
    {
        theta = (j == slices) ? 0.0 : j * dtheta;
        x = -sin(theta) * sin(drho);
        y = cos(theta) * sin(drho);
        z = nsign * cos(drho);
        triangleFanVertices[counter].x = x * radius;
        triangleFanVertices[counter].y = y * radius;
        triangleFanVertices[counter++].z = z * radius;
    }
    
    
    // Normals for a sphere around the origin are darn easy - just treat the vertex as a vector and normalize it.
    triangleFanNormals = malloc(*triangleFanVertexCount * sizeof(Vertex3D));
    memcpy(triangleFanNormals, triangleFanVertices, *triangleFanVertexCount * sizeof(Vertex3D));
    for (int i = 0; i < *triangleFanVertexCount; i++)
        Vector3DNormalize(&triangleFanNormals[i]);
    
    // Calculate the triangle strip for the sphere body
    *triangleStripVertexCount = (slices + 1) * 2 * stacks;
    triangleStripVertices = calloc(*triangleStripVertexCount, sizeof(Vertex3D));
    counter = 0;
    for (int i = 0; i < stacks; i++) {
        rho = i * drho;
		
        s = 0.0;
        for (int j = 0; j <= slices; j++) 
        {
            theta = (j == slices) ? 0.0 : j * dtheta;
            x = -sin(theta) * sin(rho);
            y = cos(theta) * sin(rho);
            z = nsign * cos(rho);
            // TODO: Implement texture mapping if texture used
            //                TXTR_COORD(s, t);
            triangleStripVertices[counter].x = x * radius;
            triangleStripVertices[counter].y = y * radius;
            triangleStripVertices[counter++].z = z * radius;
            x = -sin(theta) * sin(rho + drho);
            y = cos(theta) * sin(rho + drho);
            z = nsign * cos(rho + drho);
            //                TXTR_COORD(s, t - dt);
            s += ds;
            triangleStripVertices[counter].x = x * radius;
            triangleStripVertices[counter].y = y * radius;
            triangleStripVertices[counter++].z = z * radius;
        }
    }
    
    triangleStripNormals = malloc(*triangleStripVertexCount * sizeof(Vertex3D));
    memcpy(triangleStripNormals, triangleStripVertices, *triangleStripVertexCount * sizeof(Vertex3D));
    for (int i = 0; i < *triangleStripVertexCount; i++)
		Vector3DNormalize(&triangleStripNormals[i]);
    
    *triangleStripVertexHandle = triangleStripVertices;
    *triangleStripNormalHandle = triangleStripNormals;
    *triangleFanVertexHandle = triangleFanVertices;
    *triangleFanNormalHandle = triangleFanNormals;
}

@implementation Ball

@synthesize x_pos, y_pos, x_speed, y_speed;

- (void) start {

	static int count = 1; 
	srand(time(NULL) * count++);
	GLfloat buff; int x_sgn, y_sgn;
	
	buff = rand() % 2; if (buff == 0) x_sgn = -1; else x_sgn = 1;
	buff = rand() % 2; if (buff == 0) y_sgn = -1; else y_sgn = 1;
	
	self.x_pos = x_sgn * (rand() % 11);
	self.y_pos = y_sgn * (rand() % 17);
	self.x_speed = (-1 * x_sgn) * (20 + (rand() % 40)); 
	self.y_speed = (-1 * y_sgn) * (20 + (rand() % 40)); 
	
	NSLog([NSString stringWithFormat:@"(x_pos=%f, y_pos=%f)", self.x_pos, self.y_pos]);
	NSLog([NSString stringWithFormat:@"(x_speed=%f, y_speed=%f)", self.x_speed, self.y_speed]);
	
}

- (void) draw {
	
	glLoadIdentity();
	glTranslatef(self.x_pos, self.y_pos, -30.0);
    	
	glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
	
    glVertexPointer(3, GL_FLOAT, 0, sphereTriangleFanVertices);
    glNormalPointer(GL_FLOAT, 0, sphereTriangleFanNormals);
    glDrawArrays(GL_TRIANGLE_FAN, 0, sphereTriangleFanVertexCount);
    glVertexPointer(3, GL_FLOAT, 0, sphereTriangleStripVertices);
    glNormalPointer(GL_FLOAT, 0, sphereTriangleStripNormals);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, sphereTriangleStripVertexCount);
	getSolidSphere(&sphereTriangleStripVertices, &sphereTriangleStripNormals, &sphereTriangleStripVertexCount, 
				   &sphereTriangleFanVertices, &sphereTriangleFanNormals, &sphereTriangleFanVertexCount, 1.0, 15, 15);
    
	//clean for background positioning
	glTranslatef(-1 * self.x_pos, -1 * self.y_pos, 0.0);
	glDisableClientState(GL_VERTEX_ARRAY); glDisableClientState(GL_NORMAL_ARRAY);
	
}

@end
