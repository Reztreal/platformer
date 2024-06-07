class Button {
    float x, y, width, height;
    String label;

    Button(float x, float y, float width, float height, String label) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.label = label;
    }

    void display() {
        fill(253, 255, 226, 0);
        noStroke();
        rect(x, y, width, height);
    }

    boolean isClicked(float mx, float my) {
        return mx > x && mx < x + width && my > y && my < y + height;
    }
}
