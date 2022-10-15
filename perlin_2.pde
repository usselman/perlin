import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//PERLIN NOISE
//WRITTEN BY
//SHIRISH SARKAR

//building triangle strips
import ddf.minim.*;

float w8, h8;  // width, height div 8
float angle; 
float angleVel;
boolean rec = false;

boolean recording = false;

Minim minim;
AudioInput in;

float inc;
int col, row;
//scale
int scl = 20;

//og: 48, 38
int w = 2000;
int h = 1600;

int ascend = 1;
int position = 0;

float flying = 0;
float[][] audio;
float sensitivity = 15.8;

//gaussian
float[] distribution = new float[360];

void setup()

{
  //background(#000011);
  size(1400, 875, P3D);
  frameRate(16);
  
  smooth();

  w8 = width / 32.0;
  h8 = height / 32.0;

  minim = new Minim(this);
  in = minim.getLineIn(minim.STEREO, 144);

  col = w/scl;
  row = h/scl;

  audio = new float[col][row];

  //gaussian
  for (int i = 0; i < distribution.length; i++) {
    distribution[i] = int(randomGaussian() * 15);
  }
}


void draw()
{
  
  color(random(255));

  float audioIn = abs((in.mix.get(0)) +
    (in.mix.get(1)) +
    (in.mix.get(2)) / 3)
    * sensitivity;
  
  background(220-audioIn*10);

  //movement
  //flying -= (abs(audioIn) / 10);
  flying -= 0.015;

  float yoffset = (flying - (audioIn/1000));
  for ( int y = 0; y < row; y++) {
    float xoffset = 0;
    for ( int x = 0; x < col; x++) {
      audio[x][y] = map(noise(xoffset, yoffset), 0, 1, -400, 405);

      xoffset += .022;
    }
    yoffset += .022;
  }


  stroke(#005050 /audioIn);
  strokeWeight(.085 + audioIn/5);
  fill(#FFFFFF);
  //static
  ellipse(random(width), random(height), audioIn * 5, audioIn * 5);
  fill(#005000 * (audioIn * 10));
  ellipse(random(width), random(height), audioIn * 3, audioIn * 3);



  noFill();

  translate(width/2, height/2);
  rotateZ(PI + inc);
  //rotateX( PI/3 );
  translate((-w)/2, (-h)/2);
  rotate(frameCount/30);

  if (mousePressed) {
    translate(mouseX, mouseY);
  }
  
  //grid
  for ( int ix = 0; 
    ix < 32; 
    ix++ )
  {
    strokeWeight(.25 * second()%2);
    for ( int iy = 0; iy < 32; iy++ )
    {
      //fill(ix / second()%3);

      int choice = int(random(3));

      switch ( choice )
      {
      case 0:
        rect( ix*w8, iy*h8, w8, h8 );
        break;
      case 1:
        line( ix*w8, iy*h8+h8, ix*w8+w8, iy*h8 );
        break;
      case 2:
        for ( int i = 0; i < 32; i++ )
        {
          line((ix*w8), iy*h8+i*w8/8, ix*w8+w8, iy*h8+i*w8/8);
        }
        
      }
    }
  }

  //perlin
  int rand = int(random(50, 60));


  for (int y = 0; y < row - 1; y++) {

    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < col; x++) {

      //stroke(#9ABB99);
      stroke(#005000*audioIn);
      //stroke(#FFFFFF);


      //***************//
      //CONTROL PANEL
      //***************//

      int sec = second() + 1;
      int min = minute() + 1;


      int switcher = (sec * 2);

      //incrementer
      inc += .0000002;

      if (min % 2 == 0) {
        translate(-w/2, -h/2);
      }

      if (sec % 27 == 0) {
        rect(random(width * 2), random(height * 2), 500, 500);
        sphere(audioIn);
      }
      //fade to black
      if (sec % 10 == 0) {
        translate(500, 50);
      }
      if (sec % 36 == 0) {
        rotateX(PI/8);
      }
      if (sec % 8 == 0) {
        //stroke(#DD5000);
        stroke(#005000);
        line(width, height / 2, audioIn * 100, audioIn * 100);
      }
      if (sec % random(10) == 0) {
        //stroke(#99BBAA);
        stroke(#001234);
        //strokeWeight(1);
        line(width, height * 2, audioIn * 1000, audioIn * 1000);
      }


      switch(int(switcher/10)) {
      case 1:
        {
          //static waves
          //scl = 10;

          rotateY(PI);
          //stroke(random(255));
          noStroke();
          fill(random(150));
          break;
        }
      case 2:
        {
          //rotation
          //scl = 40;

          rotateZ(.8);
          break;
        }
      case 3:
        {
          //club night
          rect(width/2, height/2, audioIn, audioIn);
          rotate((audioIn * 1.004));
          stroke(random(audioIn + .05));
          break;
        }
      case 4:
        {

          rotateZ(PI/2);
          rotateX(PI/4);
          //rotateZ(PI/2);
          // rotateX(PI);

          stroke(audioIn + 10);
          strokeWeight(audioIn * 10);
          //scl = 100;
          break;
        }
      case 5:
        {
          //graph

          //scl=100;
          //w = width*2;
          //h = height*4;

          //scl = 60;
          //fill(random(100));

          //fill(random(250));

          //shearX(PI/6);
          //flying = -5;
          rect(scl, scl, audioIn * 2, audioIn * 2);
          audio[x][y] = map(noise(-1, 1), 1, 0, -50, 0);
          break;

          //ellipse(0, height / 2, audioIn * 100, audioIn * 100);
        }
      case 6:
        {
          //squares

          rotate(PI/6);
          stroke(random(150));
          rect(random(10), random(1000), 2500, 5000);
          rect(-width, -height, audioIn*frameCount, audioIn * frameCount);
          break;
        }
      case 7:
        {
          //waves

          //strokeWeight(3);
          //scl = 80;
          rotate(PI);
          audio[x][y] = map(noise(0, .5), 1, 1, -500, 500);
          line(width, -height, audioIn*frameCount, audioIn * frameCount);
          break;
          //h = 5000;
        }
      case 8:
        {
          //disperse

          rotate(TWO_PI/distribution.length + audioIn);
          strokeWeight(random(.008));
          stroke(random(255));
          float dist = abs(distribution[x]);
          line(width * audioIn, height * audioIn, dist, 50);
          line((width * audioIn), (height * audioIn), 0, -dist);
          break;
        }
      case 11:
        {
          //rotate(TWO_PI);
          yoffset += .2;
          line(-width, height, audioIn*frameCount, audioIn * frameCount);
          //xoffset += .01;
          break;
        }
      case 10:
        {
          //translate(width * 2, height * 2);
          rotateZ( PI );
          //translate((-w)/2, (-h)/2);
          break;
        }
      case 9:
        {
          rotateZ(10);
          audio[x][y] = map(noise(-100, 100), 1, 0, -50, 0);
          ellipse(-width, -height, audioIn*frameCount, audioIn * frameCount);
        }
      case 12:
        {
          audio[x][y] = map(noise(-1, 1), 1, 0, 500, 200);
          //yoffset = 10;
        }
      case 13:
        {
          line(width, height, audioIn * 1000, audioIn * 1000);
          line(-width, -height, audioIn*frameCount, audioIn * frameCount);
        }
      case 14:
        {
          translate(1000, 1000);
        }
      case 15:
        {
          line(width * 2, height * 2, TWO_PI, PI);
        }
      case 16:
        {
          rotateX(PI);
        }
      case 17:
        {
        }
      case 18:
        {
        }
      case 19:
        {
        }
      case 20:
        {
        }
      case 21:
        {
        }
        /*
      case 0:
         {
         //reinitialize
         
         //flying = 0;
         //scl = 60;
         //w = 4800;
         //h = 3800;
         //rotateZ(0);
         //strokeWeight(audioIn);
         //rotate(random(PI));
         break;
         }
         */
      }




      //vertex(x*scl, y*scl, audio[x][y]);
      //vertex(x*scl, (y+1)*scl, audio[x][y+1]);
      
      vertex(x*scl, y*scl, audio[x][y] += audioIn);
      vertex(x*scl, (y+1)*scl, audio[x][y+1] += audioIn);
    }
    endShape();

    /*boom
     for (int i = 0; i < in.bufferSize() - 1; i++)
     {
     stroke(#FFFFFF);
     strokeWeight(.008);
     ellipse( random(width/2, width/4), random(height/2, height/4), audioIn * 5000, audioIn * 5000 );
     //ellipse(audioIn * 400, audioIn * 400, audioIn * 500, audioIn * 500);
     noStroke();
     }
     */


    for (int i = 0; i != width; i += 100) {
      //stroke(#ABABAB);
      //fill(#ABABAB);
      rect(w * 2, h * audioIn, 100, 200);
      
      ellipse(w * 2, h * audioIn, 100, 100);
      //noStroke();
    }


    //lines
    //noStroke();
    //rotateX(0);
    //line(width - 500, ascend * audioIn, width * 8, 40 );
    if (ascend >=height * 2) {
      ascend = 1;
      position = 0;
    }
    noFill();
  }
  if (recording) {
    saveFrame("frame_5/####.png");
  }
  //camera(1000, 1000, 1000, 0, 0, 0, 0, 0, 0);
}
void keyPressed() {
  if (key == 'r' || key == 'R') {
    recording = !recording;
  }
}
