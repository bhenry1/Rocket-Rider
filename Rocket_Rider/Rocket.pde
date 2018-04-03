class Rocket
{
  PVector pos;
  PVector velocity;
  PVector acceleration;
  PVector decceleration;
  PVector direction;
  PVector recoverForce;
  RocketFront front;
  RocketRear rear;
  CollisionField box;
  boolean isMoving;
  int recoverCount;
  boolean inImmunity;
  int immunityCount;
  int counter =2;
  int t = 255;
  boolean flash = false;
  
  float r,b,g;
  
  float mass,speed,limit;
  
  //public Rocket(float x,float y, float z, float r, float speed, float tiltSpeed)
  public Rocket(RocketFront front, RocketRear rear)
  {
    this.pos = new PVector(0,0,0);
    this.front = front;
    this.rear = rear;
    this.acceleration = new PVector(0,0);
    this.decceleration = new PVector(0,0);
    this.velocity = new PVector(0,0);
    this.direction = new PVector(0,0);
    
    this.mass = this.front.defense;
    this.speed = 1+(this.rear.thrustSpeed);
    this.limit = 5+ this.rear.speedLimit;
    this.box = new CollisionField(new PVector(10,60),this.pos);
    this.isMoving = false;
    this.recoverCount = 50;
    this.recoverForce = new PVector(0,this.front.defense);
    this.inImmunity = false;
    this.immunityCount = 30;
    r = 255;
    g = 255;
    b = 255;
  }
  
  void setPosition(float x, float y, float z)
  {
    this.pos.x = x;
    this.pos.y = y;
    this.pos.z = z;
  }
  
  void setColor(float red, float green, float blue )
  {
    r = red;
    b = blue;
    g = green;
  }
  void move()
  {
    this.recover();
    if(inImmunity)
    {
      println("IMMUNE");
        if(immunityCount<=0)
        {
          println("NOT IMMUNE");
          inImmunity = false;
        }
        immunityCount--;
    }
    else
    {
       immunityCount = 30; 
    }
    
    if(direction.x==0)
    {
      
      if(velocity.mag()<=1)
      {
        velocity.mult(0);
      }
      else
      {
      decceleration.x = -velocity.x;
      decceleration.y = -velocity.y;
      decceleration.div(speed);
      //decceleration.normalize();
      this.applyForce(decceleration);
      
      //decceleration.mult(mass);
      //velocity.sub(decceleration);
      //println(velocity.mag());
      }
    }
    
    if(velocity.mag()>=limit)
    {
      this.velocity.limit(limit);
    }
   
    velocity.add(acceleration);
    pos.add(velocity);
     
    direction.x = 0;
    acceleration.mult(0);

  }
  void display()
  {
    fill(255);
   
   
    front.setPosition(pos.x,pos.y+20);
    rear.setPosition(pos.x,pos.y-16);
    if(inImmunity)
    {
      if(counter<=0)
      {
        counter = 2;
        if(flash)
        {
          t = 0;
          flash = false;
        }
        else
        {
          t = 255;
          flash = true;
        }
      }
      counter--;
    }
    else
    {
      t = 255;
    }
    tint(r,g,b,t);
    front.display();
    rear.display();
    //ellipse(pos.x,pos.y,r*2,r*2);
    if(pos.x>=width)
    {
      pos.x = width;
      isMoving = false;
    }
    if(pos.x<=0)
    {
      pos.x = 0;
      isMoving = false;
    }
    box.display(pos);
  }
  
  void moveLeft()
  {
   direction.x = -1;
   PVector f = new PVector(direction.x*speed,0);
   this.applyForce(f);
   isMoving = true;
  }
  void moveRight()
  {
   direction.x = 1;
   PVector f = new PVector(direction.x*speed,0);
   this.applyForce(f);
   isMoving = true;
  }
  
  void applyForce(PVector force)
  {
    PVector f = force.copy();
    f.div(mass);
    acceleration.add(f);
  }
  void recover()
  {
    if(recoverCount<=0)
    {
      if(pos.y<height/2.5)
      {
        
        //pos.y+=recoverForce.y*10;
        //println("Here");
        this.applyForce(new PVector(0,10/recoverForce.y));
      }
      recoverCount = 50;
    }
    else
    {
       recoverCount--; 
    }
      if (pos.y>height/2.5)
      {
        pos.y=height/2.5;
        //this.applyForce(new PVector(0,-5));
      }
    
  }
}