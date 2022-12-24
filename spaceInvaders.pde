import processing.sound.*;
SoundFile[] file;
int x;
Difficulty currentDifficulty = Difficulty.EASY;
Screen currentScreen = Screen.LANDING_PAGE;
HelpScreen helpScreen;
LandingScreen landingScreen;
int transitionFromEasyToMedium = 2 * 60 * 1000; //2 mins
int transitionFromMediumToHard = 3 * 60 * 1000; //3 mins
int transitionFromHardToVeryHard = 5 * 60 * 1000; //5 mins
int rocksDelay = 10 * 1000; //every x seconds rocks will be added
int rocksDelayInterval = 10 * 1000; // 10 seconds
boolean isFirstTimeRainingRocks = true;
int startTime = millis();
int rocksStartTime = millis();
int score = 0;
PImage img;
PImage backIcon;
PImage background;
PImage landingBackground;
ArrayList bullets=new ArrayList();
ArrayList rocks=new ArrayList();
boolean gameOver=false;
PFont font;
int bulletWidth=6;
int bulletHeight=12;

Player player;
void setup() {
  size(1000, 600);
  file = new SoundFile[24];
  file[0] = new SoundFile(this,"core/shot.wav");
  file[1] = new SoundFile(this,"core/rock.wav");
  file[2] = new SoundFile(this,"core/sound.wav");
  player = new Player();
  img = loadImage("core/space_ship.png");
  background = loadImage("core/background.jpg");
  backIcon = loadImage("core/back_icon.png");

  font = createFont("Arial", 36, true);

  helpScreen= new HelpScreen();
  landingScreen = new LandingScreen();
}


void addRocks() {
  int speed = 0;
  int numberOfRocks = 0;
  switch(currentDifficulty) {
  case EASY:
    {
      speed = int(random(0, 4));
      numberOfRocks = 10;
      rocksDelayInterval = 10;
      break;
    }
  case MEDUIM:
    {
      speed = int(random(0, 6));
      numberOfRocks = 15;
      rocksDelayInterval = 8;
      break;
    }
  case HARD:
    {
      speed = int(random(4, 8));
      numberOfRocks = 20;
      rocksDelayInterval = 6;
      break;
    }
  case VERY_HARD:
    {
      speed = int(random(0, 10));
      rocksDelayInterval = 4;
      numberOfRocks = 20;
      break;
    }
  }

  int currentTime = millis(); 
  if (isFirstTimeRainingRocks) {
    isFirstTimeRainingRocks = false;
    for (int i = 0; i < numberOfRocks; i++) {
      println("adding rocks " + numberOfRocks);
      rocks.add(new Rock(speed));
    }
  } else {
    if (currentTime - rocksStartTime >= rocksDelay) {
      for (int i = 0; i < numberOfRocks; i++) {
        println("adding rocks " + numberOfRocks);
        rocks.add(new Rock(speed));
      }
      rocksDelay += rocksDelayInterval;
      rocksStartTime = currentTime;
    }
  }
}


void checkDifficulty() {
  int currentTime = millis();
  if (currentTime - startTime >= transitionFromEasyToMedium && currentDifficulty == Difficulty.EASY) {
    currentDifficulty = Difficulty.MEDUIM;
    startTime = currentTime;
  } else if (currentTime - startTime >= transitionFromMediumToHard && currentDifficulty == Difficulty.MEDUIM) {
    currentDifficulty = Difficulty.HARD;
    startTime = currentTime;
  } else if (currentTime - startTime >= transitionFromHardToVeryHard && currentDifficulty == Difficulty.HARD) {
    currentDifficulty = Difficulty.VERY_HARD;
    startTime = currentTime;
  }
}

void resetGame() {
  rocks = new ArrayList();
  gameOver=false;
  score = 0;
}

void drawScore() {
  textFont(font);
  fill(255);
  text("Score: " + String.valueOf(score), 450, 50);
}
void draw() {
  switch (currentScreen) {
  case GAME_PAGE: 
    {

      showGamePage();
      break;
    }
  case HELP_PAGE: 
    {
      showHelpPage();
      break;
    }
  case LANDING_PAGE: 
    {
      showLandingPage();
      break;
    }
  case GAME_OVER_PAGE: 
    {
      showGamePage();
      break;
    }
  }
}

void showHelpPage() {
  helpScreen.drawHelpScreen();
}

void showLandingPage() {
  landingScreen.drawLandingScreen();
}

void showGamePage() {

  float xPlayer=min(max(mouseX-50, 0), 900);

  if (!gameOver) {
    background(0);   
    image(img, min(max(mouseX-50, 0), 900), 500, 100, 100);

    for (int i = 0; i < rocks.size(); i++) {

      Rock r = (Rock) rocks.get(i);

      if (!r.alive()) {
        rocks.remove(r);
        file[1].play();
      } else {
        r.move();
        r.display();
      }

      if (r.x+(r.rockWidth) >=xPlayer &&xPlayer >=r.x&&500<=r.y+(r.rockHeight/2)&&r.y+(r.rockHeight/2)<=600) {   
        gameOver=true;
        file[2].play();
      }
    }
      for (int i = 0; i < rocks.size(); i++) {

      Rock r = (Rock) rocks.get(i);

  
        r.move();
        r.display();
      
   
    }

    player.draw();
    drawScore();

    for (int i = 0; i < bullets.size(); i++) {
      Bullet bullet = (Bullet) bullets.get(i);
      bullet.draw();
    }
  } else {
    over();
  }

  addRocks();
  checkDifficulty();
  showBackButton();
}

void showBackButton() {

  image(backIcon, 25, 25, 35, 35);
  if (mousePressed) {
    if (mouseX>40 && mouseX <277 && mouseY>16 && mouseY <89) {
      resetGame();
      currentScreen = Screen.LANDING_PAGE;
    }
  }
}

class Player {
  boolean canShoot = true;
  int shootdelay = 0;

  Player() {
  }

  void draw() {

    if (mouseButton == LEFT && canShoot &&mousePressed  ) {


      bullets.add(new Bullet(min(max(mouseX-50, 0), 900)+50, 500));
      file[0].play();
      canShoot = false;
      shootdelay = 0;
    }

    shootdelay++;

    if (shootdelay >= 5) {
      canShoot = true;
    }
  }
}

class Bullet {
  int x, y;
  Bullet(int xPos, int yPos) {
    x=xPos;
    y=yPos;
  }
  void draw() {
    fill(255, 0, 0);
    rect(x, y, bulletWidth, bulletHeight);
    y-=20;
  }
}





void over() {
  background(0);
  textFont(font);
  fill(255);
  text("Game Over", x, height/2);
    x += 10;
    if (x > width) { 
    x = -200;  
  }
  text("Score : "+ String.valueOf(score), 450, 450);
}

class LandingScreen {

  float x1 = 400;
  float y1 = 275;
  float w = 200;
  float h = 30;
  float x2 = 400;
  float y2 = 315;
  float x3 = 400;
  float y3 = 355;
  PImage landingBackground;
  PFont font;


  LandingScreen() {
    landingBackground = loadImage("core/landing.jpg");
    font = createFont("Arial", 23, true);
  }

  void drawLandingScreen() {
    image(landingBackground, 0, 0, 1000, 600);
    fill(237, 158, 158);
    smooth();
    stroke(0);
    rect(x1, y1, w, h, 28);
    textFont(font);
    fill(255);
    text("Start", x1+75, y1+25);
    fill(237, 158, 158);
    smooth();
    stroke(0);
    rect(x2, y2, w, h, 28);
    textFont(font);
    fill(255);
    text("Help", x2+75, y2+25);
    fill(237, 158, 158);
    smooth();
    stroke(0);
    rect(x3, y3, w, h, 28);
    textFont(font);
    fill(255);
    text("Exit", x3+75, y3+25);
    if (mousePressed) {
      if (mouseX>x1 && mouseX <x1+w && mouseY>y1 && mouseY <y1+h) {
        currentScreen = Screen.GAME_PAGE;
      }
      if (mouseX>x2 && mouseX <x2+w && mouseY>y2 && mouseY <y2+h) {
        currentScreen = Screen.HELP_PAGE;
      }
      if (mouseX>x3 && mouseX <x3+w && mouseY>y3 && mouseY <y3+h) {
        exit();
        println("exit!");
      }
    }
  }
}
