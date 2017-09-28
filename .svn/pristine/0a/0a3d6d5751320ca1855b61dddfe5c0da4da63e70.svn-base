//
//  GroupOfBalls.m
//  Part5Project
//
//  Created by sadboy84 on 30/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GroupOfBalls.h"

@implementation GroupOfBalls

- (void) loadMaterials {
	
	materials[0][0] = 0.0;
	materials[0][1] = 0.1;
	materials[0][2] = 0.9;
	materials[0][3] = 1.0;
	
	materials[1][0] = 0.9;
	materials[1][1] = 0.1;
	materials[1][2] = 0.0;
	materials[1][3] = 1.0;
	
	materials[2][0] = 0.0;
	materials[2][1] = 0.9;
	materials[2][2] = 0.1;
	materials[2][3] = 1.0;
	
	materials[3][0] = 0.9;
	materials[3][1] = 0.9;
	materials[3][2] = 0.1;
	materials[3][3] = 1.0;
}

- (void) start {

	//Load materials
	[self loadMaterials];
	
	for (int i = 0; i < BALLS_COUNT; i++) {
		balls[i] = [Ball alloc];
		[balls[i] start];
	}
	
	//Load sound
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"BallHit" ofType:@"wav"];
	CFURLRef soundURL = (CFURLRef) [NSURL fileURLWithPath:soundPath];
	AudioServicesCreateSystemSoundID(soundURL, &ballHitID);	
	
}

- (void) draw {

	//draw balls
	for (int i = 0; i < BALLS_COUNT; i++) {
		glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, materials[i]);
		[balls[i] draw];
		
		//clean for not affecting background
		static GLfloat cleanMaterial[] =  {1.0, 1.0, 1.0, 0.0};
		glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, cleanMaterial);
	}

}

- (void) animate {
	
	static NSTimeInterval lastDrawTime;
	 if (lastDrawTime) {
		 NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
	
		 //move balls e rebounce on edges
		 for (int i = 0; i < BALLS_COUNT; i++) {
			 balls[i].x_pos += balls[i].x_speed * timeSinceLastDraw;
			 if (balls[i].x_pos >= 11.8 || balls[i].x_pos <= -11.8) {
				 balls[i].x_speed = balls[i].x_speed * -1;
				 if (balls[i].x_pos > 0) balls[i].x_pos = 11.8; else balls[i].x_pos = -11.8;
				 //AudioServicesPlaySystemSound(ballHitID);
			 }
			 
			 balls[i].y_pos += balls[i].y_speed * timeSinceLastDraw;
			 if (balls[i].y_pos >= 17.4 || balls[i].y_pos <= -17.4) {
				 balls[i].y_speed = balls[i].y_speed * -1;
				 if (balls[i].y_pos > 0) balls[i].y_pos = 17.4; else balls[i].y_pos = -17.4;
				 //AudioServicesPlaySystemSound(ballHitID);
			 }
		 }
		 
		 //detect collision
		 [self detectCollisions];
	 }
    lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
	
}

- (void) detectCollisions {
	
	for (int i = 0; i < BALLS_COUNT; i++) {
		for (int j = i+1; j < BALLS_COUNT; j++) {
			
			static GLfloat lastBalls = 0;
			static NSTimeInterval lastTime = 0;
			NSTimeInterval deltaT = [NSDate timeIntervalSinceReferenceDate] - lastTime;
			
			if (pow(balls[i].x_pos - balls[j].x_pos , 2) + 
				pow(balls[i].y_pos - balls[j].y_pos , 2) <= 4.0 
				&& !(lastBalls == i * i + j * j && deltaT <= 1.0)) {
				
				static int collision_count = 0;
				AudioServicesPlaySystemSound(ballHitID);
				NSLog(@"collision detected! count=%d", collision_count++);
				
				if (balls[i].x_speed * balls[j].x_speed < 0) {
					balls[i].x_speed = balls[i].x_speed * -1;
					balls[j].x_speed = balls[j].x_speed * -1;
					NSLog(@"orizzontal speeds inverted");
				}
				
				if (balls[i].y_speed * balls[j].y_speed < 0) {
					balls[i].y_speed = balls[i].y_speed * -1;
					balls[j].y_speed = balls[j].y_speed * -1;
					NSLog(@"vertical speeds inverted");
				}
				
				lastBalls = i * i + j * j;
				lastTime = [NSDate timeIntervalSinceReferenceDate];
			}
		}
	}
	
}

@end
