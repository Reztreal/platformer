boolean[] keys = new boolean[128];
boolean spacePressed = false;

class Player {
    Animation run, idle, up, down;
    PVector position;
    PVector velocity;

    PVector topLeft, topRight, bottomLeft, bottomRight;

    State currentState;
    IdleState idleState;
    JumpState jumpState;
    RunState runState;

    Animation currentAnimation;

    int direction = 1;
    boolean gravityReverse = false;
    int gravityCooldown = 100;
    long lastGravityReverseTime = 0;

    float gravity = 0.5;
    float jumpForce = -15;
    boolean isGrounded = true;

    int width = 55, height = 80;
    int xOffset = 60, yOffset = 55;
    
    Player(float x, float y) 
    {
        position = new PVector(x, y);
        velocity = new PVector(0, 0);

        topLeft = new PVector(position.x + xOffset, position.y + yOffset);
        topRight = new PVector(position.x + xOffset + width, position.y + yOffset);
        bottomLeft = new PVector(position.x + xOffset, position.y + yOffset + height);
        bottomRight = new PVector(position.x + xOffset + width, position.y + yOffset + height);

        run = new Animation("./CharacterAnimations/run.png", 8, 80, 5, 5);
        idle = new Animation("./CharacterAnimations/idle.png", 6, 100, 5, 5);
        up = new Animation("./CharacterAnimations/up.png", 6, 100, 5, 5);
        down = new Animation("./CharacterAnimations/down.png", 6, 100, 5, 5);

        currentAnimation = idle;
        currentState = idleState = new IdleState();
        jumpState = new JumpState();
        runState = new RunState();
    }

    void update()
    {
        handleInput();
        applyGravity();

        position.add(velocity);

        updateBoundingBox();

        if (currentState.isComplete)
        {
            selectState();
        }
        currentState.Execute();
    }

    void selectState()
    {
        if (isGrounded)
        {
            if (velocity.x == 0)
            {
                currentState = idleState;
            }
            else
            {
                currentState = runState;
            }
        }
        else
        {
            currentState = jumpState;
        }
        currentState.Enter();
    }

    void display()
    {
        pushMatrix();
            if (direction == -1)
            {
                translate(position.x + 175, position.y);
                scale(direction, 1);
                if (gravityReverse) {
                    scale(1, -1);
                    currentAnimation.display(0, -200);
                } else {
                    scale(1, 1);
                    currentAnimation.display(0, 0);
                }
            }
            else if (direction == 1)
            {
                translate(position.x, position.y);
                scale(direction, 1);
                if (gravityReverse) {
                    scale(1, -1);
                    currentAnimation.display(0, -200);
                } else {
                    scale(1, 1);
                    currentAnimation.display(0, 0);
                }
            }


        popMatrix();
       
        //noFill();
        //stroke(255);
        //rect(topLeft.x, topLeft.y, width, height);
        //ellipse(topLeft.x + 30, topLeft.y + 40, 10, 10);
    }

    void updateBoundingBox()
    {
        topLeft.x = position.x + xOffset; topLeft.y = position.y + yOffset;
        topRight.x = position.x + xOffset + width; topRight.y = position.y + yOffset;
        bottomLeft.x = position.x + xOffset; bottomLeft.y = position.y + yOffset + height;
        bottomRight.x = position.x + xOffset + width; bottomRight.y = position.y + yOffset + height;
    }


    boolean checkCollision(Platform p)
    {
        return !(topLeft.x > p.x + p.width ||
            topRight.x < p.x ||
            topLeft.y > p.y + p.height ||
            bottomLeft.y < p.y);
    }

    boolean checkCollisionNextFrame(Platform p)
    {
        PVector nextPosition = PVector.add(position, velocity);

        float nextTopLeftX = nextPosition.x + xOffset;
        float nextTopLeftY = nextPosition.y + yOffset;
        float nextTopRightX = nextTopLeftX + width;
        float nextBottomLeftY = nextTopLeftY + height;

        return !(nextTopLeftX > p.x + p.width ||
                 nextTopRightX < p.x ||
                 nextTopLeftY > p.y + p.height ||
                 nextBottomLeftY < p.y);
    }

    void handleInput()
    {
        if (keyPressed)
        {
            if (keys['w'] && isGrounded)
            {
                velocity.y = gravityReverse ? -jumpForce : jumpForce;
                isGrounded = false;
            }
            if (keys['a'])
            {
                direction = -1;
                velocity.x = -10;
            }
            if (keys['d'])
            {
                direction = 1;
                velocity.x = 10;
            }
            if (keys[' '] && !spacePressed)
            {
                isGrounded = false;
                velocity.y = 0;
                gravityReverse = !gravityReverse;
                spacePressed = true;
            }
        }
        else
        {
            velocity.x = 0;
            if (!keys[' '])
            {
                spacePressed = false;
            }
        }
    }

    void applyGravity()
    {
        if (!isGrounded)
        {
            velocity.y += gravityReverse ? -gravity : gravity;
        }
        else
        {
            velocity.y = 0;
        }

    }
    
}

void keyPressed()
{
    if (key < 128) {
        keys[key] = true;
    }
}

void keyReleased()
{
    if (key < 128) {
        keys[key] = false;
    }
}
