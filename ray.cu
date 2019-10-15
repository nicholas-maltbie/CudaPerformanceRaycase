/*
 * Copyright 1993-2010 NVIDIA Corporation.  All rights reserved.
 *
 * NVIDIA Corporation and its licensors retain all intellectual property and 
 * proprietary rights in and to this software and related documentation. 
 * Any use, reproduction, disclosure, or distribution of this software 
 * and related documentation without an express license agreement from
 * NVIDIA Corporation is strictly prohibited.
 *
 * Please refer to the applicable NVIDIA end user license agreement (EULA) 
 * associated with this source code for terms and conditions that govern 
 * your use of this NVIDIA software.
 * 
 */


#include "cuda.h"
#include "common/book.h"
#include "common/cpu_bitmap.h"

#define MAX_SPHERES 1000

#define rnd( x ) (x * rand() / RAND_MAX)
#define INF     2e10f

struct Sphere {
    float   r,b,g;
    float   radius;
    float   x,y,z;
    __device__ float hit( float ox, float oy, float *n ) {
        float dx = ox - x;
        float dy = oy - y;
        if (dx*dx + dy*dy < radius*radius) {
            float dz = sqrtf( radius*radius - dx*dx - dy*dy );
            *n = dz / sqrtf( radius * radius );
            return dz + z;
        }
        return -INF;
    }
};

__constant__ Sphere sconstant[MAX_SPHERES];

__global__ void kernel( Sphere *sglobal, unsigned char *ptr, int dim,
    int spheres, bool isGlobal) {
    // map from threadIdx/BlockIdx to pixel position
    int x = threadIdx.x + blockIdx.x * blockDim.x;
    int y = threadIdx.y + blockIdx.y * blockDim.y;
    int offset = x + y * blockDim.x * gridDim.x;
    float   ox = (x - dim/2);
    float   oy = (y - dim/2);

    Sphere* s = sconstant;
    if (isGlobal) {
        s = sglobal;
    }

    float   r=0, g=0, b=0;
    float   maxz = -INF;
    for(int i=0; i<spheres; i++) {
        float   n;
        float   t = s[i].hit( ox, oy, &n );
        if (t > maxz) {
            float fscale = n;
            r = s[i].r * fscale;
            g = s[i].g * fscale;
            b = s[i].b * fscale;
            maxz = t;
        }
    } 

    ptr[offset*4 + 0] = (int)(r * 255);
    ptr[offset*4 + 1] = (int)(g * 255);
    ptr[offset*4 + 2] = (int)(b * 255);
    ptr[offset*4 + 3] = 255;
}

// globals needed by the update routine
struct DataBlock {
    unsigned char   *dev_bitmap;
};

int main( int argc, char** argv ) {
    if (argc != 6) {
        printf("Usage: %s DIM SPHERES NUM-THREADS RENDER GLOBAL\n", argv[0]);
        printf("  DIM - Dimension of image (square) in pixels\n");
        printf("  SPHERES - Number of spheres to draw\n");
        printf("  NUM-THREADS - Number of threads to use per block\n");
        printf("  RENDER - Value of 0 for do not render, 1 for render\n");
        printf("  GLOBAL - Value of 0 for constant memory, 1 for global\n");
        return 1;
    }

    int dim = atoi(argv[1]);
    int spheres = atoi(argv[2]);
    int num_threads = atoi(argv[3]);
    bool render = atoi(argv[4]) == 1;
    bool isGlobal = atoi(argv[5]) == 1;

    DataBlock   data;
    // capture the start time
    cudaEvent_t     start, stop;
    HANDLE_ERROR( cudaEventCreate( &start ) );
    HANDLE_ERROR( cudaEventCreate( &stop ) );
    HANDLE_ERROR( cudaEventRecord( start, 0 ) );

    CPUBitmap bitmap( dim, dim, &data );
    unsigned char   *dev_bitmap;

    // allocate memory on the GPU for the output bitmap
    HANDLE_ERROR( cudaMalloc( (void**)&dev_bitmap,
                              bitmap.image_size() ) );

    // allocate temp memory, initialize it, copy to constant
    // memory on the GPU, then free our temp memory
    Sphere *temp_s = (Sphere*)malloc( sizeof(Sphere) * spheres );
    for (int i=0; i<spheres; i++) {
        temp_s[i].r = rnd( 1.0f );
        temp_s[i].g = rnd( 1.0f );
        temp_s[i].b = rnd( 1.0f );
        temp_s[i].x = rnd( 1000.0f ) - 500;
        temp_s[i].y = rnd( 1000.0f ) - 500;
        temp_s[i].z = rnd( 1000.0f ) - 500;
        temp_s[i].radius = rnd( 100.0f ) + 20;
    }

    Sphere          *sGlobal;
    if (isGlobal) {
        HANDLE_ERROR( cudaMalloc( (void**)&sGlobal,
                                  sizeof(Sphere) * spheres ) );
        HANDLE_ERROR( cudaMemcpy( sGlobal, temp_s,
                                    sizeof(Sphere) * spheres,
                                    cudaMemcpyHostToDevice ) );
    }
    else {
        HANDLE_ERROR( cudaMemcpyToSymbol( sconstant, temp_s, 
                                    sizeof(Sphere) * spheres) );
    }
    free( temp_s );

    // generate a bitmap from our sphere data
    dim3    grids(dim/num_threads,dim/num_threads);
    dim3    threads(num_threads,num_threads);
    kernel<<<grids,threads>>>( sGlobal, dev_bitmap, dim, spheres, isGlobal);

    // copy our bitmap back from the GPU for display
    HANDLE_ERROR( cudaMemcpy( bitmap.get_ptr(), dev_bitmap,
                              bitmap.image_size(),
                              cudaMemcpyDeviceToHost ) );

    // get stop time, and display the timing results
    HANDLE_ERROR( cudaEventRecord( stop, 0 ) );
    HANDLE_ERROR( cudaEventSynchronize( stop ) );
    float   elapsedTime;
    HANDLE_ERROR( cudaEventElapsedTime( &elapsedTime,
                                        start, stop ) );
    //printf( "Time to generate:  %3.1f ms\n", elapsedTime );
    printf( "%3.1f\n", elapsedTime );

    HANDLE_ERROR( cudaEventDestroy( start ) );
    HANDLE_ERROR( cudaEventDestroy( stop ) );

    HANDLE_ERROR( cudaFree( dev_bitmap ) );

    // display
    if (render) {
        bitmap.display_and_exit();
    }
}

