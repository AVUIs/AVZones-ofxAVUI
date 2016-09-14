#include "ofApp.h"

int main() {
    
    //  here are the most commonly used iOS window settings.
    //------------------------------------------------------
    ofiOSWindowSettings settings;
    settings.enableRetina = true; // enables retina resolution if the device supports it.
    settings.retinaScale = 2.0f;
    settings.enableDepth = false; // enables depth buffer for 3d drawing.
    settings.enableAntiAliasing = false; // enables anti-aliasing which smooths out graphics on the screen.
    settings.numOfAntiAliasingSamples = 0; // number of samples used for anti-aliasing.
    settings.enableHardwareOrientation = false; // enables native view orientation.
    settings.enableHardwareOrientationAnimation = false; // enables native orientation changes to be animated.
    settings.glesVersion = OFXIOS_RENDERER_ES1; // type of renderer to use, ES1, ES2, ES3
    settings.windowMode = OF_FULLSCREEN;
    settings.setupOrientation = OF_ORIENTATION_90_RIGHT;
    ofCreateWindow(settings);

    //retina code starts
/*
    ofAppiOSWindow *window = new ofAppiOSWindow();
    window->enableRetina();
    window->enableAntiAliasing(2);

    //retina code ends
    
	ofSetupOpenGL(1024,768, OF_FULLSCREEN);			// <-------- setup the GL context
*/
	return ofRunApp(new ofApp);
}
