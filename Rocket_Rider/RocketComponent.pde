class RocketComponent
{
  float speed, mass;
  PVector pos;
  PVector size;
  color c;
  public RocketComponent(float speed,float mass,PVector size)
  {
    this.speed = speed;
    this.mass = mass;
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