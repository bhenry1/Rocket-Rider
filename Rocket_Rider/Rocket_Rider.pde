import processing.sound.*;

SoundFile musicFile;
SoundFile stage2MusicFile;
SoundFile crashSound;
SoundFile candyCollect;
SoundFile gameOverMusic;
SoundFile levelUp;

PImage asteroid;
PImage medAsteroid;
PFont font;
PImage spaceBackGround;
PImage rocketFrontImage;
PImage rocketFrontImage2;
PImage rocketFrontImage3;
PImage rocketRearImage; 
PImage rocketRearImage2;
PImage rocketRearImage3;
PImage gameOverBackGround;
PImage milkyWayCandyCollectable;
PImage titleScreenBackground;



PImage back1;
PImage back2;
PImage back3;
PImage back4;
PImage back5;
PImage frame1;
PImage frame2;
PImage frame3;
int imageIndex = 5;

PImage[] backImages = new PImage[5];

PImage customImage;

boolean gameover;
boolean inMultiplayer;

boolean left1;
boolean left2;
boolean right1;
boolean right2;
color tint1;
color tint2;

Rocket playerRocket1;
Rocket playerRocket2;
RocketFront front_Custom;
RocketFront front_HollowPoint;
RocketFront front_TankPoint;
RocketFront front_GunayPoint;

RocketRear rear_Custom;
RocketRear rear_BoomBoom;
RocketRear rear_PuffPuff;
RocketRear rear_StagStag;

StarField[] stars = new StarField[800];
ArrayList<SpaceObject> spaceObjects = new ArrayList<SpaceObject>();
int candyCount;
int smAsteroidCount;
int medAsteroidCount;
int customObjectCount;

float speed;
float timeInterval;
float timePast;
float timePast2;
float timePast3;
float timer4;

float levelTimer = 15000;
int keyInput1;
char keyInput2;

float x,y,z;
PVector backPos1;
PVector backPos2;
PVector backPos3;
PVector  offset;
int loser = 0;
int collider = 0;


//score increses every half a second
//float scoreInterval = 500;

float timeAlive = 0;
int stage = 1;
int textOpacity = 100;
int textFadeRate = 2;
//int score = 0;
//int scoreMultiplyer = 1;
int level = 1;
int candy1 = 0;
int candy2 = 0;
float secondsEllapsed = 0;
int minutesEllapsed = 0;
Timer startTimer;

CollisionField testBox;

int laneCount;
int lastLane;

void setup()
{
  //RED IS PLAYER 1, BLUE IS PLAYER 2
  inMultiplayer = false;
  left1 = false;
  left2 = false;
  right1 = false;
  right2 = false;
  
  

  size(600,600);

  gameover = false;
  startTimer = new Timer(0);
  rocketFrontImage = loadImage("data/RocketFront.png");
  rocketFrontImage2 = loadImage("data/RocketFront2.png");
  rocketFrontImage3 = loadImage("data/RocketFront4.png");
  
  rocketRearImage = loadImage("data/RocketRear.png");
  rocketRearImage2 = loadImage("data/RocketRear2.png");
  rocketRearImage3 = loadImage("data/RocketRear4.png");
  
  backPos1 = new PVector(width/2,0);
  backPos2 = new PVector(width/2,height/2);
  backPos3 = new PVector(width/2,height);
  offset = new PVector(0,0);

  font = loadFont("Stencil-48.vlw");
  timePast = millis();
  timePast2 = millis();
  timePast3 = millis();
  timeInterval = 750.0f;
  keyInput1 = 0;
  keyInput2 = ' ';
  int size1 = 30;
  int size2= 30;
  laneCount = 10;
  lastLane = 0;
  
  PVector pos1 = new PVector(0,0);
  PVector pos2 = new PVector(0,0);
  //SETS THE CHARACTER COLORS and POSITIONS FOR MULTIPLAYER
   if(inMultiplayer)
  {
     tint1 = color(255,0,0);
     pos1.x = width/2.5;
     pos1.y = height/2.5;
     tint2 = color(0,0,255);
     pos2.x = width/1.5;
     pos2.y = height/2.5;
  }
  else
  {
     tint1 = color(255,255,255,255);
     pos1.x = width/2;
     pos1.y = height/2.5;
     tint2 = color(255,255,255);
  }
  //FRONT VARIABLES  Defense(How much damage can your rocket take) , Size(The size of the rocket)
  float defense = 0;
  PVector frontSize = new PVector(0,0);
  //REAR VARIABLES  ThrustSpeed(How fast the rocket accelerates), SpeedLimit(Max speed of the rocket) , Size
  float thrustSpeed =0;
  float speedLimit = 0;
  PVector rearSize = new PVector(0,0);
  
  /*CREATE THE ROCKET BY MAKING PARTS(FRONT/REAR) and COMBINING INTO A ROCKET OBJECT*/
  //Front rocket parameters: Defense(How much damage can your rocket take) , Size(The size of the rocket)
  front_HollowPoint   = new RocketFront(1,new PVector(size1,size1), rocketFrontImage);
  front_GunayPoint    = new RocketFront(2.5,new PVector(size1,size1), rocketFrontImage2);
  front_TankPoint     = new RocketFront(5,new PVector(size1,size1), rocketFrontImage3);
  //front_Custom = new RocketFront(defense,frontSize);
  
  //Rear Rocket parameters: ThrustSpeed, SpeedLimit , Size
   rear_BoomBoom = new RocketRear(20,1,new PVector(size2,size2), rocketRearImage3);
   rear_PuffPuff = new RocketRear(5,8,new PVector(size2,size2), rocketRearImage);
   rear_StagStag = new RocketRear(10,10,new PVector(size2,size2), rocketRearImage2);
   //rear_Custom = new RocketFront(thrustSpeed,speedLimit,rearSize);
   
   //ROCKET IS BUILT
   playerRocket1 = new Rocket(front_TankPoint,rear_BoomBoom);
   playerRocket1.setPosition(pos1.x,pos1.y,0);
   playerRocket1.setColor(255,255,255);
   
   if(inMultiplayer)
   {
   playerRocket2 = new Rocket(front_GunayPoint,rear_BoomBoom);
   playerRocket2.setPosition(pos2.x,pos2.y,0);
   playerRocket1.setColor(255,0,0);
   playerRocket2.setColor(0,0,255);
   }
   else
   {
    playerRocket2 = null; 
   }
  
   
  
  
  /**
  GAME IMAGES ARE DEFINED AND LOADED HERE
  **/
  
  asteroid = loadImage("data/smallAstro.png");
  medAsteroid = loadImage("data/MedAstro.png");
  spaceBackGround = loadImage("SpaceBackground2.png");

  gameOverBackGround = loadImage("GameOverScreen.png");
  milkyWayCandyCollectable = loadImage("MilkyWayCollectable.png");
  titleScreenBackground = loadImage("title.png");
  
  back1 = loadImage("back1.png");
  back2 = loadImage("back2.png");
  back3 = loadImage("back3.png");
  back4 = loadImage("back4.png");
  back5 = loadImage("back5.png");
  
  backImages[0] = back1;
  backImages[1] = back2;
  backImages[2] = back3;
  backImages[3] = back4;
  backImages[4] = back5;
  
  frame1 = back3;
  frame2 = back4;
  frame3 = back5;
  
  

  
  //spaceBackGround.resize(600, 600);
  
 

  /**
  CREATE THE OBJECTS FOR THE GAME AND STORE THEM IN AN ARRAY LIST
  **/
  candyCount = 5;
  smAsteroidCount = 5;
  medAsteroidCount = 3;
  
  createSpaceObject("collectable",candyCount,40f,20f,255,255,255);
  createSpaceObject("collectable_2",1,40f,20f,50,255,50);
  createSpaceObject("obstacle1",smAsteroidCount,100f,100f,255,255,255);
  createSpaceObject("obstacle2",medAsteroidCount,80f,120f,255,255,255);
  
/**INSERT your picture here simply make the line : customImage = loadImage("myPic.png");**/
  customImage = loadImage("satellite.png");
  //Number of Custom Objects in game.
  customObjectCount = 1;
  //How Wide the object is.
  float customWidth = 300;
  //How Tall the object is.
  float customHeight = 200;
  
  createSpaceObject("custom_obstacle",customObjectCount,customWidth,customHeight,255,255,255);
  
  
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
  candyCollect.amp(0.3);
  candyCollect.rate(3);
  
  gameOverMusic = new SoundFile(this, "gameover.mp3");
  gameOverMusic.amp(0.5);
  
  levelUp = new SoundFile(this, "levelUp.mp3");
  levelUp.amp(0.5);

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
  x = playerRocket1.pos.x;
  background(0);
  //y = playerRocket1.pos.y;
  getInput();
  //Stage 1
  if(stage == 1)
  {
       
    background(0);

   //Stars start from the center of the screen
   translate(0,0);
   //Speed of the stars is mapped to the player's mouseX, or mouse movent along the width of the screen
   speed = map(mouseX, 0, width, 1, 15);

   imageMode(CENTER);
   
   
   image(titleScreenBackground, width/2, height/2, width, height);//*(width/width));

   translate(width/2, height/2);
   textFade();
   setTitleText();
   displayStars(); 
  }
  
   //Stage 2
   else if(stage == 2)
  {     
    //offset.y = playerRocket1.pos.y-x;
    //background(spaceBackGround);
    imageMode(CORNER);
    displayBackground();
    //backPos.x = backPos.x+(backPos.z*(offset.x/playerRocket1.pos.z));
    //image(spaceBackGround,-width,0);//,backPos.x,0);
 
    //}
    
   /**
   UPDATE PLAYER ROCKETS
   **/
    playerRocket1.move();
    //tint(tint1);
    playerRocket1.display();
    
    //CHECKS FOR MULTIPLAYER AND DISPLAYS PLAYER 2
    if(inMultiplayer)
    {
    playerRocket2.move();
    //tint(tint2);
    playerRocket2.display();
    }
    tint(255, 255, 255);
    updateObjects();
    
    /**
    CHECK TO SEE WHICH PLAYER HAS LOST
    **/
      if(playerRocket1.pos.y<0)
       {
            gameover = true;
            loser = 1;
       }
     if(inMultiplayer)
        {
          if(playerRocket2.pos.y<0)
          {
            gameover = true;
            loser = 2;
          }
        }
     
     /**UPDATE SCORE AND GAME CLOCK **/
    displayInGameText();

  }
  
  //Stage 3
  else if(stage == 3)
  {
    stage2MusicFile.stop();
    image(gameOverBackGround, width/2, height/2, width, height);
    displayGameOverText();
   
  }
  
   if(gameover)
    {
      crashSound.play();
      gameOverMusic.play();
      resetObjects();
      stage = 3;
      gameover = false;
       playerRocket1.pos.y = height/2.5;
       playerRocket1.velocity.mult(0);
      if(inMultiplayer)
      {
       playerRocket2.pos.y = height/2.5;
       playerRocket2.velocity.mult(0);
      
      }
    }
}

void getInput()
{
  if(stage == 2)
  {
    if(right1)
    {
       playerRocket1.moveRight();
    }
    else if (left1)
    {
      playerRocket1.moveLeft();
    }
    if(inMultiplayer)
    {
      if(right2)
      {
        playerRocket2.moveRight();
      }
      else if (left2)
      {
        playerRocket2.moveLeft();
      }
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
       //score = 0;
       //scoreMultiplyer = 1;
       level = 1;
       stage = 1;
       candy1 = 0;
       candy2 = 0;
       timePast3 = 0;
       startTimer = new Timer(0);
     }
   }
}
void keyPressed()
{
   switch(keyCode)
  {
    case RIGHT:
    right1 = true;
    break;
    case LEFT:
    left1 = true;
    break;
  }
  if(inMultiplayer)
  {
    switch(keyCode)
    {
      //case 'd':
      case UP :
      right2 = true;
      break;
      //case 'a':
      case DOWN :
      left2 = true;
      break;
    }
  }
}
void keyReleased()
{
  switch(keyCode)
  {
    case RIGHT:
    right1 = false;
    break;
    case LEFT:
    left1 = false;
    break;
  }
  if(inMultiplayer)
  {
    switch(keyCode)
    {
      //case 'd':
      case UP :
      right2 = false;
      break;
      //case 'a':
      case DOWN :
      left2 = false;
      break;
    }
  }
    
/*  }
 if (keyCode == keyInput1 )
 {
   keyInput1 = 0;
 }
 if (key == keyInput2 )
 {
   keyInput2 = ' ';
 }*/
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
 text("Press enter to ride!", -width/4.5, height/3);
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
    textFadeRate *= -1;
    
  }
  
  textOpacity += textFadeRate;
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
*Method Name: displayInGameText()
*@param: None
*DESC: This method displays the score, level, and candy text at the top left of the screen
*/
void displayInGameText()
{
    textSize(22);  
    fill(255,255,255,255);
    //text("Score:" + score , 0, 30); 
    //textSize(22);
    //fill(255,255,255,255);
    text("Level: " + level, int(width/12), height/15);
    textSize(22);
    //fill(255,255,255,255);
    text("Player 1 Candy: " + candy1, int(width/12), height/10);
    if(inMultiplayer)
    {
      text("Player 2 Candy: " + candy2, int(width/12), height/7);
    }
    textSize(22);
    //fill(255,255,255,255);
    //text("Time Elapsed:" + startTimer.getTime(), width/1.65, 30);
 
    startTimer.countUp();
    fill(255);
    secondsEllapsed = startTimer.getTime();

       text("Time Elapsed: " + minutesEllapsed + ":" + Math.round(secondsEllapsed), width -(width/2.6), height/15);
    
      if( secondsEllapsed >= 60)
      {
        startTimer = new Timer(0);
        minutesEllapsed++;
        level++;
        levelUp.play();
      }
      
      if(Math.round(secondsEllapsed) == 60)
     {
         textSize(30);
         text("level: " + level, width/1.55, height/2); 
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
      
     float levelInterval = 5;
     //float secondLevelInterval = 5.04;
     
     while(Math.round(secondsEllapsed) == 5 )
     {
       level++;
       break;
       
     }
     secondsEllapsed++;
   
   /*
     if((secondsEllapsed > levelInterval) && (secondsEllapsed < secondLevelInterval))
     {
      level++;
      levelUp.play();
      
     }
   */
     
      if(Math.round(secondsEllapsed) == levelInterval)
     {
         textSize(30);
         text("level: " + level, width/1.55, height/2); 
     }
        
      
 
}


/*
*Method Name: displayGameOverText()
*@param: None
*DESC: This method sets the text the player sees at the game over screen.
*/
void displayGameOverText()
{
    

    /*fill(255);
   
    text("Your score was: " + score + "\nYou were on level: " + level + "\nYou were alive for: " + minutesEllapsed + " minute(s) and " + Math.round(secondsEllapsed) + "  sec." + "\nYou collected: " + candy + " Candies", width/4, height/3.5); 
   */
    textSize(30);
    text("Press SPACE" , width/3, 375);  
    text("To Ride again!" , width/3, 400); 
    if(inMultiplayer)
    {
       if(loser == 1)
       {
         fill(255);
         textSize(22);
         text("Player 2 collected:" + candy2 + " candies", width/4.5, 250);
         textSize(50);
         text("Player 2 wins!", width/4, height/15);
         //System.out.println("Player 2 wins!!!!");
       }
       
       else if(loser == 2)
       {
         fill(255);
         textSize(22);
         text("Player 1 collected:" + candy1 + " candies", width/4.5, 250);
         textSize(50);
         text("Player 1 wins!", width/4, height/15);
         //System.out.println("Player 1 wins!!!!!");
       }
       
    }
       
       else
    {   
    fill(255);
    textSize(50);
    text("YOU CRASHED!", width/4, height/15);
    textSize(22);
    text("You collected: " + candy1 + " Candies", width/4, 250);
    text("You were alive for: \n" + minutesEllapsed + " Minutes and "  + Math.round(secondsEllapsed) + " seconds", width/4, 300);
    }
     
}



/*
*Method Name: resetObjects()
*@param: None
*DESC: This method resets the postions of the obstacles and candy 
*upon astroid collision so that when the player restarts a new game 
*they dont immeditely collide with an astroid. 
*/

 void createSpaceObject(String tag,int count,float w, float h, float r, float g, float b)
 {
    PImage im = null;
    float speed = 0;
    switch(tag)
    {
      case "collectable":
        im = milkyWayCandyCollectable;
        speed = 12;
      break;
       case "collectable_2":
        im = milkyWayCandyCollectable;
        speed = 12;
      break;
      //SET ATTRIBUTES OF REGULAR ASTEROID
      case "obstacle1":
        im = asteroid;
        tag = "obstacle";
        speed = 15;
      break;
      //SET ATTRIBUTES OF MEDIUM ASTEROID
      case "obstacle2":
        im = medAsteroid;
        tag = "obstacle";
        speed = 20;
      break;
      case "custom_obstacle":
        im = customImage;
        tag = "obstacle";
        speed = 10;
      break;
      case "custom_collectable":
        im = customImage;
        tag = "collectable";
        speed = 10;
        break;
    }
    println(tag);
    for(int i = 0; i < count; i++)
    {
      //print(im)
      SpaceObject o = new SpaceObject(im,new CollisionField(new PVector(w-(w/3),h-(h/3)),new PVector(0,0)),tag);
      o.setSpeed(speed);
      o.setGraphicScale(w,h);
      o.setPosition(random(width),random(height,height*2)); 
      o.setColor(r,g,b);
      spaceObjects.add(o);  
    }
}
/*
*Method Name: handleCollisions()
*@param: None
*DESC: This method contains the logic for obstacle collison as well as generating astroids.
*/
void updateObjects()
{ 
  //print(spaceObjects.size());
   for(int i = 0; i < spaceObjects.size(); i++)
   {
        SpaceObject o = spaceObjects.get(i);
        o.update();
        o.show();
        if(o.box.isCollidingWith(playerRocket1.box))
        {
          collider = 1;
          handleCollision(o,playerRocket1);
        }
        if(inMultiplayer)
        {
          if(o.box.isCollidingWith(playerRocket2.box))
          {
            collider = 2;
            handleCollision(o,playerRocket2);
          }
        }
        collider =0;
       if(o.isOffScreen())
        {
           setLane(o);
        }
      }
}

void resetObjects()
{
  for(int i = 0; i < spaceObjects.size(); i++)
      {
        SpaceObject o = spaceObjects.get(i);
        setLane(o);
      }
}

void setLane(SpaceObject o)
{
     float lane = int(random(laneCount));
      while(lastLane == lane)
      {
        lane = int(random(1,laneCount));
      }
      lastLane = int(lane);
      float laneX = (lane/laneCount)*width+50;
      float laneY = height*3 + ((lane/5)*height);
      //println(laneY);
      o.setPosition(laneX,random(height,laneY));   
}

void handleCollision(SpaceObject o, Rocket r)
{
          if(o.getTag()=="obstacle")
          {
            if(!r.inImmunity)
             {
              float laneY = height/2.5;
              r.pos.y -=(laneY*(1/r.recoverForce.y));
              crashSound.play();
              r.inImmunity = true;
              setLane(o);
             }
          }
          if(o.getTag()=="collectable")
          {
            candyCollect.play();
            if(collider ==1)
              candy1++;
            else if(collider ==2)
              candy2++;
            setLane(o);
          }
          if(o.getTag()=="collectable_2")
          {
            candyCollect.play();
            flipExistence(true);
            /*if(collider ==1)
              candy1++;
            else if(collider ==2)
              candy2++;
            setLane(o);*/
          }
}

void displayBackground()
{
  imageMode(CENTER);
  tint(255,100,100);
  image(frame1,backPos1.x,backPos1.y,width,height/2);
  image(frame2,backPos2.x,backPos2.y,width,height/2);
  image(frame3,backPos3.x,backPos3.y,width,height/2);
  tint(255,255,255);
  backPos1.y-=2;
  backPos2.y-=2;
  backPos3.y-=2;
  if(imageIndex ==5)
  {
    imageIndex = 0;
  }
  if(backPos1.y<=(-height/4))
  {
   frame1 = backImages[imageIndex];
   backPos1.y = height+(height/4);
   imageIndex++;
  }
   if(backPos2.y<=(-height/4))
  {
   frame2 = backImages[imageIndex];
   backPos2.y = height+(height/4);
   imageIndex++;
  }
   if(backPos3.y<=(-height/4))
  {
   frame3 = backImages[imageIndex];
   backPos3.y = height+(height/4);
   imageIndex++;
  }
}

void flipExistence(boolean upsidedown)
{
  if(upsidedown)
  {
    for(int i = 0; i < spaceObjects.size(); i++)
    {
        SpaceObject o = spaceObjects.get(i);
        
        PImage im;
        float n = random(10);
        if(n <=3)
        {
          im = loadImage("rocket1.png");
        }
        else if(n<=6)
        {
          im = loadImage("rocket2.png");
        }
        else
        {
          im = loadImage("rocket3.png");
        }
        o.setImage(im);
        setLane(o);
    }
    //playerRocket1
  }
}