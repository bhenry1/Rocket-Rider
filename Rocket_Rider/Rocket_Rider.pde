import processing.sound.*;

SoundFile musicFile;
SoundFile stage2MusicFile;
SoundFile crashSound;
SoundFile candyCollect;
SoundFile gameOverMusic;

PImage asteroid;
PImage medAsteroid;
PFont font;
PImage spaceBackGround;
PImage rocketFrontImage;
PImage rocketRearImage; 
PImage gameOverBackGround;
PImage milkyWayCandyCollectable;
PImage titleScreenBackground;

boolean gameover;


Rocket myRocket;
RocketFront front;
RocketFront front_HollowPoint;
RocketFront front_TankPoint;
RocketFront front_GunayPoint;

RocketRear rear;
RocketRear rear_BoomBoom;
RocketRear rear_PuffPuff;
RocketRear rear_StagStag;

StarField[] stars = new StarField[800];
ArrayList<SpaceObject> spaceObjects = new ArrayList<SpaceObject>();
float candyCount;
float smAsteroidCount;
float medAsteroidCount;

float speed;
float timeInterval;
float timePast;
float timePast2;
float timePast3;
float timer4;

float levelTimer = 15000;
int keyInput;

float x,y,z;
PVector backPos;
PVector  offset;


//score increses every half a second
float scoreInterval = 500;

float timeAlive = 0;
int stage = 1;
int textOpacity = 100;
int textFade = 2;
int score = 0;
int scoreMultiplyer = 1;
int level = 1;
int candy = 0;
int secondsEllapsed = 0;
int minutesEllapsed = 0;
Timer startTimer;

CollisionField testBox;

int laneCount;
int lastLane;

void setup()
{
  //z = 1;
  gameover = false;
  size(600, 600);
  startTimer = new Timer(0);
  rocketFrontImage = loadImage("RocketFront.png");
  rocketRearImage = loadImage("RocketRear.png");
  

  backPos = new PVector((-width),0,1);
  offset = new PVector(0,0);

  font = loadFont("Stencil-48.vlw");
  timePast = millis();
  timePast2 = millis();
  timePast3 = millis();
  timeInterval = 750.0f;
  keyInput = 0;
  int size1 = 30;
  int size2= 30;
  
  laneCount = 10;
  lastLane = 0;
  
  /*
  CREATE THE ROCKET BY MAKING PARTS(FRONT/REAR) and COMBINING INTO A ROCKET OBJECT
  */
  //Front rocket parameters: Defense(How much damage can your rocket take) , Size(The size of the rocket)
  front_HollowPoint = new RocketFront(1,new PVector(size1,size1), rocketFrontImage);
  front_GunayPoint = new RocketFront(2.5,new PVector(size1,size1), rocketFrontImage);
  front_TankPoint = new RocketFront(5,new PVector(size1,size1), rocketFrontImage);
 
  
  //Rear Rocket parameters: ThrustSpeed, SpeedLimit , Size
   rear_BoomBoom = new RocketRear(20,1,new PVector(size2,size2), rocketRearImage);
   rear_PuffPuff = new RocketRear(5,8,new PVector(size2,size2), rocketRearImage);
   rear_StagStag = new RocketRear(10,10,new PVector(size2,size2), rocketRearImage);
   //ROCKET IS BUILT
   myRocket = new Rocket(width/2,height/2.5,5,front_GunayPoint,rear_BoomBoom);
  
  
  /**
  GAME IMAGES ARE DEFINED AND LOADED HERE
  **/
  
  asteroid = loadImage("smallAstro.png");
  medAsteroid = loadImage("MedAstro.png");
  spaceBackGround = loadImage("SpaceBackground2.png");

  gameOverBackGround = loadImage("GameOverBackground.png");
  milkyWayCandyCollectable = loadImage("MilkyWayCollectable.png");
  titleScreenBackground = loadImage("title2.png");

  
  //spaceBackGround.resize(600, 600);
  
 

  /**
  CREATE THE OBJECTS FOR THE GAME AND STORE THEM IN AN ARRAY LIST
  **/
  candyCount = 5;
  smAsteroidCount = 10;
  medAsteroidCount = 3;
  for(int i = 0; i < candyCount; i++)
  {
    SpaceObject o = new SpaceObject(milkyWayCandyCollectable,new CollisionField(new PVector(40,20),new PVector(0,0)),"collectable");
    o.setSpeed(8);
    o.setGraphicScale(42,22);
    o.setPosition(random(width),random(height,height*2)); 
    spaceObjects.add(o);  
  }
  for(int i = 0; i < smAsteroidCount; i++)
  {
     SpaceObject o = new SpaceObject(asteroid,new CollisionField(new PVector(40,40),new PVector(0,0)),"obstacle");
     o.setSpeed(8);
     o.setGraphicScale(50,50);
     o.setPosition(random(width),random(height,height*2));
     spaceObjects.add(o);
   }
  for(int i = 0; i < medAsteroidCount; i++)
  {
   SpaceObject o = new SpaceObject(medAsteroid,new CollisionField(new PVector(40,60),new PVector(0,0)),"obstacle");
     o.setSpeed(15);
     o.setGraphicScale(45,75);
     o.setPosition(random(width),random(height,height*2));
     spaceObjects.add(o);
  }
  
  
  for(int i = 0; i < stars.length; i++)
  {
    stars[i] = new StarField();
  }

  //Loading soundfx/music
  musicFile = new SoundFile(this, "StartMusic.mp3");
  //musicFile.play();
  musicFile.amp(0.3);
  musicFile.loop();

  
  stage2MusicFile = new SoundFile(this, "DiamondInTheSky.mp3");
  stage2MusicFile.amp(0.3);
  
  crashSound = new SoundFile(this, "Crash.mp3");
  crashSound.amp(0.6);
  
  candyCollect = new SoundFile(this, "candyget.mp3");
  crashSound.amp(0.5);
  
  gameOverMusic = new SoundFile(this, "gameover.mp3");
  gameOverMusic.amp(0.5);

  frameRate(30);
  /**
  LOOP THAT SETS THE LANE POSITIONS FOR OBJECTS
  **/
  for(int i = 0; i < spaceObjects.size(); i++)
  {
    SpaceObject o = spaceObjects.get(i);
    setLane(o);
  }
  
}

void draw()
{
  x = myRocket.pos.x;
  background(0);
  //y = myRocket.pos.y;
  getInput();
  //Stage 1
  if(stage == 1)
  {
       
    background(0);

   //Stars start from the center of the screen
   translate(0,0);
   //pushMatrix();
   //Speed of the stars is maped to the player's mouseX, or mouse movent along the width of the screen
   speed = map(mouseX, 0, width, 1, 15);

   imageMode(CORNER);
   
   image(titleScreenBackground, -width/5.7, height/20, 800, 600);
   //popMatrix();
   translate(width/2, height/2);
   textFade();
   setTitleText();
   displayStars(); 
  }
  
   //Stage 2
   else if(stage == 2)
  {     
    //offset.y = myRocket.pos.y-x;
    //background(spaceBackGround);
    imageMode(CORNER);
    backPos.x = backPos.x+(backPos.z*(offset.x/myRocket.pos.z));
    //image(spaceBackGround,backPos.x,0);
    textSize(22);
   
    startTimer.countUp();
    fill(255);
    secondsEllapsed = Math.round(startTimer.getTime());
   
    
    if(secondsEllapsed < 10)
    {
      
       text("Time Elapsed: " + minutesEllapsed + ":" + "0" + secondsEllapsed, width/1.65, 30);
    }
    else
    {
       text("Time Elapsed: " + minutesEllapsed + ":" + secondsEllapsed, width/1.65, 30);
    
      if( secondsEllapsed >= 60)
      {
        startTimer = new Timer(0);
        minutesEllapsed++;
      }
    }
    
    setPlayerScoreLevelAndCandyText();
    setScoreTimeInterval();
    setLevelTimeInterval();
    
    updateObjects();
     
    myRocket.move();
    myRocket.display();
    offset.x = x-myRocket.pos.x;
  }
  
  //Stage 3
  else if(stage == 3)
  {
    stage2MusicFile.stop();
    background(gameOverBackGround);
    setGameOverText();
   
  }
  
   if(gameover)
      {
        crashSound.play();
        gameOverMusic.play();
        resetObjects();
        stage = 3;
        gameover = false;
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

   //Enter
  if(key==10)
     {
       musicFile.stop();
       stage2MusicFile.play();
       stage = 2;
       timer4 = millis();
     }
 }
     
 else
 {
   //sapcebar
   if(key== 32)
     {
       crashSound.stop();
       gameOverMusic.stop();
       musicFile.loop();
       minutesEllapsed = 0;
       score = 0;
       scoreMultiplyer = 1;
       level = 1;
       stage = 1;
       candy = 0;
       timePast3 = 0;
       startTimer = new Timer(0);
       
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

/*
*Method Name: setTitleText()
*@param: None
*DESC: This method creates the text seen on the title screen
*/
void setTitleText()
{
 textSize(32);
 textFont(font, 32);
 //text("Rocket Rider!", -100, -250);
 fill(255,255,255,textOpacity);
 rectMode(CENTER);
 text("Press enter to ride!", -width/3.5, height/3);
}

 /*
*Method Name: textFade()
*@param: None
*DESC: This method dispalys the fading in and out effect of the "Press Enter To Ride!" text.
*/
void textFade()
{
  if(millis() > timeInterval + timePast)
  {
    timePast = millis();
    textFade *= -1;
  }
  
  textOpacity += textFade;
}

 /*
*Method Name: displayStars()
*@param: None
*DESC: This method displays the stars on the title screen.
*/
void displayStars()
{
  for(int i = 0; i < stars.length; i++)
   {
     stars[i].update();
     stars[i].show();
   }
  
}

 /*
*Method Name: setPlayerScoreLevelAndCandyText()
*@param: None
*DESC: This method sets the score, level, and candy text at the top left of the screen
*/
void setPlayerScoreLevelAndCandyText()
{
    textSize(22);  
    fill(255,255,255,255);
    text("Score:" + score , 0, 30); 
    textSize(22);
    fill(255,255,255,255);
    text("Level: " + level, 0, 50);
    textSize(22);
    fill(255,255,255,255);
    text("Candy: " + candy, 0, 70);
    textSize(22);
    fill(255,255,255,255);
    //text("Time Elapsed:" + startTimer.getTime(), width/1.65, 30);
 }
 
 /*
*Method Name: setScoreTimeInterval()
*@param: None
*DESC: This method increments the "score text interval by 10 every half a second
*/
void setScoreTimeInterval()
{
  
  
  
    if(millis() > timePast + scoreInterval)
    {
       timePast = millis();
       score += scoreMultiplyer*10; 
    }

}

/*
*Method Name: setLevelTimeInterval()
*@param: None
*DESC: This method increments the "level" text every 15 seconds
*/
void setLevelTimeInterval()
{
  /*
  
   if(millis() > timePast2 + levelTimer)
    {
      timePast2 += millis();
      level++; 
    }
    */
    
    //THIS IS A BUGG
     if(secondsEllapsed == 5)
     {
      level++;
      }
        
      
 
}

/*
*Method Name: handleCollisions()
*@param: None
*DESC: This method contains the logic for obstacle collison as well as generating astroids.
*/
void updateObjects()
{ 
   for(int i = 0; i < spaceObjects.size(); i++)
   {
        SpaceObject o = spaceObjects.get(i);
        o.update();
        o.show();
        if(o.box.isCollidingWith(myRocket.box))
        {
          handleCollision(o,myRocket);
        }
       if(o.isOffScreen())
        {
           setLane(o);
          //o.setPosition(random(width),random(height,height*2));
        }
      }
}

/*
*Method Name: setGameOverText()
*@param: None
*DESC: This method sets the text the player sees at the game over screen.
*/
void setGameOverText()
{
    fill(255);
    textSize(70);
    text("YOU CRASHED!", width/9, 100);
    
    fill(255);
    textSize(22);
    text("Your score was: " + score + "\nYou were on level: " + level + "\nYou were alive for: " + minutesEllapsed + " minute(s) and " + secondsEllapsed + "  sec." + "\nYou collected: " + candy + " Candies", 60, height/3); 
   
    text("Press the spacebar to play again" , 120, 400);  
}

/*
*Method Name: resetObjects()
*@param: None
*DESC: This method resets the postions of the obstacles and candy 
*upon astroid collision so that when the player restarts a new game 
*they dont immeditely collide with an astroid. 
*/
void resetObjects()
{
  
  for(int i = 0; i < spaceObjects.size(); i++)
      {
        SpaceObject o = spaceObjects.get(i);
        setLane(o);
       // o.setPosition(random(width),random(height,height*2));
      }
}

void setLane(SpaceObject o)
{
     float lane = int(random(laneCount));
      while(lastLane == lane)
      {
        lane = int(random(0,laneCount));
      }
      lastLane = int(lane);
      float laneX = (lane/laneCount)*width;
      float laneY = height*3 + ((lane/5)*height);
      //println(laneY);
      o.setPosition(laneX,random(height,laneY));   
}

void handleCollision(SpaceObject o, Rocket r)
{
  
          if(o.getTag()=="obstacle")
          {
            float laneY = height/2.5;
            r.pos.y -=(laneY*(1/r.recoverForce.y));
            println("GOT HIT");
            if(r.pos.y<0)
            {
               gameover = true;
            }
           //
          }
          else if(o.getTag()=="collectable")
          {
            candyCollect.play();
            scoreMultiplyer++;
            //o.setPosition(random(width),random(height,height*2));
          }
          setLane(o);
}