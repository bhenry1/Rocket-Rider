class Obstacles
{
  float timePassed;
  float levelTimer = 15000;
  float x;
  float y;
  float z;
  PVector pos;
  CollisionField box;
  float speed = 5;
  
  
  Obstacles()
  {
    x = random(-width, width);
    y = random(-height, height); 

      
    pos = new PVector(x,y);
    box = new CollisionField(new PVector(40,40),pos);
  }
  
  void update()
  {
    if(millis() > timePassed + levelTimer)
    {
    
      timePassed += millis();
      speed++;
    }
    pos.y = pos.y - speed;
  }
  
  
  void show()
  {

     
    noStroke();
    imageMode(CENTER);
    
    image(asteroid, pos.x, pos.y,50,50);
    
    if(pos.y <0)
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