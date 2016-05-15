// ChucK Experiment 1
// Ben Langham 2016
// Basic computer generated melodies and drums


// Permitted notes
[ 0, 2, 4, 7, 9, 11 ] @=> int notes[];

section1();
section2();
section3();
section4();
section5();
section6();
section7();
section8();


fun void section1() {
  <<< "section 1" >>>;
  spork ~ adsr();
  4::second => now;
}

fun void section2() {
  <<< "section 2" >>>;  
  spork ~ click(); 
  spork ~ pan();
  spork ~ melody(2); 
  16::second => now;
}

fun void section3() {
  <<< "section 3" >>>;
  spork ~ noise(1); 
   4::second => now;
}

fun void section4() {
  <<< "section 4" >>>;
  spork ~ imp1(1);
  spork ~ imp2(1);
  spork ~ imp3(1); 
  spork ~ melody(1); 
  14::second => now;
}

fun void section5() {
  <<< "section 5" >>>;
  spork ~ noise(2);
  4::second => now;
}

fun void section6() {
  <<< "section 6" >>>;
  spork ~ kick(1);
  spork ~ adsr();
  spork ~ tri(); 
  16::second => now;
}

fun void section7() {
  <<< "section 7" >>>;
  spork ~ kick(1);
  spork ~ adsr();
  spork ~ tri();
  // spork ~ melody(2); 
  16::second => now;
}

fun void section8() {
  <<< "section 8" >>>;
  spork ~ kick(2);
  spork ~ snare();
  spork ~ click(); 
  spork ~ imp1(2);
  spork ~ imp2(2);
  spork ~ imp3(2); 
  16::second => now;
  spork ~ melody(2);
  14::second => now;
}

fun void section9() {
  <<< "section 9" >>>;
  spork ~ snare();
  spork ~ click(); 
  spork ~ imp1(4);
  spork ~ imp2(4);
  spork ~ imp3(4); 
  8::second => now;
  spork ~ imp1(8);
  spork ~ imp2(16);
  spork ~ imp3(16); 
  spork ~ tri();
  8200::ms => now;
}


fun void pan() {
// set up a stereo connection to the dac
  SinOsc s => Pan2 p => HPF fltr => JCRev r  => dac;
  .1 => s.gain;
  0.6 => p.pan;
  .08 => r.mix;
  800 => fltr.freq;

	for( 0 => int count; count < 16 ; count++  ) {
		// this will flip the pan from left to right
		p.pan() * -1. => p.pan;
		Std.mtof( 45 + Math.random2(0,3) * 12 +
	       notes[Math.random2(0,notes.cap()-1)] ) => s.freq;
    1::second => now;
	}
  0 => s.gain;
}


fun void melody(int speed) {
	SinOsc s2 => LPF fltr => JCRev r => dac;
	.2 => s2.gain;
	.04 => r.mix;

  //set filter freq
  800 => s2.freq; 

  //base the moduation on a centre frequency 
  Step centre => Gain modmix => blackhole; 
  //..with a variable offset around it 
  SinOsc LFO => modmix; 

  //centre frequency 
  400 => centre.next; 
  //determines the modulation range 
  20 => LFO.gain; 

  .5::second => LFO.period; 

  //resonance 
  2 => fltr.Q; 


	for( 0 => int count; count < (110 / speed) ; count++ ) 
	{
	   Std.mtof( 45 + Math.random2(0,3) * 12 +
	       notes[Math.random2(0,notes.cap()-1)] ) => s2.freq;
	   (speed * 100)::ms => now;

     // LFO filter
     modmix.last() => fltr.freq; 
     ms => now; 

	}
}


fun void adsr() {
	TriOsc sqr => ADSR e => JCRev r => dac;
	// set a, d, s, and r
	e.set( 5::ms, 2::ms, .5, 50::ms );
	// set gain
	.4 => sqr.gain;
  .06 => r.mix;

	// infinite time-loop
	for( 0 => int count; count < 48 ; count++ )
	{
	    // choose freq
	    Std.mtof( 21 + Math.random2(0,3) * 12 +
	       notes[Math.random2(0,notes.cap()-1)] ) => sqr.freq;

	    // key on - start attack
	    e.keyOn();
	    // advance time by 800 ms
	    200::ms => now;
	    // key off - start release
	    e.keyOff();
	    // advance time by 800 ms
	    200::ms => now;
	}
}

fun void imp1(int speed) {
	// impulse to filter to dac
  	Impulse i => BiQuad f => JCRev r => dac.left;
  	// set the filter's pole radius
  	.99 => f.prad;
  	// set equal gain zero's
  	1 => f.eqzs;
  	// initialize float variable
  	0.0 => float v;
  	//gain
  	0.1 => i.gain;
  	0.2 => r.gain;

  	// infinite time-loop
  	for( 0 => int count; count < 128 ; count++ )
  	{
  	    // set the current sample/impulse
  	    1.0 => i.next;
  	    // sweep the filter resonant frequency
  	    Std.fabs(Math.sin(v)) * 4000.0 => f.pfreq;
  	    // increment v
  	    v + .1 => v;
  	    // advance time
  	    (speed * 100)::ms => now;
  	}
}

fun void imp2(int speed) {
	// impulse to filter to dac
  	Impulse i => BiQuad f => JCRev r => dac.right;
  	// set the filter's pole radius
  	.99 => f.prad;
  	// set equal gain zero's
  	1 => f.eqzs;
  	// initialize float variable
  	0.0 => float v;
  	//gain
  	0.1 => i.gain;
  	0.2 => r.gain;

  	// infinite time-loop
  	for( 0 => int count; count < 128 ; count++ )
  	{
  	    // set the current sample/impulse
  	    1.0 => i.next;
  	    // sweep the filter resonant frequency
  	    Std.fabs(Math.sin(v)) * 4000.0 => f.pfreq;
  	    // increment v
  	    v + .1 => v;
  	    // advance time
  	    (speed * 99)::ms => now;
  	}
}

fun void imp3(int speed) {
	// impulse to filter to dac
  	Impulse i => BiQuad f => JCRev r => dac;
  	// set the filter's pole radius
  	.99 => f.prad;
  	// set equal gain zero's
  	1 => f.eqzs;
  	// initialize float variable
  	0.0 => float v;
  	//gain
  	0.1 => i.gain;
  	0.2 => r.gain;
    0 => int count;

  	// infinite time-loop
  	for( 0 => int count; count < 128 ; count++ )
  	{
  	    // set the current sample/impulse
  	    1.0 => i.next;
  	    // sweep the filter resonant frequency
  	    Std.fabs(Math.sin(v)) * 4000.0 => f.pfreq;
  	    // increment v
  	    v + .1 => v;
  	    // advance time
  	    (speed * 101)::ms => now;
  	}
}

fun void noise(int mix) {
	// impulse to filter to dac
  	Noise n => Gain ng => BiQuad f => JCRev r => dac;
  	// set the filter's pole radius
  	.99 => f.prad;
  	// set equal gain zero's
  	1 => f.eqzs;
  	// initialize float variable
  	0.0 => float v;
  	//gain
  	0.01 => ng.gain;
  	(0.02 * mix) => r.mix;

  	// infinite time-loop
  	for( 0 => int count; count < 20 ; count++ )
  	{
  	    // sweep the filter resonant frequency
  	    Std.fabs(Math.sin(v)) * 4000.0 => f.pfreq;
  	    // increment v
  	    v + .1 => v;
  	    // advance time
  	    200::ms => now;
  	}
}

fun void click() {
	Noise n => ADSR e => Gain g => BiQuad f => Echo ec1 => Echo ec2 => dac;
  		0.3 => g.gain;
	  	// set the filter's pole radius
	  	.99 => f.prad;
	  	// set equal gain zero's
	  	1 => f.eqzs;
	  	// initialize float variable
	  	0.0 => float v;
	  	//gain
	  	0.2 => n.gain;
      // set delay time
      110::ms => ec1.delay;
      300::ms => ec2.delay;
      0.5 => ec1.mix;
      0.2 => ec2.mix;

  		// infinite time-loop
	for( 0 => int count; count < 32 ; count++ )
	{
		// set a, d, s, and r
		e.set( 2::ms, 2::ms, .01, 10::ms );

	    // key on - start attack
	    e.keyOn();
	    // advance time by 800 ms
	    200::ms => now;
	    // key off - start release
	    e.keyOff();
	    // advance time by 800 ms
	    200::ms => now;
	}
}


fun void tri() {
  TriOsc s => ADSR e => Pan2 p => dac;
  0.3 => s.gain;
  -0.3 => p.pan;
  while( true )
  {
    // set a, d, s, and r
    e.set( 15::ms, 5::ms, .1, 2000::ms );

      // Flip the pan
      p.pan() * -1. => p.pan;
      // Choose note
      Std.mtof( 45 + Math.random2(0,3) * 12 +
         notes[Math.random2(0,notes.cap()-1)] ) => s.freq;
      // key on - start attack
      e.keyOn();
      // advance time by 800 ms
      2000::ms => now;
      // key off - start release
      e.keyOff();
      // advance time by 800 ms
      2000::ms => now;

  }
}

// simple analog-sounding bass drum with pitch and amp decay and sine overdrive  
// http://electro-music.com/forum/topic-21382.html

class kjzBD101 
{ 
   Impulse i; // the attack 
   i => Gain g1 => Gain g1_fb => g1 => LPF g1_f => Gain BDFreq; // BD pitch envelope 
   i => Gain g2 => Gain g2_fb => g2 => LPF g2_f; // BD amp envelope 
    
   // drum sound oscillator to amp envelope to overdrive to LPF to output 
   BDFreq => SinOsc s => Gain ampenv => SinOsc s_ws => LPF s_f => Gain output; 
   g2_f => ampenv; // amp envelope of the drum sound 
   1 => ampenv.op; // set ampenv a multiplier 
   1 => s_ws.sync; // prepare the SinOsc to be used as a waveshaper for overdrive 
  
   // set default 
   80.0 => BDFreq.gain; // BD initial pitch: 80 hz 
   1.0 - 1.0 / 2000 => g1_fb.gain; // BD pitch decay 
   g1_f.set(100, 1); // set BD pitch attack 
   1.0 - 1.0 / 4000 => g2_fb.gain; // BD amp decay 
   g2_f.set(50, 1); // set BD amp attack 
   .5 => ampenv.gain; // overdrive gain 
   s_f.set(600, 1); // set BD lowpass filter 
    
   fun void hit(float v) 
   { 
      v => i.next; 
   } 
   fun void setFreq(float f) 
   { 
      f => BDFreq.gain; 
   } 
   fun void setPitchDecay(float f) 
   { 
      f => g1_fb.gain; 
   } 
   fun void setPitchAttack(float f) 
   { 
      f => g1_f.freq; 
   } 
   fun void setDecay(float f) 
   { 
      f => g2_fb.gain; 
   } 
   fun void setAttack(float f) 
   { 
      f => g2_f.freq; 
   } 
   fun void setDriveGain(float g) 
   { 
      g => ampenv.gain; 
   } 
   fun void setFilter(float f) 
   { 
      f => s_f.freq; 
   } 
} 

 fun void kick(int time) {

  kjzBD101 A;
  A.output => Gain gkick => dac; 
  0.5 => gkick.gain;

  for(int i; i < 32; i++) 
    { A.hit(.5); (800 / time)::ms => now; } 
 }


fun void snare() {
  Noise sl => ADSR e1 => HPF f1 => Gain g1 => JCRev r1 => dac.left;
  Noise sr => ADSR e2 => HPF f2 => Gain g2 => JCRev r2 => dac.right;
  0.1 => g1.gain;
  0.1 => g2.gain;
  150 => f1.freq;
  150 => f2.freq;
  0.3 => r1.mix;
  0.3 => r2.mix;

  while( true )
  {
    // set a, d, s, and r
    e1.set( 15::ms, 5::ms, 0.1, 300::ms );
    e2.set( 15::ms, 5::ms, 0.1, 300::ms );
      400::ms => now;
      // key on - start attack
      e1.keyOn();
      e2.keyOn();
      // advance time by 800 ms
      1200::ms => now;
      // key off - start release
      e1.keyOff();
      e2.keyOff();

  }
}