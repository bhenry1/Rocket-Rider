class Obstacles
{
  float timePassed = 0;
  float levelTimer = 15000;
  float x;
  float y;
  float z;
  
  float speed = 3;
  
  
  Obstacles()
  {
    x = random(-width, width);
    y = random(-height, height); 
   
    
    
  }
  
  
  void update()
  {
    if(millis() > timePassed + levelTimer)
    {
    
      timePassed += millis();
      speed++;
    }
    y = y - speed;
  }
  
  
  void show()
   {
   //fill(105, 105, 105);
     noStroke();
    image(asteroid, x, y,28,28);


    //ellipse(x, y, 10, 10);
    
    if(y <0)
    {
    x = random(width);
    y = random(height,height*2); 
  
      
    }
    
      
    
    
 
   
   }
  
}