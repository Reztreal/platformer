class Animation
{
    PImage img;
    int frameCount, frameWidth, frameHeight, frameDuration, displayWidth, displayHeight;
    int frameIndex = 0;
    int lastFrameChangeTime = 0;


    /**
     * Constructs an Animator with the specified image path, frame count, frame duration,
     * and scaling multipliers for width and height.
     *
     * @param image_path The path to the sprite sheet image.
     * @param frameCount The number of frames in the sprite sheet.
     * @param frameDuration The duration each frame is displayed in milliseconds.
     * @param widthMultiplier The factor by which to scale the width of each frame.
     * @param heightMultiplier The factor by which to scale the height of each frame.
     */
    Animation(String image_path, int frameCount, int frameDuration, int widthMultiplier, int heightMultiplier)
    {
        img = loadImage(image_path);
        this.frameCount = frameCount;
        this.frameWidth = img.width / frameCount;
        this.frameHeight = img.height;
        this.frameDuration = frameDuration;
        this.displayWidth = frameWidth * widthMultiplier;
        this.displayHeight = frameHeight * heightMultiplier;
    }

    /**
     * Displays the current frame of the animation at the specified coordinates.
     *
     * @param x The x-coordinate where the frame should be displayed.
     * @param y The y-coordinate where the frame should be displayed.
     */
    void display(float x, float y)
    {       
        if (millis() - lastFrameChangeTime > frameDuration)
        {
            frameIndex = (frameIndex + 1) % frameCount;
            lastFrameChangeTime = millis();
        }

        int frameX = frameIndex * frameWidth;
        image(img, x, y, displayWidth, displayHeight, frameX, 0, frameX + frameWidth, frameHeight);
    }
}