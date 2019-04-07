#include "mpi.h"
#include <stdio.h>
#include <math.h>

int power10[] = {1, 10, 100,
	       1000, 10000, 100000,
	       1000000, 10000000, 100000000,
	       1000000000};

// void Radix(int* array, int array_size, int max_digit); /* Thread function */
void rng(int* arr, int n); /* Seed function */
int max_el(int * vec, int n);
int to_digit(int el, int divider);
void print_array(int * array, int n);
void count_to_bucket(int * data, int * bucket, int length, int digit);
void countSort(int * data, int * bucket, int length, int digit);
void empty_bucket(int * bucket, int size);

int main(int argc,char *argv[]) {
    if(argc != 2) {
        perror("Please specify data length");
        exit(1);
    }
    int rank, size;
    int global_length, local_length;
    int *global_array, *local_array;
    int *bucket,*local_bucket;
    int base = 10;
    float temp;
    MPI_Status Status;

    // MPI initiliazation;
    MPI_Init(NULL, NULL);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // initialization    
    global_length = strtol(argv[1], NULL, 10);
    temp = (float) global_length/size;
    local_length = ceil(temp);
    // printf("global length = %d\n", global_length);
    // printf("size = %d\n", size);
    // printf("temp = %f\n", temp);
    // printf("local length = %d\n", local_length);

    if (rank == 0){
        global_array = malloc(global_length * sizeof(int));
        bucket = malloc (base * sizeof(int)); 
        empty_bucket(bucket, base);
        rng(global_array, global_length);
        // print_array(global_array, global_length);
    }
    local_bucket = malloc (base *sizeof(int));
    local_array = malloc ((local_length)*sizeof(int));
    empty_bucket(local_bucket, base);

    MPI_Barrier(MPI_COMM_WORLD);
    // printf("Process %d start\n", rank);
    
    float start_time = MPI_Wtime();
   
    // global_array split
    MPI_Scatter(global_array, local_length, MPI_INT, local_array,  local_length, MPI_INT, 0, MPI_COMM_WORLD);
    // if(rank != 0){
    // print_array(local_array, local_length);
    // }
    // printf("Process %d scatter\n", rank);
    // radix sort
    for (int j=1;j<=base;j++){
        // printf("Process %d start counting\n", rank);
        // sort local
        // if(rank != 0){
        count_to_bucket(local_array,local_bucket,local_length,j);

        // }
        // printf("Process %d count to bucket\n", rank);
        // reduce
        MPI_Reduce(local_bucket,bucket,base,MPI_INT,MPI_SUM,0,MPI_COMM_WORLD);
        // printf("Process %d reduce\n", rank);
        //global sort
        if (rank == 0){
            // print_array(bucket, base);
            // printf("%d\n", j);
            countSort(global_array,bucket,global_length,j);
            // print_array(bucket, base);
            // empty_bucket(bucket, base);
            // printf("Process %d global sort\n", rank);
        }
        empty_bucket(local_bucket, base);
    }
    // printf("Process %d finished\n", rank);
    MPI_Barrier(MPI_COMM_WORLD);
    float end_time = MPI_Wtime();
    
    if (rank==0){
        printf("Execution time: %.2f ms\n", (end_time - start_time) * 1000) ;
        // print_array(global_array, global_length);
        print_array_file(global_array , global_length);
        free(global_array);
        free(bucket);
    }
    free(local_array);
    free(local_bucket);
    MPI_Finalize();
    return 0;
} 

void count_to_bucket(int * data, int * bucket, int length, int digit){
    for(int i = 0; i < length; i++){
        int num_bucket = to_digit(data[i], digit);
        // printf("%d [%d] %d\n", data[i], digit,  num_bucket);
        bucket[num_bucket] ++;
    }
};

void countSort(int * data, int * bucket, int length, int digit){
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

void empty_bucket(int * bucket, int size){
    for(int i = 0; i < size; i++){
        bucket[i] = 0;
    }
}

void rng(int* arr, int n) {
    int seed = 13516123;   
    srand(seed);
    for(long i = 0; i < n; i++) {
        arr[i] = (int)rand();
    }
}

int max_el(int * vec, int n){
    int max = vec[0];

    for(int i = 0; i < n; i++){
        if(vec[i] > max) max = vec[i];
    }

    return max;
};

int to_digit(int el, int divider){
    for(int i = 1; i< divider; i++){
        el /= 10;
    }
    return el % 10;
};

void print_array(int * array, int array_len){
	int n = array_len;
    for(int i = 0; i < n; i++){
        printf("%d ", array[i]);
    }
    printf("\n");
}
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