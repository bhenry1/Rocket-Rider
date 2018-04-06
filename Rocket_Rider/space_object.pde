class SpaceObject
{
  PImage graphic;
  String tag;
  PVector pos;
  PVector scale;
  CollisionField box;
  float speed = 5;
  boolean offScreen;
  float r,g,b;
  
  
  SpaceObject(PImage i,CollisionField colField, String obTag)
  {
    pos = new PVector(0,0);
    scale = new PVector(0,0);
    graphic = i;
    box = colField;
    offScreen = false;
    tag = obTag;
    r=2550;
    g=255;
    b=255;
    //new CollisionField(new PVector(40,40),pos);
  }
  void setColor(float r, float g, float b)
  {
   this.r = r;
   this.g = g;
   this.b = b;
  }
  void setPosition(float x,float y)
  {
    pos.x = x;
    pos.y = y;
    offScreen = false;
  }
  void setSpeed(float s)
  {
    speed = s;
  }
  
  void setGraphicScale(float x, float y)
  {
    scale.x = x;
    scale.y = y;
  }
  
  void update()
  {
    pos.y = pos.y - speed;
      /*
    if(millis() > timePassed + levelTimer)
    {
      timePassed = millis();
      speed++;
    }
    */
    
  }
  
  void setImage(PImage i)
  {
    graphic = i;
  }

  void show()
  {  
    imageMode(CENTER);
    //print("HERE");
    tint(r,g,b);
    image(graphic, pos.x, pos.y,scale.x,scale.y);
    tint(255,255,255);
    if(pos.y <0)
    {
     offScreen = true;
    }
    box.display(pos);   
   }
   
  boolean isOffScreen()
  {
    return offScreen;
  }
  
  String getTag()
  {
    return tag; 
  }
   
}