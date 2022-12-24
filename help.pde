class HelpScreen {
  
  PImage rock;
  PImage mouse;
  PImage leftMouse;
  PImage backIcon;
  PImage bg;
  float x, y, x_step, y_step;

  HelpScreen() {
    x=random(width);
    y=random(height);
    x_step=1;
    y_step=1;
    rock = loadImage("core/rock.png");
    bg = loadImage("core/background.jpg");
    mouse = loadImage("core/mouse.png");
    leftMouse = loadImage("core/leftMouse.png");
    backIcon = loadImage("core/back_icon.png");
  }

  void drawHelpScreen() {

    if (x>=920) {
      x_step=-1;
    }
    if (x<=-20) {
      x_step=1;
    }
    if (y>=520) {
      y_step=-1;
    }
    if (y<=-20) {
      y_step=1;
    }
    x+=x_step;
    y+=y_step;

    background(bg);
    image(rock, x, y, 100, 100);
    textSize(36);
    text("Start your journey to the space ........", 200, 60);
    textSize(18);
    text("use mouse to move your ship right and left.", 200, 200);
    image(mouse, 600, 150, 100, 100);
    text("use mouse left cleck to fire.", 200, 300);
    image(leftMouse, 550, 250, 100, 100);
    text("if the rocks touches you then you are dead.", 200, 400);
    text("the more rocks you fire the more score you get.", 200, 500);
    
    showBackButton();
  }
  
  
void showBackButton() {

  image(backIcon,25,25,35,35);
  if (mousePressed) {
    if (mouseX>40 && mouseX <60 && mouseY>16 && mouseY <89) {
      currentScreen = Screen.LANDING_PAGE;
    }
  }
}

}
