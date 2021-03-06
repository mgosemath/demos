
/*
    Arturo Cepeda P�rez

    AirHockey3d - Using the Air Hockey Game Library

    --- sceneMatch.h ---
*/

#include "AH.h"
#include "AHAI.h"
#include "main.h"
#include "GEScene.h"
#include "GEMultiplayer.h"

#ifdef _KINECT_OPENNI_
#include "kinect.openni.h"
#else
#include "kinect.ms.h"
#endif

#ifndef _SCENEMATCH_H_
#define _SCENEMATCH_H_

#define SOUNDS_PUCK     10
#define SOUNDS_TABLE    10
#define SOUNDS_GOAL     6

#define AUDIO_RATIO     4.0f
#define AUDIO_UPDATE    4

#define SQSPEED_VERYSLOW    100.0f
#define SQSPEED_SLOW        500.0f

#define MULTIPLAYER_DATA_RATE   2

#define MSG_SIZE        16
#define MSG_REQ         1
#define MSG_ACK         2
#define MSG_TIME        3
#define MSG_EVENT       4
#define MSG_GOAL        5
#define MSG_MALLET      6
#define MSG_PUCK        7
#define MSG_END         8

#define REPLAY_FRAMES       80
#define REPLAY_INTERPOL     3

union UFloatValue
{
    char CharValue[4];
    float FloatValue;
};

struct SReplayFrame
{
    AHPoint PositionPlayer1;
    AHPoint PositionPlayer2;
    AHPoint PositionPuck;
    bool PuckVisible;
    bool Interpolate;
};

class CSceneMatch : public GEScene
{
private:
    // global data
    SGlobal* sGlobal;

    // game objects
    AHGame* cGame;
    AHAI* cPlayer1AI;
    AHAI* cPlayer2AI;

    // positions
    AHPoint pPlayer1Position;
    AHPoint pPlayer2Position;
    AHPoint pPuckPosition;

    // HUD positions
    float fPosX;
    float fPosY;

    // time
    int iTimeMin;
    int iTimeSec;

    // multiplayer
    GEServer* cServer;
    GEClient* cClient;
    char sUDPBuffer[MSG_SIZE];
    SRemoteAddress sClientAddress;
    bool bClientReady;
    bool bServerReady;

    // kinect
    HANDLE hKinectThread;
    KinectHandPosition kHandPosition;
    KinectCalibration kCalibration;

    // replays
    bool bReplayMode;
    int iReplayFrame;
    int iCurrentReplayRecordFrame;
    int iCurrentReplayPlayFrame;
    int iCurrentReplayPlayFramePoint;
    SReplayFrame sReplayFrame[REPLAY_FRAMES];

    // lights
    unsigned int iLightRoom;

    // cameras
    GECamera* mCameraPlayer1;
    GECamera* mCameraPlayer2;
    GECamera* mCameraReplay;
        
    // meshes
    GEMesh* mMeshMallet1;
    GEMesh* mMeshMallet2;
    GEMesh* mMeshPuck;
    GEMesh* mMeshTable;
    GEMesh* mMeshRoom;
    bool bPuckVisible;

    // sprites
    GESprite* sDisplay[10];
    GESprite* sDisplaySeparator;
    GESprite* sFrame;

    // fonts
    unsigned int iFontText;
    unsigned int iFontDebug;

    // view ports (split)
    unsigned int iPortFullScreen;
    unsigned int iPortPlayer1;
    unsigned int iPortPlayer2;
    unsigned int iPortMessages;
    unsigned int iPortSpaceBelow;

    // text region
    unsigned int iRectText;
    unsigned int iRectDebug;

    // text buffers
    char sMessage[256];
    char sBuffer[256];
    static char sKinectInfo[512];

    // colors
    GEColor cColorMessage;
    GEColor cColorDebug;

    // sound handlers
    unsigned int iChannelMallet1;
    unsigned int iChannelMallet2;
    unsigned int iChannelPuck;

    unsigned int iSoundPuckMallet[SOUNDS_PUCK];
    unsigned int iSoundPuckTable[SOUNDS_TABLE];
    unsigned int iSoundGoal[SOUNDS_GOAL];

    // sound aux data
    float fImpactSquareSpeed;
    int iSoundPlay;

    // rendering
    void initRenderObjects();
    void releaseRenderObjects();
    void render();

    // sound
    void initSoundObjects();
    void releaseSoundObjects();
    void playSounds(int iEvent);

    // multiplayer
    void sendDataToClient();
    void updateClient();

    // replay
    void replayMode();
    void renderReplay();

    // match finished
    void playAgain();
    void endOfTheMatch();

public:
    CSceneMatch(GERendering* Render, GEAudio* Audio, void* GlobalData);
    ~CSceneMatch();

    void init();
    void update();
    void release();

    void inputKey(char Key);
    void inputMouseLeftButton();
    void inputMouseRightButton();
};

#endif
