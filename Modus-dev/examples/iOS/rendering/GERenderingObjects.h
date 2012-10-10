
/*
   Arturo Cepeda P�rez

	Rendering Engine (OpenGL)

   --- GERenderingObjects.h ---
*/

#ifndef _GERENDERINGOBJECTS_H_
#define _GERENDERINGOBJECTS_H_

#include "GEDevice.h"
#include "Texture2D.h"
#include <OpenGLES/EAGL.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>

struct GEColor
{
    float R;
    float G;
    float B;

    GEColor()
    {
        set(1.0f, 1.0f, 1.0f);
    }

    GEColor(float cR, float cG, float cB)
    {
        set(cR, cG, cB);
    }

    void set(float cR, float cG, float cB)
    {
       R = cR;
       G = cG;
       B = cB;
    }
};

struct GEVector
{
    float X;
    float Y;
    float Z;

    GEVector()
    {
        set(0.0f, 0.0f, 0.0f);
    }

    GEVector(float vX, float vY, float vZ)
    {
        set(vX, vY, vZ);
    }

    void set(float vX, float vY, float vZ)
    {
        X = vX;
        Y = vY;
        Z = vZ;
    }
};

struct GETextureSize
{
   unsigned int Width;
   unsigned int Height;
};

class GERenderingObject
{
protected:
   GEVector vPosition;
   GEVector vRotation;
   GEVector vScale;
   GEColor cColor;
   float fOpacity;
   bool bVisible;
   
   void loadTexture(GLuint iTexture, NSString* sName);

public:
   void move(float DX, float DY, float DZ);
   void move(const GEVector& Move);
   void scale(float SX, float SY, float SZ);
   void scale(const GEVector& Scale);
   void rotate(float RX, float RY, float RZ);
   void rotate(const GEVector& Rotate);
   void show();
   void hide();
   
   virtual void render() = 0;

   void getPosition(GEVector* Position);
   void getRotation(GEVector* Rotation);
   void getScale(GEVector* Scale);
   float getOpacity();
   bool getVisible();   

   void setPosition(float X, float Y, float Z = 0.0f);
   void setPosition(const GEVector& Position);
   void setScale(float X, float Y, float Z = 1.0f);
   void setScale(const GEVector& Scale);
   void setRotation(float X, float Y, float Z);
   void setRotation(const GEVector& Rotation);
   void setColor(float R, float G, float B);
   void setColor(const GEColor& Color);
   void setOpacity(float Opacity);
   void setVisible(bool Visible);
};

class GESprite : public GERenderingObject
{
private:
   GLuint tTexture;
   GEVector vCenter;
   
public:
   GESprite(GLuint Texture, const GETextureSize& TextureSize);
   ~GESprite();

   void loadFromFile(const char* Filename);
   void unload();

   void render();

   void setCenter(float X, float Y, float Z);
};


class GELabel : public GERenderingObject
{
private:
   Texture2D* tTexture;
   
   NSString* sText;
   NSString* sFont;
   UITextAlignment tAligment;
   float fFontSize;
   
   unsigned int iWidth;
   unsigned int iHeight;
   
   void create();
   void release();
   
public:
   GELabel(NSString* Text, NSString* FontName, float FontSize, UITextAlignment TextAligment,
           unsigned int Width, unsigned int Height);
   ~GELabel();
   
   void render();
   
   void setText(NSString* Text);
};

#endif