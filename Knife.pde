class Knife {
    PVector position;
    float speed;

    Knife(float x, float y, float speed) {
        this.position = new PVector(x, y);
        this.speed = speed;
    }

    void update() {
        position.x -= speed;
    }

    void display() {
        fill(255, 0, 0);
        rect(position.x, position.y, 40, 10);
    }

    boolean isOffScreen() {
        return position.x < -100;
    }
}