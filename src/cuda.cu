#include <stdio.h>
#include <math.h>
#include <cuda.h>
// void Radix(int* array, int array_size, int max_digit); /* Thread function */
__host__ void rng(int* arr, int n); /* Seed function */
__host__ int max_el(int * vec, int n);
__host__ int num_digit(int el);
__device__ int to_digit(int el, int divider);
__host__ int to_digit_host(int el, int divider);
__host__ void print_array(int * array, int n);
__global__ void count_to_bucket(int * data, int * bucket, int length, int digit);
__host__ void countSort(int * data, int * bucket, int length, int digit);
__host__ void empty_bucket(int * bucket, int size);
__host__ void print_array_file(int * array, int array_len);

int main(int argc,char *argv[]) {
    if(argc != 2) {
        perror("Please specify data length");
        exit(1);
    }

    printf("flag 1\n");
    int data_size = strtol(argv[1], NULL, 10);
    int numThread = 1000;
    float numBlocksFloat = (float) data_size / numThread;
    int numBlocks = ceil(numBlocksFloat);
    int *global_array;
    int *global_bucket;
    int max_digit;
    int base= 10;
	 printf("data size : %d\n%.f\n", data_size,numBlocksFloat);
    printf("flag 2 thread %d block %d \n", numThread, numBlocks);
    // aloocating array to be accessible by both cpu and gpu
    cudaMallocManaged(&global_array, data_size*sizeof(int)+1);
    // cudaMalloc(&local_array,data_size*sizeof(int)+1);
    rng(global_array, data_size);
    // cudaMemcpy(d_a, a, sizeof(float) * N, cudaMemcpyHostToDevice);
    printf("flag 3\n");
    printf("flag 4\n");
    // global_array = (*int )malloc(data_size * sizeof(int));
    // initialization data
    print_array(global_array, data_size);
    
    max_digit = num_digit(max_el(global_array, data_size));
    printf("max digit %d\n", max_digit);
    int bucket_el = base*max_digit;

    cudaMallocManaged(&global_bucket, bucket_el*sizeof(int)+1);
    empty_bucket(global_bucket,bucket_el);
    for(int i = 1; i<= max_digit; i++){
	    count_to_bucket<<<numBlocks,numThread>>>(global_array,global_bucket,data_size,i);
    }
    // Wait for GPU to finish before accessing on host
    cudaDeviceSynchronize();
    for(int i = 0; i<max_digit; i++){
        countSort(global_array, global_bucket, data_size, i);
    }
    print_array(global_bucket,bucket_el);
	print_array(global_array, data_size);
    cudaFree(global_array);
    //cudaFree(global_bucket);
    return 0;
} 

__global__
void count_to_bucket(int * data, int * bucket, int length, int digit){
    int block = blockIdx.x;
    int thread = threadIdx.x;
    int i = block*1000+thread;
	// printf("block %d thread %d\n", digit, thread);
    //for(int i = (digit-1)*10 + thread;i <=(digit-1)*10+thread && i < length; i++){
    if(block*1000+thread < length){
		int num_bucket = to_digit(data[i], digit) + 10*(digit-1);
        printf("%d [%d] %d\n", data[i], digit,  num_bucket);
        bucket[num_bucket] ++;
	}
    //}
};


__host__
// void countSort(int * data, int * bucket, int length, int digit){
//     int *local_sort = (int*) malloc (length * sizeof(int));
//     int index = 0;

//     // sort
//     // printf("local sort ");
//     for(int block =0; block < digit; block++){
//         for(int d = 0; d < 10; d++){
//             for(int j = 0; j < length; j++){
//                 if(to_digit_host(data[j], block) == d){
//                     local_sort[index] = data[j];
//                     index ++;
//                     bucket[block*10+d] --;
//                 }
    
//                 if(bucket[block*10+d] == 0) {
//                     // printf("\n");
//                     break;
//                 }    
//             }
//         }    
//     }
//     // printf("index ends in %d \n", index);

//     // copy
//     for(int i=0; i < length; i++){
//         data[i] = local_sort[i];
//     }
//     free(local_sort);
//    //empty_bucket(bucket, 10);
// }

void countSort(int * data, int * bucket, int length, int digit){
    int * local_sort = (int*) malloc (length * sizeof(int));
    int index = 0;

    // sort
    // printf("local sort ");
    for(int i =0; i < 10; i++){
        for(int j = 0; j < length; j++){
            if(to_digit_host(data[j], digit+1) == i){
                local_sort[index] = data[j];
                index ++;
                bucket[digit*10+i] --;
            }

            if(bucket[digit*10+i] == 0) {
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
__host__
void empty_bucket(int * bucket, int size){
    for(int i = 0; i < size; i++){
        bucket[i] = 0;
    }
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
int max_el(int * vec, int n){
    int max = vec[0];

    for(int i = 0; i < n; i++){
        if(vec[i] > max) max = vec[i];
    }

    return max;
};

__device__
int to_digit(int el, int divider){
    for(int i = 1; i< divider; i++){
        el /= 10;
    }
    return el % 10;
};

__host__ 
int to_digit_host(int el, int divider){
    for(int i = 1; i< divider; i++){
        el /= 10;
    }
    return el % 10;
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
void print_array_file(int * array, int array_len){
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

__host__
int num_digit(int el){
    int digit = 1;
    while(el > 9){
        el /= 10;
        digit++;
    }
    return digit;
};
