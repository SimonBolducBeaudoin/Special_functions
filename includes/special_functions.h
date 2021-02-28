#pragma once

#define _USE_MATH_DEFINES
#define PI M_PI
#include <cmath>
#include <Numeric_Integrals.h>
typedef unsigned int uint;

/* Fresnel integrals */
// http://mathworld.wolfram.com/FresnelIntegrals.html
double Fresnel_Cosine_Integral( double x );
double Fresnel_Sine_Integral( double x );

/* Windowing functions */
/*
https://en.wikipedia.org/wiki/Window_function

Although those function are defined in between 0 and x_max
The implementation I've written is symetric ( even function ) and cyclic
*/
    /*
        symetric ( even function ) and cyclic
    */
double Tukey( double x , double alpha , double x_max );
    /*
        symetric ( even function ) and cyclic
        1st transition stops at x_1
        2nd transition starts at x_2
        The function's period is x_max
	*/
double Tukey( double x , double x_1 , double x_2 , double x_max);

    /*
        symetric ( even function ) and cyclic
        1st transition starts at x_1
        1st transition stops at x_2
        2nd transition starts at x_2
        2nd transition starts at x_2
        The function's period is x_max
	*/
double Tukey( double x , double x_1 , double x_2 , double x_3 , double x_4 , double x_max );