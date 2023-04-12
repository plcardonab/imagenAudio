//Importación de la librería de Audio
import processing.sound.*;

// A Sample object (for a sound)
SoundFile song1;
SoundFile song2;
SoundFile song3;
SoundFile song4;

Amplitude analyzer;

// Estrellas
int NUM_STARS = 50;
ArrayList<Star> stars = new ArrayList<Star>();

// Si hay algún par de círculos rotando actualmente

boolean cur_rotating = false;

int circleId1;
int circleId2;

// Par de círculos que rotó anteriormente

int prevCircleId1;
int prevCircleId2;

// Numero de circulos a dibujar

int num_circles = 12;

// Radio inicial

float radio = 200;

// Se inicializan los colores

int saturation = 60;
int brightness = 80;

float [] colors = new float[num_circles];

int colorsIterator = 0;

// Se crea la lista donde se guardaran los circulos

ArrayList <CircleItem> items = new ArrayList <CircleItem> ();

// Se crea la lista donde se guardaran las orbitas

ArrayList <OrbitItem> orbitItems = new ArrayList <OrbitItem> ();

int [][] posicionesIniciales = new int[num_circles][];

// Numero de pasos para dar la vuelta para cada par de circulos

int steps = 180;

// Velocidad de movimiento

float speed = 0;

// Parametros para la circunferencia que se dibuja al fondo

float centroX = 0;
float centroY = 0;
float diametro = 0;

int checkDescuadre = 0;
int checkDescuadre1 = 0;

// Para la traslacion del sistema
int centerXTranslate;
int centerYTranslate;

int circle_size = 40;

int bound_min;
int bound_max;

void setup() {
  
  song1 = new SoundFile(this, "peaches_loud.wav");
  song1.loop();
  
  song2 = new SoundFile(this, "533847__tosha73__distortion-guitar-power-chord-e.wav");
  song2.loop();
  
  song3 = new SoundFile(this, "KickFilter.wav");
  song3.loop(); 
  
  song4 = new SoundFile(this, "breathy-vocal-yo.wav");
  song4.loop(); 
  
   // create a new Amplitude analyzer
  analyzer = new Amplitude(this);

  // Patch the input to an volume analyzer
  analyzer.input(song2);
  
  // Cambio modo de color
  
  colorMode(HSB, 360, 100, 100);
  
  size(800, 800, P2D);
  
  // Creacion estrellas
  
  for (int i = 0; i < NUM_STARS; i++) {
        
        stars.add(new Star(noise(width), noise(height)));
  }
  
  // Creacion de los colores
  
  for (int i=0; i < num_circles; i++) {
    colors[i] = int(random(0, 359));
  }
  
  // Creacion circulos
  
  int counterPos = 0;
  
  for(int i=0; i < 360 ; i += int(360/num_circles)){
            
    int xPos = int(radio*cos(i*(PI/180)));
    int yPos = int(radio*sin(i*(PI/180)));
    
    int[] temp = new int[] {xPos, yPos};
            
    posicionesIniciales[counterPos] = (temp);
    
    counterPos++;
        
    CircleItem ci = new CircleItem(xPos, yPos, colors[(colorsIterator)%colors.length]+1-1);
    
    colorsIterator++;
    
  }
  
  frameRate(100);
  
  centerXTranslate = width/2;
  centerYTranslate = height/2;
  
  bound_min = int(radio) + circle_size;
  bound_max = width - int(radio) - circle_size;

}

boolean playing1 = true;
boolean playing2 = true;
boolean playing3 = true;
boolean playing4 = true;

void draw() {
  
  background(0);
  
  // Parte del centro
  
  float acc = map(mouseX, 0, width, 0.005f, 0.2f);
  
  if (playing4 == true) {
    
    for (Star star : stars) {
        
        star.corre();
        star.update(acc);
    }
    
    stars.removeIf(star -> !star.is_active());
    
    while (stars.size() < NUM_STARS) {
        
        stars.add(new Star(random(width), random(height)));
    }
  }
  
  translate(centerXTranslate, centerYTranslate);
  
  if (mousePressed == true && playing1 == true){
        
    if (mouseX > bound_min && mouseX < bound_max){

      centerXTranslate = mouseX;
      
    }
    
    if (mouseY > bound_min && mouseY < bound_max){

      centerYTranslate = mouseY;
      
    }  
    
  }
  
  // Si no hay nada rotando actualmente
  
  if (cur_rotating == false && playing3 == true){
    
     float temp = random(0, 1);
      
      speed = steps/1.5;
  
    
    checkDescuadre ++;
    checkDescuadre1 ++;

    
    // Escoge que par de circulos van a rotar
        
    circleId1 = int(random(0, num_circles));
    circleId2 = int(random(0, num_circles));
        
    while (
        // Si son el mismo
        circleId2 == circleId1
        // O si son los opuestos
        //|| (num_circles%2 == 0 && num_circles != 2 && abs(circleId1-circleId2) == int(num_circles/2))
        // O si son el par anterior
        || ((circleId1 == prevCircleId1 && circleId2 == prevCircleId2) || (circleId1 == prevCircleId2 && circleId2 == prevCircleId1))
      ){

      circleId1 = int(random(0, num_circles));
      circleId2 = int(random(0, num_circles));
      
    }
        
    CircleItem circle1 = items.get(circleId1);
    CircleItem circle2 = items.get(circleId2);
    
    while (num_circles%2 == 0 && num_circles != 2
      && (abs(circle1.posicion-circle2.posicion) == int(num_circles/2)-1
          || abs(circle1.posicion-circle2.posicion) == int(num_circles/2)
          || abs(circle1.posicion-circle2.posicion) == int(num_circles/2)+1)){
            
      circleId1 = int(random(0, num_circles));
      circleId2 = int(random(0, num_circles));
      
      circle1 = items.get(circleId1);
      circle2 = items.get(circleId2);
    
    }
    
    // Asigna el centro y diametro de la orbita en la que van a rotar
            
    centroX = (circle1.xPos + circle2.xPos)/2;
    centroY = (circle1.yPos + circle2.yPos)/2;
    diametro = dist(circle1.xPos, circle1.yPos, circle2.xPos, circle2.yPos);
    
    // Asigna el tono promedio entre los dos circulos
    
    float hue = (circle1.c + circle2.c) / 2;
    
    // Crea la orbita
    
    OrbitItem orbit = new OrbitItem(centroX, centroY, diametro, hue);
    
    circle1.setFinal(centroX, centroY, circle2.c);
    circle2.setFinal(centroX, centroY, circle1.c);
    
     // Reproduce el sonido de la orbita
   
    
    // Activa la rotacion
    
        
    cur_rotating = true;
    
    
  }
  
  // Cuando haya rotacion
  
  if (cur_rotating == true){
    
    CircleItem circle1 = items.get(circleId1);
    CircleItem circle2 = items.get(circleId2);
    
    // Actualiza los circulos
    
    circle1.actualiza();
    circle2.actualiza();
    
    // Cambia el alpha de las orbitas
    OrbitItem orbit = orbitItems.get(orbitItems.size()-1);
    orbit.changeOpacity();
    
    orbit.changeVolume();
    
    // Si ya termino la rotacion, escoge otro par de circulos
    
    if (circle1.check == false && circle2.check == false){
      
      prevCircleId1 = circleId1;
      prevCircleId2 = circleId2;
            
      cur_rotating = false;
      delay(steps);
      
      // Elimina la orbita
      
      orbitItems.remove(orbitItems.size()-1);
      
    }
    
  }
  
  for (CircleItem item : items){
    
    item.display();
    
  }
  
  for (OrbitItem item : orbitItems){
    
    item.display();
    
  }
  
  // Set the volume to a range between 0 and 1.0
  float volume = map(centerXTranslate, bound_min, bound_max, 0, 1);
  song1.amp(volume);

  // Set the rate to a range between 0.1 and 4
  // Changing the rate alters the pitchf
  float speed = 2 - map(centerYTranslate, bound_min, bound_max, 0, 1.5);
  
  song1.rate(speed);
  
  // Set the volume to a range between 0 and 1.0
  
  if (mousePressed == false){
    
    float volume4 = map(mouseX, 0, width, 0, 1);
    song4.amp(volume4);
    
  }
  
}

boolean on_screen(float x, float y) {
    
    return x >= 0 && x <= width && y >= 0 && y <= height;
}

void keyPressed() {
  
  if (key == 'a' || key == 'A'){
    
    if (playing1) {
      song1.stop();
      playing1 = false;
    }
    else {
      song1.loop();
      playing1 = true;
    }
    
  }
  
  if (key == 's' || key == 'S'){
    
    if (playing2) {
      song2.stop();
      playing2 = false;
    }
    else {
      song2.loop();
      playing2 = true;
    }
    
  }
  
  if (key == 'd' || key == 'D'){
    
    if (playing3) {
      song3.stop();
      playing3 = false;
    }
    else {
      song3.loop();
      playing3 = true;
    }
    
  }
  
  if (key == 'w' || key == 'W'){
    
    if (playing4) {
      song4.stop();
      playing4 = false;
    }
    else {
      song4.loop();
      playing4 = true;
    }
    
  }
}
