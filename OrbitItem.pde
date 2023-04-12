public class OrbitItem{
  
  public float centroX = 0;
  public float centroY = 0;
  public float radio = 0;
  
  public float hue = 0;
  
  public float saltoS = 0;
  
  public float sat = 0;
  
  public float alpha = 0;
  public float alphaChange = 512 / (speed);
  
  public float volume = 0;
  public float volumeChange = 2 / (speed);
    
  public OrbitItem(float centroX, float centroY, float radio, float hue){
    
    this.centroX = centroX;
    this.centroY = centroY;
    this.radio = radio;
    
    this.hue = hue;
    
    this.saltoS = float(saturation) / (speed);
    
    orbitItems.add(this);
    
  }
  
  public void changeOpacity() {
    
    this.alpha += this.alphaChange;
    
    if (this.alpha > 255 || this.alpha < 0) {
      this.alphaChange *= -1;
      
    }
    
  }
  
  public void changeVolume() {
    this.volume += this.volumeChange;
    
    if (this.volume > 1 || this.volume < 0) {
      this.volumeChange *= -1;
    }
    
    song3.amp(this.volume);
  }
  
  public void display(){
    
    this.sat += this.saltoS;
        
    strokeWeight(3);
    stroke(this.hue, this.sat, brightness, this.alpha);
    noFill();
        
    circle(centroX, centroY, radio);
    
    noStroke();
  
  }
}
