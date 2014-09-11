import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
FFT fft;
float highestAmp=0,freq,frequency;
float amplitude;

float fixedMidA = 440;

float frac = 1f/12;
float alph = pow(float(2), frac);
float noteShift = 0;
float note = 0;
String noteL = "";
float avg = 0;
float sig = 0;

ArrayList<Integer> peaks; 
ArrayList<Integer> postKPeaks; 
void setup(){
        size(1024, 400);
        background(0);
        
        // initialize Minim and catching the output
        minim = new Minim(this);
        in = minim.getLineIn(Minim.MONO, 4096*8, 44100);
        fft = new FFT(in.left.size(), 44100);
        peaks = new ArrayList();
        postKPeaks = new ArrayList();
}

float s1(int k, int i, float x, FFT fft) {
 
  float maxValL = 0;
  float maxValR = 0;  
  float jFreq = 0;
  //left side
  
  for (int j = 0; j <  k; j++)
  {
    jFreq = fft.getFreq(j);
    if(x - jFreq > maxValL){
      maxValL = x - jFreq;
    }
  }  

//right side
  for (int j = 0; j <  k; j++)
  {
    jFreq = fft.getFreq(j);
    if(x + jFreq > maxValR){
      maxValR = x + jFreq;
    }
    
    
  }
  
 return (maxValL+maxValR)/2; 
}

void draw() {
      highestAmp=0;
      amplitude=0;
      frequency = 0;
      fft.forward(in.left);
          int h = 2;
                     avg = fft.calcAvg(0, 20000);
                    float[] a = new float[20000]; 
                    ArrayList<Integer> o = new ArrayList(); 
      //searching from 0Hz to 20000Hz. getting the band, and from the band the frequency
     for(int i = 0; i < 20000; i++) {
//            amplitude = fft.getFreq(i);
//            if (amplitude > highestAmp){
//                highestAmp = amplitude;
//                frequency = i;
//            }
            
            a[i] = s1(5, i, fft.getFreq(i), fft);
   //         if (sig > 0 && (sig - fft.calcAvg(0, 20000) ) > h * avg) peaks.add(i);
            
          }
          
     for(int i = 0; i < 20000; i++) {
    
       if (a[i] > 0 && (a[i] - avg) > h) {
         o.add(i);
       }
       

     } 
println(o.size());
float k = 1.5;
    for(int i = 0; i < o.size()-1; i++) {
     float first = fft.getFreq(o.get(i)); 
     float sec = fft.getFreq(o.get(i+1)); 
     
     if (abs(o.get(i)-o.get(i+1)) <= k*3){
       
       if(first-sec > 0) {
         o.remove(i+1);
       } else {
         o.remove(i);
         
       }
       i--;
        
     }
      
    }

     
        //  peaks.sort();
/*
          for (int i = 0; i < peaks.size()-1; i++){
            if ( abs(int(peaks.get(i)) - int(peaks.get(i + 1) ) ) <= h) {
              if (peaks.get(i) - peaks.get(i + 1) > 0) {
                postKPeaks.add(i);
              } else {
                postKPeaks.add(i + 1);                
              }
            }
          }
          
*/          
          
          //write the frequency on the screen
          fill(255);
          background(0);
          text(frequency,200,100);
          text(amplitude,200,200);
          
               //     text(Float.toString(alph),200,150);
          note = frequency/fixedMidA;
          note = (log(note) / log(alph) );
          
          note = round(note);
          note = note % 12;
          if (note < 0 ) note = note + 12;
          
          switch((int)note) {
            case 0: noteL = "A"; break;
            case 1: noteL = "A#"; break;
            case 2: noteL = "B"; break;
            case 3: noteL = "C"; break;
            case 4: noteL = "C#"; break;
            case 5: noteL = "D"; break;
            case 6: noteL = "D#"; break;
            case 7: noteL = "E"; break;
            case 8: noteL = "F"; break;            
            case 9: noteL = "F#"; break;
            case 10: noteL = "G"; break;            
            case 11: noteL = "G#"; break;
          }
          
          
                              text(Float.toString(note),200,150);
                              text(noteL,250,150); 
                      
          
                              text(postKPeaks.size(),350,150);                               


           stroke(255);
         
         
         
           for(int i = 0; i < fft.specSize(); i++)

  {
    // draw the line for frequency band i, scaling it up a bit so we can see it
  //  if (postKPeaks.contains(i)) stroke(255,0,0);
  
    if(o.contains(i)) stroke(255,0,0);
    line( i, height, i, height - fft.getFreq(i)*8 );
    stroke(255);
  }
 
 

 
  
             stroke(255, 0 , 0);
         
         line(0, height - avg*8, width, height - avg*8);
          
          
         peaks.clear();
         postKPeaks.clear();                     
}
