class CircleItem{
    
  // Contador pasos
  
  public int counter = 0;
  
  // Posicion actual
  public int xPos = 0;
  public int yPos = 0;
    
  public float angulo = 0;
  
  // Centro orbita
  
  public float centroX = 0;
  public float centroY = 0;
  
  public float radio = 0;
  
  // Saltos
  
  public float saltoH = 0;
  
  // Colores
  
  private float c;
  private float cEnd;
  private float cInit;
  
  // Posicion actual del circulo
  
  private int posicion = 0;
  
  // Comprobante si ya hizo la transicion
  
  public boolean check = true;
  
  // Para dibujar cada circulo
  
  public CircleItem(int xPos, int yPos, float c){
        
    this.xPos = xPos;
    this.yPos = yPos;
    this.c = c+1-1;
    this.cInit = c+1-1;
    
    items.add(this);
    
    this.posicion = items.indexOf(this);
    
  }
  
  public void display(){
    
    float vol = analyzer.analyze();
    
    noStroke();
        
    fill(this.c, saturation, brightness);
    circle(this.xPos, this.yPos, 40 + vol*50);
    
  }
  
  public void setFinal(float centroX, float centroY, float new_c){    

    this.cEnd = new_c+1-1;
   
    this.centroX = centroX;
    this.centroY = centroY;
     
    this.angulo = atan2(this.yPos - this.centroY, this.xPos - this.centroX);
    
    this.radio = dist(this.xPos, this.yPos, this.centroX, this.centroY);
     
    this.check = true;
     
    this.saltoH = (this.cEnd - this.c) / (speed);
    
  }
  
  public void actualizaColor(){
    
    if (this.c != this.cEnd){
      
      if (this.c < this.cEnd && this.c + this.saltoH > this.cEnd) {
        this.c = this.cEnd;
      }
      
      else if (this.c > this.cEnd && this.c + this.saltoH < this.cEnd) {
        this.c = this.cEnd;
      }
      
      else {
        
        this.c += this.saltoH;
        
      }
      
    }
    
    //this.c = lerpColor(color(this.cInit, saturation, brightness), color(this.cEnd, saturation, brightness), this.counter*this.saltoH/100);
        
  }
  
  // Calcula la pos de X y Y actuales
  
  public void actualizaPosicion(){
    
    this.angulo += PI/speed;
            
    this.xPos = int(this.centroX + this.radio*cos(this.angulo));
    this.yPos = int(this.centroY + this.radio*sin(this.angulo));
    
  }
  
  public void actualiza(){
    
    this.actualizaColor();
    this.actualizaPosicion();
    
    this.counter ++;
    
    if (this.counter == speed){
            
      this.counter = 0;
      
      this.check = false;
      
      this.ajustaPosicion();
      
    }
    
  }
  
  public void ajustaPosicion(){
    
    int xCercano = this.xPos;
    
    int yCercano = this.yPos;
    
    float distCercana = radio;
    
    int indexCercano = 0;
      
    for (int i=0; i<posicionesIniciales.length; i++){
      
      float distActual = dist(this.xPos, this.yPos, posicionesIniciales[i][0], posicionesIniciales[i][1]);
      
      if (distActual < distCercana || distActual == 0){
        
        distCercana = distActual;
        
        xCercano = posicionesIniciales[i][0];
        yCercano = posicionesIniciales[i][1];
        
        indexCercano = i;
        
      }
    
    }
    
  this.xPos = xCercano;
  this.yPos = yCercano;
  
  this.posicion = indexCercano;
  
  }
  
}
