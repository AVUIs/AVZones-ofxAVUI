#include "ofApp.h"
#include "ofxMaxim.h"



//--------------------------------------------------------------
void ofApp::setup(){
    //ENVIRONMENT AND MAXIMILIAN
//    ofSetOrientation(OF_ORIENTATION_90_RIGHT);
    ofSetFrameRate(60);
    ofSetVerticalSync(true);
    ofEnableAlphaBlending();
//    ofEnableSmoothing();
    ofSetCircleResolution(200);
    ofBackground(0,0,0);
    sampleRate 	= 44100; /* Audio sampling rate */
    bufferSize	= 512; /* Audio buffer size */
    ofxMaxiSettings::setup(sampleRate, 2, bufferSize);
    //hack for OF not adjusting to iPad landscape mode correctly
//    printf(" ofxiOSGetGLView().frame.origin %f, %f\n", ofxiOSGetGLView().frame.origin.x, ofxiOSGetGLView().frame.origin.y);
//    printf(" screen %d, %d\n", ofGetWidth(), ofGetHeight());
//    if(ofxiOSGetGLView().frame.origin.x != 0 ||
//        ofxiOSGetGLView().frame.size.width != [[UIScreen mainScreen] bounds].size.width) {
//        ofxiOSGetGLView().frame = CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);
//    }
//    printf(" screen afer %d, %d\n", ofGetWidth(), ofGetHeight());
    
    //CHECK FILES IN DOCUMENTS DIR
    numFiles = DIR.listDir(ofxiPhoneGetDocumentsDirectory());
    for (int i=0;i<NUM_ZONES;i++) files[i] = 0;
    //TODO check that at least 3 files are present or use embedded ones!
    if (ofGetHeight() > ofGetWidth()) {
        toggleHeight = ofGetWidth() * 0.05;  //5% of height
        zoneWidth = ofGetHeight()/3;
        xyHeight = (ofGetWidth() - toggleHeight*5)/3;
    } else {
        toggleHeight = ofGetHeight() * 0.05;  //5% of height
        zoneWidth = ofGetWidth()/3;
        xyHeight = (ofGetHeight() - toggleHeight*5)/3;
    }

    //ZONE 0 SETUP
    //parameters: name, x, y, width, background color, foreground color, sound filename, sound buffer size
    zones[0].setup("zone1", 1, 1, zoneWidth, ofColor(0,0,0, 255), ofColor(255,255,255, 255), (numFiles>0?DIR.getPath(files[0]):""), bufferSize);
    zones[0].setUIFont("Abel-Regular.ttf", ofGetHeight()/96);
    //ZONE 0 UI
    //dropdown parameters: caption (curently not displayed), trigger (single tap) parameter name
    ofxAVUIDropDown *dropdown1 = new ofxAVUIDropDown("DropDown", "selection");
    zones[0].addUI(dropdown1, toggleHeight);
    for(int i=0;i<numFiles;i++) dropdown1->addItem(DIR.getName(i));
    //toggle parameters: caption, toggle (double tap) parameter name
    ofxAVUIToggle *toggle11 = new ofxAVUIToggle("", "delayToggle");
    zones[0].addUI(toggle11, toggleHeight);
    //pad parameters: caption, trigger (single tap) parameter name, toggle (double tap) parameter name, x parameter name, y parameter name
    ofxAVUIXYPad *pad11 = new ofxAVUIXYPad("", "delayTrigger", "delayToggle", "size", "feedback");
    //pad additional parameter: height
    zones[0].addUI(pad11, xyHeight);
    ofxAVUIToggle *toggle12 = new ofxAVUIToggle(">", "toggleLooping");
    zones[0].addUI(toggle12, toggleHeight);
    ofxAVUIXYPad *pad12 = new ofxAVUIXYPad(">", "triggerPlay",  "toggleLooping", "pitch", "volume");
    zones[0].addUI(pad12, xyHeight);
    ofxAVUIToggle *toggle13 = new ofxAVUIToggle("", "filterToggle");
    zones[0].addUI(toggle13, toggleHeight);
    ofxAVUIXYPad *pad13 = new ofxAVUIXYPad("", "filterTrigger", "filterToggle", "frequency", "resonance");
    zones[0].addUI(pad13, xyHeight);
    ofxAVUIToggle *toggle14 = new ofxAVUIToggle("", "toggleSequencer");
    zones[0].addUI(toggle14, toggleHeight);
    //ZONE 0 AUDIO EFFECTS
    ofxAVUISoundFxFilter *filter1 = new ofxAVUISoundFxFilter();
    //sound fx parameters:
    //- filter enabled toggle name (will be linked to any toggle UI with same name), start value
    //- 1st parameter float name (will be linked to any toggle UI with same name), min value, max value, start value
    //- 2nd parameter float name (will be linked to any toggle UI with same name), min value, max value, start value
    filter1->setup("filterToggle", false, "frequency", 200, 15000, 7400, "resonance", 0, 100, 50);
    zones[0].addSoundFx(filter1);
    ofxAVUISoundFxDelay *delay1 = new ofxAVUISoundFxDelay();
    delay1->setup("delayToggle", false, "size", 10000, 40000, 25000, "feedback", 0.5, 1.0, 0.75);
    zones[0].addSoundFx(delay1);
    //ZONE 0 VISUALS
    ofxAVUIVisualWave *visual1 = new ofxAVUIVisualWave();
    zones[0].addVisual(visual1, ofColor().fromHex(0x0000cc));

    //ZONE 1 SETUP
    zones[1].setup("zone2", zoneWidth+1, 1, zoneWidth, ofColor(0,0,0, 255), ofColor(255,255,255, 255), (numFiles>1?DIR.getPath(files[1]):(numFiles>0?DIR.getPath(files[0]):"")), bufferSize);
    zones[1].setUIFont("Abel-Regular.ttf", ofGetHeight()/96);
    //ZONE 1 UI
    ofxAVUIDropDown *dropdown2 = new ofxAVUIDropDown("DropDown", "selection");
    zones[1].addUI(dropdown2, toggleHeight);
    for(int i=0;i<numFiles;i++) dropdown2->addItem(DIR.getName(i));
    ofxAVUIToggle *toggle21 = new ofxAVUIToggle("", "delayToggle");
    zones[1].addUI(toggle21, toggleHeight);
    ofxAVUIXYPad *pad21 = new ofxAVUIXYPad("", "delayTrigger", "delayToggle", "size", "feedback");
    zones[1].addUI(pad21, xyHeight);
    ofxAVUIToggle *toggle22 = new ofxAVUIToggle(">", "toggleLooping");
    zones[1].addUI(toggle22, toggleHeight);
    ofxAVUIXYPad *pad22 = new ofxAVUIXYPad(">", "triggerPlay",  "toggleLooping", "pitch", "volume");
    zones[1].addUI(pad22, xyHeight);
    ofxAVUIToggle *toggle23 = new ofxAVUIToggle("", "filterToggle");
    zones[1].addUI(toggle23, toggleHeight);
    ofxAVUIXYPad *pad23 = new ofxAVUIXYPad("", "filterTrigger", "filterToggle", "frequency", "resonance");
    zones[1].addUI(pad23, xyHeight);
    ofxAVUIToggle *toggle24 = new ofxAVUIToggle("", "toggleSequencer");
    zones[1].addUI(toggle24, toggleHeight);
    //ZONE 1 AUDIO EFFECTS
    ofxAVUISoundFxFilter *filter2 = new ofxAVUISoundFxFilter();
    filter2->setup("filterToggle", false, "frequency", 200, 15000, 7400, "resonance", 0, 100, 50);
    zones[1].addSoundFx(filter2);
    ofxAVUISoundFxDelay *delay2 = new ofxAVUISoundFxDelay();
    delay2->setup("delayToggle", false, "size", 10000, 40000, 25000, "feedback", 0.5, 1.0, 0.75);
    zones[1].addSoundFx(delay2);
    //ZONE 1 VISUALS
    ofxAVUIVisualWave *visual2 = new ofxAVUIVisualWave();
    zones[1].addVisual(visual2, ofColor().fromHex(0x3300cc));

    //ZONE 2 SETUP
    zones[2].setup("zone3", zoneWidth*2+1, 1, zoneWidth, ofColor(0,0,0, 255), ofColor(255,255,255, 255), (numFiles>2?DIR.getPath(files[2]):(numFiles>1?DIR.getPath(files[1]):(numFiles>0?DIR.getPath(files[0]):""))), bufferSize);
    zones[2].setUIFont("Abel-Regular.ttf", ofGetHeight()/96);
    //ZONE 2 UI
    ofxAVUIDropDown *dropdown3 = new ofxAVUIDropDown("DropDown", "selection");
    zones[2].addUI(dropdown3, toggleHeight);
    for(int i=0;i<numFiles;i++) dropdown3->addItem(DIR.getName(i));
    ofxAVUIToggle *toggle31 = new ofxAVUIToggle("", "delayToggle");
    zones[2].addUI(toggle31, toggleHeight);
    ofxAVUIXYPad *pad31 = new ofxAVUIXYPad("", "delayTrigger", "delayToggle", "size", "feedback");
    zones[2].addUI(pad31, xyHeight);
    ofxAVUIToggle *toggle32 = new ofxAVUIToggle(">", "toggleLooping");
    zones[2].addUI(toggle32, toggleHeight);
    ofxAVUIXYPad *pad32 = new ofxAVUIXYPad(">", "triggerPlay",  "toggleLooping", "pitch", "volume");
    zones[2].addUI(pad32, xyHeight);
    ofxAVUIToggle *toggle33 = new ofxAVUIToggle("", "filterToggle");
    zones[2].addUI(toggle33, toggleHeight);
    ofxAVUIXYPad *pad33 = new ofxAVUIXYPad("", "filterTrigger", "filterToggle", "frequency", "resonance");
    zones[2].addUI(pad33, xyHeight);
    ofxAVUIToggle *toggle34 = new ofxAVUIToggle("", "toggleSequencer");
    zones[2].addUI(toggle34, toggleHeight);
    //ZONE 2 AUDIO EFFECTS
    ofxAVUISoundFxFilter *filter3 = new ofxAVUISoundFxFilter();
    filter3->setup("filterToggle", false, "frequency", 200, 15000, 7400, "resonance", 0, 100, 50);
    zones[2].addSoundFx(filter3);
    ofxAVUISoundFxDelay *delay3 = new ofxAVUISoundFxDelay();
    delay3->setup("delayToggle", false, "size", 10000, 40000, 25000, "feedback", 0.5, 1.0, 0.75);
    zones[2].addSoundFx(delay3);
    //ZONE 2 VISUALS
    ofxAVUIVisualWave *visual3 = new ofxAVUIVisualWave();
    zones[2].addVisual(visual3, ofColor().fromHex(0x6600cc));

    //START SOUND
    ofSoundStreamSetup(2,2,this, sampleRate, bufferSize, 4); /* this has to happen at the end of setup*/
    
}

//--------------------------------------------------------------
void ofApp::update(){
    //UPDATE ZONES = only needed for takeover UIs (curently ofxAVUIDropDown)
    for (int k=0; k<3; k++) {
        zones[k].update();
        if (zones[k].getParamValueInt("selection")!=-1 && zones[k].getParamValueInt("selection")!=files[k]) {
            files[k] = zones[k].getParamValueInt("selection");
            zones[k].loadSound(DIR.getPath(files[k]), bufferSize);
        }
    }
}

//--------------------------------------------------------------
void ofApp::draw(){

    //get individual parameters and use them outside of the zone, together with their min/max limits
/*    ofParameter<float> x = zones[0].getParamValueFloat("volume");
    int coordX = ofMap(x, x.getMin(), x.getMax(), 0, ofGetWidth());
    ofParameter<float> y = zones[0].getParamValueFloat("pitch");
    int coordY = ofMap(y, y.getMin(), y.getMax(), 0, ofGetHeight());
    ofDrawLine(coordX, 0, coordX, ofGetHeight());
    ofDrawLine(0, coordY, ofGetWidth(), coordY);
*/
    //DRAW ZONES
    for (int k=0; k<3; k++) {
        zones[k].draw();
    }
    
    ofPushStyle();
    ofSetLineWidth(2);
    ofDrawLine(0, toggleHeight+1, ofGetWidth(), toggleHeight+1);
    ofDrawLine(0, ofGetHeight()-toggleHeight, ofGetWidth(), ofGetHeight()-toggleHeight);
    ofPopStyle();
}

//--------------------------------------------------------------
void ofApp::exit(){
    
}


//--------------------------------------------------------------
void ofApp::audioOut(float * output, int bufferSize, int nChannels) {

    for (int i = 0; i < bufferSize; i++){
        
        output[i*nChannels    ] = 0;
        output[i*nChannels + 1] = 0;

        for (int k=0; k<3; k++) {
            zones[k].play(i);
            output[i*nChannels    ] += zones[k].getOutput(0);
            output[i*nChannels + 1] += zones[k].getOutput(1);
        }
    }
}

//--------------------------------------------------------------
void ofApp::audioIn(float * input, int bufferSize, int nChannels){
    for (int i = 0; i < bufferSize; i++){
        
        lAudioIn[i]=input[i*nChannels];
        rAudioIn[i]=input[i*nChannels +1];
    }
}


//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs &touch){
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}

