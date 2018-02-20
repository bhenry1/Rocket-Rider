import processing.sound.*;

SoundFile musicFile;
SoundFile stage2MusicFile;
SoundFile crashSound;

PImage asteroid;
PImage medAsteroid;
PFont font;
PImage spaceBackGround;
PImage rocketFrontImage;
PImage rocketRearImage; 
PImage gameOverBackGround;
PImage milkyWayCandyCollectable;

boolean gameover;
boolean visible = false;

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
Candy[] candies = new Candy[1];

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

//score increses every half a second
float scoreInterval = 500;


int stage = 1;
int textOpacity = 100;
int textFade = 2;
int score = 0;
int level = 1;
int candy = 0;

CollisionField testBox;

void setup()
{
  gameover = false;
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
   rear_BoomBoom = new RocketRear(20,1,new PVector(size2,size2), rocketRearImage);
   rear_PuffPuff = new RocketRear(2,10,new PVector(size2,size2), rocketRearImage);
   rear_StagStag = new RocketRear(10,10,new PVector(size2,size2), rocketRearImage);
   //ROCKET IS BUILT
   myRocket = new Rocket(width/2,height/4,front_HollowPoint,rear_PuffPuff);
  
  asteroid = loadImage("smallAstro.png");
  medAsteroid = loadImage("MedAstro.png");
  spaceBackGround = loadImage("SpaceBackground2.png");
  gameOverBackGround = loadImage("GameOverBackground.png");
  milkyWayCandyCollectable = loadImage("MilkyWayCollectable.png");
  //spaceBackGround.resize(600, 600);
  
 
  //Filling Obstacle/star/astroid arrays
  for(int i = 0; i < stars.length; i++)
  {
    stars[i] = new StarField();
  }
  
  for(int i = 0; i < obstacles.length; i++)
  {
        obstacles[i] = new Obstacles();
        obstacles[i].resetObstaclePostion();

  }
  
  for(int i = 0; i < mObstacles.length; i++)
  {
        mObstacles[i] = new MObstacles();
        mObstacles[i].resetObstaclePostion();

  }
  
  
  for(int i = 0; i < candies.length; i++)
  {
    candies[i] = new Candy();
    candies[i].resetCandyPostion();
  }
  
  //Loading soundfx/music
  musicFile = new SoundFile(this, "StartMusic.mp3");
  musicFile.play();
  musicFile.amp(0.3);
  
  stage2MusicFile = new SoundFile(this, "DiamondInTheSky.mp3");
  stage2MusicFile.amp(0.3);
  
  crashSound = new SoundFile(this, "Crash.mp3");
  crashSound.amp(0.6);
  frameRate(30);
  
}

void draw()
{
  getInput();
  //Stage 1
  if(stage == 1)
  {
   //Stars start from the center of the screen
   translate(width/2, height/2);
   //Speed of the stars is maped to the player's mouseX, or mouse movent along the width of the screen
   speed = map(mouseX, 0, width, 1, 15);
   background(0);
   
   textFade();
   setTitleText();
   displayStars(); 
  }
  
   //Stage 2
   else if(stage == 2)
  {
    //background starts from the corner of the screen
    imageMode(CORNER);
    image(spaceBackGround,0,0);
    
    setPlayerScoreLevelAndCandyText();
    setScoreTimeInterval();
    setLevelTimeInterval();
    obstacleCollisionLogic();
    candyCollisionLogic();
     
    myRocket.move();
    myRocket.display();
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
        resetCandyAndObstaclePostions();
        
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
     }
 }
     
 else
 {
   //sapcebar
   if(key== 32)
     {
       crashSound.stop();
       musicFile.play();
       score = 0;
       level = 1;
       stage = 1;
       candy = 0;
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

/*
*Method Name: setTitleText()
*@param: None
*DESC: This method creates the text seen on the title screen
*/
void setTitleText()
{
 textSize(32);
 textFont(font, 32);
 text("Rocket Rider!", -100, -250);
 fill(255,255,255,textOpacity);
 rectMode(CENTER);
 text("Press enter to ride!", -width/3.5, 0);
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
       score += 10; 
    }
  
}

/*
*Method Name: setLevelTimeInterval()
*@param: None
*DESC: This method increments the "level" text every 15 seconds
*/
void setLevelTimeInterval()
{
   if(millis() > timePast2 + levelTimer)
    {
      timePast2 += millis();
      level++; 
    }
}

/*
*Method Name: obstacleCollisionLogic()
*@param: None
*DESC: This method contains the logic for obstacle collison as well as generating astroids.
*/
void obstacleCollisionLogic()
{
  for(int i = 0; i < obstacles.length; i++)
      {
        
        obstacles[i].update();
        obstacles[i].show();
        if(obstacles[i].box.isCollidingWith(myRocket.box))
        { 
          gameover = true;
        }
      }
      
      for(int i = 0; i < mObstacles.length; i++)
      {
        mObstacles[i].update();
        mObstacles[i].show();
        if(mObstacles[i].box.isCollidingWith(myRocket.box))
        {
          gameover = true;
          
        }
      }
      
}

/*
*Method Name: candyCollisionLogic()
*@param: None
*DESC: This method contains the logic for generating candy and what happens upon collison with candy. 
*/
void candyCollisionLogic()
{
  for(int i =0; i < candies.length; i++)
     {
        candies[i].update();
        candies[i].show();
        if(candies[i].box.isCollidingWith(myRocket.box))
        {
          candy++;
         candies[i].resetCandyPostion();
            
          
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
    text("Your score was: " + score + "\nYou were on level: " + level + "\nYou were alive for: " + score/20 + "sec.", 120, height/3); 
   
    text("Press the spacebar to play again" , 120, 400);  
  
}

/*
*Method Name: resetCandyAndObstaclePostions()
*@param: None
*DESC: This method resets the postions of the obstacles and candy 
*upon astroid collision so that when the player restarts a new game 
*they dont immeditely collide with an astroid. 
*/
void resetCandyAndObstaclePostions()
{
  for(int i = 0; i < mObstacles.length; i++)
   {
    mObstacles[i].resetObstaclePostion();
   }
  
  for(int i = 0; i < obstacles.length; i++)
   {
   obstacles[i].resetObstaclePostion();
   }
    
    /*
   for(int i = 0; i < candies.length; i++)
   {
   candies[i].resetCandyPostion();
   }
   */
  
}

void scrollCamera()
{
  
}