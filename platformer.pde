import processing.data.JSONObject;
import processing.data.JSONArray;

final int stateWelcome = 0;
final int stateGame = 1;
final int stateGameOver = 2;

int gameState = stateWelcome;

int currentLevel = 0;
String[] levels = {"level4.json", "level1.json", "level2.json", "level3.json"};

Button startButton, restartButton;

int knifeSpawnInterval = 30;
int knifeSpawnCounter = 0;

PImage background;
PImage startBg, endBg;

Player player;
ArrayList<Platform> platforms = new ArrayList<Platform>();
ArrayList<Knife> knives = new ArrayList<Knife>();
PVector playerStart, endPoint;

float camX = 0, camY = 0;
float lerpFactor = 0.1f;

float tileSize = 2;

void setup() 
{
    size(1600, 900);
    noSmooth();

    background = loadImage("Background.png");
    startBg = loadImage("startBg.png");
    endBg = loadImage("endBg.png");

    startButton = new Button(width / 2 - 400, height / 2 - 410, 800, 150, "Start Game");
    restartButton = new Button(width / 2 - 200, height / 2 + 330, 410, 65, "Replay");
    
    loadLevelFromJSON("level1.json");
    
    player = new Player(playerStart.x, playerStart.y);

    camX = player.topLeft.x + 30;
    camY = player.topLeft.y + 40;
}

void draw() 
{
    switch (gameState) 
    {
        case stateWelcome:
            drawWelcome();
            break;
        case stateGame:
            drawGame();
            break;
        case stateGameOver:
            drawGameOver();
            break;
    }
}

void drawWelcome() 
{
    image(startBg, 0, 0, width, height);
    startButton.display();
}


void drawGame()
{
    background(0);

    player.update();

    float targetX = width / 2 - (player.topLeft.x + 30);
    float targetY = height / 2 - (player.topLeft.y + 40);

    camX = lerp(camX, targetX, lerpFactor);
    camY = lerp(camY, targetY, lerpFactor);

    pushMatrix();
    translate(camX, camY);

    boolean grounded = false;
    for (Platform p : platforms)
    {
        p.display();
        if (player.checkCollisionNextFrame(p))
        {
            if (!player.gravityReverse)
                player.position.y = p.y - 135;
            else    
                player.position.y = p.y - 3;
            grounded = true;
        }
    }

    player.display();
    player.isGrounded = grounded;

    fill(0, 255, 0);
    rect(endPoint.x, endPoint.y, 20, 20);

    PVector playerCenter = new PVector(player.topLeft.x + 30, player.topLeft.y + 40);

    if (playerCenter.dist(endPoint) < 40)
    {
        println("Level Complete!");
        currentLevel++;
        if (currentLevel < levels.length)
        {
            loadLevelFromJSON(levels[currentLevel]);
        }
        else
        {
            gameState = stateGameOver;
        }
    }

        if (currentLevel == 0)
        {
            fill(255);
            textSize(50);
            textAlign(CENTER);
            text("Move with W, A, D and REVERSE GRAVITY with SPACE", 100, height + 400);
        }
        
        if (currentLevel == 1) 
        {
            fill(255);
            textSize(50);
            textAlign(CENTER);
            text("Jump on platforms to reach the end normally or with reversed gravity!", 100, height - 300);
        }

        if (currentLevel == 3) 
        {
            fill(255);
            textSize(50);
            textAlign(CENTER);
            text("Avoid laser beams!", 100, height + 400);


            knifeSpawnCounter++;
            if (knifeSpawnCounter >= knifeSpawnInterval) 
            {
                float knifeY = random(player.topLeft.y - 300, player.topLeft.y + 300);
                knives.add(new Knife(player.topLeft.x + 400, knifeY, 5));
                knifeSpawnCounter = 0;
            }

            for (int i = knives.size() - 1; i >= 0; i--) 
            {
                Knife knife = knives.get(i);
                knife.update();
                knife.display();
                if (knife.isOffScreen()) 
                {
                    knives.remove(i);
                } 
                else if (checkKnifeCollision(knife)) 
                {
                    loadLevelFromJSON(levels[3]);
                    player.position.set(playerStart);
                    knives.clear();
                    break;
                }
            }
        }
    popMatrix();
}


void drawGameOver() 
{   
    knives.clear();
    image(endBg, 0, 0, width, height);
    restartButton.display();
}


void mousePressed()
{
    if (gameState == stateWelcome && startButton.isClicked(mouseX, mouseY))
    {
        gameState = stateGame;
        currentLevel = 0;
        loadLevelFromJSON(levels[currentLevel]);
        player.position.set(playerStart);
    }
    else if (gameState == stateGameOver && restartButton.isClicked(mouseX, mouseY))
    {
        gameState = stateGame;
        currentLevel = 0;
        loadLevelFromJSON(levels[currentLevel]);
        player.position.set(playerStart);
    }
}

void loadLevelFromJSON(String filePath) 
{
    JSONObject json = loadJSONObject(filePath);
    JSONArray layers = json.getJSONArray("layers");

    platforms.clear();

    for (int i = 0; i < layers.size(); i++) 
    {
        JSONObject layer = layers.getJSONObject(i);
        String layerType = layer.getString("type");

        if (layerType.equals("objectgroup")) 
        {
            JSONArray objects = layer.getJSONArray("objects");
            for (int j = 0; j < objects.size(); j++) 
            {
                JSONObject object = objects.getJSONObject(j);
                String name = object.getString("name");
                float x = object.getFloat("x");
                float y = object.getFloat("y");
                float width = object.getFloat("width");
                float height = object.getFloat("height");

                x *= tileSize;
                y *= tileSize;
                width = width * tileSize + 20;
                height = height * tileSize + 20;

                if (name.equals("Platform")) 
                {
                    platforms.add(new Platform(x, y, width, height));
                } 
                else if (name.equals("PlayerStart")) 
                {
                    playerStart = new PVector(x, y);
                } 
                else if (name.equals("EndPoint")) 
                {
                    endPoint = new PVector(x, y);
                }
            }
        }
        if (player != null) 
            player.position.set(playerStart.x, playerStart.y);
    }
}

boolean checkKnifeCollision(Knife knife) {
    float playerCenterX = player.topLeft.x + 30; 
    float playerCenterY = player.topLeft.y + 40;
    float knifeCenterX = knife.position.x + 20; 
    float knifeCenterY = knife.position.y + 5;
    float distance = dist(playerCenterX, playerCenterY, knifeCenterX, knifeCenterY);
    return distance < (20);
}
