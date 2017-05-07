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


 int partition (int *a,  int* b, int c, int left, int right){
	 int tmp,i,j,x;
	 x=a[right];
	 i=left - 1;
	 for( j = left; j<right; j++){
		 if(a[j]<x){
			 i++;
			 tmp = a[i];
			 a[i]=a[j];
			 a[j]=tmp;
		 }
	 }
	 i++;
   	 tmp = a[i];
	 a[i]=a[right];
	 a[right]=tmp;
	 return i;
 }
 __global__ void quickSort(int *a, int left, int right){
	 int q;
	 int  nleft, nright;
	 cudaStream_t s1, s2;
	 q=partition( a+left, a+right, a[left], nleft, nright);

	 if(left<nright){
		 cudaStreamCreateWithFlags(&s1, cudaStreamNonBlocking);
		 quickSort<<<1, s1>>>(a, left, nright);
	 }
	 
	 if(nleft<right){
		 cudaStreamCreateWithFlags(&s2, cudaStreamNonBlocking);
		 quickSort<<<1, s2>>>(a, nleft, right);
	 }
 }



 /*
 int m(){
	 int a[10]={6,4,2,7,5,4,8,9,6,4},i;
	 for(i=0;i<=9;i++)
		 printf();
	 quickSort(a,0,9);
	 return 0;

 }*/





 /*
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
            quickSort<<< 1, n >>>(arr, left, j);
      if (i < right)
            quickSort<<< 1, n >>>(arr, i, right);
}
*/






 void quick_p(char c[][30], int count)
{
   int partitions[1024];
   int newpartitions[1024];

   partitions[0]=0;
   partitions[1]=count-1;
   int threads=1;

   char *dev_c;
   cudaMalloc((void**)&dev_c, count * sizeof( char));

   int *dev_p;
   int *dev_pn;
   cudaMalloc((void**)&dev_p , 1024 * sizeof(int));
   cudaMalloc((void**)&dev_pn, 1024 * sizeof(int));

   cudaMemcpy(dev_c, c, count * sizeof( char), cudaMemcpyHostToDevice);

   while(true)
   {
        cudaMemcpy(dev_p, partitions , sizeof(partitions), cudaMemcpyHostToDevice);
        cudaMemcpy(dev_pn, newpartitions , sizeof(newpartitions), cudaMemcpyHostToDevice);

        Split<<<1,threads>>>(&dev_c,dev_p,dev_pn,threads);

        // get result back and loop again
        cudaMemcpy(newpartitions,dev_pn, sizeof(partitions), cudaMemcpyDeviceToHost);

        int tmp=0;
        for(int i=0;i<threads*2;i++)
        {
            int idx=i*2;
            if (newpartitions[idx]<newpartitions[idx+1] && newpartitions[idx+1]-newpartitions[idx]>=1)
            {
                partitions[tmp]=newpartitions[idx];
                partitions[tmp+1]=newpartitions[idx+1];
                tmp+=2;
            }
        }
        threads=tmp/2;

        if (threads==0)
            break;
    } // end main loop

    cudaMemcpy(c,dev_c, count* sizeof(unsigned char), cudaMemcpyDeviceToHost);

    cudaFree(dev_c);
    cudaFree(dev_p);
    cudaFree(dev_pn);
}