#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
  
int getMax(int arr[], int n) { 
    int mx = arr[0]; 
    for (int i = 1; i < n; i++) 
        if (arr[i] > mx) 
            mx = arr[i]; 
    return mx; 
} 
  

void countSort(int arr[], int n, int exp) { 
    int output[n]; 
    int i, count[10] = {0}; 
     
    for (i = 0; i < n; i++) 
        count[ (arr[i]/exp)%10 ]++; 
  
    
    for (i = 1; i < 10; i++) 
        count[i] += count[i - 1]; 
  
    for (i = n - 1; i >= 0; i--) 
    { 
        output[count[ (arr[i]/exp)%10 ] - 1] = arr[i]; 
        count[ (arr[i]/exp)%10 ]--; 
    } 
  
    for (i = 0; i < n; i++) 
        arr[i] = output[i]; 
} 

void radixsort(int arr[], int n) { 
    int m = getMax(arr, n); 
  
    for (int exp = 1; m/exp > 0; exp *= 10) 
        countSort(arr, n, exp); 
} 
  
void print(int arr[], int n) { 
    for (int i = 0; i < n; i++) 
        printf("%d\n", arr[i]);
    // cout << endl;
} 

void rng(int* arr, int n) {
    int seed = 13515111; // Ganti dengan NIM anda sebagai seed.
    srand(seed);
    for(long i = 0; i < n; i++) {
        arr[i] = (int)rand();
    }
}

int main() 
{ 
    clock_t tStart = clock();
    int arr[400000];
    int n = 0; 
    scanf("%d", &n);
    rng(arr, n);
    radixsort(arr, n); 
     
    printf("Time taken: %.8fms\n", ((double)(clock() - tStart)/CLOCKS_PER_SEC)*100);
    return 0;
} 