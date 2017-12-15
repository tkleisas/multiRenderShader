uniform float x0;
uniform float x1;
uniform float y0;
uniform float y1;
uniform float cstep1;
uniform float cstep2;
uniform float cstep3;
uniform float phaseR;
uniform float phaseG;
uniform float phaseB;
uniform vec2 iResolution;


vec4 getFractalColor(int iter)
{
    float PI = 3.1415923;
    

    if(iter ==0)
        return vec4(0.0,0.0,0.0,0.0);
    else
    {
        return vec4(
            		sin(float(iter)*cstep1+phaseR)*0.5+0.5,
            		sin(float(iter)*cstep2+phaseG)*0.5+0.5,
            		sin(float(iter)*cstep3+phaseB)*0.5+0.5,
            		1.0
        		);
    }
}
void main()
{

    float stepx = (x1-x0) / iResolution.x;
    float stepy = (y1-y0) / iResolution.y;

    float xpixel=x0+gl_FragCoord.xy.x*stepx;
    float ypixel=y0+gl_FragCoord.xy.y*stepy;
    
    float xtemp;
    float xstart = xpixel;
    float ystart = ypixel;
    int maxiter = 255;
    int iter =0;
    for(int i=0;i<=maxiter;i++)
    {
        if(xpixel*xpixel + ypixel*ypixel>4.0)
            break;
        xtemp = xpixel * xpixel - ypixel*ypixel + xstart;
        ypixel = 2.0*xpixel*ypixel +ystart;
        xpixel = xtemp;
        iter = i;
    }
    gl_FragColor = getFractalColor(iter);
    //gl_FragColor = vec4(1.0,1.0,1.0,1.0);
        
}

