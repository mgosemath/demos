
/*
   Arturo Cepeda P�rez

	Rendering Engine (OpenGL)

   --- GERenderingObjects.mm ---
*/

#include "GERenderingObjects.h"


//
//  GERenderingObject
//
void GERenderingObject::move(float DX, float DY, float DZ)
{
   vPosition.X += DX;
   vPosition.Y += DY;
   vPosition.Z += DZ;
}

void GERenderingObject::move(const GEVector& Move)
{
   vPosition.X += Move.X;
   vPosition.Y += Move.Y;
   vPosition.Z += Move.Z;
}

void GERenderingObject::scale(float SX, float SY, float SZ)
{
   vScale.X *= SX;
   vScale.Y *= SY;
   vScale.Z *= SZ;
}

void GERenderingObject::scale(const GEVector& Scale)
{
   vScale.X *= Scale.X;
   vScale.Y *= Scale.Y;
   vScale.Z *= Scale.Z;
}

void GERenderingObject::rotate(float RX, float RY, float RZ)
{
   vRotation.X += RX;
   vRotation.Y += RY;
   vRotation.Z += RZ;
}

void GERenderingObject::rotate(const GEVector& Rotate)
{
   vRotation.X += Rotate.X;
   vRotation.Y += Rotate.Y;
   vRotation.Z += Rotate.Z;
}

void GERenderingObject::show()
{
   bVisible = true;
}

void GERenderingObject::hide()
{
   bVisible = false;
}

void GERenderingObject::getPosition(GEVector* Position)
{
   Position->X = vPosition.X;
   Position->Y = vPosition.Y;
   Position->Z = vPosition.Z;
}

void GERenderingObject::getRotation(GEVector* Rotation)
{
   Rotation->X = vRotation.X;
   Rotation->Y = vRotation.Y;
   Rotation->Z = vRotation.Z;
}

void GERenderingObject::getScale(GEVector* Scale)
{
   Scale->X = vScale.X;
   Scale->Y = vScale.Y;
   Scale->Z = vScale.Z;
}

float GERenderingObject::getOpacity()
{
   return fOpacity;
}

bool GERenderingObject::getVisible()
{
    return bVisible;
}

void GERenderingObject::setPosition(float X, float Y, float Z)
{
   vPosition.X = X;
   vPosition.Y = Y;
   vPosition.Z = Z;
}

void GERenderingObject::setPosition(const GEVector& Position)
{
   vPosition.X = Position.X;
   vPosition.Y = Position.Y;
   vPosition.Z = Position.Z;
}

void GERenderingObject::setScale(float X, float Y, float Z)
{
   vScale.X = X;
   vScale.Y = Y;
   vScale.Z = Z;
}

void GERenderingObject::setScale(const GEVector& Scale)
{
   vScale.X = Scale.X;
   vScale.Y = Scale.Y;
   vScale.Z = Scale.Z;
}

void GERenderingObject::setRotation(float X, float Y, float Z)
{
   vRotation.X = X;
   vRotation.Y = Y;
   vRotation.Z = Z;
}

void GERenderingObject::setRotation(const GEVector& Rotation)
{
   vRotation.X = Rotation.X;
   vRotation.Y = Rotation.Y;
   vRotation.Z = Rotation.Z;
}

void GERenderingObject::setColor(float R, float G, float B)
{
   cColor.R = R;
   cColor.G = G;
   cColor.B = B;
}

void GERenderingObject::setColor(const GEColor& Color)
{
   cColor = Color;
}

void GERenderingObject::setOpacity(float Opacity)
{
   fOpacity = Opacity;
}

void GERenderingObject::setVisible(bool Visible)
{
   bVisible = Visible;
}



//
//  GESprite
//
GESprite::GESprite(GLuint Texture, const GETextureSize& TextureSize)
{
   tTexture = Texture;   
   fOpacity = 1.0f;
   bVisible = true;

   memset(&vPosition, 0, sizeof(GEVector));
   memset(&vRotation, 0, sizeof(GEVector));
   
   vScale.X = 1.0f;
   vScale.Y = 1.0f;
   vScale.Z = 1.0f;
   
   vCenter.X = 0.0f;
   vCenter.Y = 0.0f;
   vCenter.Z = 0.0f;
}

GESprite::~GESprite()
{
}

void GESprite::render()
{
   if(!bVisible)
      return;
   
	const GLfloat fSpriteVertices[] = {-1 + vCenter.X, -1 + vCenter.Y, vCenter.Z,  
                                       1 + vCenter.X, -1 + vCenter.Y, vCenter.Z, 
                                      -1 + vCenter.X,  1 + vCenter.Y, vCenter.Z,  
                                       1 + vCenter.X,  1 + vCenter.Y, vCenter.Z};
   
   const GLfloat fSpriteTextureCoordinates[] = {1, 1,  
                                                1, 0,  
                                                0, 1,  
                                                0, 0};
   
	glVertexPointer(3, GL_FLOAT, 0, fSpriteVertices);
	glTexCoordPointer(2, GL_FLOAT, 0, fSpriteTextureCoordinates);
        
   glBindTexture(GL_TEXTURE_2D, tTexture);
   glPushMatrix();

   glTranslatef(vPosition.X, vPosition.Y, vPosition.Z);
   glRotatef(vRotation.X, 1.0f, 0.0f, 0.0f);
   glRotatef(vRotation.Y, 0.0f, 1.0f, 0.0f);
   glRotatef(vRotation.Z, 0.0f, 0.0f, 1.0f);
   glScalef(vScale.X, vScale.Y, vScale.Z);
   
   glColor4f(1.0f, 1.0f, 1.0f, fOpacity);   
   glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);     
   glPopMatrix();
}

void GESprite::setCenter(float X, float Y, float Z)
{
    vCenter.X = X;
    vCenter.Y = Y;
    vCenter.Z = Z;
}


//
//  GELabel
//
GELabel::GELabel(NSString* Text, NSString* FontName, float FontSize, UITextAlignment TextAligment,
                 unsigned int Width, unsigned int Height)
{
   bVisible = true;
   
   memset(&vPosition, 0, sizeof(GEVector));
   memset(&vRotation, 0, sizeof(GEVector));
   
   vScale.X = 1.0f;
   vScale.Y = 1.0f;
   vScale.Z = 1.0f;
   
   cColor.set(1.0f, 1.0f, 1.0f);
   fOpacity = 1.0f;
   
   sText = Text;
   sFont = FontName;
   fFontSize = FontSize;
   iWidth = Width;
   iHeight = Height;   
   tAligment = TextAligment;

   create();
}

GELabel::~GELabel()
{
   release();
}

void GELabel::create()
{
   tTexture = [[Texture2D alloc] initWithString:sText dimensions:CGSizeMake(iWidth, iHeight)
                                 alignment:tAligment fontName:sFont fontSize:fFontSize];   
}

void GELabel::release()
{
   [tTexture release];
}

void GELabel::render()
{
   if(!bVisible)
      return;

   float fAspectRatio = (float)iHeight / iWidth;
   
   GLfloat fTextVertices[12];
	GLfloat fTextTextureCoordinates[] = {0.0f, [tTexture maxT],
                                        [tTexture maxS], [tTexture maxT],
                                        0.0f, 0.0f,
                                        [tTexture maxS], 0.0f};   
   switch(tAligment)
   {  
      // reference point: top left
      case UITextAlignmentLeft:         
         fTextVertices[0] = 0.0f; fTextVertices[1] = -fAspectRatio; fTextVertices[2] = 0.0f;
         fTextVertices[3] = 1.0f; fTextVertices[4] = -fAspectRatio; fTextVertices[5] = 0.0f;
         fTextVertices[6] = 0.0f; fTextVertices[7] = 0.0f; fTextVertices[8] = 0.0f;
         fTextVertices[9] = 1.0f; fTextVertices[10] = 0.0f; fTextVertices[11] = 0.0f;
         break;
         
      // reference point: top center
      case UITextAlignmentCenter:         
         fTextVertices[0] = -0.5f; fTextVertices[1] = -fAspectRatio; fTextVertices[2] = 0.0f;
         fTextVertices[3] = 0.5f; fTextVertices[4] = -fAspectRatio; fTextVertices[5] = 0.0f;
         fTextVertices[6] = -0.5f; fTextVertices[7] = 0.0f; fTextVertices[8] = 0.0f;
         fTextVertices[9] = 0.5f; fTextVertices[10] = 0.0f; fTextVertices[11] = 0.0f;        
         break;
         
      // reference point: top right
      case UITextAlignmentRight:         
         fTextVertices[0] = -1.0f; fTextVertices[1] = -fAspectRatio; fTextVertices[2] = 0.0f;
         fTextVertices[3] = 0.0f; fTextVertices[4] = -fAspectRatio; fTextVertices[5] = 0.0f;
         fTextVertices[6] = -1.0f; fTextVertices[7] = 0.0f; fTextVertices[8] = 0.0f;
         fTextVertices[9] = 0.0f; fTextVertices[10] = 0.0f; fTextVertices[11] = 0.0f;         
         break;
   }
	
	glVertexPointer(3, GL_FLOAT, 0, fTextVertices);
	glTexCoordPointer(2, GL_FLOAT, 0, fTextTextureCoordinates);   
   
	glBindTexture(GL_TEXTURE_2D, [tTexture name]);
   glPushMatrix();
   
   glTranslatef(vPosition.X, vPosition.Y, vPosition.Z);
   glRotatef(vRotation.X, 1.0f, 0.0f, 0.0f);
   glRotatef(vRotation.Y, 0.0f, 1.0f, 0.0f);
   glRotatef(vRotation.Z, 0.0f, 0.0f, 1.0f);
   glScalef(vScale.X, vScale.Y, vScale.Z);
   
   glColor4f(cColor.R, cColor.G, cColor.B, fOpacity);   
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);   
   glPopMatrix();
}

void GELabel::setText(NSString *Text)
{
   sText = Text;
   release();
   create();
}