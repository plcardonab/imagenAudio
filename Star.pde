class Star {

    PVector pos;
    PVector prev_pos;
    PVector vel;
    float ang;
    
    Star(float x, float y) {
        
        pos = new PVector(x, y);
        prev_pos = new PVector(x, y);
        vel = new PVector(0, 0);
        ang = atan2(y - (height/2), x - (width/2));
    }
    
    boolean is_active() {
        
        return on_screen(prev_pos.x, prev_pos.y);
    }
    
    void update(float acc) {
        
        vel.x += cos(ang) * acc;
        vel.y += sin(ang) * acc;
        
        prev_pos.x = pos.x;
        prev_pos.y = pos.y;
        
        pos.x += vel.x;
        pos.y += vel.y;
    }
    
    void corre() {
      
        stroke(random(255), random(255), random(255));
        strokeWeight(3);
        line(pos.x, pos.y, prev_pos.x, prev_pos.y);
    }
}
