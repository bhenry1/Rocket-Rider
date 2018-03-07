class RocketRear
{
  PVector pos;
  float thrustSpeed,speedLimit;
  PVector size;
  PImage rocketRearImage;
  color c;
  public RocketRear(float thrustSpeed,float speedLimit,PVector size, PImage rocketRearImage)
  {
    this.thrustSpeed = thrustSpeed;
    this.speedLimit = speedLimit;
    this.rocketRearImage = rocketRearImage;
    this.size = size;
    pos = new PVector(0,0);
    this.c = color(random(255),random(255),random(255));
  }
  void setPosition(float x, float y)
  {
     pos.x = x;
     pos.y = y;
  }
 
  void display()
  {
    fill(c);
   imageMode(CENTER);
   image(rocketRearImage, pos.x,pos.y, 177/6, 282/6);
  }
}