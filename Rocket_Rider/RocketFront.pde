

class RocketFront
{
  float defense;
  PVector pos;
  PVector size;
  PImage rocketFrontImage;
  color c;
  public RocketFront(float defense,PVector size, PImage rocketFrontImage)
  {
    this.defense = defense;
    this.size = size;
    this.rocketFrontImage = rocketFrontImage;
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
    image(rocketFrontImage, pos.x,pos.y,93/6,387/6);
  }
}