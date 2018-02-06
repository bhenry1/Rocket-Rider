class RocketRear
{
  PVector pos;
  float thrustSpeed,speedLimit;
  PVector size;
  color c;
  public RocketRear(float thrustSpeed,float speedLimit,PVector size)
  {
    this.thrustSpeed = thrustSpeed;
    this.speedLimit = speedLimit;
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
    ellipse(pos.x,pos.y,size.x,size.y);
  }
}