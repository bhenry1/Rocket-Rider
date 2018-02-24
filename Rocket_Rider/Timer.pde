class Timer
{

  float time;
  
  //
 Timer(float set)
 {
  this.time = set; 
 }
 
 //returns the current time
 float getTime()
 {
  return(time); 
 }
  
  //set the time to whatever temp variable is i.e 60 seconds
 void setTime(float set)
 {
  time = set; 
 }
 
 //update the timer by counting up. This must be called within void draw()
 void countUp()
 {
   
   time += 1/frameRate;
 }
  
  
  
  
  
  
}