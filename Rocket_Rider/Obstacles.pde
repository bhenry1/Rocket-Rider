class Obstacles
{
  float timePassed;
  float levelTimer = 15000;
  float x;
  float y;
  float z;
  
  float speed = 3;
  
  
  Obstacles(float timePassed)
  {
    x = random(-width, width);
    y = random(-height, height); 
    this.timePassed = timePassed;
   
    
    
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
    image(asteroid, x, y,75,75);


    //ellipse(x, y, 10, 10);
    
    if(y <0)
    {
    x = random(width);
    y = random(height,height*2); 
    }
   
   }
  
}