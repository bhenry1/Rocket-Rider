class MObstacles
{
  float timePassed = 0;
  float levelTimer = 15000;
  float x1;
  float y1;
  float z1;
  PVector pos;
  CollisionField box;
  float speed = 8;
  PVector size;
  
  
  
  MObstacles()
  { 
    x1 = random(-width, width);
    y1 = random(-height, height); 
    pos = new PVector(x1,y1);
   // size = new PVector()
    box = new CollisionField(new PVector(40,60),pos);
    
  }
  
  
  void update()
  {
    if(millis() > timePassed + levelTimer)
    {
      timePassed = millis();
      speed++;
    }
    pos.y = pos.y - speed;
  }
  
  
  void show()
   {
   //fill(105, 105, 105);
   noStroke();
   


    image(medAsteroid, pos.x, pos.y,45,75);
       
    if(pos.y < 0)

    {
    pos.x = random(width);
    pos.y = random(height,height*2); 
    }
    box.display(pos);   
 
   
   }
   
 void resetObstaclePostion()
  {
    pos.x = random(-width, -width);
    pos.y = random(-height, -height); 
    //pos = new PVector(x,y);
    //box = new CollisionField(new PVector(40,40),pos);
  }
  
}