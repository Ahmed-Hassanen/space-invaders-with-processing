class Rock {
  int life = 2;
  float rockWidth = random(100, 200);
  float rockHeight = random(100, 200);
  PImage rockImage;
  float x, y; //location of the rock
  float speed;
  color baseColor = color(255, 255, 255);
  color nextColor=baseColor;
  boolean alive() {
    nextColor = baseColor;

    for (int i = 0; i < bullets.size(); i++) {
      Bullet bullet = (Bullet) bullets.get(i);

      if (bullet.x +bulletWidth>= x && bullet.x <= x + (rockWidth) && bullet.y <= y+ (rockHeight/2) ) {
        nextColor = color(255, 0, 0);
        bullets.remove(i);

        life--;
        println(life);
        if (life == 0) {
          score += 50;
          return false;
        }

        break;
      }
    }

    return true;
  }


  Rock(int speed) {
    x = random(width);
    y = -rockHeight*4;
    this.speed = speed;
    rockImage = loadImage("core/rock.png");
  }


  void move() {
    if (y>700) {
      x = random(width);
      y = -rockHeight*4;
    } else {
      y += speed;
    }
  }


  void display() {
    tint(nextColor);
    image(rockImage, x, y, rockWidth, rockHeight);
  }
}
