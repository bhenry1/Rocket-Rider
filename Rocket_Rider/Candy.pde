class Candy
{
  
  float timePassed = 0;
  float levelTimer = 15000;
  float x2;
  float y2;
  PVector pos;
  CollisionField box;
  float speed = 3;
  
  
  
  Candy()
  { 
    x2 = random(-width, width);
    y2 = random(-height, height); 
    pos = new PVector(x2,y2);
    box = new CollisionField(new PVector(50,45),pos);
    
  }
  
  
  void update()
  {
    /*
    if(millis() > timePassed + levelTimer)
    {
      timePassed = millis();
      speed++;
    }
    */
    pos.y = pos.y - speed;
  }
  
  
  void show()
   {
   //fill(105, 105, 105);
   noStroke();
   


    image(milkyWayCandyCollectable, pos.x, pos.y,85,45);
       
    if(pos.y < 0)

    {
    pos.x = random(width);
    pos.y = random(height,height*2); 
    }
    box.display(pos);   
   }
   
 void resetCandyPostion()
  {
    pos.x = random(-width, -width);
    pos.y = random(-height, -height); 
    
  }
  
  
  
  
  
}