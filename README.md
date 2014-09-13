audio-analysis
==============

Basic Processing real time audio frequency analysis program, beginning of local max algorithm, personal interest project over Summer 2014


This is a simple program I played around with when I found an audio analyzing library, minim,that worked.
It originally stemmed from an example of taking audio sample in a buffer. The data is then sent through a FFT object.
This Fast Fortier Transformation object converts the samples of amplitude of sounds over time to an amplitude by frequency.
The output of the FFT is a new buffer containing the amplitude of each frequency in the given data. A search of the buffer will give you the most prominent frequency picked up by each index's value
The first tool that came to mind I knew I could make if I could get frequencies was a musical tuner. Or at least a program that converts the most prominent frequency to the closest of the 12 musical.

formula for covering frequency to note was fount at this link : http://www.phy.mtu.edu/~suits/NoteFreqCalcs.html

The formula is f(n) = f(0) * (a)^n
where:
f(0) = a fixed reference frequency dependent on atmosphere, A over middle C can be f(0) = 440 Hz
n = number of half step notes from reference frequency
f(n) = the frequency of the note n half steps away
a = (2)^(1/12)

This formula gives you the frequency of a note a number, n step away. I need to be able to determine the amount of steps from the reference frequency a sound is based on its frequency.

In order to do this we must rewrite the formula to solve for n

This is done by getting n by as isolated as possible by dividing through by the fixed reference frequency, getting:

(a)^n = f(n)/f(0) 

Next use logarithms to further separate n:

n = log(a)(f(n)/f(0))

This function can now be calculated in the program. the only logarithm tool at your disposal is a natural logarithm function so to calculate a logarithm with a base of a can be calculated as such:

n = ln(f(n)/f(0)) / ln(a)

this formula is then mediated in the "note" variable used in lines : 135 & 136

once this worked the amount of steps from the reference frequency running it through mod 12 and assigning each number to a note name as all that needed to be done.

This program finally displays the FFT results in lines across the screen, increasing in frequency as it moves to the right. At this point I worked on a local max min algorithm to find groups of high amplitude bands. Points of data decided to be local peaks are displayed in red. The algorithm with vastly improve once it takes into consideration the standard deviation of the data. Theoretically this would allow measuring of distances between the peaks which would distinguish types of chords played.  
