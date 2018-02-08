import processing.sound.*;
SoundFile musicFile;

PImage asteroid;
PImage medAsteroid;
PFont font;
PImage spaceBackGround;
PImage rocketFrontImage;
PImage rocketRearImage; 

Rocket myRocket;
RocketFront front;
RocketFront front_HollowPoint;
RocketFront front_TankPoint;

RocketRear rear;
RocketRear rear_BoomBoom;
RocketRear rear_PuffPuff;
RocketRear rear_StagStag;

StarField[] stars = new StarField[800];
Obstacles[] obstacles = new Obstacles[10];
MObstacles[] mObstacles = new MObstacles[1];

float speed;
float timeInterval;
float timePast;
float timePast2;
float timePast3;
float levelTimer = 15000;
int keyInput;
//Astroid Postions
float x;
float y;


float scoreInterval = 500;


int stage = 1;
int textOpacity = 100;
int textFade = 2;
int score = 0;
int level = 1;
Obstacles obj = new Obstacles(timePast3);
MObstacles Mobj = new MObstacles();


CollisionField testBox;

void setup()
{
  size(600, 600);
  rocketFrontImage = loadImage("RocketFront.png");
  rocketRearImage = loadImage("RocketRear.png");

  testBox = new CollisionField(new PVector(100,100),new PVector(width/4,100));
  font = loadFont("Stencil-48.vlw");
  timePast = millis();
  timePast2 = millis();
  timePast3 = millis();
  timeInterval = 750.0f;
  keyInput = 0;
  int size1 = 30;
  int size2= 30;
  
  //Front rocket parameters: Defense , Size
  
  front_HollowPoint = new RocketFront(1,new PVector(size1,size1), rocketFrontImage);
  front_TankPoint = new RocketFront(5,new PVector(size1,size1), rocketFrontImage);
  //Rear Rocket parameters: ThrustSpeed, SpeedLimit , Size
   

   rear_BoomBoom = new RocketRear(30,1,new PVector(size2,size2), rocketRearImage);
   rear_PuffPuff = new RocketRear(1,30,new PVector(size2,size2), rocketRearImage);
   rear_StagStag = new RocketRear(10,10,new PVector(size2,size2), rocketRearImage);
   //ROCKET IS BUILT
   myRocket = new Rocket(width/2,height/4,front_TankPoint,rear_BoomBoom);
  
  asteroid = loadImage("smallAstro.png");
  medAsteroid = loadImage("MedAstro.png");
  spaceBackGround = loadImage("Space.png");
  //spaceBackGround.resize(600, 600);
  
  
  
  for(int i = 0; i < stars.length; i++)
  {
    stars[i] = new StarField();
  }
  
  for(int i = 0; i < obstacles.length; i++)
  {
        obstacles[i] = new Obstacles(timePast3);

  }
  
  for(int i = 0; i < mObstacles.length; i++)
  {
        mObstacles[i] = new MObstacles();

  }
  
  musicFile = new SoundFile(this, "StartMusic.mp3");
  musicFile.play();
  musicFile.amp(0.3);
  frameRate(30);
  
}

void draw()
{
  getInput();
  //Stage 1
  if(stage == 1)
  {
   translate(width/2, height/2);
   speed = map(mouseX, 0, width, 1, 15);
   background(0);
   textFade();
   
   for(int i = 0; i < stars.length; i++)
   {
     stars[i].update();
     stars[i].show();
   }
   
   setText();
     
  }
  
   //Stage 2
   else if(stage == 2)
  {
    //background(spaceBackGround);
    imageMode(CORNER);
    image(spaceBackGround,0,0);
    textSize(22);
    fill(255,255,255,255);
   
    if(millis() > timePast + scoreInterval)
    {
       timePast = millis();
       score += 10; 
    }
    
    
    text("Score:" + score , 0, 30); 
    textSize(22);
    fill(255,255,255,255);
    
    if(millis() > timePast2 + levelTimer)
    {
      timePast2 += millis();
      level++;
      
    }
    
    text("Level: " + level, 0, 50);
    
      for(int i = 0; i < obstacles.length; i++)
      {
        
        obstacles[i].update();
        obstacles[i].show();
        if(obstacles[i].box.isCollidingWith(myRocket.box))
        {
          obj.resetObstaclePostion();

         stage = 3;
         

        }
      }
      
      for(int i = 0; i < mObstacles.length; i++)
      {
        mObstacles[i].update();
        mObstacles[i].show();
        if(mObstacles[i].box.isCollidingWith(myRocket.box))
        {
          stage = 3;
          
        }
      } 
      myRocket.move();
      myRocket.display();

  }
  
  //Stage 3
  else if(stage == 3)
  {
    background(0);
    fill(255);
    textSize(22);
    text("Your score was: " + score + "\nYou were on level: " + level + "\nYou were alive for: " + score/20 + "sec.", width/3, height/3); 
    
    textSize(22);
    fill(255);
   
    text("Press the spacebar to play again" , 120, 400);  
   
  }

}

void getInput()
{
  if(stage == 2)
  {
    if(keyPressed)
    {
    //println(keyCode);
    if(keyInput == RIGHT)
    myRocket.moveRight();
    
    else if(keyInput == LEFT)
    myRocket.moveLeft();
    
    }  
 }
 else if(stage == 1)
 {
  if(key == 10)
     {
       musicFile.stop();
       stage = 2;
     }
 }
     
 else
 {
   //sapcebar
   if(key== 32)
     {
       score = 0;
       level = 1;
       stage = 1;
       timePast3 = 0;
     }
 }
 
}
void keyPressed()
{
   keyInput = keyCode;
}
void keyReleased()
{
 if (keyCode == keyInput )
 {
   keyInput = 0;
 }
}

void setText()
{
 textSize(32);
 textFont(font, 32);
 text("Rocket Rider!", -100, -250);
 fill(255,255,255,textOpacity);
 rectMode(CENTER);
 text("Press enter to ride!", -width/3.5, 0);
}

void textFade()
{
  if(millis() > timeInterval + timePast)
  {
    timePast = millis();
    textFade *= -1;
  }
  
  textOpacity += textFade;
  
}