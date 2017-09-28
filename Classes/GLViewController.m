//
//  GLViewController.h
//  Part5Project
//
//  Created by jeff on 5/4/09.
//  Edited by Nicola Nicodemo on 06/10.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "GLView.h"
#import "GLViewController.h"
#import "ConstantsAndMacros.h"
#import "Ball.h"

@implementation GLViewController

@synthesize group, startTime, frames;

- (void) drawView: (GLView*) view {
		
	//reset scene
    glClearColor(0.1, 0.1, 0.1, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	//draw group of balls
	[self drawBackground];
	[self.group draw];
	
	//animate
	[self.group animate];
	frames++;
	
}

- (void) setupView: (GLView*) view {
	
	//Standard setup
	const GLfloat zNear = 0.01, zFar = 1000.0, fieldOfView = 45.0; 
	GLfloat size; 
	glEnable(GL_DEPTH_TEST);
	glMatrixMode(GL_PROJECTION); 
	size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
	CGRect rect = view.bounds; 
	glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / 
			   (rect.size.width / rect.size.height), zNear, zFar); 
	glViewport(0, 0, rect.size.width, rect.size.height);  
	glMatrixMode(GL_MODELVIEW);
    glShadeModel(GL_SMOOTH);
	
    //Set up lights
	[self setUpLights];
	
	//Load background texture
	[self loadTexture];
	
	//Create group of balls
	self.group = [GroupOfBalls alloc];
	[self.group start];
	
	//For framerate estimate
	startTime = [NSDate timeIntervalSinceReferenceDate];
	frames = 0;
	
}

- (void) setUpLights {

	//Turn lights on
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    
    //Define the components of the first light
    static const Color3D light0Ambient[] = {{0.4, 0.4, 0.4, 1.0}};
	glLightfv(GL_LIGHT0, GL_AMBIENT, (const GLfloat *)light0Ambient);
    static const Color3D light0Diffuse[] = {{0.8, 0.8, 0.8, 1.0}};
	glLightfv(GL_LIGHT0, GL_DIFFUSE, (const GLfloat *)light0Diffuse);
    static const Color3D light0Specular[] = {{0.6, 0.6, 0.6, 1.0}};
    glLightfv(GL_LIGHT0, GL_SPECULAR, (const GLfloat *)light0Specular);
    
    //Define the position of the first light
    static const Vertex3D light0Position[] = {{30.0, 30.0, 10.0}};
	glLightfv(GL_LIGHT0, GL_POSITION, (const GLfloat *)light0Position); 
	
}

- (void) drawBackground {

	static GLfloat texCoords[] = {0.0, 1.0, 1.0, 1.0, 0.0, 0.0, 1.0, 0.0};
	static Vertex3D vertices[] = {{-20.0,  20.0, -0.0}, {20.0, 20.0, -0.0}, {-20.0, -20.0, -0.0}, {20.0, -20.0, -0.0}};
	//static Vector3D normals[] = {{0.0, 0.0, 10.0}, {0.0, 0.0, 10.0}, {0.0, 0.0, 10.0}, {0.0, 0.0, 10.0}};
	
	glEnableClientState(GL_VERTEX_ARRAY); glEnableClientState(GL_TEXTURE_COORD_ARRAY); 
	glTranslatef(0.0, 0.0, 0.0); glBindTexture(GL_TEXTURE_2D, texture[0]);       
	glVertexPointer(3, GL_FLOAT, 0, vertices); //glNormalPointer(GL_FLOAT, 0, normals);	        
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords); glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);          
	glDisableClientState(GL_VERTEX_ARRAY); glDisableClientState(GL_TEXTURE_COORD_ARRAY);	
	
}

- (void) loadTexture {
	
	glEnable(GL_BLEND); glEnable(GL_TEXTURE_2D); glBlendFunc(GL_ONE, GL_SRC_COLOR);
	glGenTextures(1, &texture[0]); glBindTexture(GL_TEXTURE_2D, texture[0]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

	//Load image from bundle
	NSString *path = [[NSBundle mainBundle] pathForResource:@"WoodScaled" ofType:@"jpg"];
    NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [[UIImage alloc] initWithData:texData];
	
	if (image == nil) NSLog(@">>> texture file not found! <<<");
	
    GLuint width = CGImageGetWidth(image.CGImage);
    GLuint height = CGImageGetHeight(image.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc( height * width * 4 );
	CGContextRef context = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    
	//Flip Y-axis (iOS specific)
	CGContextTranslateCTM (context, 0, height);
    CGContextScaleCTM (context, 1.0, -1.0);
	
	CGColorSpaceRelease( colorSpace );
    CGContextClearRect( context, CGRectMake( 0, 0, width, height ) );
    CGContextDrawImage( context, CGRectMake( 0, 0, width, height ), image.CGImage );
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
	
	CGContextRelease(context); free(imageData); [image release]; [texData release];
	
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
	NSLog(@">>>>> memory warning!!! <<<<<");
}

- (void) dealloc {
    if(sphereTriangleStripVertices)
        free(sphereTriangleStripVertices);
    if (sphereTriangleStripNormals)
        free(sphereTriangleStripNormals);
    
    if (sphereTriangleFanVertices)
        free(sphereTriangleFanVertices);
    if (sphereTriangleFanNormals)
        free(sphereTriangleFanNormals);

    [super dealloc];
}

@end
