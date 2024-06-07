class Platform 
{
  float x, y, width, height;
  PImage platformImage = loadImage("platform.png");
  
  Platform(float x, float y, float width, float height) 
  {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  void display() 
  {
    fill(255);
    image(platformImage, x, y, width, height);
  }
}