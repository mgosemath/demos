
//////////////////////////////////////////////////////////////////
//
//  Arturo Cepeda Pérez
//  iOS Game Engine
//
//  Sample application
//
//  --- SceneSample.mm ---
//
//////////////////////////////////////////////////////////////////


#include "SceneSample.h"
#include "banana.h"
#include "cube.h"
#include "GEUtils.h"

GESceneSample::GESceneSample(GERendering* Render, GEAudio* Audio, void* GlobalData) :
               GEScene(Render, Audio, GlobalData)
{
}

void GESceneSample::init()
{   
   iNextScene = -1;   
   cRender->setBackgroundColor(0.1f, 0.1f, 0.3f);
   
   // lighting
   cRender->setAmbientLightColor(1.0f, 1.0f, 1.0f);
   cRender->setAmbientLightIntensity(0.25f);
   
   cRender->setNumberOfActiveLights(1);
   cRender->setLightPosition(GELights.PointLight1, 0.0f, 0.0f, 1.0f);
   cRender->setLightColor(GELights.PointLight1, 1.0f, 1.0f, 1.0f);
   cRender->setLightIntensity(GELights.PointLight1, 0.6f);
   
   // device info
   NSLog(@"\nDevice type: %s", (GEDevice::iPhone())? "iPhone": "iPad");
   NSLog(@"\nRetina display: %s", (GEDevice::displayRetina())? "yes": "no");
   
   // cameras
   cCamera = new GECamera();
   cCamera->setPosition(0.0f, 0.0f, -4.0f);

   // textures
   cRender->loadTexture(Textures.Background, @"background.jpg");
   cRender->loadTextureCompressed(Textures.Banana, @"banana.pvrtc", 512, 2);
   cRender->loadTexture(Textures.Info, @"info.png");
   cRender->loadTexture(Textures.Basketball, @"basketball.png");
   
   // meshes
   cMeshBanana = new GEMesh();
   cMeshBanana->loadFromHeader(bananaNumVerts, bananaVerts, bananaNormals, bananaTexCoords);
   cMeshBanana->setTexture(cRender->getTexture(Textures.Banana));
   cMeshBanana->scale(2.5f, 2.5f, 2.5f);

   cMeshCube = new GEMesh();
   cMeshCube->loadFromHeader(cubeNumVerts, cubeVerts, cubeNormals);
   cMeshCube->setPosition(0.0f, -1.5f, 0.0f);
   cMeshCube->scale(0.75f, 0.75f, 0.75f);
   cMeshCube->setColor(1.0f, 0.5f, 0.2f);

   // sprites
   cSpriteBackground = new GESprite();
   cSpriteBackground->setTexture(cRender->getTexture(Textures.Background));
   cSpriteBackground->scale(1.0f, 1.5f, 1.0f);
   
   cSpriteBall = new GESprite();
   cSpriteBall->setTexture(cRender->getTexture(Textures.Basketball));
   cSpriteBall->scale(0.2f, 0.2f, 0.2f);
   
   for(int i = 0; i < FINGERS; i++)
   {
      cSpriteInfo[i] = new GESprite();
      cSpriteInfo[i]->setTexture(cRender->getTexture(Textures.Info));
      cSpriteInfo[i]->scale(0.15f, 0.15f, 0.15f);
      cSpriteInfo[i]->rotate(0.0f, 0.0f, 90.0f);
      cSpriteInfo[i]->setVisible(false);
   }
   
   // sounds
   cAudio->loadSound(Sounds.Music, @"song.caf");
   cAudio->loadSound(Sounds.Touch, @"touch.wav");   
   cAudio->setSourceVolume(1, 0.2f);
   cAudio->playSound(Sounds.Music, 0);
   
   // text
   cText = new GELabel(@"ARTURO CEPEDA\niOS Game Engine", @"Optima-ExtraBlack", 44.0f,
                       UITextAlignmentCenter, 512, 128);
   cText->setPosition(0.0f, 1.3f, 0.0f);
   cText->setScale(2.0f, 2.0f, 2.0f);
   cText->setOpacity(0.0f);
}

void GESceneSample::update()
{
   updateCube();
   updateBanana();
   updateBall();
   updateText();
}

void GESceneSample::updateText()
{
   if(cText->getOpacity() < 1.0f)   
      cText->setOpacity(cText->getOpacity() + 0.005f);
}

void GESceneSample::updateBanana()
{
   cMeshBanana->rotate(-0.01f, -0.01f, -0.01f);
}

void GESceneSample::updateCube()
{
   cMeshCube->rotate(0.01f, 0.01f, 0.01f);
}

void GESceneSample::updateBall()
{
   // get ball position
   cSpriteBall->getPosition(&vBallPosition);
   
   // bounds control (left/right)
   if((vBallPosition.X < BOUNDS_LEFT) ||
      (vBallPosition.X > BOUNDS_RIGHT))
   {
      // correct position
      if(vBallPosition.X < 0.0f)
         vBallPosition.X = BOUNDS_LEFT;
      else
         vBallPosition.X = BOUNDS_RIGHT;
      
      cSpriteBall->setPosition(vBallPosition);
      
      // bounce
      vBallVelocity.X = (fabs(vBallVelocity.X) > STOPPED)? -vBallVelocity.X * BOUNCE: 0.0f;
   }
   
   // bounds control (top/bottom)
   if((vBallPosition.Y > BOUNDS_TOP) ||
      (vBallPosition.Y < BOUNDS_BOTTOM))
   {
      // correct position
      if(vBallPosition.Y < 0.0f)
         vBallPosition.Y = BOUNDS_BOTTOM;
      else
         vBallPosition.Y = BOUNDS_TOP;
      
      cSpriteBall->setPosition(vBallPosition);
      
      // bounce
      vBallVelocity.Y = (fabs(vBallVelocity.Y) > STOPPED)? -vBallVelocity.Y * BOUNCE: 0.0f;
   }
   
   // move and rotate the ball
   cSpriteBall->move(vBallVelocity);
   cSpriteBall->rotate(0.0f, 0.0f, ((vBallPosition.Y < 0.0f)? -1: 1) * vBallVelocity.X * ROTATION);
   cSpriteBall->rotate(0.0f, 0.0f, ((vBallPosition.X < 0.0f)? 1: -1) * vBallVelocity.Y * ROTATION);
}

void GESceneSample::render()
{
   // background
   cRender->set2D();
   cRender->useProgram(GEPrograms.HUD);
   cRender->renderSprite(cSpriteBackground);

   // camera
   cRender->set3D();
   cRender->useCamera(cCamera);

   // meshes
   cRender->useProgram(GEPrograms.MeshColor);
   cRender->renderMesh(cMeshCube);
   cRender->useProgram(GEPrograms.MeshTexture);
   cRender->renderMesh(cMeshBanana);

   // sprites
   cRender->set2D();
   cRender->useProgram(GEPrograms.HUD);
   cRender->renderSprite(cSpriteBall);
    
   for(int i = 0; i < FINGERS; i++)
      cRender->renderSprite(cSpriteInfo[i]);
    
   // text shadow
   cRender->set2D();
   cRender->useProgram(GEPrograms.Text);
    
   cText->setColor(0.2f, 0.2f, 0.2f);
   cText->move(0.015f, 0.015f, 0.0f);
   cRender->renderLabel(cText);
    
   // text
   cText->setColor(0.8f, 0.2f, 0.2f);
   cText->move(-0.015f, -0.015f, 0.0f);
   cRender->renderLabel(cText);
}

void GESceneSample::release()
{
   // stop audio sources and release sounds
   cAudio->stop(Sounds.Music);
   cAudio->stop(Sounds.Touch);   
   cAudio->unloadAllSounds();
   
   // release objects
   delete cCamera;
   delete cMeshBanana;
   delete cMeshCube;

   delete cSpriteBackground;
   delete cSpriteBall;
   
   for(int i = 0; i < FINGERS; i++)
      delete cSpriteInfo[i];

   delete cText;
}

void GESceneSample::inputTouchBegin(int ID, CGPoint* Point)
{
   cAudio->playSound(Sounds.Touch, 1);

   cSpriteInfo[ID]->setPosition(cPixelToPositionX->y(Point->x), cPixelToPositionY->y(Point->y), 0.0f);
   cSpriteInfo[ID]->show();
}

void GESceneSample::inputTouchMove(int ID, CGPoint* PreviousPoint, CGPoint* CurrentPoint)
{
   if(ID == 0)
   {
      cCamera->move((CurrentPoint->x - PreviousPoint->x) * TOUCH_SCALE, 
                    (-CurrentPoint->y + PreviousPoint->y) * TOUCH_SCALE, 
                    0.0f);
   }
   
   cSpriteInfo[ID]->setPosition(cPixelToPositionX->y(CurrentPoint->x), 
                                cPixelToPositionY->y(CurrentPoint->y));
}

void GESceneSample::inputTouchEnd(int ID, CGPoint* Point)
{
   cSpriteInfo[ID]->hide();
}

void GESceneSample::updateAccelerometerStatus(float X, float Y, float Z)
{
   vBallVelocity.X += X * ACC_SCALE;
   vBallVelocity.Y += Y * ACC_SCALE;
}
