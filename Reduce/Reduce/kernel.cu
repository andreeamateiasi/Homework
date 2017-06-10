#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#ifndef __CUDACC__ 
#define __CUDACC__
#endif

#include "device_launch_parameters.h"
#include <cuda.h>
#include <device_functions.h>
#include <cuda_runtime_api.h>
#include<time.h>
#include <stdio.h>
#include<malloc.h>
#include <cuda.h>
#include <stdio.h>
#include <time.h>
#define threads 10

#define SIZE 10
__global__ void find(int *a, int *elem, int *position){
    __shared__ int sdata[SIZE];
	unsigned int tid = threadIdx.x;
	unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;

	sdata[tid] = a[i];
	
	__syncthreads();
	for (unsigned int s = blockDim.x / 2; s >= 1; s = s / 2){
		if (tid < s){
			if (*elem == sdata[tid + s]){
				position[i] == tid + s;
				printf("pos for %d = %d\n",i, tid+s);
				i++;
			}
		}
		__syncthreads();
	}
	
}

int main(){
	int i, j, *h_elemToBeFound, *d_elemToBeFound;
	srand(time(NULL));

	int *host_a, *h_position;
	host_a = (int*)malloc(SIZE * sizeof(int));
	h_position = (int*)malloc(SIZE * sizeof(int));
	h_elemToBeFound = (int*)malloc(sizeof(int));
	int *dev_a;
	int *d_position;

	cudaMalloc((void **)&dev_a, SIZE * sizeof(int));
	cudaMalloc((void **)&d_position, SIZE * sizeof(int));

	cudaMalloc((void **)&d_elemToBeFound, sizeof(int));

	*h_elemToBeFound = rand() % 10 + 1;

	printf("elem = %d", *h_elemToBeFound);
	for (i = 0; i < SIZE; i++){
		host_a[i] = rand() % 10 + 1;

	}
	for (i = 0; i < SIZE; i++){
		printf("%d ", host_a[i]);

	}
	/*for (i = 0; i < SIZE; i++)
		for (j = 0; j < SIZE; j++)
			h_position[i+j] == 0;*/
	printf(" ");
	cudaMemcpy(d_position, h_position, SIZE * sizeof(int), cudaMemcpyHostToDevice);

	cudaMemcpy(dev_a, host_a, SIZE * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_elemToBeFound, h_elemToBeFound, sizeof(int), cudaMemcpyHostToDevice);

	find<<<1, threads>>>(dev_a, d_elemToBeFound, d_position);

	cudaMemcpy(h_position, d_position, SIZE * sizeof(int), cudaMemcpyDeviceToHost);
	//cudaMemcpy(h_position, d_position, SIZE * sizeof(int), cudaMemcpyDeviceToHost);
	cudaMemcpy(h_elemToBeFound, d_elemToBeFound, sizeof(int), cudaMemcpyDeviceToHost);

	for (i = 0; i < SIZE; i++)
		//for (j = 0; j < SIZE; j++)
			printf("[%d] = %d",i,h_position[i ]);
	for (i = 0; i < SIZE; i++) {
		printf("%d ", host_a[i]);
	}

	cudaFree(dev_a);
	cudaFree(d_position);

	printf(" ");
	scanf("%d", i);
		return 0;
}