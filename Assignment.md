

For this assignment you will run CUDA experiments for performance tuning studies using the ray-tracing codes in Chapter06 of Cuda_by_Example.

You will run several experiments (at least 5 runs each) on each setting of the following parameters.

- using constant memory vs only global memory

- pixels given as square of DIM = 512, 1024, 2048

- threads per block = tile size = (16x16, 32x32)

- spheres = 10, 100, 1000, # which maxs out Constant Memory

Produce a table with the median runtime per parameter setting. Finally, determine the performance stats for each setting including the following:

- time per pixel task
- time per sphere object
- time per pixel per object

Write a summary paragraph that explains the results you obtained. Explain what you would consider an optimal setting.


