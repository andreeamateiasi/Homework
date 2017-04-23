#include <io.h>
#include <malloc.h>
#include <cuda.h>
#include <stdlib.h>
#include <stdio.h>
#include <cuda_runtime.h>

__global__ void quickSort(int arr[], int left, int right);

int main(){
	int n=10;
	int index;
	int size;
	size = n * sizeof(int);
	int* h_arr = (int*)malloc(size); 
	
	int* d_arr;
	cudaMalloc(&d_arr, size); 

	for(index=0;index<n;index++){
		printf("enter the %d number from arr",index);
		scanf("%d",&h_arr[index]);
	}

		
	cudaMemcpy(d_arr, h_arr, size, cudaMemcpyHostToDevice); 


	quickSort <<< 1, n >>>(d_arr, 0, n-1);
	 
	cudaMemcpy(h_arr, d_arr, size, cudaMemcpyDeviceToHost);
	cudaFree(d_arr);

}


 __global__ void quickSort(int arr[], int left, int right) {

      int i = left, 
	  int j = right;
      int tmp;
	
      int pivot = arr[(left+right) / 2];
 

      while (i <= j) {
            while (arr[i] < pivot)
                  i++;
            while (arr[j] > pivot)
                  j--;
            if (i <= j) {
                  tmp = arr[i];
                  arr[i] = arr[j];
                  arr[j] = tmp;
                  i++;
                  j--;
            }
      };


      if (left < j)
            quickSort(arr, left, j);
      if (i < right)
            quickSort(arr, i, right);
}