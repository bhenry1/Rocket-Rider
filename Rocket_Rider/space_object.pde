class SpaceObject
{
  PImage graphic;
  String tag;
  PVector pos;
  PVector scale;
  CollisionField box;
  float speed = 5;
  boolean offScreen;
  
  
  SpaceObject(PImage i,CollisionField colField, String obTag)
  {
    pos = new PVector(0,0);
    scale = new PVector(0,0);
    graphic = i;
    box = colField;
    offScreen = false;
    tag = obTag;
    
    //new CollisionField(new PVector(40,40),pos);
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

  void show()
  {  
    imageMode(CENTER);
    //print("HERE");
    image(graphic, pos.x, pos.y,scale.x,scale.y);
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