
////////////////////////////////////////////////////////////////////////
//
//  Modus
//  C++ Music Library
//  (Examples)
//
//  Arturo Cepeda P�rez
//  September 2012
//
////////////////////////////////////////////////////////////////////////

#include "modus.h"

#include "./../audio/audio.fmod.h"
#include "FMOD/mxsoundgenfmod.h"

#include <iostream>

#define NOTE_INTENSITY  96
#define NOTE_DURATION   6

// define to avoid 100% CPU usage
#define REDUCE_CPU_USAGE

// try with a higher value in case it doesn't sound properly
#define FMOD_DSP_BUFFER_SIZE    512

using namespace std;

bool bThreadEnd = false;
pthread_mutex_t mMutex;

void* MusicTimerThread(void* lp);
void TimerTick(const MSTimePosition& mTimePosition, void* pData);

int main(int argc, char* argv[])
{
    // header
    cout << "\n  Modus " << MODUS_VERSION;
    cout << "\n  C++ Music Library";
    cout << "\n  Sample Application";

    // instrument
    MSRange mTenorSaxRange = {44, 75};
    MCInstrument* mTenorSax = new MCInstrument(1, mTenorSaxRange, 1);

    // sound generator
    CAudio::init(FMOD_DSP_BUFFER_SIZE);
    MCSoundGenFMOD* mSoundGen = new MCSoundGenFMOD(mTenorSax->getNumberOfChannels(), false, CAudio::getSoundSystem());
    mSoundGen->loadSamplePack("./../../common/instruments/tenorsax.msp");

    // score
    MCScore* mScore = new MCScore();

    // sax settings
    mTenorSax->setSoundGen(mSoundGen);
    mTenorSax->setScore(mScore);

    // timer
    MCTimer mTimer;
    mTimer.setCallbackTick(TimerTick, mTenorSax);
    mTimer.start();

    // create music timer thread
    pthread_mutex_init(&mMutex, NULL);
    pthread_t hMusicTimerThread;
    pthread_create(&hMusicTimerThread, NULL, MusicTimerThread, &mTimer);

    // data
    char sRootNote[3];
    char sScript[1024];

    MTNote mRootNote;
    MTNoteMap mChord;
    MTNoteMap mNotemap;

    MSTimePosition mTimePosition;
    int iSelected;

    sRootNote[2] = '\0';

    while(1)
    {
        do
        {
            cout << "\n\n  Root note (C, D, E, F, G, A, B). Enter 0 to quit: ";
            cin >> sRootNote[0];

            if(sRootNote[0] == '0')
                break;

        } while(toupper(sRootNote[0]) < 'A' || toupper(sRootNote[0]) > 'G');

        // quit
        if(sRootNote[0] == '0')
            break;

        do
        {
            cout << "  Accidental (-, #, b): ";
            cin >> sRootNote[1];

        } while(sRootNote[1] != '-' && sRootNote[1] != '#' && sRootNote[1] != 'b');

        mRootNote = MCNotes::fromString(sRootNote);

        // arpeggio selection
        cout << "  Select a chord:";
        cout << "\n    1) M";
        cout << "\n    2) m7";
        cout << "\n    3) 7";
        cout << "\n    4) dis7";
        cout << "\n    5) M+5";
        cout << "\n    6) 7sus4\n";

        do
        {
            cout << "    -> ";
            cin >> iSelected;

        } while(iSelected < 1 || iSelected > 6);

        cout << "  Playing arpeggio...";

        switch(iSelected)
        {
        case 1:
            mChord = MCChords::cM();
            break;
        case 2:
            mChord = MCChords::cm7();
            break;
        case 3:
            mChord = MCChords::c7();
            break;
        case 4:
            mChord = MCChords::cdis7();
            break;
        case 5:
            mChord = MCChords::cMaug5();
            break;
        case 6:
            mChord = MCChords::c7sus4();
            break;
        }

        // create a note map with all the notes which belong to the selected chord
        // inside the instrument's range
        mNotemap = MCNoteMaps::createNoteMap(mRootNote, mChord, mTenorSaxRange);

        // write a script
        MCScript::writeScale(sScript, mNotemap, NOTE_INTENSITY, 0, 0, NOTE_DURATION, mTimePosition, 4);

        // load score data and play
        mScore->loadScriptFromString(sScript);

        pthread_mutex_lock(&mMutex);
        mTimer.reset();
        mTimer.start();
        pthread_mutex_unlock(&mMutex);
    }

    // wait until the music timer thread finishes
    bThreadEnd = true;
    pthread_join(hMusicTimerThread, NULL);

    delete mScore;
    delete mTenorSax;
    delete mSoundGen;

    CAudio::release();
    
    cout << "\n";

    return 0;
}

//
//  Thread function for the music timer
//
void* MusicTimerThread(void* lp)
{
    MCTimer* mTimer = (MCTimer*)lp;

    while(!bThreadEnd)
    {
        pthread_mutex_lock(&mMutex);

#ifdef REDUCE_CPU_USAGE
        if(!mTimer->update())
            usleep(1000);
#else
        mTimer->update();
#endif

        pthread_mutex_unlock(&mMutex);
    }
}

//
//  Timer tick callback
//
void TimerTick(const MSTimePosition& mTimePosition, void* pData)
{
    MCInstrument* mTenorSax = (MCInstrument*)pData;
    mTenorSax->update(mTimePosition);
}