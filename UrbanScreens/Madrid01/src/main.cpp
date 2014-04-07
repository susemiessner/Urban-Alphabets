#include "ofMain.h"
#include "testApp.h"

//========================================================================
int main( ){

	//ofSetupOpenGL(1000,400, OF_WINDOW);			// <-------- setup the GL context
   ofSetupOpenGL(192,125, OF_WINDOW);
	// this kicks off the running of my app
	// can be OF_WINDOW or OF_FULLSCREEN
	// pass in width and height too:
	ofRunApp( new testApp());

}
