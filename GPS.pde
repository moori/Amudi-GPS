/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */

import processing.serial.*;
import ddf.minim.*;

Minim minim;
AudioPlayer sample_ch1;
AudioPlayer sample_ch2;
AudioPlayer fundo;

Serial myPort;  // Create object from Serial class
      // Data received from the serial port

char[] array = new char[500];
String latmax;
String longmax;
String latmin;
String longmin;
String lat;
String lg;
String fix;
float key_lat=0;
float key_lg=0;
int res=10;
float pt_lat;
float pt_lg;
PFont font;
String frase;
int ido=0;
PrintWriter output;
  
void setup() 
{
  size(1000, 600);
  // I know that the first port in the serial list on my mac
  // is always my FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 4800);
  latmax="0";
  longmax="0";
  latmin= "9999999999999";
  longmin="999999999999";
  
  font = loadFont("Helvetica-20.vlw");
  textFont(font, 20);
  textMode(SCREEN);
  minim = new Minim(this);
  sample_ch1 = minim.loadFile("03.gregoriano 1.aif", 512);
  sample_ch2 = minim.loadFile("03.gregoriano 1.aif", 512);
  fundo = minim.loadFile("bg paul.aif", 512);
  fundo.loop();
  
  (new Thread(){public void run(){vai();}}).start();
  background(198);
  output = createWriter("positions.txt"); 
}

char safeRead(){
  while (myPort.available() <= 0);
  return char(myPort.read());
}

boolean dpr(float x1, float x2, float y1, float y2, float pt_lg, float pt_lat){
  float m;
  
  
    m = (y1-y2)/(x1-x2);
    float a=1;
    float b=-1/m;
    float c=((-x1)+(y1/m));
    float d= abs((a*pt_lg)+(b*pt_lat)+(c))/sqrt((sq(a))+(sq(b)));
    println("DISTANCIA "+d);
    return (d < 100);
  }


boolean dpp(float x1, float x2, float y1, float y2, float pt_lg, float pt_lat){
  
  
    float d = sqrt(sq(x1-x2)+sq(y1-y2));
    float d1 = sqrt(sq(pt_lg-x1)+sq(pt_lat-y1));
    float d2 = sqrt(sq(pt_lg-x2)+sq(pt_lat-y2));
    
    if(d1>d || d2>d){return false;}
    else {return true;}
  }
  


boolean caixa(float x1, float x2, float y1, float y2, String px, String py){
  if(px == null || py == null){
    println("ARGH!");
    return false;
  }
  else{
    float plg = parseFloat(px);
    float plat = parseFloat(py);
    float tmp;
    if(x1 > x2){
      tmp = x2;
      x2 = x1;
      x1 = tmp;
    }
    if(y1 > y2){
      tmp = y2;
      y2 = y1;
      y1 = tmp;
    }
    return (plg > x1 && plg < x2 && plat > y1 && plat < y2);
  }
}

boolean inTheZone(float x1, float x2, float y1, float y2, float pt_lg, float pt_lat) {
  boolean cx = dpp(x1,x2,y1,y2,pt_lg,pt_lat);
  boolean dp = dpr(x1,x2,y1,y2,pt_lg,pt_lat);
  println("caixa: "+cx +" dpr: " + dp);
  return ( cx && dp );
}


void vai() { 
  char val;
  int pos;
  
  val = safeRead();
  while(true){
    while(val != '$') val = safeRead();
    pos = 0;
    while(pos < 5){
      array[pos++] = val = safeRead();
    }
    String palavra = new String(array,0,5);
  
    if(palavra.equals("GPGGA")){
      while(val != '$') array[pos++] = val = safeRead();
      array[pos] = '\0';
      String frase = new String(array);
      String[] graz = frase.split(",");
      
      println(frase);
      output.println(graz[2]+" "+graz[3]+" "+graz[4]+" "+graz[5]);
      lat=graz[2].substring(2);
      lg=graz[4].substring(3);
      fix=graz[7];
      pt_lat = (parseFloat(lat)*10000) + key_lat;
      pt_lg = (parseFloat(lg)*10000) + key_lg;
      
      //if(lat.compareTo(latmin) < 0) latmin = lat;
      //if(lat.compareTo(latmax) > 0) latmax = lat;
      //if(lg.compareTo(longmax) > 0) longmax = lg; 
      //if(lg.compareTo(longmin) < 0) longmin = lg;
      area(404050, 403533, 333197, 333388, pt_lg,pt_lat,"Quantic - Watusi.mp3",1);//clinicas
      area(397222, 396772, 334027, 334423, pt_lg,pt_lat,"vox1.wav",2);// bela cintra e hadock lobo
      area(396620, 396432, 334530, 334698, pt_lg,pt_lat,"meu sistema nervoso.wav",1);// haddock e banco safra
      area(397072, 396568, 333910, 334362, pt_lg,pt_lat,"deu uma hora.wav",2);// igreja gonzaga e banco panamericano
      
      area(386545, 387810, 342710, 341728, pt_lg,pt_lat,"03.gregoriano 1.aif",1);// Praça oswaldo cruz - rua Teixeira da silva
      area(387896, 388343, 341663, 341318, pt_lg,pt_lat,"04.guarany base.aif",2);// Rua Teixeira da Silva - Maria Figueredo
      area(388410, 389330, 341272, 340566, pt_lg,pt_lat,"12. sargento granular.aif",1);// Maria Figueredo - Brg Luis Antonio
      area(389420, 390401, 340493, 339678, pt_lg,pt_lat,"24. continuo nu.aif",2);// Brg Luis Antonio - Al Joaquim eungenio da lima
      area(390492, 391288, 339605, 338940, pt_lg,pt_lat,"25.meu sistema nervoso.aif",1);// Al Joaquim eugenio da lima - Al Campinas
      area(391380, 392153, 338865, 338220, pt_lg,pt_lat,"my white bicycle.aif",2);// Al Campinas - Rua Pamplona
      area(392153, 392460, 338220, 338135, pt_lg,pt_lat,"bienal todos pianos.aif",1);// Rua Pamplona - Al Flores
      area(392460, 392912, 338135, 337555, pt_lg,pt_lat,"gliss japa.aif",2);// Al Flores - Itapeva
      area(393047, 393413, 337487, 337193, pt_lg,pt_lat,"Dumont Adams.aif",1);// Itapeva - Prof Otavio Mendes
      area(393478, 393853, 337140, 336813, pt_lg,pt_lat,"god save the queen 2.aif",2);// Prof Otavio Mendes - MASP
      //area(393400, 394163, 336765, 336532, pt_lg,pt_lat,"deu uma hora.wav",1);// MASP - Peixoto Gomide
      //area(394248, 394730, 336455, 336018, pt_lg,pt_lat,"deu uma hora.wav",2);// Peixoto Gomide - Min Rocha Azevedo
      //area(394830, 395292, 335930, 335522, pt_lg,pt_lat,"deu uma hora.wav",1);// Min Rocha Azevedo - Frei Caneca
    }
    redraw();
  }
}
void area(float x1, float x2, float y1, float y2, float pt_lg, float pt_lat, String music_name, int ch)
{
  switch(ch){
    case 1:
  if(inTheZone(x1,x2,y1,y2,pt_lg,pt_lat)){
        if(!sample_ch1.isPlaying()){
          sample_ch1 = minim.loadFile(music_name, 512);
          sample_ch1.rewind();
          sample_ch1.play();
          output.println("In THa ZONE!");
        }
      }
 
      break;
      
      case 2:     
  if(inTheZone(x1,x2,y1,y2,pt_lg,pt_lat)){
        if(!sample_ch2.isPlaying()){
          sample_ch2 = minim.loadFile(music_name, 512);
          sample_ch2.rewind();
          sample_ch2.play();
          output.println("In THa ZONE!");
        }
      }
 
      
      break;
  }
  
}

void draw() {
  background(198);
  fill(100);
  strokeWeight(1);
  text(lat+" S "+lg+" W", 5, 100);
  text("Fixos: " + fix,5, 150);
  draw_regiao(404050, 403533, 333197, 333388, pt_lg,pt_lat,255);
  draw_regiao(397222, 396772, 334027, 334423, pt_lg,pt_lat,255);// bela cintra hadock lobo
  draw_regiao(396620, 396432, 334530, 334698, pt_lg,pt_lat,255);// haddock banco safra
  draw_regiao(397072, 396568, 333910, 334362, pt_lg,pt_lat,255);// igreja gonzaga e banco panamericano
  
  draw_regiao(386545, 387810, 342710, 341728, pt_lg,pt_lat,255);// Praça oswaldo cruz - rua Teixeira da silva
  draw_regiao(387896, 388343, 341663, 341318, pt_lg,pt_lat,155);// Rua Teixeira da Silva - Maria Figueredo
  draw_regiao(388410, 389330, 341272, 340566, pt_lg,pt_lat,255);// Maria Figueredo - Brg Luis Antonio
  draw_regiao(389420, 390401, 340493, 339678, pt_lg,pt_lat,155);// Brg Luis Antonio - Al Joaquim eungenio da lima
  draw_regiao(390492, 391288, 339605, 338940, pt_lg,pt_lat,255);// Al Joaquim eugenio da lima - Al Campinas
  draw_regiao(391380, 392153, 338865, 338220, pt_lg,pt_lat,155);// Al Campinas - Rua Pamplona
  draw_regiao(392153, 392460, 338220, 337955, pt_lg,pt_lat,255);// Rua Pamplona - Al Flores
  draw_regiao(392460, 392912, 337955, 337555, pt_lg,pt_lat,155);// Al Flores - Itapeva
  draw_regiao(393047, 393413, 337487, 337193, pt_lg,pt_lat,255);// Itapeva - Prof Otavio Mendes
  draw_regiao(393478, 393853, 337140, 336813, pt_lg,pt_lat,155);// Prof Otavio Mendes - MASP
  //draw_regiao(393400, 394163, 336765, 336532, pt_lg,pt_lat,255);// MASP - Peixoto Gomide
  //draw_regiao(394248, 394730, 336455, 336018, pt_lg,pt_lat,155);// Peixoto Gomide - Min Rocha Azevedo
  //draw_regiao(394830, 395292, 335930, 335522, pt_lg,pt_lat,255);// Min Rocha Azevedo - Frei Caneca
  fill(0,0,0);
  noStroke();
  ellipse(width/2, height/2, 2, 2);

}

void draw_regiao(float x1, float x2, float y1,float y2,float pt_lg,float pt_lat, int cor)
{
  x1=width-x1;
  x2=width-x2;
  pt_lg=width-pt_lg;
  fill(cor,0,255-cor);
  stroke(cor,0,255-cor);
  strokeWeight(1);
  ellipse( (x1 - (pt_lg))/res+(width/2), (y1 - (pt_lat))/res+(height/2), 4, 4);
  ellipse( (x2 - (pt_lg))/res+(width/2), (y2 - (pt_lat))/res+(height/2), 4, 4);
  noFill();
  ellipse( (x1 - (pt_lg))/res+(width/2), (y1 - (pt_lat))/res+(height/2), (sqrt(sq((x1-x2))+sq((y1-y2)))*2)/res , (sqrt(sq((x1-x2))+sq((y1-y2)))*2)/res  );
  ellipse( (x2 - (pt_lg))/res+(width/2), (y2 - (pt_lat))/res+(height/2), (sqrt(sq((x1-x2))+sq((y1-y2)))*2)/res , (sqrt(sq((x1-x2))+sq((y1-y2)))*2)/res  );
  strokeWeight(20);
  line((x1 - (pt_lg))/res+(width/2),(y1 - (pt_lat))/res+(height/2),(x2 - (pt_lg))/res+(width/2),(y2 - (pt_lat))/res+(height/2));
}

void keyPressed() {
  if(keyCode == ENTER){
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    sample_ch1.close();
    sample_ch2.close();
    minim.stop();
    exit(); // Stops the program
  }
  if(keyCode == UP) {res=res/10;}
  if(res<=0){res=1;}
  if(keyCode == DOWN) {res=res*10;}
  if(keyCode == 'W') { key_lat=key_lat-res;}
  if(keyCode == 'X') { key_lat=key_lat+res;}
  if(keyCode == 'A') { key_lg=key_lg+res;}
  if(keyCode == 'D') { key_lg=key_lg-res;}
  if(keyCode == 'S') { key_lat=10; key_lg=10;}
}
