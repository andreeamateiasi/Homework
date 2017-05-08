
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#ifndef __CUDACC__ 
#define __CUDACC__
#endif

#include "device_launch_parameters.h"
#include <cuda.h>
#include <device_functions.h>
#include <cuda_runtime_api.h>

#include <stdio.h>
#define INF 999
#define n 5

__global__ void floyd(int *a) {
	int k;
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	int j = blockIdx.y * blockDim.y + threadIdx.y;
	for (k = 0; k < n; k++)
		__syncthreads();
	if (a[i + k] + a[k + j] < a[i + j]) {
		a[i + j] = a[i + k] + a[k + j];
	}
}

void print(int **a) {
	int i, j;

	for (i = 0; i < n; i++)
		for (j = 0; j < n; j++)
			printf("%d", a[i*n + j]);
}
int main() {

	int  *d_a;
	int i, j, k;
	int size;
	size = n*n;

	int **h_a = (int**)malloc(n * sizeof(int));

	cudaMalloc((void **)&d_a, size);

	for (i = 0; i < n; i++)
		for (j = 0; j < n; j++)
			h_a[i][j] = i + j;

	cudaMemcpy(d_a, h_a, size, cudaMemcpyHostToDevice);

	dim3 threadBlock(n, n);


	floyd << <1, threadBlock >> >(d_a);

	cudaMemcpy(h_a, d_a, size, cudaMemcpyDeviceToHost);
	cudaFree(d_a);
	print(h_a);

}
