# multiRenderShader
A processing sketch that renders 1 dimentional Cellular automata, Conway's Life and Fractals (fractals are rendered using a shader)
The program can record its output by pressing 'R' to an mp4 file. This requires the installation of the optional ffmpeg movie export library, obtainable using the processing package manager.
Note that you should stop recording by pressing 'R' again and press 'Q' to exit the program in order to finalize the mp4 movie.
When the program starts, it autozooms slowly. You can adjust the zoom factor in the code. You can switch between the 4 different modes
CA1D, LIFE, MANDEL and SLIDESHOW by pressing the keys '1', '2' and '3'.
The slideshow data is inside the data/cs_people.txt xml file. The bios and pictures in there are from the Greek and English version of Wikipedia.
The shader user for rendering the fractal is found in the data directory and is called mandel.glsl
You can see an example of this program in this youtube video:
[ΝΟΗΣΗ](https://www.youtube.com/watch?v=hUomiyRfpKk)
The video was post processed in Sony Movie Studio Platinum 13
A slideshow option was added in order to be able to present data. I will use this as a kiosk slideshow.
