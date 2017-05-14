#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <cstdlib>
#include <ctime>

#define n 10

void random_matrix(int *array);
void print_matrix(int *array);
__global__ void filter(int *in, int *out);

int main(){
	int *in;
	int *out;
	int *dev_in, *dev_out;

	int size = n * n * sizeof(int);

	cudaMalloc((void **)&dev_in, size);
	cudaMalloc((void **)&dev_out, size);

	in = new int[size];
	out = new int[size];

	srand(time(nullptr));

	random_matrix(in);

	printf("\In:\n");
	print_matrix(in);

	cudaMemcpy(dev_in, in, size, cudaMemcpyHostToDevice);
	cudaMemcpy(dev_out, out, size, cudaMemcpyHostToDevice);

	int numOfBlocks = 1;
	dim3 threadsPerBlock(n, n);

	filter << < numOfBlocks, threadsPerBlock >> > (dev_in, dev_out);

	cudaMemcpy(out, dev_out, size, cudaMemcpyDeviceToHost);

	printf("\Out: \n");
	print_matrix(out);

	cudaFree(dev_in);
	cudaFree(dev_out);

	free(in);
	free(out);
	int h;
	scanf("%d",&h);
	return 0;
}

void random_matrix(int *array){
	for (auto i = 0; i < n; ++i){
		for (auto j = 0; j < n; ++j){
			array[i * n + j] = rand() % 10;
		}
	}
}

void print_matrix(int *array){
	for (auto i = 0; i < n; ++i){
		for (auto j = 0; j < n; ++j){
			printf("%d ", array[i * n + j]);
		}

		printf("\n");
	}
}

__global__ void filter(int *in, int *out) {

	int i = blockIdx.y * blockDim.y + threadIdx.y;
	int j = blockIdx.x * blockDim.x + threadIdx.x;

	int start_i = 0, start_j = 0, sum = 0, end_i = n - 1, end_j = n - 1;

	if (i > 0) {
		start_i = i - 1;
	}
	if (j > 0) {
		start_j = j - 1;
	}
	if (i < n - 1) {
		end_i = i + 1;
	}
	if (j < n - 1) {
		end_j = j + 1;
	}

	int no_elements = 0;

	for (auto ir = start_i; ir <= end_i; ++ir) {
		for (auto ic = start_j; ic <= end_j; ++ic) {

			if (ic != j || ir != i) {
				sum += in[ir * n + ic];
				no_elements++;
			}
		}
	}

	out[i * n + j] = sum / no_elements;
}
