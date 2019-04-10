#include <stdio.h>
#define N 10000000

__host__
int max_el(int * vec, int n){
    int max = vec[0];

    for(int i = 0; i < n; i++){
        if(vec[i] > max) max = vec[i];
    }

    return max;
};

__host__
void print_array(int * array, int array_len){
	int n = array_len;
    for(int i = 0; i < n; i++){
        printf("%d ", array[i]);
    }
    printf("\n");
}

__host__
void rng(int* arr, int n) {
    int seed = 13516123;   
    srand(seed);
    for(long i = 0; i < n; i++) {
        arr[i] = (int)rand();
    }
}

__host__
int max_digit(){
    return 0;
}

__global__
int to_digit(int el, int divider){
    for(int i = 1; i< divider; i++){
        el /= 10;
    }
    return el % 10;
};

int main(int argc,char *argv[]){
    if(argc != 2) {
        perror("Please specify data length");
        exit(1);
    }

    int data_size =  strtol(argv[1], NULL, 10);
    int * global_array;

    // aloocating array to be accessible by both cpu and gpu
    cudaMallocManaged(&global_array, data_size*sizeof(int));
    
    rng(global_array, data_size);

    int max_digit = 

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