#include <stdio.h>
#define N 10000000

__global__ void vector_add(float *out, float *a, float *b, int n) {
    for(int i = 0; i < n; i++){
        out[i] = a[i] + b[i];
    }
}

__global__ void count_to_bucket(int * data, int * bucket, int length, int digit){
    for(int i = 0; i < length; i++){
        int num_bucket = to_digit(data[i], digit);
        // printf("%d [%d] %d\n", data[i], digit,  num_bucket);
        bucket[num_bucket] ++;
    }
};

__global__ void countSort(int * data, int * bucket, int length, int digit){
    int * local_sort = malloc (length * sizeof(int));
    int index = 0;

    // sort
    // printf("local sort ");
    for(int i =0; i < 10; i++){
        for(int j = 0; j < length; j++){
            if(to_digit(data[j], digit) == i){
                local_sort[index] = data[j];
                index ++;
                bucket[i] --;
            }

            if(bucket[i] == 0) {
                // printf("\n");
                break;
            }
        }
    }
    // printf("index ends in %d \n", index);

    // copy
    for(int i=0; i < length; i++){
        data[i] = local_sort[i];
    }
    free(local_sort);
    empty_bucket(bucket, 10);
}

__global__ void empty_bucket(int * bucket, int size){
    for(int i = 0; i < size; i++){
        bucket[i] = 0;
    }
}

__host__ void rng(int* arr, int n) {
    int seed = 13516123;   
    srand(seed);
    for(long i = 0; i < n; i++) {
        arr[i] = (int)rand();
    }
}

__device__ int max_el(int * vec, int n){
    int max = vec[0];

    for(int i = 0; i < n; i++){
        if(vec[i] > max) max = vec[i];
    }

    return max;
};

__device__ int to_digit(int el, int divider){
    for(int i = 1; i< divider; i++){
        el /= 10;
    }
    return el % 10;
};

__global__ void print_array(int * array, int array_len){
	int n = array_len;
    for(int i = 0; i < n; i++){
        printf("%d ", array[i]);
    }
    printf("\n");
}
__host__ void print_array_file(int * array, int array_len){
	int n = array_len;
    FILE * fp;
    FILE * fo;
    int i;
    /* open the file for writing*/
    fp = fopen ("../test/result.txt","w");
    fo = fopen ("../output/output.txt","w");
    /* write 10 lines of text into the file stream*/
    for(i = 0; i < n;i++){
       fprintf (fp, "%d ", array[i]);
       fprintf (fo, "%d ", array[i]);
    }
    fprintf (fp, "\n ");
    fprintf (fo, "\n ");

   /* close the file*/  
   fclose (fp);
   fclose (fo);
}

int main(){
    float *a, *b, *out;
    float *d_a;

    a = (float*)malloc(sizeof(float) * N);
    b = (float*)malloc(sizeof(float) * N);
    out = (float*)malloc(sizeof(float) * N);

    // Allocate device memory for a
    cudaMalloc((void**)&d_a, sizeof(float) * N);

    // Transfer data from host to device memory
    cudaMemcpy(d_a, a, sizeof(float) * N, cudaMemcpyHostToDevice);
    
    vector_add<<<1,1>>>(out, d_a, b, N);
    printf("%.f\n", out[0]);
    // Cleanup after kernel execution
    cudaFree(d_a);
    free(a);
    
    return 0;
}