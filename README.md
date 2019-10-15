# Raycast Project
Assignment for Parallel Programming course at UC Fall semester 2019.

Looking into performance of raycasting

## Example

The project will render spheres as in the following image

![Spheres on a black background drawn by the program](Spheres.png)

## Compiling the program

This program requires OpenGL and Cuda (nvcc) to be installed. The project is compiled with make as using the following commands:

```bash
make
```

Once the program is compiled, it can be executed with the following arguments:

```text
Usage: ./ray DIM SPHERES NUM-THREADS RENDER GLOBAL
  DIM - Dimension of image (square) in pixels
  SPHERES - Number of spheres to draw
  NUM-THREADS - Number of threads to use per block
  RENDER - Value of 0 for do not render, 1 for render
  GLOBAL - Value of 0 for constant memory, 1 for global
```

The script `eval_bash.sh` will evaluate the performance of the program on your machine and store results in a file called ray_results.csv.

## Raycast Performance

Here is an example of the program's performance under different rendering settings. These values are calculated as the result of running ten trials with all the various settings.

|DIM|THREADS|SPHERES|MEMORY|RENDER TIME MEDIAN (ms)|RENDER TIME MEAN (ms)|RENDER TIME SD (ms)|
|---|-------|-------|------|------------------|----------------|--------|
|512|16|10|const|0.7|0.72|0.133|
|512|16|10|global|0.7|0.68|0.04|
|512|16|100|const|1|1.05|0.12|
|512|16|100|global|1|1.03|0.046|
|512|16|1000|const|4.55|4.65|0.169|
|512|16|1000|global|4.5|4.53|0.046|
|512|32|10|const|0.7|0.7|0.045|
|512|32|10|global|0.7|0.66|0.049|
|512|32|100|const|1|1.05|0.15|
|512|32|100|global|1|1.02|0.06|
|512|32|1000|const|4.6|4.78|0.299|
|512|32|1000|global|4.25|4.29|0.221|
|1024|16|10|const|2|1.99|0.03|
|1024|16|10|global|2.1|2.07|0.078|
|1024|16|100|const|3.3|3.34|0.066|
|1024|16|100|global|3.4|3.41|0.083|
|1024|16|1000|const|16.65|16.67|0.09|
|1024|16|1000|global|16.8|17.61|1.306|
|1024|32|10|const|2|1.97|0.046|
|1024|32|10|global|2.1|2.06|0.049|
|1024|32|100|const|3.4|3.4|0.141|
|1024|32|100|global|3.4|3.41|0.083|
|1024|32|1000|const|17.05|17.05|0.05|
|1024|32|1000|global|17.1|17.1|0|
|2048|16|10|const|7.2|7.21|0.083|
|2048|16|10|global|7.4|7.36|0.156|
|2048|16|100|const|12.5|12.47|0.064|
|2048|16|100|global|12.7|12.68|0.04|
|2048|16|1000|const|65.3|65.66|0.796|
|2048|16|1000|global|65.45|65.72|0.629|
|2048|32|10|const|7.3|7.28|0.04|
|2048|32|10|global|7.35|7.38|0.117|
|2048|32|100|const|12.7|12.65|0.081|
|2048|32|100|global|12.7|12.71|0.07|
|2048|32|1000|const|65.9|65.92|0.14|
|2048|32|1000|global|65.9|66.14|0.758|

Some Calculated Values for Per Sphere, Per Pixel, and Per Sphere and Pixel

|DIM|THREADS|SPHERES|MEMORY|RENDER TIME MEDIAN PER PIXEL |RENDER TIME MEAN PER PIXEL|RENDER TIME MEDIAN PER SPHERE|RENDER TIME MEAN PER SPHERE|RENDER TIME MEDIAN PER PIXEL SPHERE|RENDER TIME MEAN PER PIXEL SPHERE|
|---|--|--|-----|--------|--------|--------|--------|--------|--------|
|512|16|10|const|2.67E-06|2.75E-06|7.00E-02|7.20E-02|2.67E-07|2.75E-07|
|512|16|10|global|2.67E-06|2.59E-06|7.00E-02|6.80E-02|2.67E-07|2.59E-07|
|512|16|100|const|3.81E-06|4.01E-06|1.00E-02|1.05E-02|3.81E-08|4.01E-08|
|512|16|100|global|3.81E-06|3.93E-06|1.00E-02|1.03E-02|3.81E-08|3.93E-08|
|512|16|1000|const|1.74E-05|1.77E-05|4.55E-03|4.65E-03|1.74E-08|1.77E-08|
|512|16|1000|global|1.72E-05|1.73E-05|4.50E-03|4.53E-03|1.72E-08|1.73E-08|
|512|32|10|const|2.67E-06|2.67E-06|7.00E-02|7.00E-02|2.67E-07|2.67E-07|
|512|32|10|global|2.67E-06|2.52E-06|7.00E-02|6.60E-02|2.67E-07|2.52E-07|
|512|32|100|const|3.81E-06|4.01E-06|1.00E-02|1.05E-02|3.81E-08|4.01E-08|
|512|32|100|global|3.81E-06|3.89E-06|1.00E-02|1.02E-02|3.81E-08|3.89E-08|
|512|32|1000|const|1.75E-05|1.82E-05|4.60E-03|4.78E-03|1.75E-08|1.82E-08|
|512|32|1000|global|1.62E-05|1.64E-05|4.25E-03|4.29E-03|1.62E-08|1.64E-08|
|1024|16|10|const|1.91E-06|1.90E-06|2.00E-01|1.99E-01|1.91E-07|1.90E-07|
|1024|16|10|global|2.00E-06|1.97E-06|2.10E-01|2.07E-01|2.00E-07|1.97E-07|
|1024|16|100|const|3.15E-06|3.19E-06|3.30E-02|3.34E-02|3.15E-08|3.19E-08|
|1024|16|100|global|3.24E-06|3.25E-06|3.40E-02|3.41E-02|3.24E-08|3.25E-08|
|1024|16|1000|const|1.59E-05|1.59E-05|1.67E-02|1.67E-02|1.59E-08|1.59E-08|
|1024|16|1000|global|1.60E-05|1.68E-05|1.68E-02|1.76E-02|1.60E-08|1.68E-08|
|1024|32|10|const|1.91E-06|1.88E-06|2.00E-01|1.97E-01|1.91E-07|1.88E-07|
|1024|32|10|global|2.00E-06|1.96E-06|2.10E-01|2.06E-01|2.00E-07|1.96E-07|
|1024|32|100|const|3.24E-06|3.24E-06|3.40E-02|3.40E-02|3.24E-08|3.24E-08|
|1024|32|100|global|3.24E-06|3.25E-06|3.40E-02|3.41E-02|3.24E-08|3.25E-08|
|1024|32|1000|const|1.63E-05|1.63E-05|1.71E-02|1.71E-02|1.63E-08|1.63E-08|
|1024|32|1000|global|1.63E-05|1.63E-05|1.71E-02|1.71E-02|1.63E-08|1.63E-08|
|2048|16|10|const|1.72E-06|1.72E-06|7.20E-01|7.21E-01|1.72E-07|1.72E-07|
|2048|16|10|global|1.76E-06|1.75E-06|7.40E-01|7.36E-01|1.76E-07|1.75E-07|
|2048|16|100|const|2.98E-06|2.97E-06|1.25E-01|1.25E-01|2.98E-08|2.97E-08|
|2048|16|100|global|3.03E-06|3.02E-06|1.27E-01|1.27E-01|3.03E-08|3.02E-08|
|2048|16|1000|const|1.56E-05|1.57E-05|6.53E-02|6.57E-02|1.56E-08|1.57E-08|
|2048|16|1000|global|1.56E-05|1.57E-05|6.55E-02|6.57E-02|1.56E-08|1.57E-08|
|2048|32|10|const|1.74E-06|1.74E-06|7.30E-01|7.28E-01|1.74E-07|1.74E-07|
|2048|32|10|global|1.75E-06|1.76E-06|7.35E-01|7.38E-01|1.75E-07|1.76E-07|
|2048|32|100|const|3.03E-06|3.02E-06|1.27E-01|1.27E-01|3.03E-08|3.02E-08|
|2048|32|100|global|3.03E-06|3.03E-06|1.27E-01|1.27E-01|3.03E-08|3.03E-08|
|2048|32|1000|const|1.57E-05|1.57E-05|6.59E-02|6.59E-02|1.57E-08|1.57E-08|
|2048|32|1000|global|1.57E-05|1.58E-05|6.59E-02|6.61E-02|1.57E-08|1.58E-08|


## Performance Comparison

Here are some plots on the various of render time given the size of the image and number of spheres.

![Comparison of the size of image to render time. Increases directly with the size of the image.](Full-Dim-Comparison.png)
![Comparison of number of spheres to render time. Increases directly with the number of spheres.](Full-Sphere-Comparison.png)

When looking at the numbers, the number of spheres also increases render time.

## Normalized Performance

Here are some comparisons of differences in render time divided by number of pixels times the number of spheres. This essentially normalizes the performance based on the amount of objects being rendered. This is a great way to see what settings yielded the best performance. This is the average of the median across all settings and held constant for specific groups depending on what is being evaluated.

![Comparison of the size of image to render time. Decreases directly with the size of the image.](Dim-Comparison.png)

Surprisingly, the average time decreases with the number of pixels. This is probably due to the fact that less time is being spent on overhead from launching the program and the overall performance improves.


![Comparison of number of spheres to render time. Better with more spheres.](Sphere-Comparison.png)

Spheres performed better on average per pixel per sphere as the number of spheres increases. I assume this is also due to less overhead and related factors.

![Comparison of memory type used to render time. Slightly better with constant but essentially the same.](Memory-Comparison.png)

From my results here, it seems that const and global are essentially the same. This does make some sense as the time to access memory should be relatively fast since the number of spheres is small. Const is slightly faster but the main problem is that constant is too small to be used realistically for large projects so it is probably better to stay with global for most cases.

![Comparison of number of threads used to render time. Decreases as the number of threads increases.](Threads-Comparison.png)

With this final comparison of threads, there is a slight decrease in time to render when more threads are used. Although more threads are being used, the more time has to be spent allocating memory, threads, managing tasks, etc... Although it does make sense that as more threads are used the performance would slightly improve. It would probably be a much starker difference comparing 1x1 to 32x32 threads. (Just running this for a test did confirm my suspicion. Although the increase is not quadratic, seems to follow more of a gradual curve).

## Conclusion

So, Given all that analysis and many graphs, I would say the optimal settings for best rendering performance would be to use a small image with few spheres, many threads and global memory.

Although this isn't always the case because computers and videos are rendered at 1080p and people want to show a lot of information on the screen. The best performance per pixel and sphere drawn seems to increase at least with the tested settings so somewhere around 100 spheres, 1024 pixels, and 32 threads seems to perform great and can render a good looking image for an end user.

This is just my take on the topic, the best answer probably lies in more optimization but I can say with certainty that drawing more things results in greater rendering time.



