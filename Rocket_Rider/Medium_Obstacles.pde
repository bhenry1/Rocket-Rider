class MObstacles
{
  float timePassed = 0;
  float levelTimer = 15000;
  float x1;
  float y1;
  float z1;
  
  float speed = 5;
  
  
  MObstacles()
  {
    x1 = random(-width, width);
    y1 = random(-height, height); 
    
  }
  
  
  void update()
  {
    if(millis() > timePassed + levelTimer)
    {
      timePassed = millis();
      speed++;
    }
    y1 = y1 - speed;
  }
  
  
  void show()
   {
   //fill(105, 105, 105);
   noStroke();
   
    image(medAsteroid, x1, y1,35,35);


    
    if(y1 < 0)
    {
    x1 = random(width);
    y1 = random(height,height*2); 
 
    }
    
      
    
    
 
   
   }
  
}